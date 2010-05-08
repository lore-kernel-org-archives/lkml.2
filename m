Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0EHTQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 15:16:36 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:16009 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0EHTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 15:16:35 -0400
Date: Sat, 08 May 2010 15:16:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: 2.6.33 & 2.6.34-rc6: Huge number of Load Balancing tick wakeups.
In-reply-to: <4BE4F5DF.70903@crca.org.au>
Message-id: <alpine.LFD.2.00.1005081511550.4103@localhost.localdomain>
References: <4BE4F5DF.70903@crca.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-pm cc'd)

> I'm seeing a huge number of load balancing tick wakeups, with both 2.6.33 and
> current git (f1c448e0a9e99c76f4ece368714fb35a40a8daba).
> 
> This has been reported as a bug in some distros:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=521944
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/524281

Unclear if your sighting is the same as those two.

What do you see if vmware is not present?
What do you see if you boot single user mode,
how about with maxcpusx=1?

cheers,
Len Brown, Intel Open Source Technology Center

> PowerTOP 1.12   (C) 2007, 2008 Intel Corporation
> 
> Collecting data for 15 seconds
> 
> 
> Your CPU supports the following C-states : C1 C2 C3 C4
> Your BIOS reports the following C-states : C1 C2 C4
> Cn                Avg residency
> C0 (cpu running)        (40.8%)
> polling           0.7ms ( 0.1%)
> C1 mwait          0.0ms ( 0.0%)
> C2 mwait          0.1ms ( 3.2%)
> C4 mwait          0.4ms (56.0%)
> P-states (frequencies)
> Turbo Mode     7.3%
>   2.21 Ghz     0.7%
>   1.60 Ghz     0.8%
>   1200 Mhz     0.9%
>    800 Mhz    90.3%
> Wakeups-from-idle per second : 1727.3   interval: 15.0s
> no ACPI power usage estimate available
> Top causes for wakeups:
>   53.0% (1983.1)   [kernel scheduler] Load balancing tick
>   27.7% (1035.1)   vmware-vmx
>    8.8% (330.6)   [extra timer interrupt]
>    2.3% ( 85.5)   [TLB shootdowns] <kernel IPI>
>    1.6% ( 61.3)   totem
>    1.2% ( 45.9)   [Rescheduling interrupts] <kernel IPI>
>    1.1% ( 41.1)   [iwl3945] <interrupt>
>    1.0% ( 36.2)   firefox-bin
>    0.4% ( 16.2)   [ata_piix] <interrupt>
>    0.3% ( 11.6)   vmware
>    0.3% ( 11.3)   pulseaudio
>    0.3% ( 11.1)   vmware-unity-he
>    0.3% ( 10.7)   skype
>    0.2% (  8.0)   [kernel core] usb_hcd_poll_rh_status (rh_timer_func)
>    0.1% (  5.4)   [hda_intel] <interrupt>
>    0.1% (  5.3)   gnome-do
>    0.1% (  5.1)   compiz
>    0.1% (  4.1)   python
>    0.1% (  4.0)   avant-window-na
>    0.1% (  2.3)   liferea
>    0.1% (  2.1)   vmware-tray
>    0.1% (  2.1)   thunderbird-bin
>    0.1% (  2.0)   mysqld
>    0.1% (  2.0)   emerald
>    0.1% (  1.9)   gnome-terminal
>    0.0% (  1.3)   [kernel core] sk_reset_timer (tcp_delack_timer)
>    0.0% (  1.3)   [ahci] <interrupt>
>    0.0% (  1.2)   cc1
>    0.0% (  1.0)   [nvidia] <interrupt>
>    0.0% (  1.0)   vmware-usbarbit
>    0.0% (  1.0)   vmnet-natd
>    0.0% (  1.0)   gvfs-afc-volume
>    0.0% (  1.0)   [kernel core] enqueue_task_rt (sched_rt_period_timer)
>    0.0% (  1.0)   [kernel module] HostIF_InitUptime (HostIFUptimeResyncMono)
>    0.0% (  0.8)   cli
>    0.0% (  0.5)   events/1
>    0.0% (  0.5)   events/0
>    0.0% (  1.0)   vmware-usbarbit
>    0.0% (  1.0)   vmnet-natd
>    0.0% (  1.0)   gvfs-afc-volume
>    0.0% (  1.0)   [kernel core] enqueue_task_rt (sched_rt_period_timer)
>    0.0% (  1.0)   [kernel module] HostIF_InitUptime (HostIFUptimeResyncMono)
>    0.0% (  0.8)   cli
>    0.0% (  0.5)   events/1
>    0.0% (  0.5)   events/0
>    0.0% (  0.5)   hald-addon-stor
>    0.0% (  0.5)   udisks-daemon
>    0.0% (  0.3)   tomboy
>    0.0% (  0.3)   awn-applet
>    0.0% (  0.2)   rtkit-daemon
>    0.0% (  0.2)   Thunar
>    0.0% (  0.2)   padevchooser
>    0.0% (  0.2)   xfdesktop
>    0.0% (  0.1)   gnome-power-man
>    0.0% (  0.1)   ssh-agent
>    0.0% (  0.1)   mono
>    0.0% (  0.1)   NetworkManager
>    0.0% (  0.1)   hald


> An audio device is active 100.0% of the time:
> hwC0D2 SigmaTel STAC9228
> 
> A USB device is active  0.0% of the time:
> USB device  2-2 : Biometric Coprocessor (STMicroelectronics)
> 
> Suggestion: Enable SATA ALPM link power management via:
>   echo min_power > /sys/class/scsi_host/host0/link_power_management_policy
> or press the S key.
> 
> Suggestion: Enable wireless power saving mode by executing the following
> command:
>   iwconfig wlan0 power timeout 500ms
> This will sacrifice network performance slightly to save power.
> 
> Suggestion: Enable the CONFIG_USB_SUSPEND kernel configuration option.
> This option will automatically disable UHCI USB when not in use, and may
> save approximately 1 Watt of power.
> 
> Recent USB suspend statistics
> Active  Device name
>   0.0%  USB device  5-2 : Generic RNDIS (HTC)
>   0.0%  USB device  2-2 : Biometric Coprocessor (STMicroelectronics)
>   0.0%  USB device  1-1 : Laptop Integrated Webcam (OmniVision Technologies,
> Inc. -2640-07.07.20.3)
>   0.0%  USB device usb7 : UHCI Host Controller (Linux 2.6.34-rc6 uhci_hcd)
>   0.0%  USB device usb6 : UHCI Host Controller (Linux 2.6.34-rc6 uhci_hcd)
>   0.0%  USB device usb5 : UHCI Host Controller (Linux 2.6.34-rc6 uhci_hcd)
>   0.0%  USB device usb4 : EHCI Host Controller (Linux 2.6.34-rc6 ehci_hcd)
>   0.0%  USB device usb3 : UHCI Host Controller (Linux 2.6.34-rc6 uhci_hcd)
>   0.0%  USB device usb2 : UHCI Host Controller (Linux 2.6.34-rc6 uhci_hcd)
>   0.0%  USB device usb1 : EHCI Host Controller (Linux 2.6.34-rc6 ehci_hcd)
> 
> Recent audio activity statistics
> Active  Device name
> 100.0%  hwC0D2 SigmaTel STAC9228
> 
> Recent SATA AHCI link activity statistics
> Active  Partial Slumber Device name

