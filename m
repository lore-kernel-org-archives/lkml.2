Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1HIPNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:13:37 -0400
Received: from gateway.hbm.com ([213.157.30.2]:54932 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab1HIPNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:13:35 -0400
Thread-Index: AcxWpueDLnuy6ac4Qbe5Z2DSBsKr0Q==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Content-Transfer-Encoding: 7bit
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Tue, 9 Aug 2011 17:13:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins>
In-Reply-To: <1312580681.28695.44.camel@twins>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="Boundary-00=_P6UQONnDFR78Ts9"
Message-ID: <201108091713.19292.tim.sander@hbm.com>
X-OriginalArrivalTime: 09 Aug 2011 15:13:33.0421 (UTC) FILETIME=[E76E09D0:01CC56A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary-00=_P6UQONnDFR78Ts9
Content-Type: text/Plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi=20

I found a regression in 3.0.1-rt8 compared to 3.0-rt7 in RTB =
configuration.

The kernelconfig is attached. Plattform arm1136jfs  (pcm043).

Heres the output on booting:
Starting kernel ...

Uncompressing Linux... done, booting the kernel.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address =
00000000
pgd =3D c7a44000
[00000000] *pgd=3D87a3e831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbd0>]    lr : [<c003e29c>]    psr: 20000013
sp : c7a37ce8  ip : c7a37c30  fp : c7a37cf4
r10: c7a62c60  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000008  r5 : c0428aa0  r4 : c7a37d78
r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a44008  DAC: 00000015
Process udevd (pid: 216, stack limit =3D 0xc7a36268)
Stack: (0xc7a37ce8 to 0xc7a38000)
7ce0:                   c7a37d14 c7a37cf8 c0076a30 c002cbb8 c7a37d78 =
c7a3d7a0
7d00: 00000008 c0253020 c7a37d74 c7a37d18 c0076bb0 c00769f8 00000008 =
00000000
7d20: c7a37d44 c7a37d40 c7a36000 00000000 00001000 00000000 00000000 =
00000000
7d40: c7a37d74 c0428aa0 c0041c64 00000000 00000000 00000000 c7a62c60 =
c7a37d78
7d60: 00000000 00000000 c7a37dac c7a37d78 c0076ce8 c0076ad4 c7a37f10 =
00000001
7d80: 00000000 00000008 00000000 00000000 00000000 c7a62c60 c7a3d6f0 =
00000008
7da0: c7a37e3c c7a37db0 c0078ee4 c0076c98 00000000 00000000 c7a37ed0 =
00000008
7dc0: 00000000 c0035098 c7a37dec c7a37dd8 c0035098 c002b600 c7a3d7a0 =
c7a37ed0
7de0: c7a37f10 c7a37e98 c008ec84 c0034fe8 00000000 00000001 c7a37e24 =
c7a3fa18
7e00: 400d3000 00000000 c7a45000 00000008 c7a09860 00000000 c7a62c60 =
c7a3d70c
7e20: 00000000 c7a37e98 c7a37f10 00000001 c7a37e8c c7a37e40 c0078fa8 =
c0078a88
7e40: c002b5f4 00000001 91827364 c7a37e4c c7a37e4c c7a37e54 c7a37e54 =
00000000
7e60: c7a37eb4 c7a62c60 c7a37e98 c7a37f70 c7a37f10 fffffdee c7a36000 =
00000000
7e80: c7a37f3c c7a37e90 c00a18a0 c0078f3c 00000000 00000000 c014e08c =
c0034fe8
7ea0: 00000000 00000001 ffffffff c7a62c60 00000000 00000000 00000000 =
00000000
7ec0: c7860960 c005c35c 00000000 00000000 00000000 00000000 00000007 =
400d3000
7ee0: 00000008 c7a37fb0 00000008 be9ba378 c7a37fac c7a37f00 c002420c =
c002f0f4
7f00: c00242b0 c002f0f4 c7a37f2c c7a37f18 400d3000 00000008 c7a09898 =
00000008
7f20: c7a62c60 400d3000 c7a37f70 00000008 c7a37f6c c7a37f40 c00a1ff4 =
c00a1804
7f40: c7a36000 400d3000 00001000 c7a62c60 400d3000 00000000 00000000 =
00000008
7f60: c7a37fa4 c7a37f70 c00a2278 c00a1f44 00000000 00000000 00000022 =
00000000
7f80: ffffffff 00000008 000233d8 400d3000 00000004 c0029c04 00000000 =
c7a37fa8
7fa0: c0029a80 c00a2240 00000008 000233d8 0000000a 400d3000 00000008 =
00000000
7fc0: 00000008 000233d8 400d3000 00000004 00000008 00022344 000c42e8 =
00000001
7fe0: 00000000 be9b96e8 4017fe0c 401d321c 60000010 0000000a d4cc6578 =
c2888810
Backtrace:=20
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
Code: e59f0010 e1a01003 eb087524 e3a03000 (e5833000)=20
---[ end trace 8dc2e804e8379a4c ]---
note: udevd[216] exited with preempt_count 1
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in:
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7a37abc r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0090330>]=20
(unmap_page_range+0x1c4/0x1dc)
[<c009016c>] (unmap_page_range+0x0/0x1dc) from [<c0090838>]=20
(unmap_vmas+0x80/0xb0)
[<c00907b8>] (unmap_vmas+0x0/0xb0) from [<c0094a88>] =
(exit_mmap+0x12c/0x290)
[<c009495c>] (exit_mmap+0x0/0x290) from [<c003b1a8>] (mmput+0x3c/0xec)
 r7:c7a09894 r6:00000000 r5:00000000 r4:c7a09860
