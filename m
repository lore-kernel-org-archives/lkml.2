Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1EDRtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:49:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:59721 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1EDRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:49:22 -0400
Date: Wed, 4 May 2011 19:49:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DC1832E.5030806@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105041931510.3005@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
 <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Christian Hoffmann wrote:
> Hi,
> 
> > Huch. There is something badly wrong. Can you provide the output of
> > 
> >   cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > 
> > please ?
> 
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> tsc hpet acpi_pm

Hmm. So I really wonder why it refuses to switch to acpi_pm when you
select it on the kernel command line.
 
Does "echo acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource"
work ?

> > > [  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
> > > [  147.940147] Switching to clocksource tsc
> > 
> > I just looked at the two boot logs you provided. So the main
> > difference is that TSC gets installed way later.
> > 
> > Can you please boot the "working" kernel with clocksource=hpet on the
> > commandline and verify whether the boot hang appears there as well?
> > 
> 
> No, it works fine. See http://pastebin.com/raw.php?i=4wJWkiNM.

Ok. That excludes HPET. So the only difference left is the late
registration of TSC which happens _AFTER_ the hang.

Can you boot the non working kernel with "lpj=28098860" on the kernel
command line ?

Thanks,

	tglx
