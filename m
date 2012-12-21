Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2LUOYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:24:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:52782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:23:59 -0500
Date: Fri, 21 Dec 2012 15:23:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.6-rt17
In-Reply-To: <1356087972.4547.26.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1212211520570.3148@ionos>
References: <alpine.LFD.2.02.1211122223300.10000@ionos> <1356087972.4547.26.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012, Mike Galbraith wrote:
> On Mon, 2012-11-12 at 22:28 +0100, Thomas Gleixner wrote: 
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.6.6-rt17 release. 3.6.6-rt16 is just a
> > not announced update release to 3.6.6.
> > 
> > Changes since 3.6.6-rt16:
> > 
> >    * Finally make the NOHZ softirq pending detection work with the new
> >      softirq scheme.
> 
> Well, almost.  They gripe when rebooting, but I haven't seen one other
> than that.  This is 3.6.11-rt23 on a 64 core DL980 I set up to run some
> latency tests on.

Yeah. It's not fixed completely. I know what it needs but thats major
surgery.
 
> [  318.692463] kvm: exiting hardware virtualization
> [  319.568482] Disabling non-boot CPUs ...
> [  319.647819] NOHZ: local_softirq_pending 80
> [  319.876148] NOHZ: local_softirq_pending 202
> [  319.876172] NOHZ: local_softirq_pending 202
> [  319.988912] NOHZ: local_softirq_pending 282
> [  320.097066] NOHZ: local_softirq_pending 202
> [  320.321428] NOHZ: local_softirq_pending 80
> [  320.662601] NOHZ: local_softirq_pending 202
> [  320.662637] NOHZ: local_softirq_pending 202
> [  323.162636] NOHZ: local_softirq_pending 202
> [  323.162649] NOHZ: local_softirq_pending 202
> [  325.217675] Restarting system.
> 
> Don't suppose you know why LAZY_PREEMPT would make 3.0-rt explode if you
> turn on wakeup_rt tracer do you?

No.
 
> I backported that and your softirq changes to 3.0.  New softirq handling
> scheme work spiffy there, LAZY_PREEMPT works fine too.. until you turn
> tracing on, then it corrupts memory, and makes mushroom cloud.

I guess you are just trying to make up for the canceled apocalypse :)
