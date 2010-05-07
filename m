Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0EGNRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:17:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42497 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0EGNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:17:17 -0400
Date: Fri, 7 May 2010 15:16:52 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Artem Bityutskiy <dedekind1@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sven Neumann <s.neumann@raumfeld.com>
Subject: UBIFS: Oops while rebooting 2.6.34-rc6
Message-ID: <20100507131652.GT30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've had a kernel Oops today when rebooting an ARM PXA based machine
while file I/O via SSH was outstanding.

Daniel

# reboot
# [  671.190085] UBIFS: un-mount UBI device 0, volume 1
The system is going down NOW!
Sent SIGTERM to all processes
[  672.083833] Unable to handle kernel NULL pointer dereference at virtual address 000000ac
[  672.094587] pgd = c0004000
[  672.097301] [000000ac] *pgd=00000000
[  672.100850] Internal error: Oops: 817 [#1]
[  672.104919] last sysfs file: /sys/devices/platform/spi_gpio.0/spi0.2/value
[  672.111741] Modules linked in: eeti_ts libertas_sdio libertas pxamci ds2760_battery w1_ds2760 wire
[  672.120641] CPU: 0    Tainted: G        W   (2.6.34-rc6 #154)
[  672.126376] PC is at mutex_lock+0x4/0x14
[  672.130291] LR is at make_reservation+0x74/0x328
[  672.134880] pc : [<c035bec4>]    lr : [<c0142268>]    psr: 60000013
[  672.134890] sp : c775fd18  ip : 00000088  fp : 000000ac
[  672.146281] r10: 00000000  r9 : 00000000  r8 : c7eb8000
[  672.151469] r7 : 00000088  r6 : c7a68310  r5 : c7eb8000  r4 : 00000001
[  672.157947] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 000000ac
[  672.164429] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  672.171691] Control: 0000397f  Table: a7f54018  DAC: 00000035
[  672.177394] Process flush-ubifs_0_0 (pid: 1289, stack limit = 0xc775e278)
[  672.184131] Stack: (0xc775fd18 to 0xc7760000)
[  672.188458] fd00:                                                       c7f5ea00 00000000
[  672.196588] fd20: 00000000 c775fde0 c7f6c000 000000a0 00000001 c7eb8144 00000000 c775e000
[  672.204721] fd40: 00000001 00000088 00000004 00000000 00000004 c7a68310 c7eb8000 c7a68310
[  672.212853] fd60: 00000000 000000a0 c6894180 00000000 00000000 c0143aa4 c775fde0 000006d0
[  672.220978] fd80: 0000a1e0 c7eb8000 c775fdb4 c015634c 00000001 00000080 c7a68310 00000001
[  672.229111] fda0: c7a68458 c7eb8000 00000000 00000000 00000063 c01489b0 c775fe74 c0085400
[  672.237245] fdc0: c775e000 c775e000 c7a68310 c0558b00 00000063 c014559c c7a683ac c7a683ac
[  672.245377] fde0: 00000001 c775fef0 00000400 00000000 ffffffff c775fe34 00000000 c008b2e4
[  672.253510] fe00: c0558b00 c008bb3c 0000000e c00865b4 00000007 ffffffff c7a683ac c008b2d0
[  672.261642] fe20: c7a683ac 00000001 00000001 00000001 c775fe5c 00000001 00000000 c0558b00
[  672.269767] fe40: c062cf40 c062cf60 c0629080 c06290a0 c06290c0 c06290e0 c062cd60 00000000
[  672.277900] fe60: c062d0a0 00006872 00000000 c775fef0 00000000 00000001 c04eb4f8 00000007
[  672.286034] fe80: c7a68310 c775fef0 c7eb8068 c7a683ac c04eb4f8 c775fef0 c7eb8088 c00c3f28
[  672.294166] fea0: 00000000 c7a68310 00000000 c7eb8068 c7e12600 c00c4b48 c0246d3c c7eb8090
[  672.302298] fec0: c7ac17b0 c7a68318 c7eb8068 00000000 c7eb8090 c0537a6c c775fef0 00000400
[  672.310431] fee0: c775ff60 00000000 c7eb8068 c00c4d98 c7eb8008 00000000 00000000 00000000
[  672.318555] ff00: 0000a277 00000400 00000000 00000000 00000000 00000000 ffffffff 7fffffff
[  672.326680] ff20: 00000000 00000000 c035b804 c0053aa8 c04f1f08 c04f1dbc c77a9f04 c68958c0
[  672.334813] ff40: c7eb8068 0000a270 c775ff60 00000000 00000000 c7eb80a8 00000001 c00c4f74
[  672.342944] ff60: 00000009 00000000 00000000 00000000 00000000 000001f4 c775e000 0000a270
[  672.351070] ff80: c7eb8068 c04eb4f8 c04f22b0 0000000a 00007530 c00c50e0 00000000 c7eb8008
[  672.359202] ffa0: c7eb8068 c7eb8068 c0095e18 00000000 00000000 00000000 00000000 c0095ec0
[  672.367328] ffc0: c775ffd4 c7c4bf2c c7eb8068 c006ac50 00000000 00000000 c775ffd8 c775ffd8
[  672.375459] ffe0: 00000000 00000000 00000000 00000000 00000000 c00458bc 5f455349 48504943
[  672.383609] [<c035bec4>] (mutex_lock+0x4/0x14) from [<c0142268>] (make_reservation+0x74/0x328)
[  672.392184] [<c0142268>] (make_reservation+0x74/0x328) from [<c0143aa4>] (ubifs_jnl_write_inode+0x80/0x1b8)
[  672.401871] [<c0143aa4>] (ubifs_jnl_write_inode+0x80/0x1b8) from [<c01489b0>] (ubifs_write_inode+0x64/0xc4)
[  672.411554] [<c01489b0>] (ubifs_write_inode+0x64/0xc4) from [<c014559c>] (ubifs_writepage+0x124/0x15c)
[  672.420830] [<c014559c>] (ubifs_writepage+0x124/0x15c) from [<c008b2e4>] (__writepage+0x14/0x64)
[  672.429572] [<c008b2e4>] (__writepage+0x14/0x64) from [<c008bb3c>] (write_cache_pages+0x1e4/0x2c0)
[  672.438498] [<c008bb3c>] (write_cache_pages+0x1e4/0x2c0) from [<c00c3f28>] (writeback_single_inode+0xd4/0x2b8)
[  672.448447] [<c00c3f28>] (writeback_single_inode+0xd4/0x2b8) from [<c00c4b48>] (writeback_inodes_wb+0x434/0x52c)
[  672.458568] [<c00c4b48>] (writeback_inodes_wb+0x434/0x52c) from [<c00c4d98>] (wb_writeback+0x158/0x1cc)
[  672.467907] [<c00c4d98>] (wb_writeback+0x158/0x1cc) from [<c00c4f74>] (wb_do_writeback+0x64/0x198)
[  672.476815] [<c00c4f74>] (wb_do_writeback+0x64/0x198) from [<c00c50e0>] (bdi_writeback_task+0x38/0xbc)
[  672.486084] [<c00c50e0>] (bdi_writeback_task+0x38/0xbc) from [<c0095ec0>] (bdi_start_fn+0xa8/0xf8)
[  672.495009] [<c0095ec0>] (bdi_start_fn+0xa8/0xf8) from [<c006ac50>] (kthread+0x78/0x80)
[  672.502992] [<c006ac50>] (kthread+0x78/0x80) from [<c00458bc>] (kernel_thread_exit+0x0/0x8)
[  672.511293] Code: 05843000 e28dd010 e8bd81f0 e3a02000 (e1001092) 
[  672.517534] ---[ end trace f5c79b7be5adbe31 ]---
Sent SIGKILL to all processes
Requesting system reboot[  674.543613] Restarting system.
