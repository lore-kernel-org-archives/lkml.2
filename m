Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2E1OaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:30:06 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:55254 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2E1OaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:30:04 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2012 10:30:04 EDT
From: takuo.koguchi.sw@hitachi.com
X-AuditID: b753bd60-94a01ba000003d24-c7-4fc38a30f221
Message-Type: Multiple Part
MIME-Version: 1.0
Message-ID: <XNM1$5$0$1$$3$9$0$A$8005401U4fc38a01@hitachi.com>
Content-Type: text/plain; charset=us-ascii
To: <linux-kernel@vger.kernel.org>
Cc: <rob.herring@calxeda.com>, <linus.walleij@linaro.org>
Date: Mon, 28 May 2012 23:22:22 +0900
Importance: normal
Subject: v3.4 boot failure on qemu-system-arm -M versatilepb
X400-Content-Identifier: X4FC38A0100000M
X400-MTS-Identifier: [/C=JP/ADMD=HITNET/PRMD=HITACHI/;gmml06120528232153P4N]
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found linux-3.4 kernel fails to mount the rootfs on "qemu-system-arm -M versatile."

Git bisect shows commit c334bc1 cause this first.

So I tried to revert it by putting arch/arm/mach-versatile/include/mach/io.h and adding select NEED_MACH_IO_H in the section of ARCH_VERSATILE in arch/arm/Kconfig, then the kernel can mount the rootfs.

Can someone confirm and fix this?

Takuo Koguchi


-----------
Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.4.0-yocto-standard (koguchi@mg70k) (gcc version 4.5.2 (Sourcery G++ Lite 2011.03-41) ) #37 PREEMPT Sun May 27 22:36:22 JST 2012
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00093177
CPU: VIVT data cache, VIVT instruction cache
Machine: ARM-Versatile PB
...
eth0: link up
IP-Config: Complete:
     device=eth0, addr=192.168.7.3, mask=255.255.255.0, gw=192.168.7.1
     host=192.168.7.3, domain=, nis-domain=(none)
     bootserver=255.255.255.255, rootserver=255.255.255.255, rootpath=
 input: AT Raw Set 2 keyboard as /devices/fpga:06/serio0/input/input0
md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
VFS: Cannot open root device "0x0800" or unknown-block(8,0): error -6
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,0)
[<c0013870>] (unwind_backtrace+0x0/0xec) from [<c0389b68>] (dump_stack+0x20/0x24)
[<c0389b68>] (dump_stack+0x20/0x24) from [<c0389bf4>] (panic+0x88/0x1c4)
[<c0389bf4>] (panic+0x88/0x1c4) from [<c04fbde8>] (mount_block_root+0x240/0x290)
[<c04fbde8>] (mount_block_root+0x240/0x290) from [<c04fbf80>] (mount_root+0x50/0x68)
[<c04fbf80>] (mount_root+0x50/0x68) from [<c04fc108>] (prepare_namespace+0x170/0x1d0)
[<c04fc108>] (prepare_namespace+0x170/0x1d0) from [<c04fba08>] (kernel_init+0x1bc/0x204)
[<c04fba08>] (kernel_init+0x1bc/0x204) from [<c000e7dc>] (kernel_thread_exit+0x0/0x8)




