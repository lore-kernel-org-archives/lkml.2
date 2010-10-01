Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0JAKF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 06:05:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44336 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0JAKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 06:05:25 -0400
Subject: Problem: initrd boot failure on QSD8250
From: Tomasz Sterna <tsterna@tuenti.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Tuenti.com
Date: Fri, 01 Oct 2010 12:05:19 +0200
Message-ID: <1285927519.16981.63.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am porting msm-2.6.35 kernel to Dell Streak. I ported required
board-qsd8x50.c changes and most Streak hardware drivers from 2.06 Dell
release and the kernel is booting.

The problem is that it breaks on starting init from initrd, which is not
accessible. I have no idea what could be wrong. Maybe you could help me?

If you're interested in the kernel source it's on:
http://gitorious.org/streak/kernel and I'm using streak_defconfig to
build.

CONFIG_CMDLINE="init=/sbin/init root=/dev/ram rw initrd=0x11000000,16M console=tty mem=88M"

and the end of kernel boot looks like this:
[...] 
clock_late_init() disabled 21 unused clocks
input: 8k_handset as /devices/virtual/input/input1
__msm_rpc_connect: server not found 30000091:30001
__msm_rpc_connect: server not found 30000091:20001
[BAT]## Charger Mode = [I2C Control]
report_hs_key: No mapping for remote handset event 136
[BAT]## usb_current: 0 -> 100
[BAT]## bat_status: Unknown -> Not charging
msm_rpc_client_req: RPC call was not successful (4)
hs_rpc_cb_init: RPC client request failed for pwr key delay cmd, using normal mode
BUG: key df2ec770 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2701 sysfs_add_file_mode+0x4c/0xa8()
Modules linked in:
[<c0037920>] (unwind_backtrace+0x0/0xe4) from [<c0071094>] (warn_slowpath_common+0x4c/0x64)
[<c0071094>] (warn_slowpath_common+0x4c/0x64) from [<c00710c4>] (warn_slowpath_null+0x18/0x1c)
[<c00710c4>] (warn_slowpath_null+0x18/0x1c) from [<c011faf8>] (sysfs_add_file_mode+0x4c/0xa8)
[<c011faf8>] (sysfs_add_file_mode+0x4c/0xa8) from [<c01220c4>] (internal_create_group+0x110/0x190)
[<c01220c4>] (internal_create_group+0x110/0x190) from [<c000fbc8>] (msm_pm_init+0x244/0x3d8)
[<c000fbc8>] (msm_pm_init+0x244/0x3d8) from [<c00313b8>] (do_one_initcall+0x58/0x1b8)
[<c00313b8>] (do_one_initcall+0x58/0x1b8) from [<c0008404>] (kernel_init+0xa8/0x168)
[<c0008404>] (kernel_init+0xa8/0x168) from [<c0032fbc>] (kernel_thread_exit+0x0/0x8)
---[ end trace 0684cd56c42dcf4f ]---
BUG: key df2ec790 not in .data!
BUG: key df2ec7b0 not in .data!
BUG: key df2ec7d0 not in .data!
BUG: key df2ec370 not in .data!
BUG: key df2ec390 not in .data!
BUG: key df2ec3b0 not in .data!
BUG: key df2ec3d0 not in .data!
BUG: key de3498b0 not in .data!
BUG: key de3498d0 not in .data!
BUG: key de3498f0 not in .data!
BUG: key de349910 not in .data!
BUG: key de35f850 not in .data!
BUG: key de35f870 not in .data!
BUG: key de35f890 not in .data!
BUG: key de35f8b0 not in .data!
VFP support v0.3: implementor 51 architecture 0 part 0f variant 0 rev 1
[BAT]## bat_capacity: 100 (99), vol: 4077, ma: -371, fcc: 1445
[BAT]## bat_low: 0 -> 1
msmrtc_tod_proc_result: 09/30/2010 20:35:30 (03)
rs30000048 rs30000048.65536: setting system clock to 2010-09-30 20:35:30 UTC (1285878930)
msm_v4l2: msm_v4l2_init
VFS: Cannot open root device "(null)" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available partitions:
1f00            5120 mtdblock0 (driver?)
1f01            6144 mtdblock0 (driver?)
1f02            6144 mtdblock0 (driver?)
1f03             256 mtdblock0 (driver?)
1f04            3072 mtdblock0 (driver?)
1f05            1024 mtdblock0 (driver?)
1f06          266240 mtdblock0 (driver?)
1f07          143360 mtdblock0 (driver?)
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[<c0037920>] (unwind_backtrace+0x0/0xe4) from [<c043275c>] (panic_0x58/0xdc)
[<c043275c>] (panic_0x58/0xdc) from [<c0008edc>] (mount_block_root+0x254/0x2a4)
[<c0008edc>] (mount_block_root+0x254/0x2a4) from [<c00090ec>] (prepare_namespace+0x164/0x1b8)
[<c00090ec>] (prepare_namespace+0x164/0x1b8) from [<c000847c>] (kernel_init+0x120/0x168)
[<c000847c>] (kernel_init+0x120/0x168) from [<c0032fbc>] (kernel_thread_exit+0x0/0x8)



