Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1HKLas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:30:48 -0400
Received: from gateway.hbm.com ([213.157.30.2]:40761 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1HKLap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:30:45 -0400
Thread-Index: AcxYGhsXTE5c9WEAQVaWRdNLXbG9EQ==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Thu, 11 Aug 2011 13:30:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins> <201108091713.19292.tim.sander@hbm.com> <1313055790.23660.70.camel@twins>
In-Reply-To: <1313055790.23660.70.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108111330.28168.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Aug 2011 11:30:43.0240 (UTC) FILETIME=[1B01D280:01CC581A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter

Thanks for your reply.
> Please ensure your mailer doesn't wrap splats, ARM splats are aren't my
> strong point to begin with and having them look all messed up doesn't
> help.
Im sorry for the inconvinience. Below is a version without newlines broken.

The error does not occur  when configured with 
CONFIG_PREEMPT_RT_FULL=y
but with 
CONFIG_PREEMPT_RTB=y.
The same error also happens with
CONFIG_PREEMPT_LL=y. (A log is appended after the other log just search for CONFIG_PREEMPT_LL 
for starting point).

Best regards
Tim

Log with CONFIG_PREEMPT_RTB:
commandline: console=ttymxc0,115200 init=/usr/sbin/init lpj=2654208 quiet ip=none ubi.mtd=3 root=ubi0:root rootfstype=ubifs mtdparts=physmap-
flash.0:256k(barebox)ro,128k(env),2M(kernel),-(rootfs);mxc_nand:-(data)
arch_number: 2072

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a44000
[00000000] *pgd=87a31831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: nand_ecc(+)
CPU: 0    Not tainted  (3.0.1-pmx-rt8 #2)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2fc>]    psr: 60000013
sp : c7a37ce8  ip : c7a37c30  fp : c7a37cf4
r10: c789f840  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000008  r5 : c04286c0  r4 : c7a37d78
r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a44008  DAC: 00000015
Process udevd (pid: 216, stack limit = 0xc7a36268)
Stack: (0xc7a37ce8 to 0xc7a38000)
7ce0:                   c7a37d14 c7a37cf8 c0076aac c002cbd8 c7a37d78 c7a617a0
7d00: 00000008 c02530a0 c7a37d74 c7a37d18 c0076c2c c0076a74 00000008 00000000
7d20: c7a37d44 c7a37d40 c7a36000 00000000 00001000 00000000 00000000 00000000
7d40: c7a37d74 c04286c0 c0041ce0 00000000 00000000 00000000 c789f840 c7a37d78
7d60: 00000000 00000000 c7a37dac c7a37d78 c0076d64 c0076b50 c7a37f10 00000001
7d80: 00000000 00000008 00000000 00000000 00000000 c789f840 c7a616f0 00000008
7da0: c7a37e3c c7a37db0 c0078f60 c0076d14 00000000 00000000 c7a37ed0 00000008
7dc0: 00000000 c0035114 c7a37dec c7a37dd8 c0035114 c002b620 c7a617a0 c7a37ed0
7de0: c7a37f10 c7a37e98 c008ed00 c0035064 00000000 00000001 c7a37e24 c7a6d808
7e00: 400c3000 00000000 c7a45000 00000008 c7a08860 00000000 c789f840 c7a6170c
7e20: 00000000 c7a37e98 c7a37f10 00000001 c7a37e8c c7a37e40 c0079024 c0078b04
7e40: c002b614 00000001 91827364 c7a37e4c c7a37e4c c7a37e54 c7a37e54 00000000
7e60: c7a37eb4 c789f840 c7a37e98 c7a37f70 c7a37f10 fffffdee c7a36000 00000000
7e80: c7a37f3c c7a37e90 c00a191c c0078fb8 00000000 00000000 c014e10c c0035064
7ea0: 00000000 00000001 ffffffff c789f840 00000000 00000000 00000000 00000000
7ec0: c7860c40 c005c3d8 00000000 00000000 00000000 00000000 00000007 400c3000
7ee0: 00000008 c7a37fb0 00000008 bee39378 c7a37fac c7a37f00 c002420c c002f114
7f00: c00242b0 c002f114 c7a37f2c c7a37f18 400c3000 00000008 c7a08898 00000008
7f20: c789f840 400c3000 c7a37f70 00000008 c7a37f6c c7a37f40 c00a2070 c00a1880
7f40: c7a36000 400c3000 00001000 c789f840 400c3000 00000000 00000000 00000008
7f60: c7a37fa4 c7a37f70 c00a22f4 c00a1fc0 00000000 00000000 00000022 00000000
7f80: ffffffff 00000008 000233d8 400c3000 00000004 c0029c24 00000000 c7a37fa8
7fa0: c0029aa0 c00a22bc 00000008 000233d8 0000000a 400c3000 00000008 00000000
7fc0: 00000008 000233d8 400c3000 00000004 00000008 00022344 000c42e8 00000001
7fe0: 00000000 bee386e8 4014fe0c 401a321c 60000010 0000000a 006c6961 646e616e
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008
Code: e59f0010 e1a01003 eb08753c e3a03000 (e5833000) 
---[ end trace 2c683ece01bdd6a1 ]---
note: udevd[216] exited with preempt_count 1
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ecc(+)
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7a37abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a08894 r6:00000000 r5:00000000 r4:c7a08860
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7860c40 r4:c7a08860
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a08860 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c04286c0 00000008 00000000
7cc0: 00000000 00000000 c789f840 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008
init: mount main process (218) terminated with status 1
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a08860 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c04286c0 00000008 00000000
7cc0: 00000000 00000000 c789f840 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008

tim login: NAND device: Manufacturer ID: 0xec, Chip ID: 0xd3 (Samsung NAND 1GiB 3,3V 8-bit)
Scanning device for bad blocks
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7ad4000
[00000000] *pgd=87aa6831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#2] PREEMPT
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #2)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e318>]    psr: 20000013
sp : c7ac1ce8  ip : c7ac1c30  fp : c7ac1cf4
r10: c7abfa40  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000041  r5 : c0334d80  r4 : c7ac1d78
r3 : 00000000  r2 : 00000002  r1 : 00000001  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87ad4008  DAC: 00000015
Process syslogd (pid: 233, stack limit = 0xc7ac0268)
Stack: (0xc7ac1ce8 to 0xc7ac2000)
1ce0:                   c7ac1d14 c7ac1cf8 c0076aac c002cbd8 c7ac1d78 c7a61490
1d00: 00000041 c02530a0 c7ac1d74 c7ac1d18 c0076c2c c0076a74 00000041 00000000
1d20: c7ac1d44 c7ac1d40 c7ac0000 00000000 00001000 00000000 00000000 00000000
1d40: c7ac1d74 c0334d80 c0041ce0 00000000 00000000 00000000 c7abfa40 c7ac1d78
1d60: 00000000 00000000 c7ac1dac c7ac1d78 c0076d64 c0076b50 c7ac1f10 00000001
1d80: 00000000 00000041 00000000 00000000 00000000 c7abfa40 c7a613e0 00000041
1da0: c7ac1e3c c7ac1db0 c0078f60 c0076d14 00000000 00000000 c7ac1ed0 00000041
1dc0: 00000000 c00574a4 ffffffff c7ac0000 c7ac1e2c c7ac1de0 c7a61490 c7ac1ed0
1de0: c7ac1f10 c7ac1e98 00000000 401b7000 00000000 00000001 401b7000 c04291c0
1e00: c7ac1e2c c7a27a18 000000b7 00000041 c7ad5000 00000000 c7abfa40 c7a613fc
1e20: 00000000 c7ac1e98 c7ac1f10 00000001 c7ac1e8c c7ac1e40 c0079024 c0078b04
1e40: c002cbb0 c002b5f0 91827364 c7ac1e4c c7ac1e4c c7ac1e54 c7ac1e54 00000000
1e60: c002b650 c7abfa40 c7ac1e98 c7ac1f70 c7ac1f10 fffffdee c7ac0000 00000000
1e80: c7ac1f3c c7ac1e90 c00a191c c0078fb8 00000000 00000000 c7ac1ebc c7ac1ea8
1ea0: 00000000 00000001 ffffffff c7abfa40 00000000 00000000 00000000 00000000
1ec0: c7838080 c7ac1ed0 00000000 00000000 00000000 00000000 00000000 00000007
1ee0: 00000041 401b7200 00000041 00000041 00000000 0006c6f0 c7ac1fac c7ac1f08
1f00: c00242b0 c002f114 00000003 0db58584 0006c458 00000041 00000079 00000041
1f20: c7abfa40 0006c458 c7ac1f70 00000041 c7ac1f6c c7ac1f40 c00a2070 c00a1880
1f40: 00000079 00000000 00000010 c7abfa40 0006c458 00000000 00000000 00000041
1f60: c7ac1fa4 c7ac1f70 c00a22f4 c00a1fc0 00000000 00000000 00000003 00000000
1f80: 00001000 0006b89c 00000041 0006c458 00000004 c0029c24 00000000 c7ac1fa8
1fa0: c0029aa0 c00a22bc 0006b89c 00000041 00000004 0006c458 00000041 00032000
1fc0: 0006b89c 00000041 0006c458 00000004 00000041 00000000 0006c6f0 beb31bdc
1fe0: 00000004 beb31b30 0000faa4 401b721c 60000010 00000004 00000000 00000000
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Code: e59f0010 e1a01003 eb08753c e3a03000 (e5833000) 
---[ end trace 2c683ece01bdd6a2 ]---
note: syslogd[233] exited with preempt_count 1
BUG: scheduling while atomic: syslogd/233/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7ac0000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7838080 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7ac1abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a7dbf4 r6:00000000 r5:00000000 r4:c7a7dbc0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7838080 r4:c7a7dbc0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7838080
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7ac1ca0 r6:c7a7dbc0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7838080 r5:c7a7dbc0 r4:c7ac1ca0
r3:c7ac1ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7ac1ca0 to 0xc7ac1ce8)
1ca0: 00000027 00000001 00000002 00000000 c7ac1d78 c0334d80 00000041 00000000
1cc0: 00000000 00000000 c7abfa40 c7ac1cf4 c7ac1c30 c7ac1ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7ac1cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/233/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7ac0000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7838080 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7ac1abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a7dbf4 r6:00000000 r5:00000000 r4:c7a7dbc0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7838080 r4:c7a7dbc0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7838080
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7ac1ca0 r6:c7a7dbc0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7838080 r5:c7a7dbc0 r4:c7ac1ca0
r3:c7ac1ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7ac1ca0 to 0xc7ac1ce8)
1ca0: 00000027 00000001 00000002 00000000 c7ac1d78 c0334d80 00000041 00000000
1cc0: 00000000 00000000 c7abfa40 c7ac1cf4 c7ac1c30 c7ac1ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7ac1cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/233/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7ac0000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7838080 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818500 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7838080
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7ac1ca0 r6:c7a7dbc0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7838080 r5:c7a7dbc0 r4:c7ac1ca0
r3:c7ac1ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7ac1ca0 to 0xc7ac1ce8)
1ca0: 00000027 00000001 00000002 00000000 c7ac1d78 c0334d80 00000041 00000000
1cc0: 00000000 00000000 c7abfa40 c7ac1cf4 c7ac1c30 c7ac1ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7ac1cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/233/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7ac0000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7838080 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818500 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7838080
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7ac1ca0 r6:c7a7dbc0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7838080 r5:c7a7dbc0 r4:c7ac1ca0
r3:c7ac1ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7ac1ca0 to 0xc7ac1ce8)
1ca0: 00000027 00000001 00000002 00000000 c7ac1d78 c0334d80 00000041 00000000
1cc0: 00000000 00000000 c7abfa40 c7ac1cf4 c7ac1c30 c7ac1ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7ac1cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/233/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7ac0000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7838080 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818500 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7838080
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7ac1ca0 r6:c7a7dbc0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7838080 r5:c7a7dbc0 r4:c7ac1ca0
r3:c7ac1ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7ac1ca0 to 0xc7ac1ce8)
1ca0: 00000027 00000001 00000002 00000000 c7ac1d78 c0334d80 00000041 00000000
1cc0: 00000000 00000000 c7abfa40 c7ac1cf4 c7ac1c30 c7ac1ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7ac1cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000041 r5:c7a61490 r4:c7ac1d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a613e0 r6:c7abfa40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7ac1f70 r6:0006c458 r5:c7abfa40 r4:00000041
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7abfa40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
sched: RT throttling activated
Segmentation faultinit: syslogd main process (228) terminated with status 139
init: syslogd main process ended, respawning

kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a74000
[00000000] *pgd=87a5f831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#3] PREEMPT
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #2)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e318>]    psr: 20000013
sp : c7a81ce8  ip : c7a81c30  fp : c7a81cf4
r10: c7a31e20  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000006  r5 : c0428ee0  r4 : c7a81d78
r3 : 00000000  r2 : 00000002  r1 : 00000002  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a74008  DAC: 00000015
Process ifup (pid: 222, stack limit = 0xc7a80268)
Stack: (0xc7a81ce8 to 0xc7a82000)
1ce0:                   c7a81d14 c7a81cf8 c0076aac c002cbd8 c7a81d78 c7a61618
1d00: 00000006 c02530a0 c7a81d74 c7a81d18 c0076c2c c0076a74 00000006 00000000
1d20: c7a81d44 c7a81d40 c7a80000 00000000 00001000 00000000 00000000 00000000
1d40: c7a81d74 c0428ee0 c0041ce0 00000000 00000000 00000000 c7a31e20 c7a81d78
1d60: 00000000 00000000 c7a81dac c7a81d78 c0076d64 c0076b50 c7a81f10 00000001
1d80: 00000000 00000006 00000000 00000000 00000000 c7a31e20 c7a61568 00000006
1da0: c7a81e3c c7a81db0 c0078f60 c0076d14 00000000 00000000 c7a81ed0 00000006
1dc0: 00000000 c0035114 c7a81dec c7a81dd8 c0035114 c002b620 c7a61618 c7a81ed0
1de0: c7a81f10 c7a81e98 c008ed00 c0035064 00000000 00000001 c7a81e24 c7a6d700
1e00: 40046000 00000000 c7a75000 00000006 c7a081e0 00000000 c7a31e20 c7a61584
1e20: 00000000 c7a81e98 c7a81f10 00000001 c7a81e8c c7a81e40 c0079024 c0078b04
1e40: c002b614 00000001 91827364 c7a81e4c c7a81e4c c7a81e54 c7a81e54 00000000
1e60: c7a81eb4 c7a31e20 c7a81e98 c7a81f70 c7a81f10 fffffdee c7a80000 00000000
1e80: c7a81f3c c7a81e90 c00a191c c0078fb8 00000000 00000000 c014e10c c0035064
1ea0: 00000000 00000001 ffffffff c7a31e20 00000000 00000000 00000000 00000000
1ec0: c787d400 c005c3d8 00000000 00000000 00000000 00000000 00000007 40046000
1ee0: 00000006 c7a81fb0 00000006 0006c0d8 c7a81fac c7a81f00 c002420c c002f114
1f00: c00242b0 c002f114 c7a81f2c c7a81f18 40046000 00000006 c7a08218 00000006
1f20: c7a31e20 40046000 c7a81f70 00000006 c7a81f6c c7a81f40 c00a2070 c00a1880
1f40: c7a80000 40046000 00001000 c7a31e20 40046000 00000000 00000000 00000006
1f60: c7a81fa4 c7a81f70 c00a22f4 c00a1fc0 00000000 00000000 00000022 00000000
1f80: ffffffff 00000006 0006c4c8 40046000 00000004 c0029c24 00000000 c7a81fa8
1fa0: c0029aa0 c00a22bc 00000006 0006c4c8 00000003 40046000 00000006 00000000
1fc0: 00000006 0006c4c8 40046000 00000004 00000006 00000000 000c42e8 00000001
1fe0: 00000000 be8a6c10 4013ce0c 4019021c 60000010 00000003 7fe00402 7ff00402
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000006 r5:c7a61618 r4:c7a81d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a61568 r6:c7a31e20 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a81f70 r6:40046000 r5:c7a31e20 r4:00000006
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:40046000 r4:c7a31e20
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40046000 r5:0006c4c8 r4:00000006
Code: e59f0010 e1a01003 eb08753c e3a03000 (e5833000) 
---[ end trace 2c683ece01bdd6a3 ]---
note: ifup[222] exited with preempt_count 1
BUG: scheduling while atomic: ifup/222/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a80000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c787d400 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7a81abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a08214 r6:00000000 r5:00000000 r4:c7a081e0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c787d400 r4:c7a081e0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c787d400
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a81ca0 r6:c7a081e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c787d400 r5:c7a081e0 r4:c7a81ca0
r3:c7a81ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a81ca0 to 0xc7a81ce8)
1ca0: 00000027 00000002 00000002 00000000 c7a81d78 c0428ee0 00000006 00000000
1cc0: 00000000 00000000 c7a31e20 c7a81cf4 c7a81c30 c7a81ce8 c003e318 c002cbf0
1ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000006 r5:c7a81cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000006 r5:c7a61618 r4:c7a81d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a61568 r6:c7a31e20 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a81f70 r6:40046000 r5:c7a31e20 r4:00000006
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:40046000 r4:c7a31e20
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:40046000 r5:0006c4c8 r4:00000006
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a08860 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c04286c0 00000008 00000000
7cc0: 00000000 00000000 c789f840 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a08860 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c04286c0 00000008 00000000
7cc0: 00000000 00000000 c789f840 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00407cc>] (put_files_struct+0x94/0xec)
[<c0040738>] (put_files_struct+0x0/0xec) from [<c00408d0>] (exit_files+0x58/0x5c)
[<c0040878>] (exit_files+0x0/0x5c) from [<c0040adc>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a08860 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a08860 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c04286c0 00000008 00000000
7cc0: 00000000 00000000 c789f840 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00000008 r5:c7a617a0 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a616f0 r6:c789f840 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400c3000 r5:c789f840 r4:00000008
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400c3000 r4:c789f840
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400c3000 r5:000233d8 r4:00000008
init: udev main process (216) killed by SEGV signal
init: udev main process ended, respawning
hbm fpgaload loaded successfully
DSPLOAD: loaded successful
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7b08000
[00000000] *pgd=87b00831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#4] PREEMPT
Modules linked in: dspload(+) fpgaload mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #2)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2fc>]    psr: 60000013
sp : c7a37ce8  ip : c7a37c30  fp : c7a37cf4
r10: c789fc40  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00001000  r5 : c0426060  r4 : c7a37d78
r3 : 00000000  r2 : 00000002  r1 : 00000003  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87b08008  DAC: 00000015
Process udevadm (pid: 246, stack limit = 0xc7a36268)
Stack: (0xc7a37ce8 to 0xc7a38000)
7ce0:                   c7a37d14 c7a37cf8 c0076aac c002cbd8 c7a37d78 c7ad3f68
7d00: 00001000 c02530a0 c7a37d74 c7a37d18 c0076c2c c0076a74 00001000 00000000
7d20: c7a37d44 c7a37d40 c7a36000 00000000 00001000 00000000 00000000 00000000
7d40: c0035114 c0426060 00000001 00000000 00000000 00000000 c789fc40 c7a37d78
7d60: 00000000 00000000 c7a37dac c7a37d78 c0076d64 c0076b50 c7a37f10 00000001
7d80: 00000000 00001000 00000000 00000000 00000000 c789fc40 c7ad3eb8 00001000
7da0: c7a37e3c c7a37db0 c0078f60 c0076d14 00000000 00000000 c7a37ed0 00001000
7dc0: 00000000 c0035114 c7a37dec c7a37dd8 c0035114 c002b620 c7ad3f68 c7a37ed0
7de0: c7a37f10 c7a37e98 c008ed00 bec4fb78 00000004 00000001 c7a37e18 00000001
7e00: 00000000 00002000 c74041a0 00001000 c7a37d28 00000000 c789fc40 c7ad3ed4
7e20: 00000000 c7a37e98 c7a37f10 00000001 c7a37e8c c7a37e40 c0079024 c0078b04
7e40: 00000066 c7a37f64 91827364 c7a37e4c c7a37e4c c7a37e54 c7a37e54 00000000
7e60: bec4f88c c789fc40 c7a37e98 c7a37f70 c7a37f10 fffffdee c7a36000 00000000
7e80: c7a37f3c c7a37e90 c00a191c c0078fb8 00000000 00000000 c7867100 00000001
7ea0: 00000000 00000001 ffffffff c789fc40 00000000 00000000 00000000 00000000
7ec0: c7860c40 c7a37ed0 00000000 00000000 00000000 00000000 c0024c60 00000002
7ee0: 00001000 ffffffff 00001000 00001f9a c7a37f1c c7a37f00 c002cbb0 c002b5f0
7f00: c002b614 00000001 c0306a38 c7a36000 4003c000 00001000 c7a37e18 00001000
7f20: c789fc40 4003c000 c7a37f70 00001000 c7a37f6c c7a37f40 c00a2070 c00a1880
7f40: c7a37f80 0000004e c0029c24 c789fc40 4003c000 00000000 00000000 00001000
7f60: c7a37fa4 c7a37f70 c00a22f4 c00a1fc0 00000000 00000000 bec4f8a0 00000000
7f80: 00000006 00001000 402245c8 4003c000 00000004 c0029c24 00000000 c7a37fa8
7fa0: c0029aa0 c00a22bc 00001000 402245c8 00000001 4003c000 00001000 00000000
7fc0: 00001000 402245c8 4003c000 00000004 00001000 00000001 000c42e8 bec4f864
7fe0: 00000000 bec4f2a8 4015fe0c 401b321c 60000010 00000001 006c6961 646e616e
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00001000 r5:c7ad3f68 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7ad3eb8 r6:c789fc40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a37f70 r6:4003c000 r5:c789fc40 r4:00001000
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4003c000 r4:c789fc40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4003c000 r5:402245c8 r4:00001000
Code: e59f0010 e1a01003 eb08753c e3a03000 (e5833000) 
---[ end trace 2c683ece01bdd6a4 ]---
note: udevadm[246] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/246/0x40000002
Modules linked in: dspload(+) fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7a37abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a7d3d4 r6:00000000 r5:00000000 r4:c7a7d3a0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7860c40 r4:c7a7d3a0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a7d3a0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a7d3a0 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000003 00000002 00000000 c7a37d78 c0426060 00001000 00000000
7cc0: 00000000 00000000 c789fc40 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00001000 r5:c7ad3f68 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7ad3eb8 r6:c789fc40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a37f70 r6:4003c000 r5:c789fc40 r4:00001000
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4003c000 r4:c789fc40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4003c000 r5:402245c8 r4:00001000
hbm netx_reset loaded successfully
netx mmap loaded successfully
PAD_TX0= 0x20f8
WEIM registers set up:
CSCR4U_VAL = 0x580
CSCR4L_VAL = 0x3d51
CSCR4A_VAL = 0x20
BCM_VAL = 1000
BUG: scheduling while atomic: udevadm/246/0x40000002
Modules linked in: i2c_imx(+) netx netx_reset dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7a37abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a7d3d4 r6:00000000 r5:00000000 r4:c7a7d3a0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7860c40 r4:c7a7d3a0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a7d3a0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a7d3a0 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000003 00000002 00000000 c7a37d78 c0426060 00001000 00000000
7cc0: 00000000 00000000 c789fc40 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00001000 r5:c7ad3f68 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7ad3eb8 r6:c789fc40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a37f70 r6:4003c000 r5:c789fc40 r4:00001000
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4003c000 r4:c789fc40
[<c00a22b0>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4003c000 r5:402245c8 r4:00001000
BUG: scheduling while atomic: udevadm/246/0x40000002
Modules linked in: i2c_imx(+) netx netx_reset dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0249f58>] (dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249f40>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c024a258>] (__schedule+0x60/0x2f0)
 r4:c7860c40 r3:00000000
[<c024a1f8>] (__schedule+0x0/0x2f0) from [<c00357d0>] (__cond_resched+0x24/0x3c)
[<c00357ac>] (__cond_resched+0x0/0x3c) from [<c024a58c>] (_cond_resched+0x38/0x48)
 r4:c7a37abc r3:00000001
[<c024a554>] (_cond_resched+0x0/0x48) from [<c00903ac>] (unmap_page_range+0x1c4/0x1dc)
[<c00901e8>] (unmap_page_range+0x0/0x1dc) from [<c00908b4>] (unmap_vmas+0x80/0xb0)
[<c0090834>] (unmap_vmas+0x0/0xb0) from [<c0094b04>] (exit_mmap+0x12c/0x290)
[<c00949d8>] (exit_mmap+0x0/0x290) from [<c003b224>] (mmput+0x3c/0xec)
 r7:c7a7d3d4 r6:00000000 r5:00000000 r4:c7a7d3a0
[<c003b1e8>] (mmput+0x0/0xec) from [<c003f2fc>] (exit_mm+0x150/0x160)
 r5:c7860c40 r4:c7a7d3a0
[<c003f1ac>] (exit_mm+0x0/0x160) from [<c0040acc>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7860c40
[<c00408d4>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a7d3a0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860c40 r5:c7a7d3a0 r4:c7a37ca0
r3:c7a37ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000003 00000002 00000000 c7a37d78 c0426060 00001000 00000000
7cc0: 00000000 00000000 c789fc40 c7a37cf4 c7a37c30 c7a37ce8 c003e2fc c002cbf0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a37cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076aac>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076a68>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076c2c>] (generic_perform_write+0xe8/0x1c4)
 r7:c02530a0 r6:00001000 r5:c7ad3f68 r4:c7a37d78
[<c0076b44>] (generic_perform_write+0x0/0x1c4) from [<c0076d64>] (generic_file_buffered_write+0x5c/0x88)
[<c0076d08>] (generic_file_buffered_write+0x0/0x88) from [<c0078f60>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7ad3eb8 r6:c789fc40 r5:00000000 r4:00000000
[<c0078af8>] (__generic_file_aio_write+0x0/0x4b4) from [<c0079024>] (generic_file_aio_write+0x78/0xe8)
[<c0078fac>] (generic_file_aio_write+0x0/0xe8) from [<c00a191c>] (do_sync_write+0xa8/0xe4)
[<c00a1874>] (do_sync_write+0x0/0xe4) from [<c00a2070>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a37f70 r6:4003c000 r5:c789fc40 r4:00001000
[<c00a1fb4>] (vfs_write+0x0/0x148) from [<c00a22f4>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000

Log with CONFIG_PREEMPT_LL=y:
Starting kernel ...

Uncompressing Linux... done, booting the kernel.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a38000
[00000000] *pgd=87a37831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: nand_ecc
CPU: 0    Not tainted  (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e2cc>]    psr: 20000013
sp : c7a2fce8  ip : c7a2fc30  fp : c7a2fcf4
r10: c783ba20  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000008  r5 : c03305e0  r4 : c7a2fd78
r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a38008  DAC: 00000015
Process udevd (pid: 210, stack limit = 0xc7a2e268)
Stack: (0xc7a2fce8 to 0xc7a30000)
fce0:                   c7a2fd14 c7a2fcf8 c0076658 c002cbd8 c7a2fd78 c7a697a0
fd00: 00000008 c02507a0 c7a2fd74 c7a2fd18 c00767d8 c0076620 00000008 00000000
fd20: c7a2fd44 c7a2fd40 c7a2e000 00000000 00001000 00000000 00000000 00000000
fd40: c0035114 c03305e0 00000001 00000000 00000000 00000000 c783ba20 c7a2fd78
fd60: 00000000 00000000 c7a2fdac c7a2fd78 c0076910 c00766fc c7a2ff10 00000001
fd80: 00000000 00000008 00000000 00000000 00000000 c783ba20 c7a696f0 00000008
fda0: c7a2fe3c c7a2fdb0 c0078b0c c00768c0 00000000 00000000 c7a2fed0 00000008
fdc0: 00000000 c0035114 c7a2fdec c7a2fdd8 c0035114 c002b620 c7a697a0 c7a2fed0
fde0: c7a2ff10 c7a2fe98 c008e090 c0035064 00000000 00000001 c7a2fe24 c7a3c650
fe00: 400d5000 00000000 c7a39000 00000008 c7a01960 00000000 c783ba20 c7a6970c
fe20: 00000000 c7a2fe98 c7a2ff10 00000001 c7a2fe8c c7a2fe40 c0078bd0 c00786b0
fe40: c002b614 00000001 91827364 c7a2fe4c c7a2fe4c c7a2fe54 c7a2fe54 00000000
fe60: c7a2feb4 c783ba20 c7a2fe98 c7a2ff70 c7a2ff10 fffffdee c7a2e000 00000000
fe80: c7a2ff3c c7a2fe90 c00a04d0 c0078b64 00000000 00000000 c014ca68 c0035064
fea0: 00000000 00000001 ffffffff c783ba20 00000000 00000000 00000000 00000000
fec0: c78663c0 c005bf94 00000000 00000000 00000000 00000000 00000007 400d5000
fee0: 00000008 c7a2ffb0 00000008 beca8378 c7a2ffac c7a2ff00 c002420c c002f114
ff00: c00242b0 c002f114 00000000 c0035114 400d5000 00000008 c0035114 00000008
ff20: c783ba20 400d5000 c7a2ff70 00000008 c7a2ff6c c7a2ff40 c00a0c24 c00a0434
ff40: c7a2e000 400d5000 00001000 c783ba20 400d5000 00000000 00000000 00000008
ff60: c7a2ffa4 c7a2ff70 c00a0ea8 c00a0b74 00000000 00000000 00000022 00000000
ff80: ffffffff 00000008 000233d8 400d5000 00000004 c0029c24 00000000 c7a2ffa8
ffa0: c0029aa0 c00a0e70 00000008 000233d8 0000000a 400d5000 00000008 00000000
ffc0: 00000008 000233d8 400d5000 00000004 00000008 00022344 000c42e8 00000001
ffe0: 00000000 beca76e8 40166e0c 401ba21c 60000010 0000000a c4cc6558 40880810
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000008 r5:c7a697a0 r4:c7a2fd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a696f0 r6:c783ba20 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2ff70 r6:400d5000 r5:c783ba20 r4:00000008
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d5000 r4:c783ba20
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400d5000 r5:000233d8 r4:00000008
Code: e59f0010 e1a01003 eb086b03 e3a03000 (e5833000) 
---[ end trace 48a34d846aec482e ]---
note: udevd[210] exited with preempt_count 1
BUG: scheduling while atomic: udevd/210/0x40000002
Modules linked in: nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a2e000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c78663c0 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a2fabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01994 r6:00000000 r5:00000000 r4:c7a01960
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c78663c0 r4:c7a01960
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c78663c0
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2fca0 r6:c7a01960 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c78663c0 r5:c7a01960 r4:c7a2fca0
r3:c7a2fca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2fca0 to 0xc7a2fce8)
fca0: 00000027 00000000 00000002 00000000 c7a2fd78 c03305e0 00000008 00000000
fcc0: 00000000 00000000 c783ba20 c7a2fcf4 c7a2fc30 c7a2fce8 c003e2cc c002cbf0
fce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2fcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000008 r5:c7a697a0 r4:c7a2fd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a696f0 r6:c783ba20 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2ff70 r6:400d5000 r5:c783ba20 r4:00000008
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d5000 r4:c783ba20
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400d5000 r5:000233d8 r4:00000008
init: mount main process (212) terminated with status 1
BUG: scheduling while atomic: udevd/210/0x40000002
Modules linked in: nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a2e000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c78663c0 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c787b2e0 r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c0040760>] (put_files_struct+0x94/0xec)
[<c00406cc>] (put_files_struct+0x0/0xec) from [<c0040864>] (exit_files+0x58/0x5c)
[<c004080c>] (exit_files+0x0/0x5c) from [<c0040a70>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c78663c0
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a2fca0 r6:c7a01960 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c78663c0 r5:c7a01960 r4:c7a2fca0
r3:c7a2fca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a2fca0 to 0xc7a2fce8)
fca0: 00000027 00000000 00000002 00000000 c7a2fd78 c03305e0 00000008 00000000
fcc0: 00000000 00000000 c783ba20 c7a2fcf4 c7a2fc30 c7a2fce8 c003e2cc c002cbf0
fce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a2fcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000008 r5:c7a697a0 r4:c7a2fd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a696f0 r6:c783ba20 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a2ff70 r6:400d5000 r5:c783ba20 r4:00000008
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d5000 r4:c783ba20
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400d5000 r5:000233d8 r4:00000008

tim login: init: udev main process (210) killed by SEGV signal
init: udev main process ended, respawning
NAND device: Manufacturer ID: 0xec, Chip ID: 0xd3 (Samsung NAND 1GiB 3,3V 8-bit)
Scanning device for bad blocks
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7aa8000
[00000000] *pgd=87a7a831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#2] PREEMPT
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e2cc>]    psr: 20000013
sp : c7abbce8  ip : c7abbc30  fp : c7abbcf4
r10: c783b620  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000041  r5 : c03306c0  r4 : c7abbd78
r3 : 00000000  r2 : 00000002  r1 : 00000001  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87aa8008  DAC: 00000015
Process syslogd (pid: 230, stack limit = 0xc7aba268)
Stack: (0xc7abbce8 to 0xc7abc000)
bce0:                   c7abbd14 c7abbcf8 c0076658 c002cbd8 c7abbd78 c7a69308
bd00: 00000041 c02507a0 c7abbd74 c7abbd18 c00767d8 c0076620 00000041 00000000
bd20: c7abbd44 c7abbd40 c7aba000 00000000 00001000 00000000 00000000 00000000
bd40: c7abbd74 c03306c0 c0041c68 00000000 00000000 00000000 c783b620 c7abbd78
bd60: 00000000 00000000 c7abbdac c7abbd78 c0076910 c00766fc c7abbf10 00000001
bd80: 00000000 00000041 00000000 00000000 00000000 c783b620 c7a69258 00000041
bda0: c7abbe3c c7abbdb0 c0078b0c c00768c0 00000000 00000000 c7abbed0 00000041
bdc0: 00000000 c0057430 ffffffff c7aba000 c7abbe2c c7abbde0 c7a69308 c7abbed0
bde0: c7abbf10 c7abbe98 00000000 40107000 00000000 00000001 40107000 c0425140
be00: c7abbe2c c7a1ee38 000000b7 00000041 c7aa9000 00000000 c783b620 c7a69274
be20: 00000000 c7abbe98 c7abbf10 00000001 c7abbe8c c7abbe40 c0078bd0 c00786b0
be40: c002cbb0 c002b5f0 91827364 c7abbe4c c7abbe4c c7abbe54 c7abbe54 00000000
be60: c002b650 c783b620 c7abbe98 c7abbf70 c7abbf10 fffffdee c7aba000 00000000
be80: c7abbf3c c7abbe90 c00a04d0 c0078b64 00000000 00000000 c7abbebc c7abbea8
bea0: 00000000 00000001 ffffffff c783b620 00000000 00000000 00000000 00000000
bec0: c7866980 c7abbed0 00000000 00000000 00000000 00000000 00000000 00000007
bee0: 00000041 40107200 00000041 00000041 00000000 0006c6f0 c7abbfac c7abbf08
bf00: c00242b0 c002f114 00000003 173eed83 0006c458 00000041 00000088 00000041
bf20: c783b620 0006c458 c7abbf70 00000041 c7abbf6c c7abbf40 c00a0c24 c00a0434
bf40: 00000088 00000000 00000010 c783b620 0006c458 00000000 00000000 00000041
bf60: c7abbfa4 c7abbf70 c00a0ea8 c00a0b74 00000000 00000000 00000003 00000000
bf80: 00001000 0006b89c 00000041 0006c458 00000004 c0029c24 00000000 c7abbfa8
bfa0: c0029aa0 c00a0e70 0006b89c 00000041 00000004 0006c458 00000041 00032000
bfc0: 0006b89c 00000041 0006c458 00000004 00000041 00000000 0006c6f0 beb5abdc
bfe0: 00000004 beb5ab30 0000faa4 4010721c 60000010 00000004 87ffe821 87ffec21
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000041 r5:c7a69308 r4:c7abbd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a69258 r6:c783b620 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7abbf70 r6:0006c458 r5:c783b620 r4:00000041
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c783b620
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Code: e59f0010 e1a01003 eb086b03 e3a03000 (e5833000) 
---[ end trace 48a34d846aec482f ]---
note: syslogd[230] exited with preempt_count 1
BUG: scheduling while atomic: syslogd/230/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7aba000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c7866980 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7abbabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a99e34 r6:00000000 r5:00000000 r4:c7a99e00
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c7866980 r4:c7a99e00
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7866980
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7abbca0 r6:c7a99e00 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c7866980 r5:c7a99e00 r4:c7abbca0
r3:c7abbca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7abbca0 to 0xc7abbce8)
bca0: 00000027 00000001 00000002 00000000 c7abbd78 c03306c0 00000041 00000000
bcc0: 00000000 00000000 c783b620 c7abbcf4 c7abbc30 c7abbce8 c003e2cc c002cbf0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7abbcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000041 r5:c7a69308 r4:c7abbd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a69258 r6:c783b620 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7abbf70 r6:0006c458 r5:c783b620 r4:00000041
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c783b620
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/230/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7aba000 r5:c0302a18 r4:00000000 r3:20000013
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c7866980 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c787b2e0 r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c0040760>] (put_files_struct+0x94/0xec)
[<c00406cc>] (put_files_struct+0x0/0xec) from [<c0040864>] (exit_files+0x58/0x5c)
[<c004080c>] (exit_files+0x0/0x5c) from [<c0040a70>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7866980
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7abbca0 r6:c7a99e00 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c7866980 r5:c7a99e00 r4:c7abbca0
r3:c7abbca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7abbca0 to 0xc7abbce8)
bca0: 00000027 00000001 00000002 00000000 c7abbd78 c03306c0 00000041 00000000
bcc0: 00000000 00000000 c783b620 c7abbcf4 c7abbc30 c7abbce8 c003e2cc c002cbf0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7abbcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000041 r5:c7a69308 r4:c7abbd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a69258 r6:c783b620 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7abbf70 r6:0006c458 r5:c783b620 r4:00000041
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c783b620
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
BUG: scheduling while atomic: syslogd/230/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7aba000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c7866980 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c787b2e0 r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c0040760>] (put_files_struct+0x94/0xec)
[<c00406cc>] (put_files_struct+0x0/0xec) from [<c0040864>] (exit_files+0x58/0x5c)
[<c004080c>] (exit_files+0x0/0x5c) from [<c0040a70>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7866980
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7abbca0 r6:c7a99e00 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c7866980 r5:c7a99e00 r4:c7abbca0
r3:c7abbca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7abbca0 to 0xc7abbce8)
bca0: 00000027 00000001 00000002 00000000 c7abbd78 c03306c0 00000041 00000000
bcc0: 00000000 00000000 c783b620 c7abbcf4 c7abbc30 c7abbce8 c003e2cc c002cbf0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7abbcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000041 r5:c7a69308 r4:c7abbd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a69258 r6:c783b620 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7abbf70 r6:0006c458 r5:c783b620 r4:00000041
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c783b620
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
sched: RT throttling activated
BUG: scheduling while atomic: syslogd/230/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7aba000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c7866980 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c787b2e0 r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c0040760>] (put_files_struct+0x94/0xec)
[<c00406cc>] (put_files_struct+0x0/0xec) from [<c0040864>] (exit_files+0x58/0x5c)
[<c004080c>] (exit_files+0x0/0x5c) from [<c0040a70>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c7866980
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7abbca0 r6:c7a99e00 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c7866980 r5:c7a99e00 r4:c7abbca0
r3:c7abbca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7abbca0 to 0xc7abbce8)
bca0: 00000027 00000001 00000002 00000000 c7abbd78 c03306c0 00000041 00000000
bcc0: 00000000 00000000 c783b620 c7abbcf4 c7abbc30 c7abbce8 c003e2cc c002cbf0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7abbcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000041 r5:c7a69308 r4:c7abbd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a69258 r6:c783b620 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000041 r7:c7abbf70 r6:0006c458 r5:c783b620 r4:00000041
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c783b620
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Segmentation faultinit: syslogd main process (227) terminated with status 139

