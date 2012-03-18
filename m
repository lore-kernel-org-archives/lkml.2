Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2CRPgb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 11:36:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36703 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2CRPg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 11:36:29 -0400
Message-ID: <4F6600FA.7050005@gmail.com>
Date: Sun, 18 Mar 2012 08:36:26 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with the current linux-next I am seeing this in dmesg..:

[    3.643089] isapnp: No Plug & Play device found
[    3.643690] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    3.673061]
[    3.699307] ===============================
[    3.725757] [ INFO: suspicious RCU usage. ]
[    3.752134] 3.3.0-rc7-next-20120316 #1 Not tainted
[    3.778508] -------------------------------
[    3.778510] kernel/cgroup.c:1719 suspicious rcu_dereference_check() 
usage!
[    3.778512]
[    3.778512] other info that might help us debug this:
[    3.778513]
[    3.778515]
[    3.778515] rcu_scheduler_active = 1, debug_locks = 1
[    3.778517] no locks held by swapper/0/1.
[    3.778517]
[    3.778518] stack backtrace:
[    3.778519] Pid: 1, comm: swapper/0 Not tainted 
3.3.0-rc7-next-20120316 #1
[    3.778521] Call Trace:
[    3.778528]  [<c158cc21>] ? printk+0x1d/0x1f
[    3.778534]  [<c10a822a>] lockdep_rcu_suspicious+0xca/0x100
[    3.778536]  [<c10bedea>] cgroup_path+0x17a/0x1c0
[    3.778540]  [<c12d4e92>] ? __raw_spin_lock_init+0x32/0x60
[    3.778545]  [<c12b9eba>] blkg_lookup_create+0x1aa/0x430
[    3.778548]  [<c1596ec5>] ? _raw_spin_lock_irq+0x55/0x60
[    3.778550]  [<c12bc32b>] blk_throtl_init+0x11b/0x210
[    3.778552]  [<c12bc24a>] ? blk_throtl_init+0x3a/0x210
[    3.778554]  [<c12ba600>] blkcg_init_queue+0x30/0x80
[    3.778558]  [<c129fc77>] blk_alloc_queue_node+0x1e7/0x220
[    3.778560]  [<c129fcc2>] blk_alloc_queue+0x12/0x20
[    3.778563]  [<c13a4139>] brd_alloc+0x69/0x180
[    3.778566]  [<c1398ab5>] ? device_pm_init+0x65/0x90
[    3.778569]  [<c186f0e7>] brd_init+0xb0/0x185
[    3.778574]  [<c138fe07>] ? device_register+0x17/0x20
[    3.778577]  [<c1003034>] do_one_initcall+0x34/0x170
[    3.778578]  [<c186f037>] ? regmap_initcall+0xc/0xc
[    3.778582]  [<c183e8d9>] kernel_init+0x103/0x198
[    3.778584]  [<c183e19a>] ? rdinit_setup+0x22/0x22
[    3.778586]  [<c183e7d6>] ? start_kernel+0x38b/0x38b
[    3.778589]  [<c159ef02>] kernel_thread_helper+0x6/0x10
[    3.778592]  [<c136d379>] ? tty_change_softcar+0x29/0xe0
[    3.780902] brd: module loaded
[    3.782352] loop: module loaded
[    3.782641] ahci 0000:00:1f.2: version 3.


dmesg here:
http://fpaste.org/CpBD/

from what I remember I was doing a git pull and ran out of memory then 
ran git pull again and everything seemed alright, so I proceeded with 
building and running this kernel on reboot this showed up.

Justin P. Mattock
