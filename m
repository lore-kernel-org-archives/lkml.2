Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1HKJnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:43:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:49511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1HKJng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:43:36 -0400
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 11 Aug 2011 11:43:10 +0200
In-Reply-To: <201108091713.19292.tim.sander@hbm.com>
References: <1312580681.28695.44.camel@twins>
	 <201108091713.19292.tim.sander@hbm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313055790.23660.70.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ensure your mailer doesn't wrap splats, ARM splats are aren't my
strong point to begin with and having them look all messed up doesn't
help.

On Tue, 2011-08-09 at 17:13 +0200, Tim Sander wrote:
> kernel BUG at mm/filemap.c:2043!
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> pgd = c7a44000
> [00000000] *pgd=87a3e831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 817 [#1] PREEMPT
> Modules linked in:
> CPU: 0    Not tainted  (3.0.1-pmx-rt8 #1)
> PC is at __bug+0x24/0x30
> LR is at vprintk+0x3b4/0x404
> pc : [<c002cbd0>]    lr : [<c003e29c>]    psr: 20000013
> sp : c7a37ce8  ip : c7a37c30  fp : c7a37cf4
> r10: c7a62c60  r9 : 00000000  r8 : 00000000
> r7 : 00000000  r6 : 00000008  r5 : c0428aa0  r4 : c7a37d78
> r3 : 00000000  r2 : 00000002  r1 : 00000000  r0 : 00000027
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 00c5387d  Table: 87a44008  DAC: 00000015
> Process udevd (pid: 216, stack limit = 0xc7a36268)
> Stack: (0xc7a37ce8 to 0xc7a38000)
> 7ce0:                   c7a37d14 c7a37cf8 c0076a30 c002cbb8 c7a37d78 c7a3d7a0
> 7d00: 00000008 c0253020 c7a37d74 c7a37d18 c0076bb0 c00769f8 00000008 00000000
> 7d20: c7a37d44 c7a37d40 c7a36000 00000000 00001000 00000000 00000000 00000000
> 7d40: c7a37d74 c0428aa0 c0041c64 00000000 00000000 00000000 c7a62c60 c7a37d78
> 7d60: 00000000 00000000 c7a37dac c7a37d78 c0076ce8 c0076ad4 c7a37f10 00000001
> 7d80: 00000000 00000008 00000000 00000000 00000000 c7a62c60 c7a3d6f0 00000008
> 7da0: c7a37e3c c7a37db0 c0078ee4 c0076c98 00000000 00000000 c7a37ed0 00000008
> 7dc0: 00000000 c0035098 c7a37dec c7a37dd8 c0035098 c002b600 c7a3d7a0 c7a37ed0
> 7de0: c7a37f10 c7a37e98 c008ec84 c0034fe8 00000000 00000001 c7a37e24 c7a3fa18
> 7e00: 400d3000 00000000 c7a45000 00000008 c7a09860 00000000 c7a62c60 c7a3d70c
> 7e20: 00000000 c7a37e98 c7a37f10 00000001 c7a37e8c c7a37e40 c0078fa8 c0078a88
> 7e40: c002b5f4 00000001 91827364 c7a37e4c c7a37e4c c7a37e54 c7a37e54 00000000
> 7e60: c7a37eb4 c7a62c60 c7a37e98 c7a37f70 c7a37f10 fffffdee c7a36000 00000000
> 7e80: c7a37f3c c7a37e90 c00a18a0 c0078f3c 00000000 00000000 c014e08c c0034fe8
> 7ea0: 00000000 00000001 ffffffff c7a62c60 00000000 00000000 00000000 00000000
> 7ec0: c7860960 c005c35c 00000000 00000000 00000000 00000000 00000007 400d3000
> 7ee0: 00000008 c7a37fb0 00000008 be9ba378 c7a37fac c7a37f00 c002420c c002f0f4
> 7f00: c00242b0 c002f0f4 c7a37f2c c7a37f18 400d3000 00000008 c7a09898 00000008
> 7f20: c7a62c60 400d3000 c7a37f70 00000008 c7a37f6c c7a37f40 c00a1ff4 c00a1804
> 7f40: c7a36000 400d3000 00001000 c7a62c60 400d3000 00000000 00000000 00000008
> 7f60: c7a37fa4 c7a37f70 c00a2278 c00a1f44 00000000 00000000 00000022 00000000
> 7f80: ffffffff 00000008 000233d8 400d3000 00000004 c0029c04 00000000 c7a37fa8
> 7fa0: c0029a80 c00a2240 00000008 000233d8 0000000a 400d3000 00000008 00000000
> 7fc0: 00000008 000233d8 400d3000 00000004 00000008 00022344 000c42e8 00000001
> 7fe0: 00000000 be9b96e8 4017fe0c 401d321c 60000010 0000000a d4cc6578 c2888810
> Backtrace: 
> [<c002cbac>] (__bug+0x0/0x30) from [<c0076a30>] (iov_iter_copy_from_user_atomic+0x44/0xdc)
> [<c00769ec>] (iov_iter_copy_from_user_atomic+0x0/0xdc) from [<c0076bb0>] (generic_perform_write+0xe8/0x1c4) r7:c0253020 r6:00000008 r5:c7a3d7a0 r4:c7a37d78
> [<c0076ac8>] (generic_perform_write+0x0/0x1c4) from [<c0076ce8>] (generic_file_buffered_write+0x5c/0x88)
> [<c0076c8c>] (generic_file_buffered_write+0x0/0x88) from [<c0078ee4>] (__generic_file_aio_write+0x468/0x4b4) r8:00000008 r7:c7a3d6f0 r6:c7a62c60 r5:00000000 r4:00000000
> [<c0078a7c>] (__generic_file_aio_write+0x0/0x4b4) from [<c0078fa8>] (generic_file_aio_write+0x78/0xe8)
> [<c0078f30>] (generic_file_aio_write+0x0/0xe8) from [<c00a18a0>] (do_sync_write+0xa8/0xe4)
> [<c00a17f8>] (do_sync_write+0x0/0xe4) from [<c00a1ff4>] (vfs_write+0xbc/0x148) r8:00000008 r7:c7a37f70 r6:400d3000 r5:c7a62c60 r4:00000008
> [<c00a1f38>] (vfs_write+0x0/0x148) from [<c00a2278>] (sys_write+0x44/0x70) r8:00000008 r7:00000000 r6:00000000 r5:400d3000 r4:c7a62c60
> [<c00a2234>] (sys_write+0x0/0x70) from [<c0029a80>] (ret_fast_syscall+0x0/0x30) r8:c0029c04 r7:00000004 r6:400d3000 r5:000233d8 r4:00000008
> Code: e59f0010 e1a01003 eb087524 e3a03000 (e5833000) 
> ---[ end trace 8dc2e804e8379a4c ]--- 

Right, so I wouldn't know where to start looking on this one. That's
generic code exploding for some reason. How is that related to RTB and
what is RTB to begin with?


