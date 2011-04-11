Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1DKNVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:21:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:48699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1DKNVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:21:35 -0400
Subject: Re: [question] perf_event, ptrace
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E0132FFD8DC@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E0132FFD8DC@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 15:21:21 +0200
Message-ID: <1302528081.2388.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:12 +0100, Metzger, Markus T wrote:
> Hi Ingo, Peter,
> 
>  
> 
> When I use perf_event together with ptrace (i.e. when the ptracer is the
> event owner), are there any guarantees whether events have been drained when
> the ptracer is notified?
> 
>  
> 
> When I look at the signal handling code (kernel/signal.c:ptrace_stop(), line
> 1682), it appears as if the ptracee first wakes up the ptracer and then
> calls schedule().
> 
>  
> 
> Thus, if ptracer and ptracee run on different cpus, the ptracer might
> already be looking at the event buffer when the ptracee is scheduled out and
> the last events are drained.
> 
>  
> 
> Am I reading this correctly?
> 
>  
> 
> Is the ptracer expected to check ->data_head to see if there had been any
> updates?

I've got absolutely no clue about ptrace anything. One would expect
ptrace to provide proper notification of when the ptracee is stopped, at
which point staring at ->data_head seems like the right thing to do if
you want to figure out if new events have happened.