[<c003b16c>] (mmput+0x0/0xec) from [<c003f280>] (exit_mm+0x150/0x160)
 r5:c7860960 r4:c7a09860
[<c003f130>] (exit_mm+0x0/0x160) from [<c0040a50>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
init: mount main process (218) terminated with status 1
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ids(+) nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ids(+) nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008

tim login: BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ids(+) nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: nand_ids nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000013
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
NAND device: Manufacturer ID: 0xec, Chip ID: 0xd3 (Samsung NAND 1GiB =
3,3V 8-
bit)
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address =
00000000
pgd =3D c7abc000
[00000000] *pgd=3D87ab3831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 817 [#2] PREEMPT
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x398/0x404
pc : [<c002cbd0>]    lr : [<c003e280>]    psr: 60000013
sp : c7aa7ce8  ip : c7aa7c30  fp : c7aa7cf4
r10: c7a9fba0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000041  r5 : c03346e0  r4 : c7aa7d78
r3 : 00000000  r2 : 00000002  r1 : 00000001  r0 : 00000027
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87abc008  DAC: 00000015
Process syslogd (pid: 230, stack limit =3D 0xc7aa6268)
Stack: (0xc7aa7ce8 to 0xc7aa8000)
7ce0:                   c7aa7d14 c7aa7cf8 c0076a30 c002cbb8 c7aa7d78 =
c7a3d490
7d00: 00000041 c0253020 c7aa7d74 c7aa7d18 c0076bb0 c00769f8 00000041 =
00000000
7d20: c7aa7d44 c7aa7d40 c7aa6000 00000000 00001000 00000000 00000000 =
00000000
7d40: c7aa7d74 c03346e0 c0041c64 00000000 00000000 00000000 c7a9fba0 =
c7aa7d78
7d60: 00000000 00000000 c7aa7dac c7aa7d78 c0076ce8 c0076ad4 c7aa7f10 =
00000001
7d80: 00000000 00000041 00000000 00000000 00000000 c7a9fba0 c7a3d3e0 =
00000041
7da0: c7aa7e3c c7aa7db0 c0078ee4 c0076c98 00000000 00000000 c7aa7ed0 =
00000041
7dc0: 00000000 c0057428 ffffffff c7aa6000 c7aa7e2c c7aa7de0 c7a3d490 =
c7aa7ed0
7de0: c7aa7f10 c7aa7e98 00000000 401ad000 00000000 00000001 401ad000 =
c04291c0
7e00: c7aa7e2c c7a3f0d0 000000b7 00000041 c7abd000 00000000 c7a9fba0 =
c7a3d3fc
7e20: 00000000 c7aa7e98 c7aa7f10 00000001 c7aa7e8c c7aa7e40 c0078fa8 =
c0078a88
7e40: c002cb90 c002b5d0 91827364 c7aa7e4c c7aa7e4c c7aa7e54 c7aa7e54 =
00000000
7e60: c002b630 c7a9fba0 c7aa7e98 c7aa7f70 c7aa7f10 fffffdee c7aa6000 =
00000000
7e80: c7aa7f3c c7aa7e90 c00a18a0 c0078f3c 00000000 00000000 c7aa7ebc =
c7aa7ea8
7ea0: 00000000 00000001 ffffffff c7a9fba0 00000000 00000000 00000000 =
00000000
7ec0: c787d9c0 c7aa7ed0 00000000 00000000 00000000 00000000 00000000 =
00000007
7ee0: 00000041 401ad200 00000041 00000041 00000000 0006c6f0 c7aa7fac =
c7aa7f08
7f00: c00242b0 c002f0f4 00000004 01c9c384 0006c458 00000041 00000079 =
00000041
7f20: c7a9fba0 0006c458 c7aa7f70 00000041 c7aa7f6c c7aa7f40 c00a1ff4 =
c00a1804
7f40: 00000079 00000000 00000010 c7a9fba0 0006c458 00000000 00000000 =
00000041
7f60: c7aa7fa4 c7aa7f70 c00a2278 c00a1f44 00000000 00000000 00000004 =
00000000
7f80: 00001000 0006b89c 00000041 0006c458 00000004 c0029c04 00000000 =
c7aa7fa8
7fa0: c0029a80 c00a2240 0006b89c 00000041 00000004 0006c458 00000041 =
00032000
7fc0: 0006b89c 00000041 0006c458 00000004 00000041 00000000 0006c6f0 =
be8cabdc
7fe0: 00000004 be8cab30 0000faa4 401ad21c 60000010 00000004 d4cc657c =
c2c88810
Backtrace:=20
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000041 r5:c7a3d490 r4:c7aa7d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a3d3e0 r6:c7a9fba0 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000041 r7:c7aa7f70 r6:0006c458 r5:c7a9fba0 r4:00000041
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7a9fba0
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Code: e59f0010 e1a01003 eb087524 e3a03000 (e5833000)=20
---[ end trace 8dc2e804e8379a4d ]---
note: syslogd[230] exited with preempt_count 1
BUG: scheduling while atomic: syslogd/230/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7aa6000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c787d9c0 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7aa7abc r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0090330>]=20
(unmap_page_range+0x1c4/0x1dc)
[<c009016c>] (unmap_page_range+0x0/0x1dc) from [<c0090838>]=20
(unmap_vmas+0x80/0xb0)
[<c00907b8>] (unmap_vmas+0x0/0xb0) from [<c0094a88>] =
(exit_mmap+0x12c/0x290)
[<c009495c>] (exit_mmap+0x0/0x290) from [<c003b1a8>] (mmput+0x3c/0xec)
 r7:c7ab0bf4 r6:00000000 r5:00000000 r4:c7ab0bc0
[<c003b16c>] (mmput+0x0/0xec) from [<c003f280>] (exit_mm+0x150/0x160)
 r5:c787d9c0 r4:c7ab0bc0
[<c003f130>] (exit_mm+0x0/0x160) from [<c0040a50>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c787d9c0
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7aa7ca0 r6:c7ab0bc0 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c787d9c0 r5:c7ab0bc0 r4:c7aa7ca0
r3:c7aa7ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7aa7ca0 to 0xc7aa7ce8)
7ca0: 00000027 00000001 00000002 00000000 c7aa7d78 c03346e0 00000041 =
00000000
7cc0: 00000000 00000000 c7a9fba0 c7aa7cf4 c7aa7c30 c7aa7ce8 c003e280 =
c002cbd0
7ce0: 60000013 ffffffff
 r8:00000000 r7:00000000 r6:00000041 r5:c7aa7cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000041 r5:c7a3d490 r4:c7aa7d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000041 r7:c7a3d3e0 r6:c7a9fba0 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000041 r7:c7aa7f70 r6:0006c458 r5:c7a9fba0 r4:00000041
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000041 r7:00000000 r6:00000000 r5:0006c458 r4:c7a9fba0
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:0006c458 r5:00000041 r4:0006b89c
Scanning device for bad blocks
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address =
00000000
pgd =3D c7a5c000
[00000000] *pgd=3D87a7d831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 817 [#3] PREEMPT
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbd0>]    lr : [<c003e29c>]    psr: 20000013
sp : c7a6bce8  ip : c7a6bc30  fp : c7a6bcf4
r10: c789f9c0  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00000006  r5 : c0334b80  r4 : c7a6bd78
r3 : 00000000  r2 : 00000002  r1 : 00000002  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87a5c008  DAC: 00000015
Process ifup (pid: 223, stack limit =3D 0xc7a6a268)
Stack: (0xc7a6bce8 to 0xc7a6c000)
bce0:                   c7a6bd14 c7a6bcf8 c0076a30 c002cbb8 c7a6bd78 =
c7a3d308
bd00: 00000006 c0253020 c7a6bd74 c7a6bd18 c0076bb0 c00769f8 00000006 =
00000000
bd20: c7a6bd44 c7a6bd40 c7a6a000 00000000 00001000 00000000 00000000 =
00000000
bd40: c7a6bd74 c0334b80 c0041c64 00000000 00000000 00000000 c789f9c0 =
c7a6bd78
bd60: 00000000 00000000 c7a6bdac c7a6bd78 c0076ce8 c0076ad4 c7a6bf10 =
00000001
bd80: 00000000 00000006 00000000 00000000 00000000 c789f9c0 c7a3d258 =
00000006
bda0: c7a6be3c c7a6bdb0 c0078ee4 c0076c98 00000000 00000000 c7a6bed0 =
00000006
bdc0: 00000000 c0035098 c7a6bdec c7a6bdd8 c0035098 c002b600 c7a3d308 =
c7a6bed0
bde0: c7a6bf10 c7a6be98 c008ec84 c0034fe8 00000000 00000001 c7a6be24 =
c7a3f968
be00: 400ed000 00000000 c7a5d000 00000006 c7a09520 00000000 c789f9c0 =
c7a3d274
be20: 00000000 c7a6be98 c7a6bf10 00000001 c7a6be8c c7a6be40 c0078fa8 =
c0078a88
be40: c002b5f4 00000001 91827364 c7a6be4c c7a6be4c c7a6be54 c7a6be54 =
00000000
be60: c7a6beb4 c789f9c0 c7a6be98 c7a6bf70 c7a6bf10 fffffdee c7a6a000 =
00000000
be80: c7a6bf3c c7a6be90 c00a18a0 c0078f3c 00000000 00000000 c014e08c =
c0034fe8
bea0: 00000000 00000001 ffffffff c789f9c0 00000000 00000000 00000000 =
00000000
bec0: c787d400 c005c35c 00000000 00000000 00000000 00000000 00000007 =
400ed000
bee0: 00000006 c7a6bfb0 00000006 0006c0d8 c7a6bfac c7a6bf00 c002420c =
c002f0f4
bf00: c00242b0 c002f0f4 c7a6bf2c c7a6bf18 400ed000 00000006 c7a09558 =
00000006
bf20: c789f9c0 400ed000 c7a6bf70 00000006 c7a6bf6c c7a6bf40 c00a1ff4 =
c00a1804
bf40: c7a6a000 400ed000 00001000 c789f9c0 400ed000 00000000 00000000 =
00000006
bf60: c7a6bfa4 c7a6bf70 c00a2278 c00a1f44 00000000 00000000 00000022 =
00000000
bf80: ffffffff 00000006 0006c4c8 400ed000 00000004 c0029c04 00000000 =
c7a6bfa8
bfa0: c0029a80 c00a2240 00000006 0006c4c8 00000003 400ed000 00000006 =
00000000
bfc0: 00000006 0006c4c8 400ed000 00000004 00000006 00000000 000c42e8 =
00000001
bfe0: 00000000 beec0c10 40193e0c 401e721c 60000010 00000003 87ffe821 =
87ffec21
Backtrace:=20
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000006 r5:c7a3d308 r4:c7a6bd78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a3d258 r6:c789f9c0 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a6bf70 r6:400ed000 r5:c789f9c0 r4:00000006
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:400ed000 r4:c789f9c0
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400ed000 r5:0006c4c8 r4:00000006
Code: e59f0010 e1a01003 eb087524 e3a03000 (e5833000)=20
---[ end trace 8dc2e804e8379a4e ]---
note: ifup[223] exited with preempt_count 1
BUG: scheduling while atomic: ifup/223/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a6a000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c787d400 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7a6babc r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0090330>]=20
(unmap_page_range+0x1c4/0x1dc)
[<c009016c>] (unmap_page_range+0x0/0x1dc) from [<c0090838>]=20
(unmap_vmas+0x80/0xb0)
[<c00907b8>] (unmap_vmas+0x0/0xb0) from [<c0094a88>] =
(exit_mmap+0x12c/0x290)
[<c009495c>] (exit_mmap+0x0/0x290) from [<c003b1a8>] (mmput+0x3c/0xec)
 r7:c7a09554 r6:00000000 r5:00000000 r4:c7a09520