init: syslogd main process ended, respawning
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7a5c000
[00000000] *pgd=87a66831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#3] PREEMPT
Modules linked in: fpgaload(+) mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbf0>]    lr : [<c003e2cc>]    psr: 20000013
sp : c7a63ce8  ip : c7a63c30  fp : c7a63cf4
r10: c7ae5540  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000006  r5 : c0331ee0  r4 : c7a63d78
r3 : 00000000  r2 : 00000002  r1 : 00000002  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a5c008  DAC: 00000015
Process ifup (pid: 215, stack limit = 0xc7a62268)
Stack: (0xc7a63ce8 to 0xc7a64000)
3ce0:                   c7a63d14 c7a63cf8 c0076658 c002cbd8 c7a63d78 c7a79de0
3d00: 00000006 c02507a0 c7a63d74 c7a63d18 c00767d8 c0076620 00000006 00000000
3d20: c7a63d44 c7a63d40 c7a62000 00000000 00001000 00000000 00000000 00000000
3d40: c7a63d74 c0331ee0 c0041c68 00000000 00000000 00000000 c7ae5540 c7a63d78
3d60: 00000000 00000000 c7a63dac c7a63d78 c0076910 c00766fc c7a63f10 00000001
3d80: 00000000 00000006 00000000 00000000 00000000 c7ae5540 c7a79d30 00000006
3da0: c7a63e3c c7a63db0 c0078b0c c00768c0 00000000 00000000 c7a63ed0 00000006
3dc0: 00000000 c0035114 c7a63dec c7a63dd8 c0035114 c002b620 c7a79de0 c7a63ed0
3de0: c7a63f10 c7a63e98 c008e090 c0035064 00000000 00000001 c7a63e24 c7ab24f0
3e00: 400ba000 00000000 c7a5d000 00000006 c7a014e0 00000000 c7ae5540 c7a79d4c
3e20: 00000000 c7a63e98 c7a63f10 00000001 c7a63e8c c7a63e40 c0078bd0 c00786b0
3e40: c002b614 00000001 91827364 c7a63e4c c7a63e4c c7a63e54 c7a63e54 00000000
3e60: c7a63eb4 c7ae5540 c7a63e98 c7a63f70 c7a63f10 fffffdee c7a62000 00000000
3e80: c7a63f3c c7a63e90 c00a04d0 c0078b64 00000000 00000000 c014ca68 c0035064
3ea0: 00000000 00000001 ffffffff c7ae5540 00000000 00000000 00000000 00000000
3ec0: c7838920 c005bf94 00000000 00000000 00000000 00000000 00000007 400ba000
3ee0: 00000006 c7a63fb0 00000006 0006c0d8 c7a63fac c7a63f00 c002420c c002f114
3f00: c00242b0 c002f114 00000000 c0035114 400ba000 00000006 c0035114 00000006
3f20: c7ae5540 400ba000 c7a63f70 00000006 c7a63f6c c7a63f40 c00a0c24 c00a0434
3f40: c7a62000 400ba000 00001000 c7ae5540 400ba000 00000000 00000000 00000006
3f60: c7a63fa4 c7a63f70 c00a0ea8 c00a0b74 00000000 00000000 00000022 00000000
3f80: ffffffff 00000006 0006c4c8 400ba000 00000004 c0029c24 00000000 c7a63fa8
3fa0: c0029aa0 c00a0e70 00000006 0006c4c8 00000003 400ba000 00000006 00000000
3fc0: 00000006 0006c4c8 400ba000 00000004 00000006 00000000 000c42e8 00000001
3fe0: 00000000 be851c10 4014ee0c 401a221c 60000010 00000003 87ffe821 87ffec21
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000006 r5:c7a79de0 r4:c7a63d78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a79d30 r6:c7ae5540 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a63f70 r6:400ba000 r5:c7ae5540 r4:00000006
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:400ba000 r4:c7ae5540
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400ba000 r5:0006c4c8 r4:00000006
Code: e59f0010 e1a01003 eb086b03 e3a03000 (e5833000) 
---[ end trace 48a34d846aec4830 ]---
note: ifup[215] exited with preempt_count 1
BUG: scheduling while atomic: ifup/215/0x40000002
Modules linked in: fpgaload(+) mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a62000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c7838920 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a63abc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01514 r6:00000000 r5:00000000 r4:c7a014e0
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c7838920 r4:c7a014e0
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7838920
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a63ca0 r6:c7a014e0 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c7838920 r5:c7a014e0 r4:c7a63ca0
r3:c7a63ca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a63ca0 to 0xc7a63ce8)
3ca0: 00000027 00000002 00000002 00000000 c7a63d78 c0331ee0 00000006 00000000
3cc0: 00000000 00000000 c7ae5540 c7a63cf4 c7a63c30 c7a63ce8 c003e2cc c002cbf0
3ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000006 r5:c7a63cd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00000006 r5:c7a79de0 r4:c7a63d78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a79d30 r6:c7ae5540 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a63f70 r6:400ba000 r5:c7ae5540 r4:00000006
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:400ba000 r4:c7ae5540
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:400ba000 r5:0006c4c8 r4:00000006
hbm fpgaload loaded successfully
DSPLOAD: loaded successful
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c7ad4000
[00000000] *pgd=87ae7831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#4] PREEMPT
Modules linked in: dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbf0>]    lr : [<c003e2b0>]    psr: 60000013
sp : c7a9dce8  ip : c7a9dc30  fp : c7a9dcf4
r10: c789a440  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00001000  r5 : c0331f60  r4 : c7a9dd78
r3 : 00000000  r2 : 00000002  r1 : 00000003  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87ad4008  DAC: 00000015
Process udevadm (pid: 233, stack limit = 0xc7a9c268)
Stack: (0xc7a9dce8 to 0xc7a9e000)
dce0:                   c7a9dd14 c7a9dcf8 c0076658 c002cbd8 c7a9dd78 c7a69180
dd00: 00001000 c02507a0 c7a9dd74 c7a9dd18 c00767d8 c0076620 00001000 00000000
dd20: c7a9dd44 c7a9dd40 c7a9c000 00000000 00001000 00000000 00000000 00000000
dd40: c0035114 c0331f60 00000001 00000000 00000000 00000000 c789a440 c7a9dd78
dd60: 00000000 00000000 c7a9ddac c7a9dd78 c0076910 c00766fc c7a9df10 00000001
dd80: 00000000 00001000 00000000 00000000 00000000 c789a440 c7a690d0 00001000
dda0: c7a9de3c c7a9ddb0 c0078b0c c00768c0 00000000 00000000 c7a9ded0 00001000
ddc0: 00000000 c0035114 c7a9ddec c7a9ddd8 c0035114 c002b620 c7a69180 c7a9ded0
dde0: c7a9df10 c7a9de98 956d607c becb3b78 00000004 00000001 c7a9de18 00000001
de00: 00000000 00002000 c74042e0 00001000 c7a9dd28 00000000 c789a440 c7a690ec
de20: 00000000 c7a9de98 c7a9df10 00000001 c7a9de8c c7a9de40 c0078bd0 c00786b0
de40: 000000a0 c7a9df64 91827364 c7a9de4c c7a9de4c c7a9de54 c7a9de54 00000000
de60: becb388c c789a440 c7a9de98 c7a9df70 c7a9df10 fffffdee c7a9c000 00000000
de80: c7a9df3c c7a9de90 c00a04d0 c0078b64 00000000 00000000 c7a9deb4 c7a9dea8
dea0: 00000000 00000001 ffffffff c789a440 00000000 00000000 00000000 00000000
dec0: c789ba00 c03059d8 00000000 00000000 00000000 00000000 c7a9df04 c7a9dee8
dee0: 00001000 c0035064 00001000 00001f60 c7aa4000 00000021 00000000 00000021
df00: c03059d8 00000020 00000001 00000001 4007d000 00001000 c7a9de18 00001000
df20: c789a440 4007d000 c7a9df70 00001000 c7a9df6c c7a9df40 c00a0c24 c00a0434
df40: c7a9df80 0000004e c0029c24 c789a440 4007d000 00000000 00000000 00001000
df60: c7a9dfa4 c7a9df70 c00a0ea8 c00a0b74 00000000 00000000 becb38a0 00000000
df80: 00000005 00001000 402415c8 4007d000 00000004 c0029c24 00000000 c7a9dfa8
dfa0: c0029aa0 c00a0e70 00001000 402415c8 00000001 4007d000 00001000 00000000
dfc0: 00001000 402415c8 4007d000 00000004 00001000 0000001c 000c42e8 becb3864
dfe0: 00000000 becb32a8 4017ce0c 401d021c 60000010 00000001 00000000 00000000
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00001000 r5:c7a69180 r4:c7a9dd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7a690d0 r6:c789a440 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a9df70 r6:4007d000 r5:c789a440 r4:00001000
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4007d000 r4:c789a440
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007d000 r5:402415c8 r4:00001000
Code: e59f0010 e1a01003 eb086b03 e3a03000 (e5833000) 
---[ end trace 48a34d846aec4831 ]---
note: udevadm[233] exited with preempt_count 1
BUG: scheduling while atomic: udevadm/233/0x40000002
Modules linked in: dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a9c000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c789ba00 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a9dabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01c94 r6:00000000 r5:00000000 r4:c7a01c60
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c789ba00 r4:c7a01c60
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c789ba00
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a9dca0 r6:c7a01c60 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c789ba00 r5:c7a01c60 r4:c7a9dca0
r3:c7a9dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a9dca0 to 0xc7a9dce8)
dca0: 00000027 00000003 00000002 00000000 c7a9dd78 c0331f60 00001000 00000000
dcc0: 00000000 00000000 c789a440 c7a9dcf4 c7a9dc30 c7a9dce8 c003e2b0 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a9dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00001000 r5:c7a69180 r4:c7a9dd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7a690d0 r6:c789a440 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a9df70 r6:4007d000 r5:c789a440 r4:00001000
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4007d000 r4:c789a440
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007d000 r5:402415c8 r4:00001000
BUG: scheduling while atomic: udevadm/233/0x40000002
Modules linked in: netx_reset(+) dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a9c000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c789ba00 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a9dabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01c94 r6:00000000 r5:00000000 r4:c7a01c60
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c789ba00 r4:c7a01c60
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c789ba00
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a9dca0 r6:c7a01c60 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c789ba00 r5:c7a01c60 r4:c7a9dca0
r3:c7a9dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a9dca0 to 0xc7a9dce8)
dca0: 00000027 00000003 00000002 00000000 c7a9dd78 c0331f60 00001000 00000000
dcc0: 00000000 00000000 c789a440 c7a9dcf4 c7a9dc30 c7a9dce8 c003e2b0 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a9dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00001000 r5:c7a69180 r4:c7a9dd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7a690d0 r6:c789a440 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a9df70 r6:4007d000 r5:c789a440 r4:00001000
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4007d000 r4:c789a440
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007d000 r5:402415c8 r4:00001000
BUG: scheduling while atomic: udevadm/233/0x40000002
Modules linked in: netx_reset(+) dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a9c000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c789ba00 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a9dabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01c94 r6:00000000 r5:00000000 r4:c7a01c60
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c789ba00 r4:c7a01c60
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c789ba00
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a9dca0 r6:c7a01c60 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c789ba00 r5:c7a01c60 r4:c7a9dca0
r3:c7a9dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a9dca0 to 0xc7a9dce8)
dca0: 00000027 00000003 00000002 00000000 c7a9dd78 c0331f60 00001000 00000000
dcc0: 00000000 00000000 c789a440 c7a9dcf4 c7a9dc30 c7a9dce8 c003e2b0 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a9dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00001000 r5:c7a69180 r4:c7a9dd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7a690d0 r6:c789a440 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a9df70 r6:4007d000 r5:c789a440 r4:00001000
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4007d000 r4:c789a440
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007d000 r5:402415c8 r4:00001000
BUG: scheduling while atomic: udevadm/233/0x40000002
Modules linked in: netx_reset(+) dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a9c000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c789ba00 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c7a9dabc r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c008f73c>] (unmap_page_range+0x1c4/0x1dc)
[<c008f578>] (unmap_page_range+0x0/0x1dc) from [<c008fc44>] (unmap_vmas+0x80/0xb0)
[<c008fbc4>] (unmap_vmas+0x0/0xb0) from [<c0093e94>] (exit_mmap+0x12c/0x290)
[<c0093d68>] (exit_mmap+0x0/0x290) from [<c003b1d8>] (mmput+0x3c/0xec)
 r7:c7a01c94 r6:00000000 r5:00000000 r4:c7a01c60
