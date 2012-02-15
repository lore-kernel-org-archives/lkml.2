Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2BOUgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:36:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:54972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2BOUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:36:49 -0500
Date: Wed, 15 Feb 2012 21:36:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20120215153438.GB11343@sgi.com>
Message-ID: <alpine.LFD.2.02.1202152131280.2794@ionos>
References: <20111108191149.GA7236@sgi.com> <alpine.LFD.2.02.1202151512420.2794@ionos> <20120215143710.GA10543@sgi.com> <alpine.LFD.2.02.1202151547520.2794@ionos> <20120215153438.GB11343@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Dimitri Sivanich wrote:
> On Wed, Feb 15, 2012 at 03:52:06PM +0100, Thomas Gleixner wrote:
> > So the first CPU which registers a clock event device takes it. That's
> > the boot CPU, no matter what.
> >
> Both kernel tracing and the original patch that I proposed for this
> showed plainly (at the time) that the tick_do_timer_cpu was not always cpu 0
> prior to modifying it for nohz=off.  Maybe that is no longer the case?

This logic has not been changed in years.

tick_do_timer_cpu is initialized to TICK_DO_TIMER_BOOT and the first
cpu which registers either a global or a per cpu clock event device
takes it over. This is at least on x86 always the boot cpu, i.e. cpu0.
After that point nothing touches that variable when nohz is disabled
(runtime or compile time).

So I really want to see proper proof why that would not be the
case. If it really happens then we fix the root cause instead of
adding random sysfs interfaces.

Thanks,

	tglx
