Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DTCCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab1DTCCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:02:21 -0400
Date: Tue, 19 Apr 2011 22:02:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: rcu stall.
Message-ID: <20110420020215.GA30081@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Machine was under heavy load (300 or so running processes
calling random system calls). The rcu stall detector kicked in,
spewed this, and then the machine completely locked up.

	Dave

 INFO: rcu_sched_state detected stall on CPU 0 (t=65000 jiffies)
 sending NMI to all CPUs:
 NMI backtrace for cpu 0
 CPU 0 
 Modules linked in: snd_seq_dummy ip6_queue nfnetlink scsi_transport_iscsi ip_queue ipt_ULOG can_raw hidp inet_diag tun can_bcm sctp libcrc32c bnep rfcomm cmtp kernelcapi ipx p8022 p8023 af_key rose ax25 phonet appletalk psnap llc can rds pppoe pppox ppp_generic slhc decnet irda crc_ccitt af_802154 atm fuse nfsd lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 snd_hda_codec_realtek iwlagn snd_hda_intel snd_hda_codec snd_hwdep snd_seq mac80211 snd_seq_device snd_pcm uvcvideo snd_timer btusb bluetooth snd e1000e videodev cfg80211 microcode joydev v4l2_compat_ioctl32 iTCO_wdt pcspkr soundcore iTCO_vendor_support i2c_i801 snd_page_alloc sony_laptop rfkill tpm_infineon wmi uinput ipv6 sdhci_pci sdhci mmc_core firewire_ohci firewire_core yenta_socket crc_itu_t nouveau i915 ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
 
 Pid: 983, comm: wpa_supplicant Not tainted 2.6.39-rc4+ #2 Sony Corporation VGN-Z540N/VAIO
 RIP: 0010:[<ffffffff81256fea>]  [<ffffffff81256fea>] __bitmap_empty+0x56/0x58
 RSP: 0018:ffff8800baa03dc8  EFLAGS: 00000046
 RAX: 0000000000000000 RBX: 0000000000002710 RCX: 0000000000000040
 RDX: 0000000000000001 RSI: 0000000000000200 RDI: ffffffff81b5fa50
 RBP: ffff8800baa03dc8 R08: 0000000000000002 R09: 0000000000000000
 R10: 0000ffff00066c0a R11: 0000000000000001 R12: ffffffff81a32000
 R13: ffffffff81a32100 R14: ffff8800baa03f50 R15: ffffffff810819c4
 FS:  00007f17cd9ac7e0(0000) GS:ffff8800baa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fbf04ce3010 CR3: 00000000a1427000 CR4: 00000000000006f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process wpa_supplicant (pid: 983, threadinfo ffff8800a6fbe000, task ffff8800a6c20000)
 Stack:
  ffff8800baa03de8 ffffffff810218a0 0000000000000000 ffff8800babd0680
  ffff8800baa03e38 ffffffff810bbf77 0000000000000096 0000000000000000
  ffff8800baa03e18 0000000000000000 0000000000000000 0000000000000000
 Call Trace:
  <IRQ> 
  [<ffffffff810218a0>] arch_trigger_all_cpu_backtrace+0x68/0x88
  [<ffffffff810bbf77>] __rcu_pending+0x8c/0x321
  [<ffffffff810819c4>] ? tick_nohz_handler+0xdf/0xdf
  [<ffffffff810bc668>] rcu_check_callbacks+0x88/0xb9
  [<ffffffff81064ad8>] update_process_times+0x3f/0x75
  [<ffffffff81081a39>] tick_sched_timer+0x75/0x9e
  [<ffffffff8107653f>] __run_hrtimer+0xcf/0x15a
  [<ffffffff81076cef>] hrtimer_interrupt+0xe1/0x1c2
  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff814c794e>] smp_apic_timer_interrupt+0x79/0x8c
  [<ffffffff814c67d3>] apic_timer_interrupt+0x13/0x20
  <EOI> 
  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff81082e4f>] ? arch_local_irq_restore+0x6/0xd
  [<ffffffff81084df8>] lock_acquired+0x20f/0x21e
  [<ffffffff814be9cc>] _raw_spin_lock+0x62/0x6a
  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff814bf215>] ? _raw_spin_unlock+0x28/0x2c
  [<ffffffff8114f842>] simple_release_fs+0x22/0x57
  [<ffffffff811f53e9>] debugfs_remove_recursive+0x11f/0x16b
  [<ffffffffa037adf3>] ieee80211_debugfs_key_remove+0x1f/0x2e [mac80211]
  [<ffffffffa0373e7a>] __ieee80211_key_destroy+0x61/0x6d [mac80211]
  [<ffffffffa0374250>] ieee80211_key_link+0x12c/0x165 [mac80211]
  [<ffffffffa036b90e>] ieee80211_add_key+0xfb/0x133 [mac80211]
  [<ffffffffa0277ff4>] nl80211_new_key+0xe5/0x106 [cfg80211]
  [<ffffffffa026d2c5>] ? cfg80211_get_dev_from_ifindex+0x72/0x7a [cfg80211]
  [<ffffffff81422244>] genl_rcv_msg+0x1dc/0x207
  [<ffffffff81422068>] ? genl_rcv+0x2d/0x2d
  [<ffffffff81421c69>] netlink_rcv_skb+0x43/0x8f
  [<ffffffff81422061>] genl_rcv+0x26/0x2d
  [<ffffffff8142176a>] netlink_unicast+0xec/0x156
  [<ffffffff81421a53>] netlink_sendmsg+0x27f/0x2c0
  [<ffffffff813ed78c>] __sock_sendmsg+0x69/0x75
  [<ffffffff813ed905>] sock_sendmsg+0xa1/0xb6
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff81100de0>] ? might_fault+0xa5/0xac
  [<ffffffff81100d97>] ? might_fault+0x5c/0xac
  [<ffffffff813ec8e4>] ? copy_from_user+0x2f/0x31
  [<ffffffff813f707a>] ? copy_from_user+0x2f/0x31
  [<ffffffff813f7370>] ? verify_iovec+0x52/0xa6
  [<ffffffff813eece3>] sys_sendmsg+0x23a/0x2b8
  [<ffffffff81086d29>] ? lock_acquire+0xec/0xfb
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff8114b7d7>] ? mntput+0x26/0x28
  [<ffffffff811343bc>] ? fput+0x1e6/0x1f5
  [<ffffffff8113ba95>] ? path_put+0x1f/0x23
  [<ffffffff810a9f23>] ? audit_syscall_entry+0x11c/0x148
  [<ffffffff81255e4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff814c5d82>] system_call_fastpath+0x16/0x1b
 Code: 2a 89 f0 4c 63 c2 41 b9 40 00 00 00 99 41 f7 f9 b8 01 00 00 00 88 d1 48 d3 e0 48 ff c8 4a 85 04 c7 0f 94 c0 0f b6 c0 eb 02 31 c0 <5d> c3 89 f0 55 b9 40 00 00 00 99 f7 f9 48 89 e5 31 d2 eb 0b 48 
 Call Trace:
  <IRQ>  [<ffffffff810218a0>] arch_trigger_all_cpu_backtrace+0x68/0x88
  [<ffffffff810bbf77>] __rcu_pending+0x8c/0x321
  [<ffffffff810819c4>] ? tick_nohz_handler+0xdf/0xdf
  [<ffffffff810bc668>] rcu_check_callbacks+0x88/0xb9
  [<ffffffff81064ad8>] update_process_times+0x3f/0x75
  [<ffffffff81081a39>] tick_sched_timer+0x75/0x9e
  [<ffffffff8107653f>] __run_hrtimer+0xcf/0x15a
  [<ffffffff81076cef>] hrtimer_interrupt+0xe1/0x1c2
  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff814c794e>] smp_apic_timer_interrupt+0x79/0x8c
  [<ffffffff814c67d3>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff81082e4f>] ? arch_local_irq_restore+0x6/0xd
  [<ffffffff81084df8>] lock_acquired+0x20f/0x21e
  [<ffffffff814be9cc>] _raw_spin_lock+0x62/0x6a
  [<ffffffff8114f842>] ? simple_release_fs+0x22/0x57
  [<ffffffff814bf215>] ? _raw_spin_unlock+0x28/0x2c
  [<ffffffff8114f842>] simple_release_fs+0x22/0x57
  [<ffffffff811f53e9>] debugfs_remove_recursive+0x11f/0x16b
  [<ffffffffa037adf3>] ieee80211_debugfs_key_remove+0x1f/0x2e [mac80211]
  [<ffffffffa0373e7a>] __ieee80211_key_destroy+0x61/0x6d [mac80211]
  [<ffffffffa0374250>] ieee80211_key_link+0x12c/0x165 [mac80211]
  [<ffffffffa036b90e>] ieee80211_add_key+0xfb/0x133 [mac80211]
  [<ffffffffa0277ff4>] nl80211_new_key+0xe5/0x106 [cfg80211]
  [<ffffffffa026d2c5>] ? cfg80211_get_dev_from_ifindex+0x72/0x7a [cfg80211]
  [<ffffffff81422244>] genl_rcv_msg+0x1dc/0x207
  [<ffffffff81422068>] ? genl_rcv+0x2d/0x2d
  [<ffffffff81421c69>] netlink_rcv_skb+0x43/0x8f
  [<ffffffff81422061>] genl_rcv+0x26/0x2d
  [<ffffffff8142176a>] netlink_unicast+0xec/0x156
  [<ffffffff81421a53>] netlink_sendmsg+0x27f/0x2c0
  [<ffffffff813ed78c>] __sock_sendmsg+0x69/0x75
  [<ffffffff813ed905>] sock_sendmsg+0xa1/0xb6
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff81100de0>] ? might_fault+0xa5/0xac
  [<ffffffff81100d97>] ? might_fault+0x5c/0xac
  [<ffffffff813ec8e4>] ? copy_from_user+0x2f/0x31
  [<ffffffff813f707a>] ? copy_from_user+0x2f/0x31
  [<ffffffff813f7370>] ? verify_iovec+0x52/0xa6
  [<ffffffff813eece3>] sys_sendmsg+0x23a/0x2b8
  [<ffffffff81086d29>] ? lock_acquire+0xec/0xfb
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff8114b7d7>] ? mntput+0x26/0x28
  [<ffffffff811343bc>] ? fput+0x1e6/0x1f5
  [<ffffffff8113ba95>] ? path_put+0x1f/0x23
  [<ffffffff810a9f23>] ? audit_syscall_entry+0x11c/0x148
  [<ffffffff81255e4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff814c5d82>] system_call_fastpath+0x16/0x1b
 NMI backtrace for cpu 1
 CPU 1 
 Modules linked in: snd_seq_dummy ip6_queue nfnetlink scsi_transport_iscsi ip_queue ipt_ULOG can_raw hidp inet_diag tun can_bcm sctp libcrc32c bnep rfcomm cmtp kernelcapi ipx p8022 p8023 af_key rose ax25 phonet appletalk psnap llc can rds pppoe pppox ppp_generic slhc decnet irda crc_ccitt af_802154 atm fuse nfsd lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables arc4 snd_hda_codec_realtek iwlagn snd_hda_intel snd_hda_codec snd_hwdep snd_seq mac80211 snd_seq_device snd_pcm uvcvideo snd_timer btusb bluetooth snd e1000e videodev cfg80211 microcode joydev v4l2_compat_ioctl32 iTCO_wdt pcspkr soundcore iTCO_vendor_support i2c_i801 snd_page_alloc sony_laptop rfkill tpm_infineon wmi uinput ipv6 sdhci_pci sdhci mmc_core firewire_ohci firewire_core yenta_socket crc_itu_t nouveau i915 ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
 
 Pid: 0, comm: kworker/0:0 Not tainted 2.6.39-rc4+ #2 Sony Corporation VGN-Z540N/VAIO
 RIP: 0010:[<ffffffff8124c28c>]  [<ffffffff8124c28c>] cpumask_next_and+0x2c/0x39
 RSP: 0018:ffff8800bac03b80  EFLAGS: 00000202
 RAX: 0000000000000001 RBX: ffff8800bac0fc80 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000000200
 RBP: ffff8800bac03b90 R08: 0000000000000000 R09: ffff8800bac0f848
 R10: 0000000000706071 R11: ffff8800b57fc760 R12: ffff8800bac0f848
 R13: 0000000000000001 R14: ffff8800bac0f830 R15: 00000000ffffffff
 FS:  0000000000000000(0000) GS:ffff8800bac00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007f5cd7f66010 CR3: 00000000a17aa000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kworker/0:0 (pid: 0, threadinfo ffff8800b5004000, task ffff8800b57fc760)
 Stack:
  ffff8800bac0f890 00000000ffffffff ffff8800bac03d50 ffffffff8105106d
  0000000000000000 0000001e3229a026 ffff8800bac03e00 00000000001d4340
  00000000001d4340 ffff8800bac0fc80 0000000000000000 0000000000000002
 Call Trace:
  <IRQ> 
  [<ffffffff8105106d>] find_busiest_group+0x256/0x8bc
  [<ffffffff8105175c>] load_balance+0x89/0x654
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff81042ace>] ? rcu_read_unlock+0x21/0x23
  [<ffffffff81051e19>] rebalance_domains+0xf2/0x168
  [<ffffffff812525f6>] ? timerqueue_add+0x86/0xa8
  [<ffffffff8107bf84>] ? timekeeping_get_ns+0x18/0x3a
  [<ffffffff81051ed5>] run_rebalance_domains+0x46/0x108
  [<ffffffff8105ccff>] __do_softirq+0xf4/0x1da
  [<ffffffff8108161f>] ? tick_program_event+0x1f/0x21
  [<ffffffff814c701c>] call_softirq+0x1c/0x30
  [<ffffffff8100abc9>] do_softirq+0x4b/0xa2
  [<ffffffff8105cff5>] irq_exit+0x5d/0xa8
  [<ffffffff814c7953>] smp_apic_timer_interrupt+0x7e/0x8c
  [<ffffffff814c67d3>] apic_timer_interrupt+0x13/0x20
  <EOI> 
  [<ffffffff8104303e>] ? set_next_entity+0x46/0x9c
  [<ffffffff812cd370>] ? acpi_idle_enter_c1+0x9b/0xbe
  [<ffffffff812cc7e2>] ? arch_local_irq_enable+0xb/0xd
  [<ffffffff81087128>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff812cd375>] acpi_idle_enter_c1+0xa0/0xbe
  [<ffffffff813d1882>] cpuidle_idle_call+0xf0/0x173
  [<ffffffff81008303>] cpu_idle+0xaa/0xe4
  [<ffffffff814ac579>] start_secondary+0x232/0x234
 Code: 89 f8 48 89 e5 41 54 49 89 f4 53 48 89 d3 eb 09 0f a3 03 19 d2 85 d2 75 1a ff c0 be 00 02 00 00 4c 89 e7 48 63 d0 e8 7c 02 00 00 <3b> 05 72 5c 91 00 7c dd 5b 41 5c 5d c3 55 ff c7 48 63 d7 48 89 
 Call Trace:
  <IRQ>  [<ffffffff8105106d>] find_busiest_group+0x256/0x8bc
  [<ffffffff8105175c>] load_balance+0x89/0x654
  [<ffffffff81086c30>] ? lock_release+0x181/0x18e
  [<ffffffff81042ace>] ? rcu_read_unlock+0x21/0x23
  [<ffffffff81051e19>] rebalance_domains+0xf2/0x168
  [<ffffffff812525f6>] ? timerqueue_add+0x86/0xa8
  [<ffffffff8107bf84>] ? timekeeping_get_ns+0x18/0x3a
  [<ffffffff81051ed5>] run_rebalance_domains+0x46/0x108
  [<ffffffff8105ccff>] __do_softirq+0xf4/0x1da
  [<ffffffff8108161f>] ? tick_program_event+0x1f/0x21
  [<ffffffff814c701c>] call_softirq+0x1c/0x30
  [<ffffffff8100abc9>] do_softirq+0x4b/0xa2
  [<ffffffff8105cff5>] irq_exit+0x5d/0xa8
  [<ffffffff814c7953>] smp_apic_timer_interrupt+0x7e/0x8c
  [<ffffffff814c67d3>] apic_timer_interrupt+0x13/0x20
  <EOI>  [<ffffffff8104303e>] ? set_next_entity+0x46/0x9c
  [<ffffffff812cd370>] ? acpi_idle_enter_c1+0x9b/0xbe
  [<ffffffff812cc7e2>] ? arch_local_irq_enable+0xb/0xd
  [<ffffffff81087128>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff812cd375>] acpi_idle_enter_c1+0xa0/0xbe
  [<ffffffff813d1882>] cpuidle_idle_call+0xf0/0x173
  [<ffffffff81008303>] cpu_idle+0xaa/0xe4
  [<ffffffff814ac579>] start_secondary+0x232/0x234
 INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 1, t=65002 jiffies)

