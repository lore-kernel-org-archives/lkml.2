Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab0FKW1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:27:24 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:42416 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932608Ab0FKW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:27:21 -0400
Subject: 2.6.33.4-rt20, BUG + Ooops
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, nando@ccrma.Stanford.EDU
Content-Type: text/plain
Date: Fri, 11 Jun 2010 15:26:42 -0700
Message-Id: <1276295202.19803.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just happened a moment ago, 2.6.33.4 rt20 had been up since May 18th so
whatever it is, it is really infrequent, after the Oops I rebooted into
2.6.33.5 rt23 (maybe the problem is fixed in rt23). 

-- Fernando


Jun 11 15:04:56 localhost kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000008c
Jun 11 15:04:56 localhost kernel: IP: [<c0464fb6>]
rt_spin_lock_fastunlock.clone.2+0x6/0x3e
Jun 11 15:04:56 localhost kernel: *pdpt = 00000000119b1001 *pde =
0000000000000000 
Jun 11 15:04:56 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
Jun 11 15:04:56 localhost kernel: last sysfs
file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Jun 11 15:04:56 localhost kernel: Modules linked in: vfat fat
usb_storage vboxnetadp vboxnetflt vboxdrv snd_seq_dummy nls_utf8 fuse
autofs4 xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_policy
ipt_ULOG ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
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
auth_rpcgss sunrpc ip6t_REJECT nf_conn
Jun 11 15:04:56 localhost kernel: track_ipv6 ip6table_filter ip6_tables
ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath uinput
snd_hda_codec_realtek snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_hda_intel snd_cs8427 snd_hda_codec snd_ac97_codec snd_hwdep joydev
snd_seq snd_pcm ac97_bus snd_i2c asus_atk0110 snd_mpu401_uart
snd_rawmidi snd_seq_device sata_sil24 ohci1394 snd_timer snd soundcore
iTCO_wdt i2c_i801 snd_page_alloc iTCO_vendor_support sky2 serio_raw
ata_generic pata_acpi radeon ttm drm_kms_helper drm i2c_algo_bit
i2c_core [last unloaded: microcode]
Jun 11 15:04:56 localhost kernel:
Jun 11 15:04:56 localhost kernel: Pid: 10579, comm: find Tainted: G
W  2.6.33.4-96.rt20.1.fc11.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
Jun 11 15:04:56 localhost kernel: EIP: 0060:[<c0464fb6>] EFLAGS:
00210246 CPU: 1
Jun 11 15:04:56 localhost kernel: EIP is at
rt_spin_lock_fastunlock.clone.2+0x6/0x3e
Jun 11 15:04:56 localhost kernel: EAX: 00000078 EBX: d022aa7c ECX:
00000000 EDX: 00000078
Jun 11 15:04:56 localhost kernel: ESI: d8faca1c EDI: 00000000 EBP:
eebbbd24 ESP: eebbbd20
Jun 11 15:04:56 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068 preempt:00000000
Jun 11 15:04:56 localhost kernel: Process find (pid: 10579, ti=eebba000
task=cc990370 task.ti=eebba000)
Jun 11 15:04:56 localhost kernel: Stack:
Jun 11 15:04:56 localhost kernel: d022aa7c eebbbd2c c07929fe eebbbd5c
c04e1114 00000000 cdb3150c c07929fe
Jun 11 15:04:56 localhost kernel: <0> 068d0298 cdb31494 00000000
d8faca1c 068d0298 00000000 d022aa7c eebbbdb8
Jun 11 15:04:56 localhost kernel: <0> fa41c578 00000073 eebbbda0
da832030 c04ddc4c eebbbf90 00000000 e8b6de00
Jun 11 15:04:56 localhost kernel: Call Trace:
Jun 11 15:04:56 localhost kernel: [<c07929fe>] ? rt_spin_unlock+0x8/0xa
Jun 11 15:04:56 localhost kernel: [<c04e1114>] ? d_materialise_unique
+0x1fd/0x297
Jun 11 15:04:56 localhost kernel: [<c07929fe>] ? rt_spin_unlock+0x8/0xa
Jun 11 15:04:56 localhost kernel: [<fa41c578>] ? nfs_do_filldir
+0x27b/0x3a9 [nfs]
Jun 11 15:04:56 localhost kernel: [<c04ddc4c>] ? filldir64+0x0/0xcb
Jun 11 15:04:56 localhost kernel: [<fa41cd2f>] ? nfs_readdir+0x689/0x707
[nfs]
Jun 11 15:04:56 localhost kernel: [<c04ddc4c>] ? filldir64+0x0/0xcb
Jun 11 15:04:56 localhost kernel: [<fa32c786>] ?
rpcauth_lookup_credcache+0x141/0x16f [sunrpc]
Jun 11 15:04:56 localhost kernel: [<fa3341ed>] ? cache_release_procfs
+0x8/0x10 [sunrpc]
Jun 11 15:04:56 localhost kernel: [<fa41ffa5>] ? nfs_open+0x178/0x182
[nfs]
Jun 11 15:04:56 localhost kernel: [<c0575c68>] ? rcu_read_unlock+0x8/0xa
Jun 11 15:04:56 localhost kernel: [<fa42d128>] ? nfs3_decode_dirent
+0x0/0x110 [nfs]
Jun 11 15:04:56 localhost kernel: [<c057768e>] ? inode_has_perm
+0x66/0x81
Jun 11 15:04:56 localhost kernel: [<c0792681>] ? rt_mutex_lock_killable
+0x28/0x2c
Jun 11 15:04:56 localhost kernel: [<c04ddf06>] ? vfs_readdir+0x66/0x92
Jun 11 15:04:56 localhost kernel: [<c04ddc4c>] ? filldir64+0x0/0xcb
Jun 11 15:04:56 localhost kernel: [<c04ddf95>] ? sys_getdents64
+0x63/0xa5
Jun 11 15:04:56 localhost kernel: [<c047de65>] ? audit_syscall_entry
+0x113/0x135
Jun 11 15:04:56 localhost kernel: [<c040895f>] ? sysenter_do_call
+0x12/0x28
Jun 11 15:04:56 localhost kernel: Code: 8d 74 26 00 f6 c4 02 74 19 64 8b
15 2c f1 a5 c0 31 c0 f0 0f b1 53 14 85 c0 74 07 89 d8 e8 c3 d2 32 00 5b
5d c3 55 89 c2 89 e5 53 <8b> 40 14 64 8b 0d 2c f1 a5 c0 83 e0 fc 39 c1
74 09 83 b9 fc 0c 
Jun 11 15:04:56 localhost kernel: EIP: [<c0464fb6>]
rt_spin_lock_fastunlock.clone.2+0x6/0x3e SS:ESP 0068:eebbbd20
Jun 11 15:04:56 localhost kernel: CR2: 000000000000008c
Jun 11 15:04:56 localhost kernel: ---[ end trace 360087be0947ec45 ]---


