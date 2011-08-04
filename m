Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1HDIT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:19:59 -0400
Received: from mail.virtall.com ([178.63.195.102]:47319 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab1HDITv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=wpkg.org; h=message-id:date
	:from:mime-version:to:subject:content-type
	:content-transfer-encoding; q=dns; s=default; b=7TwfOdwdU8Cvyr5i
	9Fgs6hOsxOAgKUQU22pvGj0CG2QyNLnsoMNdGSy0uCzq4wJCSMBBXL8AGH6RIr5P
	Rc7e9ioXpVa07491AbkdWISTBU3ql/Nv6WEMAiSz1lQ9STmFsNgJG196RC1VRynj
	Xr0/VjNGJx2XjkjzneNcb3IFeiw=
Message-ID: <4E3A5623.8090003@wpkg.org>
Date: Thu, 04 Aug 2011 10:19:47 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110701 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.39.3 - BUG: unable to handle kernel NULL pointer dereference,
 IP: nfs_mark_return_delegation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just had a server dying (had to be hard rebooted) with this found in syslog:

Aug  4 00:15:53 octo kernel: [104324.700338] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
Aug  4 00:15:53 octo kernel: [104324.700834] IP: [<ffffffffa053d7b9>] nfs_mark_return_delegation+0x8/0x25 [nfs]
Aug  4 00:15:53 octo kernel: [104324.706518] PGD 0 
Aug  4 00:15:53 octo kernel: [104324.706736] Oops: 0000 [#1] SMP 
Aug  4 00:15:53 octo kernel: [104324.706959] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Aug  4 00:15:53 octo kernel: [104324.707398] CPU 4 
Aug  4 00:15:53 octo kernel: [104324.707406] Modules linked in: ip_vs_wlc ip_vs nf_conntrack drbd lru_cache nfsd fuse ipv6 nfs fscache auth_rpcgss nfs_acl lockd sunrpc 8021q xt_tcpudp iptable_filter ip_tables x_tables ext4 jbd2 crc16 dm_multipath scsi_dh video sbs sbshc battery acpi_memhotplug acpi_ipmi ipmi_msghandler ac parport_pc lp parport sg serio_raw tpm_tis tpm rtc_cmos tpm_bios rtc_core rtc_lib button i2c_i801 i2c_core ioatdma pcspkr shpchp netxen_nic 3w_9xxx qlge ixgbe dca mdio sata_nv forcedeth via686a hwmon mptctl mptsas scsi_transport_sas dm_crypt raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid0 dm_mirror sata_via sata_sis pata_sis sym53c8xx megaraid aic7xxx 3w_xxxx sky2 r8169 skge e1000e e1000 via_rhine sis900 8139too e100 mii dm_region_hash dm_log ata_piix mptspi mptscsih scsi_transport_spi mptbase ahci libahci libata sd_mod scsi_mod raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Aug  4 00:15:53 octo kernel: [104324.710582] 
Aug  4 00:15:53 octo kernel: [104324.710801] Pid: 1993, comm: kworker/4:0 Not tainted 2.6.39.3 #1 Supermicro X8DT6/X8DT6
Aug  4 00:15:53 octo kernel: [104324.711244] RIP: 0010:[<ffffffffa053d7b9>]  [<ffffffffa053d7b9>] nfs_mark_return_delegation+0x8/0x25 [nfs]
Aug  4 00:15:53 octo kernel: [104324.711701] RSP: 0018:ffff8806262d9dd0  EFLAGS: 00010246
Aug  4 00:15:53 octo kernel: [104324.711925] RAX: 0000000000000000 RBX: ffff88053e2a2e00 RCX: 0000000000000390
Aug  4 00:15:53 octo kernel: [104324.712361] RDX: ffff8803321ad808 RSI: 0000000000000286 RDI: ffff88053e2a2e00
Aug  4 00:15:53 octo kernel: [104324.712799] RBP: ffff8806262d9dd0 R08: 00000000000001f4 R09: ffff88063fc31df0
Aug  4 00:15:53 octo kernel: [104324.713232] R10: ffff8806262d9db0 R11: 0000000000000286 R12: ffff8803321ad800
Aug  4 00:15:53 octo kernel: [104324.713662] R13: ffff880331831c00 R14: ffffffffa054ab70 R15: 0000000000000000
Aug  4 00:15:53 octo kernel: [104324.714104] FS:  0000000000000000(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
Aug  4 00:15:53 octo kernel: [104324.714539] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  4 00:15:53 octo kernel: [104324.714762] CR2: 0000000000000018 CR3: 0000000001713000 CR4: 00000000000006e0
Aug  4 00:15:53 octo kernel: [104324.715198] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 00:15:53 octo kernel: [104324.715630] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 00:15:53 octo kernel: [104324.716063] Process kworker/4:0 (pid: 1993, threadinfo ffff8806262d8000, task ffff880622a49620)
Aug  4 00:15:53 octo kernel: [104324.716498] Stack:
Aug  4 00:15:53 octo kernel: [104324.716712]  ffff8806262d9e10 ffffffffa053de26 ffff8806262d9df0 0000000000000018
Aug  4 00:15:53 octo kernel: [104324.717155]  ffff88053e2a2e00 0000000000000000 ffff880331831d10 ffff880331831c00
Aug  4 00:15:53 octo kernel: [104324.717597]  ffff8806262d9e50 ffffffffa053d64e 00000001009eac05 0000000000002328
Aug  4 00:15:53 octo kernel: [104324.718040] Call Trace:
Aug  4 00:15:53 octo kernel: [104324.718274]  [<ffffffffa053de26>] nfs_expire_unreferenced_delegations+0x37/0x92 [nfs]
Aug  4 00:15:53 octo kernel: [104324.718722]  [<ffffffffa053d64e>] nfs4_renew_state+0x104/0x12e [nfs]
Aug  4 00:15:53 octo kernel: [104324.718951]  [<ffffffff81049b71>] process_one_work+0x19b/0x2c5
Aug  4 00:15:53 octo kernel: [104324.719190]  [<ffffffffa053d54a>] ? nfs4_schedule_state_renewal+0xc8/0xc8 [nfs]
Aug  4 00:15:53 octo kernel: [104324.719623]  [<ffffffff8104b4bb>] worker_thread+0x12e/0x20d
Aug  4 00:15:53 octo kernel: [104324.719847]  [<ffffffff8104b38d>] ? gcwq_mayday_timeout+0x67/0x67
Aug  4 00:15:53 octo kernel: [104324.720084]  [<ffffffff8104e9be>] kthread+0x81/0x89
Aug  4 00:15:53 octo kernel: [104324.720312]  [<ffffffff813f7d94>] kernel_thread_helper+0x4/0x10
Aug  4 00:15:53 octo kernel: [104324.720534]  [<ffffffff8104e93d>] ? kthread_stop+0x57/0x57
Aug  4 00:15:53 octo kernel: [104324.720756]  [<ffffffff813f7d90>] ? gs_change+0xb/0xb
Aug  4 00:15:53 octo kernel: [104324.720976] Code: 48 8d 7b 58 48 c7 c6 a2 d7 53 a0 e8 e8 a2 b3 e0 59 5b c9 c3 55 48 83 ef 58 48 89 e5 e8 6e 9a b7 e0 c9 c3 48 8b 47 18 55 48 89 e5 
Aug  4 00:15:53 octo kernel: <48>[104324.721311]  8b 40 18 48 8b 80 88 02 00 00 48 8b 00 f0 80 4f 48 02 f0 80 
Aug  4 00:15:53 octo kernel: [104324.721791] RIP  [<ffffffffa053d7b9>] nfs_mark_return_delegation+0x8/0x25 [nfs]
Aug  4 00:15:53 octo kernel: [104324.722242]  RSP <ffff8806262d9dd0>
Aug  4 00:15:53 octo kernel: [104324.722458] CR2: 0000000000000018
Aug  4 00:15:53 octo kernel: [104324.723126] ---[ end trace cbde0c25a938b281 ]---
Aug  4 00:15:53 octo kernel: [104324.723459] BUG: unable to handle kernel paging request at fffffffffffffff8
Aug  4 00:15:53 octo kernel: [104324.723891] IP: [<ffffffff8104e678>] kthread_data+0xb/0x11
Aug  4 00:15:53 octo kernel: [104324.724209] PGD 1715067 PUD 1716067 PMD 0 
Aug  4 00:15:53 octo kernel: [104324.724715] Oops: 0000 [#2] SMP 
Aug  4 00:15:53 octo kernel: [104324.725137] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Aug  4 00:15:53 octo kernel: [104324.725616] CPU 4 
Aug  4 00:15:53 octo kernel: [104324.725667] Modules linked in: ip_vs_wlc ip_vs nf_conntrack drbd lru_cache nfsd fuse ipv6 nfs fscache auth_rpcgss nfs_acl lockd sunrpc 8021q xt_tcpudp iptable_filter ip_tables x_tables ext4 jbd2 crc16 dm_multipath scsi_dh video sbs sbshc battery acpi_memhotplug acpi_ipmi ipmi_msghandler ac parport_pc lp parport sg serio_raw tpm_tis tpm rtc_cmos tpm_bios rtc_core rtc_lib button i2c_i801 i2c_core ioatdma pcspkr shpchp netxen_nic 3w_9xxx qlge ixgbe dca mdio sata_nv forcedeth via686a hwmon mptctl mptsas scsi_transport_sas dm_crypt raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid0 dm_mirror sata_via sata_sis pata_sis sym53c8xx megaraid aic7xxx 3w_xxxx sky2 r8169 skge e1000e e1000 via_rhine sis900 8139too e100 mii dm_region_hash dm_log ata_piix mptspi mptscsih scsi_transport_spi mptbase ahci libahci libata sd_mod scsi_mod raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Aug  4 00:15:53 octo kernel: [104324.733747] 
Aug  4 00:15:53 octo kernel: [104324.734008] Pid: 1993, comm: kworker/4:0 Tainted: G      D     2.6.39.3 #1 Supermicro X8DT6/X8DT6
Aug  4 00:15:53 octo kernel: [104324.734628] RIP: 0010:[<ffffffff8104e678>]  [<ffffffff8104e678>] kthread_data+0xb/0x11
Aug  4 00:15:53 octo kernel: [104324.735154] RSP: 0018:ffff8806262d9968  EFLAGS: 00010096
Aug  4 00:15:53 octo kernel: [104324.735420] RAX: 0000000000000000 RBX: ffff880622a49620 RCX: ffff880622a49620
Aug  4 00:15:53 octo kernel: [104324.735898] RDX: 0000000000000040 RSI: 0000000000000004 RDI: ffff880622a49620
Aug  4 00:15:53 octo kernel: [104324.736378] RBP: ffff8806262d9968 R08: ffffea0004e32940 R09: ffffffff81036a4a
Aug  4 00:15:53 octo kernel: [104324.736859] R10: dead000000200200 R11: 0000000000000004 R12: 00007ffffffff000
Aug  4 00:15:53 octo kernel: [104324.737336] R13: 0000000000000004 R14: ffff88063fc11d80 R15: ffff880622a499a0
Aug  4 00:15:53 octo kernel: [104324.737813] FS:  0000000000000000(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
Aug  4 00:15:53 octo kernel: [104324.738294] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  4 00:15:53 octo kernel: [104324.738563] CR2: fffffffffffffff8 CR3: 0000000001713000 CR4: 00000000000006e0
Aug  4 00:15:53 octo kernel: [104324.739040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  4 00:15:53 octo kernel: [104324.739515] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  4 00:15:53 octo kernel: [104324.739997] Process kworker/4:0 (pid: 1993, threadinfo ffff8806262d8000, task ffff880622a49620)
Aug  4 00:15:53 octo kernel: [104324.740506] Stack:
Aug  4 00:15:53 octo kernel: [104324.740767]  ffff8806262d9998 ffffffff8104b151 ffff8806262d9a18 ffff880622a49620
Aug  4 00:15:53 octo kernel: [104324.741510]  00007ffffffff000 ffff880622a49620 ffff8806262d9aa8 ffffffff813f4377
Aug  4 00:15:53 octo kernel: [104324.742183]  ffff880333004240 ffff880622a49620 ffff8806262d99d8 00000004810cd870
Aug  4 00:15:53 octo kernel: [104324.742856] Call Trace:
Aug  4 00:15:53 octo kernel: [104324.743120]  [<ffffffff8104b151>] wq_worker_sleeping+0x15/0x81
Aug  4 00:15:53 octo kernel: [104324.743396]  [<ffffffff813f4377>] schedule+0x16a/0x930
Aug  4 00:15:53 octo kernel: [104324.743668]  [<ffffffff81077a96>] ? call_rcu_sched+0x10/0x12
Aug  4 00:15:53 octo kernel: [104324.743939]  [<ffffffff8103b30b>] ? release_task+0x39f/0x3b7
Aug  4 00:15:53 octo kernel: [104324.744207]  [<ffffffff8103c500>] do_exit+0x6eb/0x705
Aug  4 00:15:53 octo kernel: [104324.744475]  [<ffffffff810051d3>] oops_end+0xb2/0xba
Aug  4 00:15:53 octo kernel: [104324.744743]  [<ffffffff810237ac>] no_context+0x1f5/0x204
Aug  4 00:15:53 octo kernel: [104324.745011]  [<ffffffff813f4dd0>] ? schedule_timeout+0x26/0x1c7
Aug  4 00:15:53 octo kernel: [104324.745279]  [<ffffffff81023936>] __bad_area_nosemaphore+0x17b/0x19e
Aug  4 00:15:53 octo kernel: [104324.745551]  [<ffffffff8102b713>] ? enqueue_task+0x5a/0x69
Aug  4 00:15:53 octo kernel: [104324.745819]  [<ffffffff810239cf>] bad_area_nosemaphore+0xe/0x10
Aug  4 00:15:53 octo kernel: [104324.746087]  [<ffffffff81023da5>] do_page_fault+0x17d/0x384
Aug  4 00:15:53 octo kernel: [104324.746356]  [<ffffffff8102c227>] ? select_idle_sibling+0x4a/0xe2
Aug  4 00:15:53 octo kernel: [104324.746685]  [<ffffffff8102c333>] ? __enqueue_entity+0x74/0x76
Aug  4 00:15:53 octo kernel: [104324.746953]  [<ffffffff810355b1>] ? enqueue_task_fair+0x205/0x21d
Aug  4 00:15:53 octo kernel: [104324.747291]  [<ffffffff813f689f>] page_fault+0x1f/0x30
Aug  4 00:15:53 octo kernel: [104324.747573]  [<ffffffffa053d7b9>] ? nfs_mark_return_delegation+0x8/0x25 [nfs]
Aug  4 00:15:53 octo kernel: [104324.748071]  [<ffffffffa053de26>] nfs_expire_unreferenced_delegations+0x37/0x92 [nfs]
Aug  4 00:15:53 octo kernel: [104324.748634]  [<ffffffffa053d64e>] nfs4_renew_state+0x104/0x12e [nfs]
Aug  4 00:15:53 octo kernel: [104324.748910]  [<ffffffff81049b71>] process_one_work+0x19b/0x2c5
Aug  4 00:15:53 octo kernel: [104324.749193]  [<ffffffffa053d54a>] ? nfs4_schedule_state_renewal+0xc8/0xc8 [nfs]
Aug  4 00:15:53 octo kernel: [104324.749675]  [<ffffffff8104b4bb>] worker_thread+0x12e/0x20d
Aug  4 00:15:53 octo kernel: [104324.749947]  [<ffffffff8104b38d>] ? gcwq_mayday_timeout+0x67/0x67
Aug  4 00:15:53 octo kernel: [104324.750233]  [<ffffffff8104e9be>] kthread+0x81/0x89
Aug  4 00:15:53 octo kernel: [104324.750563]  [<ffffffff813f7d94>] kernel_thread_helper+0x4/0x10
Aug  4 00:15:53 octo kernel: [104324.750831]  [<ffffffff8104e93d>] ? kthread_stop+0x57/0x57
Aug  4 00:15:53 octo kernel: [104324.751162]  [<ffffffff813f7d90>] ? gs_change+0xb/0xb
Aug  4 00:15:53 octo kernel: [104324.751428] Code: 5e 41 5f c9 c3 90 90 55 65 48 8b 04 25 c0 b5 00 00 48 8b 80 28 03 00 00 48 89 e5 8b 40 f0 c9 c3 48 8b 87 28 03 00 00 55 48 89 e5 
Aug  4 00:15:53 octo kernel: <48>[104324.754033]  8b 40 f8 c9 c3 48 3b 3d db f3 85 00 55 48 89 e5 75 09 0f bf 
Aug  4 00:15:53 octo kernel: [104324.755655] RIP  [<ffffffff8104e678>] kthread_data+0xb/0x11
Aug  4 00:15:53 octo kernel: [104324.755972]  RSP <ffff8806262d9968>
Aug  4 00:15:53 octo kernel: [104324.756235] CR2: fffffffffffffff8
Aug  4 00:15:53 octo kernel: [104324.756496] ---[ end trace cbde0c25a938b282 ]---
Aug  4 00:15:53 octo kernel: [104324.756762] Fixing recursive fault but reboot is needed!


-- 
Tomasz Chmielewski
http://wpkg.org

