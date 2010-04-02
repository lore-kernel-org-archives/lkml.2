Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0DBJkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:40:11 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:60296 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0DBJkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:40:05 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 05:40:04 EDT
Date: Fri, 2 Apr 2010 09:30:34 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: kernel BUG at kernel/workqueue.c:399!
Message-ID: <alpine.LRH.2.00.1004020927440.19452@diagnostix.dwd.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

  received the following BUG with 2.6.33.1:

    Apr  2 01:05:01 hermes kernel: ------------[ cut here ]------------
    Apr  2 01:05:01 hermes kernel: kernel BUG at kernel/workqueue.c:399!
    Apr  2 01:05:01 hermes kernel: invalid opcode: 0000 [#1] SMP
    Apr  2 01:05:01 hermes kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host/host3/proc_name
    Apr  2 01:05:01 hermes kernel: CPU 1
    Apr  2 01:05:01 hermes kernel: Pid: 28, comm: events/1 Not tainted 2.6.33.1 #2 D2519/PRIMERGY RX300 S4
    Apr  2 01:05:01 hermes kernel: RIP: 0010:[<ffffffff810427dd>]  [<ffffffff810427dd>] worker_thread+0xe3/0x173
    Apr  2 01:05:01 hermes kernel: RSP: 0018:ffff88083cdc7e70  EFLAGS: 00010206
    Apr  2 01:05:01 hermes kernel: RAX: ffff8808386462a0 RBX: ffff8800282544c0 RCX: ffff8808386462a0
    Apr  2 01:05:01 hermes kernel: RDX: ffff8800282144c0 RSI: ffff88083cdc7e00 RDI: ffff880838646298
    Apr  2 01:05:01 hermes kernel: RBP: ffff88083cdc7ee0 R08: 0000000000000200 R09: ffffffff81682780
    Apr  2 01:05:01 hermes kernel: R10: ffff88083bae6950 R11: ffff88083bae6950 R12: ffff88083cdc48c0
    Apr  2 01:05:01 hermes kernel: R13: ffff8800282544c8 R14: ffffffff8103d2c9 R15: ffff8800282544d8
    Apr  2 01:05:01 hermes kernel: FS:  0000000000000000(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
    Apr  2 01:05:01 hermes kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    Apr  2 01:05:01 hermes kernel: CR2: 00007fffa2115ff0 CR3: 00000008356f2000 CR4: 00000000000406e0
    Apr  2 01:05:01 hermes kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Apr  2 01:05:01 hermes kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Apr  2 01:05:01 hermes kernel: Process events/1 (pid: 28, threadinfo ffff88083cdc6000, task ffff88083cdc48c0)
    Apr  2 01:05:01 hermes kernel: Stack:
    Apr  2 01:05:01 hermes kernel: ffff88083cdc4cf0 ffff88083cdc7fd8 0000000000000000 ffff88083cdc48c0
    Apr  2 01:05:01 hermes kernel: <0> ffffffff81045ea3 ffff88083cdc7e98 ffff88083cdc7e98 0000000000000000
    Apr  2 01:05:01 hermes kernel: <0> ffff88083cdc7ee0 ffff88083ccaddc0 ffff88083cdc7ef8 ffffffff810426fa
    Apr  2 01:05:01 hermes kernel: Call Trace:
    Apr  2 01:05:01 hermes kernel: [<ffffffff81045ea3>] ? autoremove_wake_function+0x0/0x34
    Apr  2 01:05:01 hermes kernel: [<ffffffff810426fa>] ? worker_thread+0x0/0x173
    Apr  2 01:05:01 hermes kernel: [<ffffffff81045ac3>] kthread+0x7a/0x82
    Apr  2 01:05:01 hermes kernel: [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
    Apr  2 01:05:01 hermes kernel: [<ffffffff81045a49>] ? kthread+0x0/0x82
    Apr  2 01:05:01 hermes kernel: [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
    Apr  2 01:05:01 hermes kernel: Code: 77 18 48 89 7b 30 48 8b 08 48 8b 50 08 48 89 51 08 48 89 0a 48 89 40 08 48 89 00 fe 03 fb 48 8b 50 f8 48 83 e2 fc 48 39 d3 74 04 <0f> 0b eb fe f0 80 60 f8 fe 41 ff d6 48 8b 45 98 8b 90 44 e0 ff
    Apr  2 01:05:01 hermes kernel: RIP  [<ffffffff810427dd>] worker_thread+0xe3/0x173
    Apr  2 01:05:01 hermes kernel: RSP <ffff88083cdc7e70>
    Apr  2 01:05:01 hermes kernel: ---[ end trace 9a3c461e93d472b5 ]---

Any idea what ist the cause of this. Just saw that there is now 2.6.33.2
out. Just updated to this kernel. Is this a known issue and already fixed
in 2.6.33.2?

Thanks,
Holger
