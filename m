Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2BFUbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:31:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55313 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2BFUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:31:39 -0500
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
 granularity on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <20120206202722.GA556@aftab>
References: <20120206132546.GA30854@quad> <1328538403.2482.4.camel@laptop>
	 <20120206153408.GA31237@aftab> <1328546246.2482.10.camel@laptop>
	 <20120206164626.GA31704@aftab> <1328547259.2482.11.camel@laptop>
	 <20120206202722.GA556@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 21:31:33 +0100
Message-ID: <1328560293.2482.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 21:27 +0100, Borislav Petkov wrote:
> On Mon, Feb 06, 2012 at 05:54:19PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-02-06 at 17:46 +0100, Borislav Petkov wrote:
> > > > across all CPUs in the entire system.
> > > 
> > > Right, by the "entire system" you mean consistent across cores and
> > > sockets but not necessarily across cabinets, as in the comment above,
> > > correct?
> > > 
> > > If so, let me ask around if this holds true too.
> > 
> > Every CPU available to the kernel. So if you run a single system image
> > across your cabinets, then yes those too.
> 
> Ok, but what about that sentence "(but not across cabinets - we turn
> it off in that case explicitly.)" - I don't see any place where it is
> turned off explicitly... Maybe a stale comment?

I suspect it might be the sched_clock_stable = 0 in mark_tsc_unstable(),
but lets ask Venki, IIRC he wrote all that.