[<c003b16c>] (mmput+0x0/0xec) from [<c003f280>] (exit_mm+0x150/0x160)
 r5:c787d400 r4:c7a09520
[<c003f130>] (exit_mm+0x0/0x160) from [<c0040a50>] (do_exit+0x1f8/0x2d8)
 r7:00000817 r6:00000001 r5:0000000b r4:c787d400
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a6bca0 r6:c7a09520 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c787d400 r5:c7a09520 r4:c7a6bca0
r3:c7a6bca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a6bca0 to 0xc7a6bce8)
bca0: 00000027 00000002 00000002 00000000 c7a6bd78 c0334b80 00000006 =
00000000
bcc0: 00000000 00000000 c789f9c0 c7a6bcf4 c7a6bc30 c7a6bce8 c003e29c =
c002cbd0
bce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000006 r5:c7a6bcd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000006 r5:c7a3d308 r4:c7a6bd78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000006 r7:c7a3d258 r6:c789f9c0 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000006 r7:c7a6bf70 r6:400ed000 r5:c789f9c0 r4:00000006
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000006 r7:00000000 r6:00000000 r5:400ed000 r4:c789f9c0
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400ed000 r5:0006c4c8 r4:00000006
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
BUG: scheduling while atomic: udevd/216/0x40000002
Modules linked in: mxc_nand(+) nand nand_ids nand_ecc
Backtrace:=20
[<c002cdd8>] (dump_backtrace+0x0/0x110) from [<c0249ed8>]=20
(dump_stack+0x18/0x1c)
 r6:c7a36000 r5:c0306a38 r4:00000000 r3:20000113
