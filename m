Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1EDTkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:40:17 -0400
Received: from christianhoffmann.info ([88.175.101.52]:41347 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1EDTkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:40:15 -0400
Message-ID: <4DC1AB9B.8080501@christianhoffmann.info>
Date: Wed, 04 May 2011 21:40:11 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm> <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105041931510.3005@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hmm. So I really wonder why it refuses to switch to acpi_pm when you
> select it on the kernel command line.
>
> Does "echo acpi_pm>  /sys/devices/system/clocksource/clocksource0/current_clocksource"
> work ?

Yes, that seems to work:

root@c3po:~# echo acpi_pm > 
/sys/devices/system/clocksource/clocksource0/current_clocksource
root@c3po:~# dmesg | grep clocksource
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch+ 
root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch+ 
root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
[    1.463754] Switching to clocksource tsc
[    1.470700] Override clocksource acpi_pm is not HRT compatible. 
Cannot switch while in HRT/NOHZ mode
[  125.808622] Switching to clocksource acpi_pm

>
> Ok. That excludes HPET. So the only difference left is the late
> registration of TSC which happens _AFTER_ the hang.
>
> Can you boot the non working kernel with "lpj=28098860" on the kernel
> command line ?

The dmesg output with lpj is here (and it still hangs):

http://pastebin.com/raw.php?i=wZWrbc7Z

Kind regards,

Chris
