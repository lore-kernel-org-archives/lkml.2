Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0KIKaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:30:19 -0500
Received: from lucidpixels.com ([75.144.35.66]:36925 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0KIKaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:30:18 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 05:30:18 EST
Date: Tue, 9 Nov 2010 05:24:28 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: ext3-users@redhat.com
Subject: Assertion failure in journal_commit_transaction() at fs/jbd/commit.c:496:
 "commit_transaction->t_nr_buffers <=
 commit_transaction->t_outstanding_credits"
Message-ID: <alpine.DEB.2.00.1011090519120.5074@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have the same errors as these folks:
https://bugzilla.redhat.com/show_bug.cgi?id=563247

OS: RHEL 5 x86_64
Kernel: 2.6.18

I see this on a wide variety of hardware and according to the bug report,
it happens whether its hardware raid or dm.

Since there are no records of this bug/issue on LKML I thought I'd pose the
question.  I am just looking into what is the root cause here, is it an ext3
bug?

Assertion failure in journal_commit_transaction() at fs/jbd/commit.c:496: "commit_transaction->t_nr_buffers <= commit_transaction->t_outstanding_credits"
----------- [cut here ] --------- [please bite here ] ---------
Kernel BUG at fs/jbd/commit.c:496
invalid opcode: 0000 [1] SMP
last sysfs file: /class/scsi_host/host0/stats
CPU 3
Modules linked in: i2c_dev eeprom adm1026 hwmon_vid i2c_amd756 nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc ipv6 xfrm_nalgo crypto_api dm_mirror dm_log dm_mod video backlight sbs i2c_ec button battery asus_acpi acpi_memhotplug ac lp floppy shpchp k8temp k8_edac hwmon parport_pc amd_rng edac_mc parport i2c_amd8111 tg3 serio_raw i2c_core pcspkr sg 3w_9xxx sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 1473, comm: kjournald Not tainted 2.6.18-164.el5az00 #1
RIP: 0010:[<ffffffff88033b05>]  [<ffffffff88033b05>] :jbd:journal_commit_transaction+0x6a3/0x106a
RSP: 0018:ffff81020ee63de0  EFLAGS: 00010286
RAX: 000000000000009d RBX: ffff810133f3c130 RCX: ffffffff80304ba8
RDX: ffffffff80304ba8 RSI: 0000000000000000 RDI: ffffffff80304ba0
RBP: ffff81010f6f4200 R08: ffffffff80304ba8 R09: 000000000000003d
R10: ffff81020ee63a80 R11: 0000000000000280 R12: ffff81011520b730
R13: ffff8101139b41c0 R14: 0000000000000001 R15: ffff81010e441000
FS:  00002b03c3c59d30(0000) GS:ffff8101139aa6c0(0000) knlGS:00000000f7f228d0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002aac9c7f20a0 CR3: 00000001fe72d000 CR4: 00000000000006e0
Process kjournald (pid: 1473, threadinfo ffff81020ee62000, task ffff81010e8aa820)
Stack:  00021f55e0d52ccc ffff81010e441000 ffff810100000000 000000b500000000
  0000000000000000 ffff81010e8aa820 ffffffff8009f468 ffff81020ee63e18
  ffff81020ee63e18 00000000ffffffff 0000000000000286 ffffffff8004b241
Call Trace:
  [<ffffffff8009f468>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8004b241>] try_to_del_timer_sync+0x51/0x5a
  [<ffffffff8803758c>] :jbd:kjournald+0xc1/0x213
  [<ffffffff8009f468>] autoremove_wake_function+0x0/0x2e
  [<ffffffff880374cb>] :jbd:kjournald+0x0/0x213
  [<ffffffff8009f250>] keventd_create_kthread+0x0/0xc4
  [<ffffffff8003295e>] kthread+0xfe/0x132
  [<ffffffff8005dfb1>] child_rip+0xa/0x11
  [<ffffffff8009f250>] keventd_create_kthread+0x0/0xc4
  [<ffffffff80032860>] kthread+0x0/0x132
  [<ffffffff8005dfa7>] child_rip+0x0/0x11


Code: 0f 0b 68 74 8e 03 88 c2 f0 01 45 31 e4 45 31 ff 45 31 f6 c7
RIP  [<ffffffff88033b05>] :jbd:journal_commit_transaction+0x6a3/0x106a
  RSP <ffff81020ee63de0>

Message from<0>Kernel panic - not syncing: Fatal exception