[<c0249ec0>] (dump_stack+0x0/0x1c) from [<c0034fd0>]=20
(__schedule_bug+0x58/0x64)
[<c0034f78>] (__schedule_bug+0x0/0x64) from [<c024a1d8>]=20
(__schedule+0x60/0x2f0)
 r4:c7860960 r3:00000000
[<c024a178>] (__schedule+0x0/0x2f0) from [<c0035754>]=20
(__cond_resched+0x24/0x3c)
[<c0035730>] (__cond_resched+0x0/0x3c) from [<c024a50c>]=20
(_cond_resched+0x38/0x48)
 r4:c7818c80 r3:00000001
[<c024a4d4>] (_cond_resched+0x0/0x48) from [<c0040750>]=20
(put_files_struct+0x94/0xec)
[<c00406bc>] (put_files_struct+0x0/0xec) from [<c0040854>]=20
(exit_files+0x58/0x5c)
[<c00407fc>] (exit_files+0x0/0x5c) from [<c0040a60>] =
(do_exit+0x208/0x2d8)
 r5:0000000b r4:c7860960
[<c0040858>] (do_exit+0x0/0x2d8) from [<c002d328>] (die+0x114/0x128)
[<c002d214>] (die+0x0/0x128) from [<c002f0c8>] =
(__do_kernel_fault+0x6c/0x8c)
 r7:c7a37ca0 r6:c7a09860 r5:00000817 r4:00000000
