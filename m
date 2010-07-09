Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0GIWN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:13:58 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:58779 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425Ab0GIWN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:13:56 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278705254.2349.14.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 15:13:20 -0700
Message-ID: <1278713600.7122.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 12:54 -0700, john stultz wrote:
> On Fri, 2010-07-09 at 12:02 -0700, Fernando Lopez-Lezcano wrote:
> > Ok, I got one! (had to go buy a null modem cable, I thought I had one
> > but it has disappeared since the last time I did this :-)
> 
> Great! Sorry to make you go shopping! But this points out the problem
> nicely.

No problem at all, I was sure I had one... anyway, I still need it :-<

> > Find it below... it keeps spewing stuff every once in a while. Hopefully
> > this will be enough. No response from the network or the keyboard or
> > mouse at this point, reset is the only way out. 
> > 
> > I can retest if somebody comes up with a patch...

Sorry, it looks like the patch patched correctly and this is the new
kernel, but I still get a hang as before. 

-- Fernando


localhost ------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:808!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs
file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2889, comm: nautilus Not tainted
2.6.33.6-147.rt23.2.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0792f67>] EFLAGS: 00210046 CPU: 0
EIP is at rt_spin_lock_slowlock+0x43/0x1bb
EAX: f2a9e170 EBX: efbb1804 ECX: efbb1804 EDX: f2a9e170
ESI: ef25e47c EDI: efbf197c EBP: f1579d14 ESP: f1579cbc
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000001
Process nautilus (pid: 2889, ti=f1578000 task=f2a9e170 task.ti=f1578000)
Stack:
 00000000 00000001 00000000 f1579cd8 00200292 ef263ddc 00000000 f1579d1c
