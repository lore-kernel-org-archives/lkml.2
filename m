Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2K1UhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:37:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:42432 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2K1UhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:37:12 -0500
Date: Wed, 28 Nov 2012 21:37:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Norbert Warmuth <nwarmuth@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7+ suspend to RAM/offline CPU fails with
 nmi_watchdog=0 (bisected)
In-Reply-To: <50B64258.7020001@canonical.com>
Message-ID: <alpine.LFD.2.02.1211282136410.2701@ionos>
References: <86sj83pbwy.fsf@belegost.ivcecceob.t-online.de> <alpine.LFD.2.02.1211231033230.2701@ionos> <868v9s4g7m.fsf@belegost.ivcecceob.t-online.de> <50B64258.7020001@canonical.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012, Joseph Salisbury wrote:
> On 11/23/2012 08:11 AM, Norbert Warmuth wrote:
> > Thomas Gleixner writes:
> > > On Wed, 21 Nov 2012, Norbert Warmuth wrote:
> > > > 3.7-rc6 booted with nmi_watchdog=0 fails to suspend to RAM or
> > > > offline CPUs. It's reproducable with a KVM guest and physical
> > > > system.
> > > Does the patch below fix it?
> > Yes.
> > 
> > - Norbert
> > 
> > > diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> > > index 9d4c8d5..e3ef521 100644
> > > --- a/kernel/watchdog.c
> > > +++ b/kernel/watchdog.c
> > > @@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
> > >   {
> > >   	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> > >   +	if (!watchdog_enabled)
> > > +		return;
> > > +
> > >   	watchdog_set_prio(SCHED_NORMAL, 0);
> > >   	hrtimer_cancel(hrtimer);
> > >   	/* disable the perf event */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Hi Thomas,
> 
> Your patch also fixes a bug[0] reported against Ubuntu.  I assume the window
> for v3.7 is closed.  Will you be submitting this patch for inclusion in v3.8?

Sure, with a stable tag so it gets back into 3.7

Thanks,

	tglx