[<c002f05c>] (__do_kernel_fault+0x0/0x8c) from [<c002f21c>]=20
(do_page_fault+0x134/0x14c)
 r8:00000000 r7:c03050cc r6:c7860960 r5:c7a09860 r4:c7a37ca0
r3:c7a37ca0
[<c002f0e8>] (do_page_fault+0x0/0x14c) from [<c002420c>]=20
(do_DataAbort+0x38/0xa0)
[<c00241d4>] (do_DataAbort+0x0/0xa0) from [<c002960c>] =
(__dabt_svc+0x4c/0x80)
Exception stack(0xc7a37ca0 to 0xc7a37ce8)
7ca0: 00000027 00000000 00000002 00000000 c7a37d78 c0428aa0 00000008 =
00000000
7cc0: 00000000 00000000 c7a62c60 c7a37cf4 c7a37c30 c7a37ce8 c003e29c =
c002cbd0
7ce0: 20000013 ffffffff
 r8:00000000 r7:00000000 r6:00000008 r5:c7a37cd4 r4:ffffffff
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] =

(generic_perform_write+0xe8/0x1c4)
 r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
[<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>]=20
(generic_file_buffered_write+0x5c/0x88)
[<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>]=20
(__generic_file_aio_write+0x468/0x4b4)
 r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
[<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>]=20
(generic_file_aio_write+0x78/0xe8)
[<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>]=20
(do_sync_write+0xa8/0xe4)
[<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] =
(vfs_write+0xbc/0x148)
 r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
[<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] =
(sys_write+0x44/0x70)
 r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
[<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>]=20
(ret_fast_syscall+0x0/0x30)
 r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
