Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2CHIYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:24:42 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:43272 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752836Ab2CHIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 03:24:41 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2012 03:24:41 EST
Message-ID: <4F586B32.90905@fold.natur.cuni.cz>
Date: Thu, 08 Mar 2012 09:17:54 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120210 Firefox/10.0 SeaMonkey/2.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: linux-3.2.9: OOPS in arch_get_unmapped_area_topdown()
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  does the below stacktrace of a crash on Core i7-based laptop help
somebody to come up with a fix? I found by Google some other reports
from the past. I can provide a .config or other information if you want.

Mar  7 18:47:53 vostro kernel: CPU 1 
Mar  7 18:47:53 vostro kernel: Modules linked in: usb_storage option usb_wwan usbserial cdc_ether uas usbnet
Mar  7 18:47:53 vostro kernel: 
Mar  7 18:47:53 vostro kernel: Pid: 26410, comm: X Not tainted 3.2.9-default #2 Dell Inc. Vostro 3550/0JGC48
Mar  7 18:47:53 vostro kernel: RIP: 0010:[<ffffffff810dc0e0>]  [<ffffffff810dc0e0>] find_vma+0x2c/0x5a
Mar  7 18:47:53 vostro kernel: RSP: 0018:ffff88040d38de18  EFLAGS: 00010202
Mar  7 18:47:53 vostro kernel: RAX: ffff880206a721e0 RBX: ffff88040c6564c0 RCX: 38313d79782033f9
Mar  7 18:47:53 vostro kernel: RDX: 38313d7978203431 RSI: 00007fbab4bd7000 RDI: ffff88040c6564c0
Mar  7 18:47:53 vostro kernel: RBP: ffff88040d38de18 R08: 0000000000000001 R09: ffff88040c6564c0
Mar  7 18:47:53 vostro kernel: R10: 0000000000000001 R11: 0000000000003246 R12: 0000000000038000
Mar  7 18:47:53 vostro kernel: R13: 0000000000000000 R14: ffff88040eaf2780 R15: 00000000001059b2
Mar  7 18:47:53 vostro kernel: FS:  00007fbaba86f880(0000) GS:ffff88041fa80000(0000) knlGS:0000000000000000
Mar  7 18:47:53 vostro kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar  7 18:47:53 vostro kernel: CR2: 00007fbab4ff1130 CR3: 000000040bbf7000 CR4: 00000000000406e0
Mar  7 18:47:53 vostro kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  7 18:47:53 vostro kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  7 18:47:53 vostro kernel: Process X (pid: 26410, threadinfo ffff88040d38c000, task ffff88040c4b78d0)
Mar  7 18:47:53 vostro kernel:  ffff88040d38de68 ffffffff8102f434 00007fbab4bd7000 0000000000000001
Mar  7 18:47:53 vostro kernel:  0000000000000000 0000000000038000 ffff88040eaf2780 ffff88040c4b78d0
Mar  7 18:47:53 vostro kernel:  0000000000000001 0000000000000003 ffff88040d38de88 ffffffff810dc1ae
Mar  7 18:47:53 vostro kernel:  [<ffffffff8102f434>] arch_get_unmapped_area_topdown+0x1cc/0x294
Mar  7 18:47:53 vostro kernel:  [<ffffffff810dc1ae>] get_unmapped_area+0x9a/0x10e
Mar  7 18:47:53 vostro kernel:  [<ffffffff810de3df>] do_mmap_pgoff+0xf1/0x2f0
Mar  7 18:47:53 vostro kernel:  [<ffffffff810de6cf>] sys_mmap_pgoff+0xf1/0x129
Mar  7 18:47:53 vostro kernel:  [<ffffffff81105b6e>] ? sys_ioctl+0x42/0x68
Mar  7 18:47:53 vostro kernel:  [<ffffffff8102f00d>] sys_mmap+0x1d/0x1f
Mar  7 18:47:53 vostro kernel:  [<ffffffff8162f312>] system_call_fastpath+0x16/0x1b
Mar  7 18:47:53 vostro kernel:  RSP <ffff88040d38de18>
Mar  7 18:47:53 vostro kernel: ---[ end trace 6d84d133cdb77497 ]---
Mar  7 18:49:41 vostro kernel: SysRq : Emergency Sync
Mar  7 18:49:41 vostro kernel: Emergency Sync complete



Thank you for comments,
Martin