<0> fad3c5e6 00200246 efbb1804 efbb17fc 00000000 f1579cfc c0465523
ef263ddc
<0> 00000000 c07936b6 00200246 efbb1804 ef25e47c efbf197c f1579d20
c0465559
Call Trace:
 [<fad3c5e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c0465559>] ? rt_spin_lock_fastlock.clone.1+0x5c/0x5f
 [<c07936a2>] ? rt_spin_lock+0x8/0xa
 [<c04e08e9>] ? d_materialise_unique+0xbf/0x29e
 [<fad395a0>] ? nfs_do_filldir+0x27b/0x3a9 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<fad39d57>] ? nfs_readdir+0x689/0x707 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<fad4a0de>] ? nfs3_decode_dirent+0x0/0x10e [nfs]
 [<c04642a6>] ? do_futex+0x99/0x696
 [<c0793335>] ? rt_mutex_lock_killable+0x28/0x2c
 [<c04ddd56>] ? vfs_readdir+0x66/0x92
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<c04ddde5>] ? sys_getdents64+0x63/0xa5
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43 0c 89 43
0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0 83 e0 fc 39 c2 75 04 <0f> 0b
eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 
EIP: [<c0792f67>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f1579cbc
---[ end trace 54bac6c1fd35847f ]---
note: nautilus[2889] exited with preempt_count 1
BUG: scheduling while atomic: nautilus/0x00000001/2889, CPU#0
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]
Pid: 2889, comm: nautilus Tainted: G      D
2.6.33.6-147.rt23.2.fc12.ccrma.i686.rtPAE #1
Call Trace:
 [<c0436617>] __schedule_bug+0x54/0x59
 [<c0791d99>] __schedule+0x66/0x7bf
 [<c05b0742>] ? plist_add+0x60/0x66
 [<c0793928>] ? _raw_spin_unlock+0x1b/0x1d
 [<c0465008>] ? task_blocks_on_rt_mutex+0x102/0x147
 [<c07925d7>] schedule+0xe/0x1f
 [<c0792efa>] __rt_mutex_slowlock+0x9b/0xc5
 [<c0793286>] rt_mutex_slowlock+0xee/0x175
 [<c04654f1>] rt_mutex_fastlock.clone.0+0x29/0x35
 [<c079335e>] rt_mutex_lock+0x25/0x28
 [<c0465690>] rt_down_read+0x1e/0x24
 [<c04409de>] exit_mm+0x2b/0x111
 [<c044236e>] do_exit+0x1a8/0x5dc
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c043fc21>] ? kmsg_dump+0xde/0xe6
 [<c0794b98>] oops_end+0x99/0xa1
 [<c040af8d>] die+0x53/0x59
 [<c07944bb>] do_trap+0x89/0xa2
 [<c0409403>] ? do_invalid_op+0x0/0x80
 [<c0409479>] do_invalid_op+0x76/0x80
 [<c0792f67>] ? rt_spin_lock_slowlock+0x43/0x1bb
 [<fad3c5e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
 [<fac48153>] ? rpc_put_task+0x6f/0x72 [sunrpc]
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04c9083>] ? slab_irq_enable+0x4c/0x6d
 [<c0794267>] error_code+0x73/0x78
 [<c0792f67>] ? rt_spin_lock_slowlock+0x43/0x1bb
 [<fad3c5e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c0465559>] rt_spin_lock_fastlock.clone.1+0x5c/0x5f
 [<c07936a2>] rt_spin_lock+0x8/0xa
 [<c04e08e9>] d_materialise_unique+0xbf/0x29e
 [<fad395a0>] nfs_do_filldir+0x27b/0x3a9 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<fad39d57>] nfs_readdir+0x689/0x707 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<fad4a0de>] ? nfs3_decode_dirent+0x0/0x10e [nfs]
 [<c04642a6>] ? do_futex+0x99/0x696
 [<c0793335>] ? rt_mutex_lock_killable+0x28/0x2c
 [<c04ddd56>] vfs_readdir+0x66/0x92
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<c04ddde5>] sys_getdents64+0x63/0xa5
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] sysenter_do_call+0x12/0x28
BUG: soft lockup - CPU#3 stuck for 61s! [nautilus:2892]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 2892, comm: nautilus Tainted: G      D
2.6.33.6-147.rt23.2.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c042a3e3>] EFLAGS: 00000202 CPU: 3
EIP is at native_flush_tlb_others+0x87/0xb0
EAX: 00000202 EBX: c0a82100 ECX: 00000800 EDX: fffff000
ESI: 000000c0 EDI: c0a8210c EBP: f236ded0 ESP: f236deb4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process nautilus (pid: 2892, ti=f236c000 task=f63323b0 task.ti=f236c000)
Stack:
 f5afb280 f5afb404 00000003 c0a82108 f5afb280 f5afb404 b21ff000 f236dee0
<0> c042a2be f236df04 f236df04 f236deec c04b5a92 b2200000 f236df4c
c04b6cc9
<0> b2200000 f236df3c 00000000 00001000 f5afb280 00000000 00000400
00000000
Call Trace:
 [<c042a2be>] ? flush_tlb_mm+0x63/0x7d
 [<c04b5a92>] ? tlb_flush_mmu+0x1a/0x56
 [<c04b6cc9>] ? zap_page_range+0xa9/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] ? sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
Code: 55 e8 89 7b 04 8d 7b 0c f7 d0 23 02 85 c0 89 43 0c 74 1d 8b 55 ec
89 f8 8b 0d 50 12 99 c0 81 c2 f0 00 00 00 ff 51 78 eb 02 f3 90 <83> 3f
00 75 f9 8b 45 f0 c7 86 40 20 a8 c0 00 00 00 00 c7 43 04 
Call Trace:
 [<c042a2be>] flush_tlb_mm+0x63/0x7d
 [<c04b5a92>] tlb_flush_mmu+0x1a/0x56
 [<c04b6cc9>] zap_page_range+0xa9/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] sysenter_do_call+0x12/0x28
