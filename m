Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1KNGXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:23:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:58775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1KNGXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:23:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,506,1315206000"; 
   d="scan'208";a="84813499"
Subject: x86: WARNING: kmemcheck: Caught 8-bit read from freed memory
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 14:32:53 +0800
Message-ID: <1321252373.22361.283.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this with kmemcheck enabled. the info->device in
fb_is_primary_device isn't a pci device.

Thanks,
Shaohua

WARNING: kmemcheck: Caught 8-bit read from freed memory
(ffff88003b8a2020)
414354494f4e3d61646400444556504154483d2f646576696365732f706c6174
 f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
 ^

Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc1+ #531 Dell Inc.
Studio XPS 8000/0X231R
RIP: 0010:[<ffffffff817af82d>]  [<ffffffff817af82d>]
fb_is_primary_device+0x1d/0x30
RSP: 0018:ffff88003da53c60  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88003c18f000 RCX: dead000000200200
RDX: ffff88003b8a1b80 RSI: 2222222222222222 RDI: ffff88003c18f000
RBP: ffff88003da53c60 R08: 2222222222222222 R09: 2222222222222222
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003b8a1c10
R13: 0000000000000000 R14: ffff88003c18f350 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88003fa00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88003d5c2000 CR3: 0000000001d35000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff8146067c>] do_register_framebuffer+0x4c/0x2d0
 [<ffffffff81460922>] register_framebuffer+0x22/0x40
 [<ffffffff818d6d9a>] vga16fb_probe+0x25d/0x2cc
 [<ffffffff81506c82>] platform_drv_probe+0x12/0x20
 [<ffffffff81505583>] really_probe+0x63/0x180
 [<ffffffff81505853>] driver_probe_device+0x23/0x30
 [<ffffffff8150595b>] __device_attach+0x4b/0x60
 [<ffffffff815043b4>] bus_for_each_drv+0x64/0x90
 [<ffffffff81505771>] device_attach+0xa1/0xb0
 [<ffffffff81504de5>] bus_probe_device+0x25/0x40
 [<ffffffff81503117>] device_add+0x307/0x410
 [<ffffffff81507550>] platform_device_add+0x110/0x1f0
 [<ffffffff81e64fde>] vga16fb_init+0x88/0xb3
 [<ffffffff810002c0>] do_one_initcall+0x40/0x180
 [<ffffffff81e3bc4c>] kernel_init+0xcb/0x150
 [<ffffffff81904134>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff


