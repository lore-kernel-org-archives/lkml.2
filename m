Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1EDIht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:37:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:33293 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1EDIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:37:47 -0400
Date: Wed, 4 May 2011 10:37:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DC100D0.1030302@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105041015220.3005@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
 <4DC100D0.1030302@christianhoffmann.info>
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

> In fact, switching to acpi_pm doesn't seem to work:
> 
> $ dmesg | grep clock
> 
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+
> root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch-broken+
> root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
> [    0.000000] hpet clockevent registered
> [    1.413835] Switching to clocksource hpet
> [    1.420762] Override clocksource acpi_pm is not HRT compatible. Cannot
> switch while in HRT/NOHZ mode

Huch. There is something badly wrong. Can you provide the output of

 cat /sys/devices/system/clocksource/clocksource0/available_clocksource

please ?

> [  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
> [  147.940147] Switching to clocksource tsc

I just looked at the two boot logs you provided. So the main
difference is that TSC gets installed way later.

Can you please boot the "working" kernel with clocksource=hpet on the
commandline and verify whether the boot hang appears there as well?

Thanks,

	tglx
