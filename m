Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1BAVPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:15:18 -0500
Received: from www.tglx.de ([62.245.132.106]:56172 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1BAVPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:15:16 -0500
Date: Tue, 1 Feb 2011 22:14:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 08/28] posix-timers: Cleanup restart_block usage
In-Reply-To: <1296594674.3336.51.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1102012213510.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de>  <20110201134418.232288779@linutronix.de> <1296594674.3336.51.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, john stultz wrote:
> On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> > -		restart_block->fn = posix_cpu_nsleep_restart;
> > -		restart_block->arg0 = which_clock;
> > -		restart_block->arg1 = (unsigned long) rmtp;
> > -		restart_block->arg2 = t.tv_sec;
> > -		restart_block->arg3 = t.tv_nsec;
> > +		restart_block->nanosleep.expires = timespec_to_ns(&t);
> 
> The conversion back and forth from nanoseconds to timespec seems a
> little extraneous, but short of reworking all of the do_nanosleep calls
> to take a ktime I don't see a clean solution (since hrtimer also uses
> the restart_block).

We could simply add a timespec to the nanosleep struct in the
restart_block. Could be a union with expires.
 
Thanks,

	tglx