init: udev main process (216) killed by SEGV signal
init: udev main process ended, respawning
hbm fpgaload loaded successfully
DSPLOAD: loaded successful
kernel BUG at mm/filemap.c:2043!
Unable to handle kernel NULL pointer dereference at virtual address =
00000000
pgd =3D c7afc000
[00000000] *pgd=3D87ae6831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 817 [#4] PREEMPT
Modules linked in: dspload fpgaload mxc_nand(+) nand nand_ids nand_ecc
CPU: 0    Tainted: G      D      (3.0.1-pmx-rt8 #1)
PC is at __bug+0x24/0x30
LR is at vprintk+0x3b4/0x404
pc : [<c002cbd0>]    lr : [<c003e29c>]    psr: 20000013
sp : c7ac5ce8  ip : c7ac5c30  fp : c7ac5cf4
r10: c789f640  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : 00001000  r5 : c04260e0  r4 : c7ac5d78
r3 : 00000000  r2 : 00000002  r1 : 00000003  r0 : 00000027
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387d  Table: 87afc008  DAC: 00000015
Process udevadm (pid: 244, stack limit =3D 0xc7ac4268)
Stack: (0xc7ac5ce8 to 0xc7ac6000)
5ce0:                   c7ac5d14 c7ac5cf8 c0076a30 c002cbb8 c7ac5d78 =
c7a36f68
5d00: 00001000 c0253020 c7ac5d74 c7ac5d18 c0076bb0 c00769f8 00001000 =
00000000
5d20: c7ac5d44 c7ac5d40 c7ac4000 00000000 00001000 00000000 00000000 =
00000000
5d40: c0035098 c04260e0 00000001 00000000 00000000 00000000 c789f640 =
c7ac5d78
5d60: 00000000 00000000 c7ac5dac c7ac5d78 c0076ce8 c0076ad4 c7ac5f10 =
00000001
5d80: 00000000 00001000 00000000 00000000 00000000 c789f640 c7a36eb8 =
00001000
5da0: c7ac5e3c c7ac5db0 c0078ee4 c0076c98 00000000 00000000 c7ac5ed0 =
00001000
5dc0: 00000000 c0035098 c7ac5dec c7ac5dd8 c0035098 c002b600 c7a36f68 =
c7ac5ed0
5de0: c7ac5f10 c7ac5e98 c008ec84 beb3cb78 00000004 00000001 c7ac5e18 =
00000001
5e00: 00000000 00002000 c74041a0 00001000 c7ac5d28 00000000 c789f640 =
c7a36ed4
5e20: 00000000 c7ac5e98 c7ac5f10 00000001 c7ac5e8c c7ac5e40 c0078fa8 =
c0078a88
5e40: 000000a0 c7ac5f64 91827364 c7ac5e4c c7ac5e4c c7ac5e54 c7ac5e54 =
00000000
5e60: beb3c88c c789f640 c7ac5e98 c7ac5f70 c7ac5f10 fffffdee c7ac4000 =
00000000
5e80: c7ac5f3c c7ac5e90 c00a18a0 c0078f3c 00000000 00000000 c7863980 =
00000001
5ea0: 00000000 00000001 ffffffff c789f640 00000000 00000000 00000000 =
00000000
5ec0: c78a3a20 c7ac5ed0 00000000 00000000 00000000 00000000 c0024c60 =
00000002
5ee0: 00001000 ffffffff 00001000 00001f60 c7ac5f1c c7ac5f00 c002cb90 =
c002b5d0
5f00: c002b5f4 00000001 c0306a38 c7ac4000 400be000 00001000 c7ac5e18 =
00001000
5f20: c789f640 400be000 c7ac5f70 00001000 c7ac5f6c c7ac5f40 c00a1ff4 =
c00a1804
5f40: c7ac5f80 0000004e c0029c04 c789f640 400be000 00000000 00000000 =
00001000
5f60: c7ac5fa4 c7ac5f70 c00a2278 c00a1f44 00000000 00000000 beb3c8a0 =
00000000
5f80: 00000006 00001000 4022f5c8 400be000 00000004 c0029c04 00000000 =
c7ac5fa8
5fa0: c0029a80 c00a2240 00001000 4022f5c8 00000001 400be000 00001000 =
00000000
5fc0: 00001000 4022f5c8 400be000 00000004 00001000 0000001c 000c42e8 =
beb3c864
5fe0: 00000000 beb3c2a8 4016ae0c 401be21c 60000010 00000001 00000000 =
00000000
Backtrace:=20
[<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>]=20
(iov_iter_copy_from_user_atomic+0x44/0xdc)
[<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, =
Germany | www.hbm.com=20

Registered as GmbH (German limited liability corporation) in the =
commercial register at the local court of Darmstadt, HRB 1147 =20
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of =
the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im =
Handelsregister des Amtsgerichts Darmstadt unter HRB 1147=20
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas =
Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for =
the addressee. If you are not the intended recipient, please let me know =
and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und =
lediglich f=C3=BCr den Empfaenger bestimmt. Sollten Sie nicht der =
eigentliche Empfaenger sein, informieren Sie mich bitte kurz und =
loeschen diese E-Mail.


--Boundary-00=_P6UQONnDFR78Ts9
Content-Type: text/plain;
	charset="UTF-8";
	name="kernelconfig"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernelconfig"

#
# Automatically generated make config: don't edit
# Linux/arm 3.0.0-pmx Kernel Configuration
#
CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_HAVE_SCHED_CLOCK=y
CONFIG_GENERIC_GPIO=y
# CONFIG_ARCH_USES_GETTIMEOFFSET is not set
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_KTIME_SCALAR=y
CONFIG_HAVE_PROC_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_VECTORS_BASE=0xffff0000
# CONFIG_ARM_PATCH_PHYS_VIRT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_FORCED_THREADING=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_RCU is not set
# CONFIG_TINY_PREEMPT_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=50
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CGROUPS is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
# CONFIG_FREEZER is not set

#
# System Type
#
CONFIG_MMU=y
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_VEXPRESS is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_BCMRING is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_CNS3XXX is not set
# CONFIG_ARCH_GEMINI is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
CONFIG_ARCH_MXC=y
# CONFIG_ARCH_MXS is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_H720X is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP23XX is not set
# CONFIG_ARCH_IXP2000 is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_DOVE is not set
# CONFIG_ARCH_KIRKWOOD is not set
# CONFIG_ARCH_LOKI is not set
# CONFIG_ARCH_LPC32XX is not set
# CONFIG_ARCH_MV78XX0 is not set
# CONFIG_ARCH_ORION5X is not set
# CONFIG_ARCH_MMP is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_W90X900 is not set
# CONFIG_ARCH_NUC93X is not set
# CONFIG_ARCH_TEGRA is not set
# CONFIG_ARCH_PNX4008 is not set
# CONFIG_ARCH_PXA is not set
# CONFIG_ARCH_MSM is not set
# CONFIG_ARCH_SHMOBILE is not set
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C2410 is not set
# CONFIG_ARCH_S3C64XX is not set
# CONFIG_ARCH_S5P64X0 is not set
# CONFIG_ARCH_S5PC100 is not set
# CONFIG_ARCH_S5PV210 is not set
# CONFIG_ARCH_EXYNOS4 is not set
# CONFIG_ARCH_SHARK is not set
# CONFIG_ARCH_TCC_926 is not set
# CONFIG_ARCH_U300 is not set
# CONFIG_ARCH_U8500 is not set
# CONFIG_ARCH_NOMADIK is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP is not set
# CONFIG_PLAT_SPEAR is not set
# CONFIG_ARCH_VT8500 is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_IMX_HAVE_PLATFORM_FEC=y
CONFIG_IMX_HAVE_PLATFORM_FLEXCAN=y
CONFIG_IMX_HAVE_PLATFORM_FSL_USB2_UDC=y
CONFIG_IMX_HAVE_PLATFORM_IMX2_WDT=y
CONFIG_IMX_HAVE_PLATFORM_IMX_I2C=y
CONFIG_IMX_HAVE_PLATFORM_IMX_SSI=y
CONFIG_IMX_HAVE_PLATFORM_IMX_UART=y
CONFIG_IMX_HAVE_PLATFORM_IPU_CORE=y
CONFIG_IMX_HAVE_PLATFORM_MXC_EHCI=y
CONFIG_IMX_HAVE_PLATFORM_MXC_NAND=y
CONFIG_IMX_HAVE_PLATFORM_SDHCI_ESDHC_IMX=y
CONFIG_IMX_HAVE_PLATFORM_SPI_IMX=y

#
# Freescale MXC Implementations
#
# CONFIG_ARCH_MX1 is not set
# CONFIG_ARCH_MX2 is not set
# CONFIG_ARCH_MX25 is not set
CONFIG_ARCH_MX3=y
# CONFIG_ARCH_MX503 is not set
# CONFIG_ARCH_MX51 is not set
CONFIG_ARCH_MX35=y
CONFIG_SOC_IMX35=y

#
# MX31 platforms:
#
# CONFIG_MACH_MX31ADS is not set
# CONFIG_MACH_MX31LILLY is not set
# CONFIG_MACH_MX31LITE is not set
# CONFIG_MACH_PCM037 is not set
# CONFIG_MACH_MX31_3DS is not set
# CONFIG_MACH_MX31MOBOARD is not set
# CONFIG_MACH_QONG is not set
# CONFIG_MACH_ARMADILLO5X0 is not set
# CONFIG_MACH_KZM_ARM11_01 is not set
# CONFIG_MACH_BUG is not set

#
# MX35 platforms:
#
CONFIG_MACH_PCM043=y
# CONFIG_MACH_MX35_3DS is not set
# CONFIG_MACH_EUKREA_CPUIMX35 is not set
# CONFIG_MACH_VPR200 is not set
# CONFIG_MXC_IRQ_PRIOR is not set
CONFIG_MXC_AVIC=y
# CONFIG_MXC_PWM is not set
# CONFIG_MXC_DEBUG_BOARD is not set
CONFIG_HAVE_EPIT=y
# CONFIG_MXC_USE_EPIT is not set
CONFIG_MXC_ULPI=y
CONFIG_ARCH_MXC_IOMUX_V3=y
CONFIG_ARCH_MXC_AUDMUX_V2=y

#
# System MMU
#

#
# Processor Type
#
CONFIG_CPU_V6=y
CONFIG_CPU_32v6=y
CONFIG_CPU_ABRT_EV6=y
CONFIG_CPU_PABRT_V6=y
CONFIG_CPU_CACHE_V6=y
CONFIG_CPU_CACHE_VIPT=y
CONFIG_CPU_COPY_V6=y
CONFIG_CPU_TLB_V6=y
CONFIG_CPU_HAS_ASID=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y
CONFIG_CPU_USE_DOMAINS=y

#
# Processor Features
#
CONFIG_ARM_THUMB=y
# CONFIG_CPU_ICACHE_DISABLE is not set
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_CPU_BPREDICT_DISABLE is not set
CONFIG_OUTER_CACHE=y
CONFIG_OUTER_CACHE_SYNC=y
CONFIG_CACHE_L2X0=y
CONFIG_ARM_L1_CACHE_SHIFT=5
CONFIG_ARM_DMA_MEM_BUFFERABLE=y
CONFIG_CPU_HAS_PMU=y
# CONFIG_ARM_ERRATA_411920 is not set
# CONFIG_PL310_ERRATA_588369 is not set
# CONFIG_PL310_ERRATA_727915 is not set

#
# Bus support
#
# CONFIG_PCI_SYSCALL is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCCARD is not set

#
# Kernel Features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_PREEMPT=y
CONFIG_PREEMPT_RT_BASE=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT_LL is not set
CONFIG_PREEMPT_RTB=y
# CONFIG_PREEMPT_RT_FULL is not set
CONFIG_HZ=100
CONFIG_AEABI=y
# CONFIG_OABI_COMPAT is not set
# CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
CONFIG_HAVE_ARCH_PFN_VALID=y
# CONFIG_HIGHMEM is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_FORCE_MAX_ZONEORDER=11
CONFIG_ALIGNMENT_TRAP=y
# CONFIG_UACCESS_WITH_MEMCPY is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_DEPRECATED_PARAM_STRUCT is not set

#
# Boot options
#
# CONFIG_USE_OF is not set
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_CMDLINE="console=ttymxc0,115200n8 quiet"
CONFIG_CMDLINE_FROM_BOOTLOADER=y
# CONFIG_CMDLINE_EXTEND is not set
# CONFIG_CMDLINE_FORCE is not set
# CONFIG_XIP_KERNEL is not set
CONFIG_KEXEC=y
CONFIG_ATAGS_PROC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_AUTO_ZRELADDR is not set

#
# CPU Power Management
#
# CONFIG_CPU_IDLE is not set

#
# Floating point emulation
#

#
# At least one emulation must be selected
#
CONFIG_VFP=y

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Power management options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_MCP251X is not set
CONFIG_HAVE_CAN_FLEXCAN=y
CONFIG_CAN_FLEXCAN=y
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AFS_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_ARM_INTEGRATOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
CONFIG_MTD_NAND_MXC=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_DEBUG is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_MG_DISK is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_BMP085 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_SPI is not set
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_MII is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_AX88796 is not set
# CONFIG_SMC91X is not set
# CONFIG_DM9000 is not set
# CONFIG_ENC28J60 is not set
# CONFIG_ETHOC is not set
# CONFIG_SMC911X is not set
# CONFIG_SMSC911X is not set
# CONFIG_DNET is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
# CONFIG_B44 is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
CONFIG_FEC=y
# CONFIG_FTMAC100 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=m
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=m
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_IMX is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=m
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_LIBPS2=m
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
CONFIG_SERIAL_IMX=y
CONFIG_SERIAL_IMX_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_HVC_DCC is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_R3964 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_IMX=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_IMX_VER_0_7=y
CONFIG_SPI_IMX=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_BASIC_MMIO_CORE=y
CONFIG_GPIO_BASIC_MMIO=y
# CONFIG_GPIO_IT8761E is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_MXC=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_BQ27000=m
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
CONFIG_IMX2_WDT=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set
CONFIG_MFD_SUPPORT=y
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_ASIC3 is not set
# CONFIG_HTC_EGPIO is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_T7L66XB is not set
# CONFIG_MFD_TC6387XB is not set
# CONFIG_MFD_TC6393XB is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB_ARCH_HAS_OHCI is not set
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_MXC=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_MUSB_HDRC is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
# CONFIG_USB_SERIAL_GENERIC is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ULPI=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_MXC=y
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_DW_DMAC is not set
# CONFIG_MX3_IPU is not set
# CONFIG_TIMB_DMA is not set
CONFIG_IMX_SDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_CLKSRC_MMIO=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_ARM_UNWIND is not set
# CONFIG_DEBUG_USER is not set
# CONFIG_DEBUG_LL is not set
# CONFIG_OC_ETM is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
CONFIG_GENERIC_ATOMIC64=y
# CONFIG_AVERAGE is not set

--Boundary-00=_P6UQONnDFR78Ts9--
