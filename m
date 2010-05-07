Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0EGByU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 21:54:20 -0400
Received: from smtp5.Stanford.EDU ([171.67.219.85]:34473 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615Ab0EGByT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 21:54:19 -0400
Subject: 2.6.33.3-rt19 kernel BUG's
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: nando@ccrma.Stanford.EDU
Content-Type: text/plain
Date: Thu, 06 May 2010 18:53:38 -0700
Message-Id: <1273197218.6768.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See below... just trying to boot (quad core desktop machine).

-- Fernando


May  6 18:23:36 localhost kernel: ------------[ cut here ]------------
May  6 18:23:36 localhost kernel: kernel BUG at kernel/rtmutex.c:808!
May  6 18:23:36 localhost kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
May  6 18:23:36 localhost kernel: last sysfs
file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
May  6 18:23:36 localhost kernel: Modules linked in: autofs4 xt_time
xt_connlimit xt_realm iptable_raw xt_comment xt_policy ipt_ULOG
ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac
xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp
xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
iptable_mangle nfnetlink coretemp hwmon_vid nfs lockd fscache nfs_acl
auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_mul
May  6 18:23:36 localhost kernel: tipath uinput snd_hda_codec_realtek
snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_hda_intel snd_cs8427
snd_hda_codec snd_ac97_codec snd_hwdep snd_seq snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi joydev asus_atk0110 snd_seq_device snd_timer
snd ohci1394 iTCO_wdt sata_sil24 soundcore i2c_i801 snd_page_alloc
iTCO_vendor_support sky2 serio_raw ata_generic pata_acpi radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: microcode]
May  6 18:23:36 localhost kernel:
May  6 18:23:36 localhost kernel: Pid: 4100, comm: gdm-session-wor Not
tainted 2.6.33.3-84.rt19.1.fc11.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
May  6 18:23:36 localhost kernel: EIP: 0060:[<c079201b>] EFLAGS:
00210046 CPU: 1
May  6 18:23:36 localhost kernel: EIP is at rt_spin_lock_slowlock
+0x43/0x1bb
May  6 18:23:36 localhost kernel: EAX: f33620f0 EBX: fba27f00 ECX:
fba27f00 EDX: f33620f0
May  6 18:23:36 localhost kernel: ESI: f33f2940 EDI: f2859910 EBP:
f01b5db4 ESP: f01b5d5c
May  6 18:23:36 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068 preempt:00000001
May  6 18:23:36 localhost kernel: Process gdm-session-wor (pid: 4100,
ti=f01b4000 task=f33620f0 task.ti=f01b4000)
May  6 18:23:36 localhost kernel: Stack:
May  6 18:23:36 localhost kernel: ffffffff 00000001 00000000 f01b5d90
00200296 f01b5df0 00200246 c58857f4
May  6 18:23:36 localhost kernel: <0> c0a607f4 c58857f4 f01b5d90
c0464f73 c5885810 f01b5d98 c0792766 f01b5db0
May  6 18:23:36 localhost kernel: <0> 00000000 f01b5da0 00200246
fba27f00 f33f2940 f2859910 f01b5dc0 c0464fa9
May  6 18:23:36 localhost kernel: Call Trace:
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c0464fa9>] ?
rt_spin_lock_fastlock.clone.1+0x5c/0x5f
May  6 18:23:36 localhost kernel: [<c0792752>] ? rt_spin_lock+0x8/0xa
May  6 18:23:36 localhost kernel: [<fba24f1f>] ? autofs4_revalidate
+0x24b/0x263 [autofs4]
May  6 18:23:36 localhost kernel: [<c04d91a9>] ? do_revalidate+0xc/0x3a
May  6 18:23:36 localhost kernel: [<c04d92ee>] ? do_lookup+0x117/0x137
May  6 18:23:36 localhost kernel: [<c0572222>] ?
security_inode_permission+0x1a/0x20
May  6 18:23:36 localhost kernel: [<c04d98cf>] ? link_path_walk
+0x20b/0x4fc
May  6 18:23:36 localhost kernel: [<c04d9cc7>] ? path_walk+0x3a/0x84
May  6 18:23:36 localhost kernel: [<c04db08b>] ? path_init+0x6e/0x10c
May  6 18:23:36 localhost kernel: [<c04db24d>] ? do_path_lookup
+0x124/0x186
May  6 18:23:36 localhost kernel: [<c04db3c4>] ? do_filp_open+0xd1/0x817
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c04d0975>] ? do_sys_open+0x48/0xdf
May  6 18:23:36 localhost kernel: [<c07951fe>] ? do_page_fault
+0x26e/0x2b3
May  6 18:23:36 localhost kernel: [<c04d0a4e>] ? sys_open+0x1e/0x26
May  6 18:23:36 localhost kernel: [<c040895f>] ? sysenter_do_call
+0x12/0x28
May  6 18:23:36 localhost kernel: Code: 7b 08 00 89 45 b8 75 12 8d 43 04
89 43 04 89 43 08 8d 43 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5
c0 83 e0 fc 39 c2 75 04 <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83
ff 02 b8 04 00 00 
May  6 18:23:36 localhost kernel: EIP: [<c079201b>]
rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f01b5d5c
May  6 18:23:36 localhost kernel: ---[ end trace 7d2af8ee67c50871 ]---
May  6 18:23:36 localhost kernel: note: gdm-session-wor[4100] exited
with preempt_count 1
May  6 18:23:36 localhost kernel: BUG: scheduling while atomic:
gdm-session-wor/0x10000001/4100, CPU#1
May  6 18:23:36 localhost kernel: Modules linked in: autofs4 xt_time
xt_connlimit xt_realm iptable_raw xt_comment xt_policy ipt_ULOG
ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac
xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp
xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
iptable_mangle nfnetlink coretemp hwmon_vid nfs lockd fscache nfs_acl
auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_mul
May  6 18:23:36 localhost kernel: tipath uinput snd_hda_codec_realtek
snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_hda_intel snd_cs8427
snd_hda_codec snd_ac97_codec snd_hwdep snd_seq snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi joydev asus_atk0110 snd_seq_device snd_timer
snd ohci1394 iTCO_wdt sata_sil24 soundcore i2c_i801 snd_page_alloc
iTCO_vendor_support sky2 serio_raw ata_generic pata_acpi radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: microcode]
May  6 18:23:36 localhost kernel: Pid: 4100, comm: gdm-session-wor
Tainted: G      D    2.6.33.3-84.rt19.1.fc11.ccrma.i686.rtPAE #1
May  6 18:23:36 localhost kernel: Call Trace:
May  6 18:23:36 localhost kernel: [<c0435cbd>] __schedule_bug+0x54/0x59
May  6 18:23:36 localhost kernel: [<c0790e99>] __schedule+0x66/0x7d7
May  6 18:23:36 localhost kernel: [<c04a5e7a>] ? list_add+0xa/0xc
May  6 18:23:36 localhost kernel: [<c04a65df>] ? __free_one_page
+0xfd/0x14e
May  6 18:23:36 localhost kernel: [<c07916ef>] schedule+0xe/0x1f
May  6 18:23:36 localhost kernel: [<c0439e7b>] __cond_resched+0x16/0x2f
May  6 18:23:36 localhost kernel: [<c0439eb3>] __cond_resched_lock
+0x1f/0x2e
May  6 18:23:36 localhost kernel: [<c04a67b6>] free_pcppages_bulk
+0xbe/0xfc
May  6 18:23:36 localhost kernel: [<c04a7503>] free_hot_cold_page
+0x15c/0x186
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c04a758d>] __pagevec_free+0x60/0x6d
May  6 18:23:36 localhost kernel: [<c04a9c04>] release_pages+0xbc/0xf3
May  6 18:23:36 localhost kernel: [<c04c1961>] free_pages_and_swap_cache
+0x43/0x50
May  6 18:23:36 localhost kernel: [<c04baa1b>] tlb_finish_mmu+0x2a/0x67
May  6 18:23:36 localhost kernel: [<c04babee>] exit_mmap+0xa2/0xc5
May  6 18:23:36 localhost kernel: [<c043cb5d>] mmput+0x41/0xa4
May  6 18:23:36 localhost kernel: [<c04405f4>] exit_mm+0x103/0x10b
May  6 18:23:36 localhost kernel: [<c0441e73>] do_exit+0x1a8/0x5dc
May  6 18:23:36 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c043f748>] ? kmsg_dump+0xde/0xe6
May  6 18:23:36 localhost kernel: [<c0793c40>] oops_end+0x99/0xa1
May  6 18:23:36 localhost kernel: [<c040ae57>] die+0x53/0x59
May  6 18:23:36 localhost kernel: [<c079356b>] do_trap+0x89/0xa2
May  6 18:23:36 localhost kernel: [<c04092c0>] ? do_invalid_op+0x0/0x80
May  6 18:23:36 localhost kernel: [<c0409336>] do_invalid_op+0x76/0x80
May  6 18:23:36 localhost kernel: [<c079201b>] ? rt_spin_lock_slowlock
+0x43/0x1bb
May  6 18:23:36 localhost kernel: [<c04c9391>] ? slab_irq_enable
+0x4c/0x6d
May  6 18:23:36 localhost kernel: [<c05760a7>] ? avc_alloc_node
+0x18/0x18c
May  6 18:23:36 localhost kernel: [<c0575bd8>] ? rcu_read_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c05765b0>] ? avc_has_perm_noaudit
+0x395/0x3cf
May  6 18:23:36 localhost kernel: [<c0793317>] error_code+0x73/0x78
May  6 18:23:36 localhost kernel: [<c079201b>] ? rt_spin_lock_slowlock
+0x43/0x1bb
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c0464fa9>]
rt_spin_lock_fastlock.clone.1+0x5c/0x5f
May  6 18:23:36 localhost kernel: [<c0792752>] rt_spin_lock+0x8/0xa
May  6 18:23:36 localhost kernel: [<fba24f1f>] autofs4_revalidate
+0x24b/0x263 [autofs4]
May  6 18:23:36 localhost kernel: [<c04d91a9>] do_revalidate+0xc/0x3a
May  6 18:23:36 localhost kernel: [<c04d92ee>] do_lookup+0x117/0x137
May  6 18:23:36 localhost kernel: [<c0572222>] ?
security_inode_permission+0x1a/0x20
May  6 18:23:36 localhost kernel: [<c04d98cf>] link_path_walk
+0x20b/0x4fc
May  6 18:23:36 localhost kernel: [<c04d9cc7>] path_walk+0x3a/0x84
May  6 18:23:36 localhost kernel: [<c04db08b>] ? path_init+0x6e/0x10c
May  6 18:23:36 localhost kernel: [<c04db24d>] do_path_lookup
+0x124/0x186
May  6 18:23:36 localhost kernel: [<c04db3c4>] do_filp_open+0xd1/0x817
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:36 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:36 localhost kernel: [<c04d0975>] do_sys_open+0x48/0xdf
May  6 18:23:36 localhost kernel: [<c07951fe>] ? do_page_fault
+0x26e/0x2b3
May  6 18:23:36 localhost kernel: [<c04d0a4e>] sys_open+0x1e/0x26
May  6 18:23:36 localhost kernel: [<c040895f>] sysenter_do_call
+0x12/0x28
May  6 18:23:42 localhost kernel: ------------[ cut here ]------------
May  6 18:23:42 localhost kernel: kernel BUG at kernel/rtmutex.c:808!
May  6 18:23:42 localhost kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
May  6 18:23:42 localhost kernel: last sysfs
file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
May  6 18:23:42 localhost kernel: Modules linked in: autofs4 xt_time
xt_connlimit xt_realm iptable_raw xt_comment xt_policy ipt_ULOG
ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac
xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp
xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
iptable_mangle nfnetlink coretemp hwmon_vid nfs lockd fscache nfs_acl
auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq dm_mul
May  6 18:23:42 localhost kernel: tipath uinput snd_hda_codec_realtek
snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_hda_intel snd_cs8427
snd_hda_codec snd_ac97_codec snd_hwdep snd_seq snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi joydev asus_atk0110 snd_seq_device snd_timer
snd ohci1394 iTCO_wdt sata_sil24 soundcore i2c_i801 snd_page_alloc
iTCO_vendor_support sky2 serio_raw ata_generic pata_acpi radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: microcode]
May  6 18:23:42 localhost kernel:
May  6 18:23:42 localhost kernel: Pid: 4109, comm: gdm-session-wor
Tainted: G      D    2.6.33.3-84.rt19.1.fc11.ccrma.i686.rtPAE #1
P5K/EPU/P5K/EPU
May  6 18:23:42 localhost kernel: EIP: 0060:[<c079201b>] EFLAGS:
00210046 CPU: 1
May  6 18:23:42 localhost kernel: EIP is at rt_spin_lock_slowlock
+0x43/0x1bb
May  6 18:23:42 localhost kernel: EAX: f33620f0 EBX: f2859910 ECX:
f2859910 EDX: f33620f0
May  6 18:23:42 localhost kernel: ESI: f33f2940 EDI: f2859910 EBP:
f021bdb4 ESP: f021bd5c
May  6 18:23:42 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068 preempt:00000001
May  6 18:23:42 localhost kernel: Process gdm-session-wor (pid: 4109,
ti=f021a000 task=f33620f0 task.ti=f021a000)
May  6 18:23:42 localhost kernel: Stack:
May  6 18:23:42 localhost kernel: ffffffff 00000001 00000000 f021bd90
00200296 f021bdf0 00200246 c58857f4
May  6 18:23:42 localhost kernel: <0> c0a607f4 c58857f4 f021bd90
c0464f73 c5885810 f021bd98 c0792766 f021bdb0
May  6 18:23:42 localhost kernel: <0> 00000000 00200246 00200246
f2859910 f33f2940 f2859910 f021bdc0 c0464fa9
May  6 18:23:42 localhost kernel: Call Trace:
May  6 18:23:42 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:42 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:42 localhost kernel: [<c0464fa9>] ?
rt_spin_lock_fastlock.clone.1+0x5c/0x5f
May  6 18:23:42 localhost kernel: [<c0792752>] ? rt_spin_lock+0x8/0xa
May  6 18:23:42 localhost kernel: [<fba24dbc>] ? autofs4_revalidate
+0xe8/0x263 [autofs4]
May  6 18:23:42 localhost kernel: [<c04d91a9>] ? do_revalidate+0xc/0x3a
May  6 18:23:42 localhost kernel: [<c04d92ee>] ? do_lookup+0x117/0x137
May  6 18:23:42 localhost kernel: [<c0572222>] ?
security_inode_permission+0x1a/0x20
May  6 18:23:42 localhost kernel: [<c04d98cf>] ? link_path_walk
+0x20b/0x4fc
May  6 18:23:42 localhost kernel: [<c04d9cc7>] ? path_walk+0x3a/0x84
May  6 18:23:42 localhost kernel: [<c04db08b>] ? path_init+0x6e/0x10c
May  6 18:23:42 localhost kernel: [<c04db24d>] ? do_path_lookup
+0x124/0x186
May  6 18:23:42 localhost kernel: [<c04db3c4>] ? do_filp_open+0xd1/0x817
May  6 18:23:42 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:42 localhost kernel: [<c0464f73>] ?
rt_spin_lock_fastlock.clone.1+0x26/0x5f
May  6 18:23:42 localhost kernel: [<c0792766>] ? rt_spin_unlock+0x8/0xa
May  6 18:23:42 localhost kernel: [<c04d0975>] ? do_sys_open+0x48/0xdf
May  6 18:23:42 localhost kernel: [<c07951fe>] ? do_page_fault
+0x26e/0x2b3
May  6 18:23:42 localhost kernel: [<c04d0a4e>] ? sys_open+0x1e/0x26
May  6 18:23:42 localhost kernel: [<c040895f>] ? sysenter_do_call
+0x12/0x28
May  6 18:23:42 localhost kernel: Code: 7b 08 00 89 45 b8 75 12 8d 43 04
89 43 04 89 43 08 8d 43 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5
c0 83 e0 fc 39 c2 75 04 <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83
ff 02 b8 04 00 00 
May  6 18:23:42 localhost kernel: EIP: [<c079201b>]
rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f021bd5c
May  6 18:23:42 localhost kernel: ---[ end trace 7d2af8ee67c50872 ]---
May  6 18:23:42 localhost kernel: note: gdm-session-wor[4109] exited
with preempt_count 1


