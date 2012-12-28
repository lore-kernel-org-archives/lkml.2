Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab2L1TMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:12:08 -0500
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:60446 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753711Ab2L1TMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:12:06 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 14:12:06 EST
From: Martin Nybo Andersen <tweek@tweek.dk>
Subject: Panic: dma_map_area overflow 66 bytes on 3.7+
Date: Fri, 28 Dec 2012 20:05:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.1-dmafix+; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
X-Length: 3140
To: "David S. Miller" <davem@davemloft.net>,
        Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201212282005.10812.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Since the release of 3.7 my main computer has been panicking a couple of
times on both 3.7.0 and 3.7.1 because of a 'dma_map_area overflow xx bytes'.

Example screen shot:
http://www.tweek.dk/panic.jpg

I can reproduce it somewhat easily by visiting http://www.openstreetmap.org/
and zoom erratically with the scroll-button on the mouse.

The panic seems to occur on line 229 of arch/x86/kernel/amd_gart_64.c, and
reverting commit aee77e4accbeb2c86b1d294cd84fec4a12dde3bd (r8169: use
unlimited DMA burst for TX) seems to fix the problem for me (at least I've
not been able to make it panic as before (yet)).


lspci -v:
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RS480 Host Bridge (rev 01)
00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS480 PCI-X Root Port
00:05.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RS480 PCI Bridge
00:12.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB600 Non-Raid-5 SATA
00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB (OHCI0)
00:13.1 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB (OHCI1)
00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB (OHCI2)
00:13.3 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB (OHCI3)
00:13.4 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB (OHCI4)
00:13.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB600 USB Controller (EHCI)
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 13)
00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI SB600 IDE
00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB600 PCI to LPC Bridge
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
02:00.0 VGA compatible controller: NVIDIA Corporation G84 [GeForce 8600 GT] (rev a1)
03:07.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)


Please tell, if more info is needed.

Regards,
Martin Nybo Andersen