BUG: soft lockup - CPU#0 stuck for 61s! [flush-8:0:1247]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 1247, comm: flush-8:0 Tainted: G      D
2.6.33.6-147.rt23.2.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00000202 CPU: 0
EIP is at smp_call_function_many+0x167/0x175
EAX: 00000296 EBX: c5e041ec ECX: 00000004 EDX: 00000020
ESI: 00000000 EDI: c5e04204 EBP: f2f9dc50 ESP: f2f9dc38
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process flush-8:0 (pid: 1247, ti=f2f9c000 task=f591aef0
task.ti=f2f9c000)
Stack:
 01000000 00000000 c042a1a2 f2f9c000 c042a1a2 000000f8 f2f9dc60 c0465ce2
<0> 00000001 00000000 f2f9dc74 c04442f5 00000119 00000020 000000f8
f2f9dc7c
<0> c042a110 f2f9dd18 c04b4784 00000020 00000020 000000f9 000000fa
000000fb
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] ? smp_call_function+0x26/0x43
 [<c04442f5>] ? on_each_cpu+0x1b/0x4c
 [<c042a110>] ? flush_tlb_all+0x14/0x16
 [<c04b4784>] ? pkmap_get_free+0x146/0x188
 [<c04b47de>] ? pkmap_insert+0x18/0x123
 [<c04b491b>] ? kmap_high+0x32/0x39
 [<c042b1c2>] ? kmap+0x4b/0x59
 [<c04256ea>] ? kmap_atomic_func+0x16/0x18
 [<c04bd741>] ? page_check_address+0xa8/0x14b
 [<c04bd9cd>] ? page_mkclean+0xbf/0x192
 [<c04a82e3>] ? clear_page_dirty_for_io+0x47/0xa8
 [<c04a8fbd>] ? write_cache_pages+0x167/0x249
 [<c04a8089>] ? __writepage+0x0/0x23
 [<c04a90b8>] ? generic_writepages+0x19/0x23
 [<c04a90e0>] ? do_writepages+0x1e/0x24
 [<c04e9bbf>] ? writeback_single_inode+0xad/0x1b3
 [<c04ea22d>] ? writeback_inodes_wb+0x2c2/0x34c
 [<c04ea3ac>] ? wb_writeback+0xf5/0x180
 [<c04ea5ed>] ? wb_do_writeback+0x132/0x141
 [<c04ea624>] ? bdi_writeback_task+0x28/0x90
 [<c04b3864>] ? bdi_start_fn+0x0/0xb0
 [<c04b38bc>] ? bdi_start_fn+0x58/0xb0
 [<c04b3864>] ? bdi_start_fn+0x0/0xb0
 [<c04557ae>] ? kthread+0x5f/0x64
 [<c045574f>] ? kthread+0x0/0x64
 [<c040907e>] ? kernel_thread_helper+0x6/0x10
Code: 1d c0 21 96 c0 89 c2 b8 c8 21 96 c0 89 59 04 e8 4f dc 32 00 0f ae
f0 89 f6 89 f8 ff 15 b8 0f 99 c0 80 7d eb 00 75 04 eb 08 f3 90 <f6> 43
10 01 75 f8 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] smp_call_function+0x26/0x43
 [<c04442f5>] on_each_cpu+0x1b/0x4c
 [<c042a110>] flush_tlb_all+0x14/0x16
 [<c04b4784>] pkmap_get_free+0x146/0x188
 [<c04b47de>] pkmap_insert+0x18/0x123
 [<c04b491b>] kmap_high+0x32/0x39
 [<c042b1c2>] kmap+0x4b/0x59
 [<c04256ea>] kmap_atomic_func+0x16/0x18
 [<c04bd741>] page_check_address+0xa8/0x14b
 [<c04bd9cd>] page_mkclean+0xbf/0x192
 [<c04a82e3>] clear_page_dirty_for_io+0x47/0xa8
 [<c04a8fbd>] write_cache_pages+0x167/0x249
 [<c04a8089>] ? __writepage+0x0/0x23
 [<c04a90b8>] generic_writepages+0x19/0x23
 [<c04a90e0>] do_writepages+0x1e/0x24
 [<c04e9bbf>] writeback_single_inode+0xad/0x1b3
 [<c04ea22d>] writeback_inodes_wb+0x2c2/0x34c
 [<c04ea3ac>] wb_writeback+0xf5/0x180
 [<c04ea5ed>] wb_do_writeback+0x132/0x141
 [<c04ea624>] bdi_writeback_task+0x28/0x90
 [<c04b3864>] ? bdi_start_fn+0x0/0xb0
 [<c04b38bc>] bdi_start_fn+0x58/0xb0
 [<c04b3864>] ? bdi_start_fn+0x0/0xb0
 [<c04557ae>] kthread+0x5f/0x64
 [<c045574f>] ? kthread+0x0/0x64
 [<c040907e>] kernel_thread_helper+0x6/0x10
