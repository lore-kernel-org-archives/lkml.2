Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0JVAri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:47:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:42787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0JVArh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:47:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,220,1286175600"; 
   d="scan'208";a="339047677"
Subject: Re: booting "nosmp" kernel causing ACPI errors
From: Zhang Rui <rui.zhang@intel.com>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bernard Pidoux <bpidoux@free.fr>
In-Reply-To: <4CB9D69D.60203@upmc.fr>
References: <4CB9D69D.60203@upmc.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 08:48:03 +0800
Message-ID: <1287708483.2210.13.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bernard,

On Sun, 2010-10-17 at 00:45 +0800, Bernard Pidoux wrote:
> Hi,
> 
> I observed ACPI errors when booting 2.6.35.7 kernel with "nosmp" argument.
> dmesg shows a warning message starting with :
> WARNING: at mm/page_alloc.c:1981 __alloc_pages_nodemask+0x5b4/0x6d0()
> +Hardware name: MS-7519
> +Modules linked in:
> +Pid: 1, comm: swapper Not tainted 2.6.35.7 #2
> 
it seems that ACPI is trying to load an invalid table.
would you please attach the acpidump of your laptop, both with and
without "nosmp"?

thanks,
rui
> This is followed by ACPI error messages and /proc/interrupts show that
> interrupts 0-15 are then handled by XT-PIC-XT
> instead of IO-APIC-edge and IO-APIC-fasteoi when runing smp kernel.
> 
> Here is lspci dump :
> 
> 00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller 
> (rev 03)
> 00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root 
> Port (rev 03)
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #4
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #5
> 00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #6
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
> EHCI Controller #2
> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio 
> Controller
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
> Root Port 1
> 00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
> Port 2
> 00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express 
> Root Port 6
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #1
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #2
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #3
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
> EHCI Controller #1
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface 
> Controller
> 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port 
> SATA IDE Controller #1
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port 
> SATA IDE Controller #2
> 01:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 8400 
> GS] (rev a1)
> 02:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller
> 04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 
> I observed the same issue with another machine with also an MSI 
> motherboard but using a PCI bridge VIA VT8237/VX700
> even when booting with "pci=use_crs" argument.
> 
> Attached is diff -ruN file between 2.6.35.7 kernel without and with 
> "nosmp" boot argument.
> 
> Bernard
> 


