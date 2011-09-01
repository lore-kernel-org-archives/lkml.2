Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1IAQmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:42:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab1IAQmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:42:18 -0400
Subject: Re: Problem with perf hardware counters grouping
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Mike Hommey <mh@glandium.org>, linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 18:41:52 +0200
In-Reply-To: <alpine.DEB.2.00.1109011117200.9976@cl320.eecs.utk.edu>
References: <20110831085718.GB13884@glandium.org>
	 <1314878012.11566.7.camel@twins>
	 <alpine.DEB.2.00.1109011117200.9976@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314895312.1485.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:21 -0400, Vince Weaver wrote:
> On Thu, 1 Sep 2011, Peter Zijlstra wrote:
> 
> > What happens with your >3 case is that while the group is valid and
> > could fit on the PMU, it won't fit at runtime because the NMI watchdog
> > is taking one and won't budge (cpu-pinned counter have precedence over
> > any other kind), effectively starving your group of pmu runtime.

> UGH!  I just noticed this problem yesterday and was meaning to track it 
> down.
> 
> This obviously causes PAPI to fail if you try to use the maximum number of 
> counters.  Instead of getting EINVAL at open time or even at start time, 
> you just silently read all zeros at read time, and by then it's too late 
> to do anything useful about the problem because you just missed measuring 
> what you were trying to.
> 
> Is there any good workaround, or do we have to fall back to trying to 
> start/read/stop every proposed event set to make sure it's valid?

I guess my first question is going to be, how do you know what the
maximum number of counters is in the first place?


> This is going to seriously impact performance, and perf_event performance 
> is pretty bad to begin with.  The whole reason I was writing the tests to 
> trigger this is because PAPI users are complaining that perf_event 
> overhead is roughly twice that of perfctr or perfmon2, which I've verified 
> experimentally.

Yeah, you keep saying this, where does it come from? Only the lack of
userspace rdpmc?
