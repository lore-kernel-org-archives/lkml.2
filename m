Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2GSREa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:04:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59901 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2GSRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:04:28 -0400
MIME-Version: 1.0
Date: Thu, 19 Jul 2012 13:04:27 -0400
Message-ID: <CAB1R3sgjhtcS5m73C=oynr-UFfDak621pXdQMB2ouNSYWhgA3A@mail.gmail.com>
Subject: CPU Stuck error with 2.6.43.8
From: Alex <mysqlstudent@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an fc15 server with an Opteron 6128 that I believe was working
fine until I rebooted it last night with 2.6.43.8-1. I haven't
reported a kernel bug in a long time, so hopefully someone can help me
through the process or tell me if there's something else wrong. There
are several kvm instances running on this system.

I'm finding the following in the logs. Is this a known bug? Is there
anything that can be done with this information, or is there something
further necessary?

It's somewhat of a process to reboot this server to use a different
kernel because of the kvm instances on a production box. It would be
helpful if someone could tell me if this is indeed a kernel bug and an
older kernel would help.

[27691.032784] BUG: soft lockup - CPU#1 stuck for 33s! [qemu-kvm:3626]
[27691.032896] Modules linked in: vhost_net macvtap macvlan tun
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM
iptable_mangle sunrpc cpufreq_ondemand powernow_k8 freq_table mperf
bridge stp llc w83795 ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ftp
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ip6table_filter ip6_tables sp5100_tco i2c_piix4 i2c_core
amd64_edac_mod edac_core edac_mce_amd k10temp microcode igb dca
virtio_net kvm_amd kvm raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy async_tx raid1 ata_generic pata_acpi
usb_storage pata_atiixp [last unloaded: scsi_wait_scan]
[27691.033749] CPU 1
[27691.033749] Modules linked in: vhost_net macvtap macvlan tun
ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM
iptable_mangle sunrpc cpufreq_ondemand powernow_k8 freq_table mperf
bridge stp llc w83795 ip6t_REJECT nf_conntrack_ipv6 nf_conntrack_ftp
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ip6table_filter ip6_tables sp5100_tco i2c_piix4 i2c_core
amd64_edac_mod edac_core edac_mce_amd k10temp microcode igb dca
virtio_net kvm_amd kvm raid456 async_raid6_recov async_pq raid6_pq
async_xor xor async_memcpy async_tx raid1 ata_generic pata_acpi
usb_storage pata_atiixp [last unloaded: scsi_wait_scan]
[27691.033749]
[27691.033749] Pid: 3626, comm: qemu-kvm Not tainted
2.6.43.8-1.fc15.x86_64 #1 Supermicro H8DGU/H8DGU
[27691.033749] RIP: 0010:[<ffffffffa00a10ea>]  [<ffffffffa00a10ea>]
kvm_arch_vcpu_ioctl_run+0x4ca/0xfa0 [kvm]
[27691.033749] RSP: 0018:ffff8803f5825d58  EFLAGS: 00000203
[27691.033749] RAX: 00003233f48030c8 RBX: ffffffff8101bc99 RCX: 0000000100000000
[27691.033749] RDX: 0000000100000000 RSI: ffff880404bac000 RDI: ffff8803eeab8000
[27691.033749] RBP: ffff8803f5825df8 R08: 000000000343aa5d R09: 0000000000000000
[27691.033749] R10: 00000000000788f0 R11: 0000000000000000 R12: ffffffff8101bc23
[27691.033749] R13: ffff8803f5825cc8 R14: 0000000000000400 R15: ffff8803eeaec038
[27691.033749] FS:  00007f8d6cb2e720(0000) GS:ffff88041fa20000(0000)
knlGS:ffff88007fc00000
[27691.033749] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[27691.033749] CR2: 000000000468d108 CR3: 0000000405314000 CR4: 00000000000006e0
[27691.033749] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[27691.033749] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[27691.033749] Process qemu-kvm (pid: 3626, threadinfo
ffff8803f5824000, task ffff880402bb4590)
[27691.033749] Stack:
[27691.033749]  ffff8804057c0000 0000000000000296 ffff8803f5825da8
ffffffffa0105bce
[27691.033749]  ffff8803f5825fd8 0000000000000001 ffff880402bb4590
ffff880402bb4590
[27691.033749]  ffff880402bb4590 0000000000000206 ffff8803f5825dd8
0000000000006c06
[27691.033749] Call Trace:
[27691.033749]  [<ffffffffa0105bce>] ? svm_vcpu_load+0x6e/0x100 [kvm_amd]
[27691.033749]  [<ffffffffa008a342>] kvm_vcpu_ioctl+0x462/0x6b0 [kvm]
[27691.037893]  [<ffffffff81193858>] do_vfs_ioctl+0x98/0x550
[27691.037893]  [<ffffffff8106d1fc>] ? sys_rt_sigtimedwait+0xcc/0xe0
[27691.037893]  [<ffffffff81193da1>] sys_ioctl+0x91/0xa0
[27691.037893]  [<ffffffff8161ff29>] system_call_fastpath+0x16/0x1b
[27691.037893] Code: 00 a8 aa 0f 85 98 06 00 00 48 8b 05 91 34 03 00
48 89 df ff 90 30 02 00 00 c7 43 2c 00 00 00 00 48 89 83 c8 1f 00 00
fb 66 66 90 <66> 66 90 83 83 b8 00 00 00 01 48 8b 7d 90 e8 83 63 fe e0
48 8b
[27691.037893] Call Trace:
[27691.037893]  [<ffffffffa0105bce>] ? svm_vcpu_load+0x6e/0x100 [kvm_amd]
[27691.037893]  [<ffffffffa008a342>] kvm_vcpu_ioctl+0x462/0x6b0 [kvm]
[27691.037893]  [<ffffffff81193858>] do_vfs_ioctl+0x98/0x550
[27691.037893]  [<ffffffff8106d1fc>] ? sys_rt_sigtimedwait+0xcc/0xe0
[27691.037893]  [<ffffffff81193da1>] sys_ioctl+0x91/0xa0
[27691.037893]  [<ffffffff8161ff29>] system_call_fastpath+0x16/0x1b
[27691.147114] usb 5-3: USB disconnect, device number 27
[27691.760093] usb 5-3: new full-speed USB device number 28 using ohci_hcd
[59186.704904] kvm: 31848: cpu0 unhandled rdmsr: 0xc0010112
[59186.705051] kvm: 31848: cpu0 unhandled rdmsr: 0xc0010048
[59186.853960] kvm: 31848: cpu0 unhandled rdmsr: 0xc0010001
[59186.866451] kvm: 31848: cpu1 unhandled rdmsr: 0xc0010048
[59186.941457] kvm: 31848: cpu2 unhandled rdmsr: 0xc0010048
[59186.954027] kvm: 31848: cpu3 unhandled rdmsr: 0xc0010048

Thanks,
Alex