BUG: soft lockup - CPU#1 stuck for 61s! [rsyslogd:1366]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]
Modules linked in: fuse autofs4 act_police cls_flow cls_fw cls_u32
sch_htb sch_hfsc sch_ingress sch_sfq xt_time xt_connlimit xt_realm
iptable_raw xt_comment xt_recent xt_policy ipt_ULOG ipt_REDIRECT
ipt_NETMAP ipt_MASQUERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log
xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark
xt_CLASSIFY ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp
hwmon_vid nfs lockd fscache nfs_acl auth_rpcgss sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss snd_pcm ac97_bus snd_i2c
snd_mpu401_uart snd_rawmidi snd_seq_device snd_timer snd soundcore sky2
iTCO_wdt iTCO_vendor_support ohci1394 snd_page_alloc i2c_i801 serio_raw
joydev asus_atk0110 sata_sil24 radeon ttm drm_kms_helper drm
i2c_algo_bit i2c_core [last unloaded: microcode]

Pid: 1366, comm: rsyslogd Tainted: G      D
2.6.33.6-147.rt23.2.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cac>] EFLAGS: 00000202 CPU: 1
EIP is at smp_call_function_many+0x165/0x175
EAX: 00000292 EBX: c5e841ec ECX: 00000004 EDX: 00000020
ESI: 00000001 EDI: c5e84204 EBP: f63cde1c ESP: f63cde04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process rsyslogd (pid: 1366, ti=f63cc000 task=f3c30d70 task.ti=f63cc000)
Stack:
 01000000 00000000 c042a1a2 f63cc000 c042a1a2 000000d7 f63cde2c c0465ce2
<0> 00000001 00000000 f63cde40 c04442f5 000000f8 00000020 000000d7
f63cde48
<0> c042a110 f63cdee4 c04b4784 00000000 00000020 000000d8 000000d9
000000da
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] ? smp_call_function+0x26/0x43
 [<c04442f5>] ? on_each_cpu+0x1b/0x4c
 [<c042a110>] ? flush_tlb_all+0x14/0x16
 [<c04b4784>] ? pkmap_get_free+0x146/0x188
 [<c04b47de>] ? pkmap_insert+0x18/0x123
 [<c04b491b>] ? kmap_high+0x32/0x39
 [<c042b1c2>] ? kmap+0x4b/0x59
 [<c04256ea>] ? kmap_atomic_func+0x16/0x18
 [<c04b84b8>] ? handle_mm_fault+0xdc/0x92a
 [<c07961ab>] ? do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] ? error_code+0x73/0x78
Code: 0b 89 1d c0 21 96 c0 89 c2 b8 c8 21 96 c0 89 59 04 e8 4f dc 32 00
0f ae f0 89 f6 89 f8 ff 15 b8 0f 99 c0 80 7d eb 00 75 04 eb 08 <f3> 90
f6 43 10 01 75 f8 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] smp_call_function+0x26/0x43
 [<c04442f5>] on_each_cpu+0x1b/0x4c
 [<c042a110>] flush_tlb_all+0x14/0x16
 [<c04b4784>] pkmap_get_free+0x146/0x188
 [<c04b47de>] pkmap_insert+0x18/0x123
 [<c04b491b>] kmap_high+0x32/0x39
 [<c042b1c2>] kmap+0x4b/0x59
 [<c04256ea>] kmap_atomic_func+0x16/0x18
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78


