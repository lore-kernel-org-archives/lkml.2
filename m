Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2IBO0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 10:26:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41828 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2IBO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 10:26:07 -0400
Message-ID: <1346595965.3941.1.camel@anime-power2>
Subject: ASpeed Technologies KMS VGA Driver error in log
From: Keven <thekingmen@gmail.com>
To: linux-kernel@vger.kernel.org, airlied@redhat.com
Date: Sun, 02 Sep 2012 10:26:05 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. ASpeed Technologies KMS VGA Driver error in log
2. Hi, I have an error message in my kernel log and I don't know if this
need to be taken care of or this is a normal behaviour. 

The component is [PATCH] drm: Initial KMS driver for AST (ASpeed
Technologies) 2000 series
This article is related to the new compoent. 
http://lists.freedesktop.org/archives/dri-devel/2012-April/021578.html

The code file should be 
Linux/drivers/gpu/drm/ast/ast_mode.c

The error I have is  
[    7.518793] [drm:ast_cursor_init] *ERROR* pinned cursor cache at 0

When I start my machine, I receive these messages from the component.

[    7.515770] ast 0000:01:01.0: enabling device (0000 -> 0003)
[    7.516711] [drm] AST 1100 detected
[    7.516764] [drm] dram 324000000 0 32 04000000
**
[    7.518793] [drm:ast_cursor_init] *ERROR* pinned cursor cache at 0
**
[   23.703894] fb1: astdrmfb frame buffer device
[   23.703897] drm: registered panic notifier
[   23.703902] [drm] Initialized ast 0.1.0 20120228 for 0000:01:01.0 on
minor 0



This can be traced back to the function
int ast_cursor_init(struct drm_device *dev)
and 
	DRM_ERROR("pinned cursor cache at %llx\n", ast->cursor_cache_gpu_addr);

So.. is this normal ? ? ?

3. /proc/version Linux version 3.5.3-1-ARCH (tobias@T-POWA-LX) (gcc
version 4.7.1 20120721 (prerelease) (GCC) ) #1 SMP PREEMPT Sun Aug 26
09:14:51 CEST 2012

7.lspci -vvvvvvvv
01:01.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED
Graphics Family (rev 10) (prog-if 00 [VGA controller])
	Subsystem: ASPEED Technology, Inc. ASPEED Graphics Family
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=8M]
	Region 1: Memory at f6fe0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at b000 [size=128]
	Capabilities: [40] Power Management version 3
	Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
	Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ast

Motherboard
Asus Z8NA-D6C

Also, I do *not* use the inboard graphical card. I plugged an external
card in the pci-express slow on this board. There is no options in the
bios to deactive the external card and check if the message is
different. As I am using another card, the system does work.

Please advise. 





