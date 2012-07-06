Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab2GFAa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:30:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39495 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2GFAaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:30:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF63193.20308@jp.fujitsu.com>
Date: Fri, 6 Jul 2012 09:30:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: BUG: cannot online the hot-added cpu
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I onlined the hot-added cpu on linux-3.5-rc4, the following
messages was shown.

[  129.745837] Booting Node 2 Processor 32 APIC 0xc0
[  129.879044] ------------[ cut here ]------------
[  129.934337] WARNING: at kernel/sched/core.c:6214 build_sched_domains+0x704/0x8e8()
[  130.024978] Hardware name: PRIMEQUEST 1800E
[  130.075155] Modules linked in: megaraid_sas dpemu ebtable_nat ebtables ipt_MASQUERADE iptable_nat
nf_nat xt_CHECKSUM iptable_mangle bridge stp llc sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc
vhost_net macvtap macvlan tun uinput coretemp kvm_intel kvm crc32c_intel microcode i2c_i801 i2c_core
lpc_ich mfd_core pcspkr acpi_memhotplug e1000e i7core_edac edac_core ioatdma igb dca ptp pps_core
mptsas mptscsih mptbase scsi_transport_sas [last unloaded: scsi_wait_scan]
[  130.669192] Pid: 10000, comm: bash Tainted: G       A     3.5.0-rc4-ishi #48
[  130.753595] Call Trace:
[  130.782880]  [<ffffffff81049fb6>] warn_slowpath_common+0x85/0x9d
[  130.854807]  [<ffffffff81049fe8>] warn_slowpath_null+0x1a/0x1c
[  130.924651]  [<ffffffff81075f79>] build_sched_domains+0x704/0x8e8
[  130.997610]  [<ffffffff810763d0>] partition_sched_domains+0x273/0x2e9
[  131.074733]  [<ffffffff810a6905>] cpuset_update_active_cpus+0x6b/0x72
[  131.151860]  [<ffffffff810722d0>] cpuset_cpu_active+0x20/0x27
[  131.220662]  [<ffffffff814fbc64>] notifier_call_chain+0x37/0x63
[  131.291547]  [<ffffffff8106b8fa>] __raw_notifier_call_chain+0xe/0x10
[  131.367630]  [<ffffffff8104cc01>] __cpu_notify+0x20/0x32
[  131.431256]  [<ffffffff814ef805>] _cpu_up+0xf7/0x128
[  131.490692]  [<ffffffff814ef905>] cpu_up+0xcf/0xe1
[  131.548128]  [<ffffffff814e01b4>] store_online+0x62/0x90
[  131.611739]  [<ffffffff8130daca>] dev_attr_store+0x20/0x22
[  131.677426]  [<ffffffff811990ab>] sysfs_write_file+0x101/0x13d
[  131.747273]  [<ffffffff8113e9e4>] vfs_write+0xae/0x10a
[  131.808798]  [<ffffffff8113eb03>] sys_write+0x4a/0x71
[  131.869289]  [<ffffffff814ff3a9>] system_call_fastpath+0x16/0x1b
[  131.941169] ---[ end trace 6df754ed91edd189 ]---
[  131.997505] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[  131.998051] IP: [<ffffffff81252cd8>] __bitmap_weight+0x31/0x8c
[  131.998051] PGD 84f7e9067 PUD 842913067 PMD 0
[  131.998051] Oops: 0000 [#1] SMP
[  131.998051] CPU 17
[  131.998051] Modules linked in: megaraid_sas dpemu ebtable_nat ebtables ipt_MASQUERADE iptable_nat
nf_nat xt_CHECKSUM iptable_mangle bridge stp llc sunrpc nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables binfmt_misc
vhost_net macvtap macvlan tun uinput coretemp kvm_intel kvm crc32c_intel microcode i2c_i801 i2c_core
lpc_ich mfd_core pcspkr acpi_memhotplug e1000e i7core_edac edac_core ioatdma igb dca ptp pps_core
mptsas mptscsih mptbase scsi_transport_sas [last unloaded: scsi_wait_scan]
[  131.998051]
[  131.998051] Pid: 10000, comm: bash Tainted: G       AW    3.5.0-rc4-ishi #48 FUJITSU-SV
PRIMEQUEST 1800E/SB
[  131.998051] RIP: 0010:[<ffffffff81252cd8>]  [<ffffffff81252cd8>] __bitmap_weight+0x31/0x8c
[  131.998051] RSP: 0018:ffff8808408f3bd8  EFLAGS: 00010297
[  131.998051] RAX: 0000000000000004 RBX: 0000000000000018 RCX: ffff8808408f3c08
[  131.998051] RDX: 0000000000000018 RSI: 0000000000000100 RDI: 0000000000000018
[  131.998051] RBP: ffff8808408f3c08 R08: 0000000000000100 R09: ffffffff81adfaa0
[  131.998051] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
[  131.998051] R13: 0000000000000100 R14: 0000000000000004 R15: 0000000000000000
[  131.998051] FS:  00007f9f7fd3a700(0000) GS:ffff88085f320000(0000) knlGS:0000000000000000
[  131.998051] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  131.998051] CR2: 000000000073f778 CR3: 000000084436f000 CR4: 00000000000007e0
[  131.998051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  131.998051] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  131.998051] Process bash (pid: 10000, threadinfo ffff8808408f2000, task ffff8808471bdc80)
[  131.998051] Stack:
[  131.998051]  0000000000000000 0000000000000020 0000000000000000 ffff8808523f8000
[  131.998051]  ffffffff81ade070 ffff880844074000 ffff8808408f3cb8 ffffffff81075f88
[  131.998051]  ffff8808408f3c28 ffff88104ff85780 0000000000000020 000000000000fea8
[  131.998051] Call Trace:
[  131.998051]  [<ffffffff81075f88>] build_sched_domains+0x713/0x8e8
[  131.998051]  [<ffffffff810763d0>] partition_sched_domains+0x273/0x2e9
[  131.998051]  [<ffffffff810a6905>] cpuset_update_active_cpus+0x6b/0x72
[  131.998051]  [<ffffffff810722d0>] cpuset_cpu_active+0x20/0x27
[  131.998051]  [<ffffffff814fbc64>] notifier_call_chain+0x37/0x63
[  131.998051]  [<ffffffff8106b8fa>] __raw_notifier_call_chain+0xe/0x10
[  131.998051]  [<ffffffff8104cc01>] __cpu_notify+0x20/0x32
[  131.998051]  [<ffffffff814ef805>] _cpu_up+0xf7/0x128
[  131.998051]  [<ffffffff814ef905>] cpu_up+0xcf/0xe1
[  131.998051]  [<ffffffff814e01b4>] store_online+0x62/0x90
[  131.998051]  [<ffffffff8130daca>] dev_attr_store+0x20/0x22
[  131.998051]  [<ffffffff811990ab>] sysfs_write_file+0x101/0x13d
[  131.998051]  [<ffffffff8113e9e4>] vfs_write+0xae/0x10a
[  131.998051]  [<ffffffff8113eb03>] sys_write+0x4a/0x71
[  131.998051]  [<ffffffff814ff3a9>] system_call_fastpath+0x16/0x1b
[  131.998051] Code: e5 41 57 45 31 ff 41 56 41 be 40 00 00 00 41 f7 fe 41 55 48 89 fa 41 89 f5 41
54 45 31 e4 53 48 89 fb 41 89 c6 48 83 ec 08 eb 1a <48> 8b 3a 48 89 55 d0 41 ff c7 e8 b5 ff ff ff 48
8b 55 d0 41 01
[  131.998051] RIP  [<ffffffff81252cd8>] __bitmap_weight+0x31/0x8c
[  131.998051]  RSP <ffff8808408f3bd8>
[  131.998051] CR2: 0000000000000018
[  135.827684] ---[ end trace 6df754ed91edd18a ]---