[<c003b19c>] (mmput+0x0/0xec) from [<c003f290>] (exit_mm+0x150/0x160)
 r5:c789ba00 r4:c7a01c60
[<c003f140>] (exit_mm+0x0/0x160) from [<c0040a60>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c789ba00
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a9dca0 r6:c7a01c60 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c789ba00 r5:c7a01c60 r4:c7a9dca0
r3:c7a9dca0
[<c002f108>] (do_page_fault+0x0/0x14c) from [<c002420c>] (do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] (__dabt_svc+0x4c/0x80)
Exception stack(0xc7a9dca0 to 0xc7a9dce8)
dca0: 00000027 00000003 00000002 00000000 c7a9dd78 c0331f60 00001000 00000000
dcc0: 00000000 00000000 c789a440 c7a9dcf4 c7a9dc30 c7a9dce8 c003e2b0 c002cbf0
dce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00001000 r5:c7a9dcd4 r4:ffffffff
[<c002cbcc>] (__bug+0x0/0x30) from [<c0076658>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c0076614>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c00767d8>] (generic_perform_write+0xe8/0x1c4)
 r7:c02507a0 r6:00001000 r5:c7a69180 r4:c7a9dd78
[<c00766f0>] (generic_perform_write+0x0/0x1c4) from [<c0076910>] (generic_file_buffered_write+0x5c/0x88)
[<c00768b4>] (generic_file_buffered_write+0x0/0x88) from [<c0078b0c>] (__generic_file_aio_write+0x468/0x4b4)
 r8:00001000 r7:c7a690d0 r6:c789a440 r5:00000000 r4:00000000
[<c00786a4>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078bd0>] (generic_file_aio_write+0x78/0xe8)
[<c0078b58>] (generic_file_aio_write+0x0/0xe8) from [<c00a04d0>] (do_sync_write+0xa8/0xe4)
[<c00a0428>] (do_sync_write+0x0/0xe4) from [<c00a0c24>] (vfs_write+0xbc/0x148)
 r8:00001000 r7:c7a9df70 r6:4007d000 r5:c789a440 r4:00001000
[<c00a0b68>] (vfs_write+0x0/0x148) from [<c00a0ea8>] (sys_write+0x44/0x70)
 r8:00001000 r7:00000000 r6:00000000 r5:4007d000 r4:c789a440
[<c00a0e64>] (sys_write+0x0/0x70) from [<c0029aa0>] (ret_fast_syscall+0x0/0x30)
 r8:c0029c24 r7:00000004 r6:4007d000 r5:402415c8 r4:00001000
BUG: scheduling while atomic: udevadm/233/0x40000002
Modules linked in: netx_reset(+) dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
Backtrace: 
[<c002cdf8>] (dump_backtrace+0x0/0x110) from [<c0247674>] (dump_stack+0x18/0x1c)
 r6:c7a9c000 r5:c0302a18 r4:00000000 r3:20000113
[<c024765c>] (dump_stack+0x0/0x1c) from [<c003504c>] (__schedule_bug+0x58/0x64)
[<c0034ff4>] (__schedule_bug+0x0/0x64) from [<c0247970>] (__schedule+0x60/0x2f0)
 r4:c789ba00 r3:00000000
[<c0247910>] (__schedule+0x0/0x2f0) from [<c00357bc>] (__cond_resched+0x24/0x3c)
[<c0035798>] (__cond_resched+0x0/0x3c) from [<c0247ca4>] (_cond_resched+0x38/0x48)
 r4:c787b820 r3:00000001
[<c0247c6c>] (_cond_resched+0x0/0x48) from [<c0040760>] (put_files_struct+0x94/0xec)
[<c00406cc>] (put_files_struct+0x0/0xec) from [<c0040864>] (exit_files+0x58/0x5c)
[<c004080c>] (exit_files+0x0/0x5c) from [<c0040a70>] (do_exit+0x208/0x2d8)
 r5:0000000b r4:c789ba00
[<c0040868>] (do_exit+0x0/0x2d8) from [<c002d348>] (die+0x114/0x128)
[<c002d234>] (die+0x0/0x128) from [<c002f0e8>] (__do_kernel_fault+0x6c/0x8c)
 r7:c7a9dca0 r6:c7a01c60 r5:00000817 r4:00000000
[<c002f07c>] (__do_kernel_fault+0x0/0x8c) from [<c002f23c>] (do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03010c4 r6:c789

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

