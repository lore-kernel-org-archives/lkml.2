Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1F2PCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:02:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:58863 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1F2PCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:02:06 -0400
Message-ID: <4E0B3E61.3090308@tmr.com>
Date: Wed, 29 Jun 2011 11:01:53 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.19) Gecko/20110420 Lightning/1.0b2 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: All kinds of irq 16: nobody cared with Sandy Bridge Asus P8H67-M
 MB and multiple drivers
References: <20110626170345.GA26430@merlins.org> <4E0B23AE.4070703@tmr.com> <20110629144704.GF10580@merlins.org>
In-Reply-To: <20110629144704.GF10580@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc MERLIN wrote:
> I'll put the summary at the top:
> Apparently upgrading the MB's bios seems to have mostly fixed my problem.
>
> On Wed, Jun 29, 2011 at 09:07:58AM -0400, Bill Davidsen wrote:
>    
>> Does this happen with an untainted kernel?
>>      
>
> I'm confused as to why the kernel is tainted.
>
> I have no binary modules and with 2.6.39.1 compiled from kernel.org source
> with no patches, I still got:
> Jun 25 20:05:41 gargamel kernel: irq 16: nobody cared (try booting with the "irqpoll" option)
> Jun 25 20:05:41 gargamel kernel: Pid: 0, comm: swapper Tainted: G        W 2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2
>
> Just to be clear, I am not running vmware.
>
> I checked a recent boot, and saw it went from not tainted to tainted
> after an apparent minor problem in the sata_mv driver (from kernel.org).
> Would that make sense?
>
> Jun 28 21:59:30 gargamel kernel: Modules linked in: keyspan ati_remote visor pl2303 ftdi_sio pci_hotplug soundcore backlight option processor usb_wwan rtc_cmos thermal_sys rtc_core hwmon parport_pc button snd_page_alloc parport usbserial wmi i2c_i801 evdev rtc_lib sata_mv pcspkr intel_agp intel_gtt agpgart tpm_tis r8169 iTCO_wdt iTCO_vendor_support xhci_hcd ehci_hcd usbcore
> Jun 28 21:59:30 gargamel kernel: Pid: 1636, comm: scsi_eh_9 Not tainted 2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2
> (...)
> Jun 28 21:59:30 gargamel kernel: Modules linked in: keyspan ati_remote visor pl2303 ftdi_sio pci_hotplug soundcore backlight option processor usb_wwan rtc_cmos thermal_sys rtc_core hwmon parport_pc button snd_page_alloc parport usbserial wmi i2c_i801 evdev rtc_lib sata_mv pcspkr intel_agp intel_gtt agpgart tpm_tis r8169 iTCO_wdt iTCO_vendor_support xhci_hcd ehci_hcd usbcore
> Jun 28 21:59:30 gargamel kernel: Pid: 1636, comm: scsi_eh_9 Tainted: G W   2.6.39.1-core2-volpreempt-noide-hm64-20110620 #2
>
>    
Sounds as if some module isn't properly labeled? Do you load any custom 
firmware or something like that.
Most puzzling.

> But back to the original question, it looks like a bios upgrade of the
> motherboard mostly fixed the problem. The system boots and works fine with
> multiple drivers using irq16 (using the same cards that were failing when
> used together days ago).
>
>    
Glad the BIOS upgrade fixed it. The problem below is probably caused by 
a driver for the irq going away with an int pending.
Again, "or something like that."  ;-)

> What's interesting though is that at shutdown time, I do see this on the
> console:
> Stopping domain name service...: bind9 waiting for pid 3967 to die.
> Stopping kernel log daemon....
> Stopping system log daemon....
> Asking all remaining processes to terminate...done.
> irq 19: nobody cared (try booting with the "irqpoll" option)
> handlers: [<f8ab1213>] (snd_cmipci_interrupt+0x0/0xe5 [snd_cmipci])
> Disabling IRQ #19
> All processes ended within 4 seconds....done.
>
> And I only have one card using irq19:
>   19:          0          0          0          0   IO-APIC-fasteoi   CMI8738-MC6
>
> This does not happen while I use the card when the system is running.
>
> Marc
>    


-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



