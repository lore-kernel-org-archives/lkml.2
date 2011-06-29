Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1F2PSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:18:12 -0400
Received: from magic.merlins.org ([209.81.13.136]:35678 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1F2PSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:18:08 -0400
X-Greylist: delayed 1859 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 11:18:08 EDT
Date: Wed, 29 Jun 2011 07:47:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: All kinds of irq 16: nobody cared with Sandy Bridge Asus P8H67-M MB and multiple drivers
Message-ID: <20110629144704.GF10580@merlins.org>
References: <20110626170345.GA26430@merlins.org> <4E0B23AE.4070703@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0B23AE.4070703@tmr.com>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 2.6.36.0-magic-20101023/Debian squeeze/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll put the summary at the top:
Apparently upgrading the MB's bios seems to have mostly fixed my problem.

On Wed, Jun 29, 2011 at 09:07:58AM -0400, Bill Davidsen wrote:
> Does this happen with an untainted kernel?
 
I'm confused as to why the kernel is tainted.

I have no binary modules and with 2.6.39.1 compiled from kernel.org source
with no patches, I still got:
Jun 25 20:05:41 gargamel kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
Jun 25 20:05:41 gargamel kernel: Pid: 0, comm: swapper Tainted: G        W 2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2

Just to be clear, I am not running vmware.

I checked a recent boot, and saw it went from not tainted to tainted
after an apparent minor problem in the sata_mv driver (from kernel.org).
Would that make sense?

Jun 28 21:59:30 gargamel kernel: Modules linked in: keyspan ati_remote visor pl2303 ftdi_sio pci_hotplug soundcore backlight option processor usb_wwan rtc_cmos thermal_sys rtc_core hwmon parport_pc button snd_page_alloc parport usbserial wmi i2c_i801 evdev rtc_lib sata_mv pcspkr intel_agp intel_gtt agpgart tpm_tis r8169 iTCO_wdt iTCO_vendor_support xhci_hcd ehci_hcd usbcore
Jun 28 21:59:30 gargamel kernel: Pid: 1636, comm: scsi_eh_9 Not tainted 2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2
(...)
Jun 28 21:59:30 gargamel kernel: Modules linked in: keyspan ati_remote visor pl2303 ftdi_sio pci_hotplug soundcore backlight option processor usb_wwan rtc_cmos thermal_sys rtc_core hwmon parport_pc button snd_page_alloc parport usbserial wmi i2c_i801 evdev rtc_lib sata_mv pcspkr intel_agp intel_gtt agpgart tpm_tis r8169 iTCO_wdt iTCO_vendor_support xhci_hcd ehci_hcd usbcore
Jun 28 21:59:30 gargamel kernel: Pid: 1636, comm: scsi_eh_9 Tainted: G W   2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2

But back to the original question, it looks like a bios upgrade of the
motherboard mostly fixed the problem. The system boots and works fine with
multiple drivers using irq16 (using the same cards that were failing when
used together days ago).

What's interesting though is that at shutdown time, I do see this on the
console:
Stopping domain name service...: bind9 waiting for pid 3967 to die.
Stopping kernel log daemon....
Stopping system log daemon....
Asking all remaining processes to terminate...done.
irq 19: nobody cared (try booting with the "irqpoll" option)
handlers: [<f8ab1213>] (snd_cmipci_interrupt+0x0/0xe5 [snd_cmipci])
Disabling IRQ #19
All processes ended within 4 seconds....done.

And I only have one card using irq19:
 19:          0          0          0          0   IO-APIC-fasteoi   CMI8738-MC6

This does not happen while I use the card when the system is running.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
