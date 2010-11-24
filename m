Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0KXRag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:30:36 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7443 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0KXRaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:30:35 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Grzegorz Chwesewicz <grzegorz.chwesewicz@retis.net.pl>
Subject: Re: [regression] 2.6.37-rc1: Freeze while booting on HP nx6325
Date: Wed, 24 Nov 2010 12:30:25 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
References: <4CED1AB8.80305@retis.net.pl>
In-Reply-To: <4CED1AB8.80305@retis.net.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201011241230.26262.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 24, 2010 07:01:28 am Grzegorz Chwesewicz wrote:
> Hi, I have a problem with 2.6.37-rc1. My HP nx6325 freezes during boot.
> It happens after printing lines:
> 
> [    0.298457] atiixp 0000:00:14.1: not 100% native mode: will probe
> irqs later
> [    0.298515]     ide0: BM-DMA at 0x7040-0x7047
> [    0.298573] atiixp 0000:00:14.1: simplex device: DMA disabled
> [    0.298625] ide1: DMA disabled
> <Freeze>

I think this is the same problem as
https://bugzilla.kernel.org/show_bug.cgi?id=23332

If you have more of the log, that would be useful, but I doubt you
do because I don't think the nx6325 has a serial port.  I do have
a sample of that system, so I'm hoping to learn something about it
today.

Thanks for the report!

Bjorn

> This didn't happen in 2.6.36. I bisected between 2.6.36 and 2.6.37-rc1:
> 
> 1af3c2e45e7a641e774bbb84fa428f2f0bf2d9c9 is the first bad commit
> commit 1af3c2e45e7a641e774bbb84fa428f2f0bf2d9c9
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue Oct 26 15:41:54 2010 -0600
> 
>     x86: allocate space within a region top-down
> 
>     Request that allocate_resource() use available space from high addresses
>     first, rather than the default of using low addresses first.
> 
>     The most common place this makes a difference is when we move or assign
>     new PCI device resources.  Low addresses are generally scarce, so it's
>     better to use high addresses when possible.  This follows Windows
> practice
>     for PCI allocation.
> 
>     Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> Reverting above patch from latest linus-tree resolves problem.
> 
> My lspci:
> 
> 00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 10)
> 00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
> 00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
> 00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
> 00:06.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
> 00:12.0 IDE interface: ATI Technologies Inc IXP SB400 Serial ATA
> Controller (rev 80)
> 00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host
> Controller (rev 80)
> 00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host
> Controller (rev 80)
> 00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host
> Controller (rev 80)
> 00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 82)
> 00:14.1 IDE interface: ATI Technologies Inc IXP SB400 IDE Controller
> (rev 80)
> 00:14.2 Audio device: ATI Technologies Inc IXP SB4x0 High Definition
> Audio Controller (rev 01)
> 00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge (rev 80)
> 00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge (rev 80)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> DRAM Controller
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
> 
> 01:05.0 VGA compatible controller: ATI Technologies Inc RS482 [Radeon
> Xpress 200M]
> 
> 02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788
> Gigabit Ethernet (rev 03)
> 
> 02:04.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
> 
> 
> 02:04.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
> IEEE 1394 Host Controller
> 
> 02:04.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
> Card Reader (SD/MMC/MS/MS PRO/xD)
> 
> 02:04.3 SD Host controller: Texas Instruments PCIxx12 SDA Standard
> Compliant SD Host Controller
> 
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
> Gigabit Ethernet (rev 10)
> 
> 30:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g
> (rev 01)
> 
> Please CC to me, as I'm not subscribed to the list.
> 
> 
