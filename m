Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0GITC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:02:57 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:55217 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467Ab0GITCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:02:54 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278630050.3008.18.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 12:02:14 -0700
Message-ID: <1278702134.5102.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 16:00 -0700, john stultz wrote:
> On Thu, 2010-07-08 at 15:44 -0700, Fernando Lopez-Lezcano wrote:
> > On Thu, 2010-07-08 at 15:33 -0700, john stultz wrote:
> > > On Thu, 2010-07-08 at 10:19 -0700, Fernando Lopez-Lezcano wrote:
> > > > We are having problems with 2.6.33.5+rt23, at least in our configuration
> > > > while accessing an nfs automounted directory. This causes a complete
> > > > machine lockup (press reset to exit as the only option). 
> > > > 
> > > > I simply use the Nautilus file manager (in Fedora 12) to navigate to an
> > > > autofs mounted directory and the process monitor goes to 100% on one
> > > > core (or maybe two), the mouse jerks a bit and the whole thing goes
> > > > catatonic almost immediately. 
> > > > 
> > > > I get this in any open terminal at the time of the crash:
> > > > 
> > > > --------
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:------------[ cut here ]------------
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:invalid opcode: 0000 [#1] PREEMPT SMP 
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:last sysfs
> > > > file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:Process nautilus (pid: 2874, ti=f0204000 task=f17dd1f0
> > > > task.ti=f0204000)
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:Stack:
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:Call Trace:
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43
> > > > 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0 83 e0 fc 39 c2 75 04
> > > > <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 
> > > > 
> > > > Message from syslogd@localhost at Jul  8 10:13:54 ...
> > > >  kernel:EIP: [<c0792c0f>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP
> > > > 0068:f0205cbc
> > > > --------
> > > > 
> > > > And that's it... nothing else in the logs. 
> > > 
> > > Hrm. Not too much to go on there, but thanks for the report.
> > > 
> > > 
> > > > For now we are booting into the normal Fedora kernel (this is on Fedora
> > > > 12) as this makes the rt kernel not usable in our setup. 
> > > > 
> > > > Let me know if there is anything else I can do to help debug this...
> > > 
> > > Had you done any testing with earlier 2.6.33-rt kernels where this
> > > didn't occur? If so what version?
> > 
> > I have been working with the whole series but my main usage case does
> > not use nfs/autofs (see next paragraphs). 
> > 
> > I have noticed that the problem does not appear to happen when I cd into
> > an nfs automounted directory directly. It appears to happen only when
> > listing the contents of a mount point (ie: when "/whatever/" is an
> > autofs mount point where several directories are mounted, not
> > necessarily from the same server). 
> > 
> > Before switching to Fedora 12 users were normally running 2.6.29 rt and
> > I had been running 2.6.31.x and 2.6.33.x rt, but I don't think it ever
> > happened to me personally (I'm always using the command line - this is
> > completely reproducible with nautilus). After the switch it started
> > happening almost immediately to regular users (using nautilus mostly). 
> > 
> > How could I try to get more debugging information?
> 
> Any chance you have a serial port on the machine in question? If so its
> likely any oops messages could be collected over that.

Ok, I got one! (had to go buy a null modem cable, I thought I had one
but it has disappeared since the last time I did this :-)

Find it below... it keeps spewing stuff every once in a while. Hopefully
this will be enough. No response from the network or the keyboard or
mouse at this point, reset is the only way out. 

I can retest if somebody comes up with a patch...
Thanks.
-- Fernando

localhost login: ------------[ cut here ]------------
kernel BUG at kernel/rtmutex.c:808!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2872, comm: nautilus Not tainted
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0792f67>] EFLAGS: 00010046 CPU: 2
EIP is at rt_spin_lock_slowlock+0x43/0x1bb
EAX: f2ad2eb0 EBX: ef2a2da4 ECX: ef2a2da4 EDX: f2ad2eb0
ESI: ef2ededc EDI: ef2a893c EBP: f20e3d14 ESP: f20e3cbc
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00000001
Process nautilus (pid: 2872, ti=f20e2000 task=f2ad2eb0 task.ti=f20e2000)
Stack:
 00000000 00000001 00000000 f20e3cd8 00000292 ef2a0ac4 00000000 f20e3d1c
<0> facf45e6 00000246 ef2a2da4 ef2a2d9c 00000000 f20e3cfc c0465523
ef2a0ac4
<0> 00000000 c07936b6 00000246 ef2a2da4 ef2ededc ef2a893c f20e3d20
c0465559
Call Trace:
 [<facf45e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c0465559>] ? rt_spin_lock_fastlock.clone.1+0x5c/0x5f
 [<c07936a2>] ? rt_spin_lock+0x8/0xa
 [<c04e08d3>] ? d_materialise_unique+0xa9/0x29e
 [<facf55bc>] ? nfs_fhget+0x492/0x51d [nfs]
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<facf15a0>] ? nfs_do_filldir+0x27b/0x3a9 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<facf1d57>] ? nfs_readdir+0x689/0x707 [nfs]
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<fad020de>] ? nfs3_decode_dirent+0x0/0x10e [nfs]
 [<c04642a6>] ? do_futex+0x99/0x696
 [<c0793335>] ? rt_mutex_lock_killable+0x28/0x2c
 [<c04ddd56>] ? vfs_readdir+0x66/0x92
 [<c04dda9c>] ? filldir64+0x0/0xcb
 [<c04ddde5>] ? sys_getdents64+0x63/0xa5
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
Code: 7b 08 00 89 45 b8 75 12 8d 43 04 89 43 04 89 43 08 8d 43 0c 89 43
0c 89 43 10 8b 43 14 64 8b 15 2c d1 a5 c0 83 e0 fc 39 c2 75 04 <0f> 0b
eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83 ff 02 b8 04 00 00 
EIP: [<c0792f67>] rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f20e3cbc
---[ end trace aebccf812d36404e ]---
note: nautilus[2872] exited with preempt_count 1
BUG: soft lockup - CPU#3 stuck for 61s! [gvfs-gdu-volume:2792]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2792, comm: gvfs-gdu-volume Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 3
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200292 EBX: c5f841ec ECX: 00000004 EDX: 00000020
ESI: 00000003 EDI: c5f84204 EBP: f23bfe1c ESP: f23bfe04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gvfs-gdu-volume (pid: 2792, ti=f23be000 task=f2bf6330
task.ti=f23be000)
Stack:
 01000000 00000000 c042a1a2 f23be000 c042a1a2 000000b4 f23bfe2c c0465ce2
<0> 00000001 00000000 f23bfe40 c04442f5 000000d5 00000020 000000b4
f23bfe48
<0> c042a110 f23bfee4 c04b4784 00000000 00000020 000000b5 000000b6
000000b7
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] ? smp_call_function+0x26/0x43
 [<c04442f5>] ? on_each_cpu+0x1b/0x4c
 [<c042a110>] ? flush_tlb_all+0x14/0x16
 [<c04b4784>] ? pkmap_get_free+0x146/0x188
 [<c04b47de>] ? pkmap_insert+0x18/0x123
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] ? kmap_high+0x32/0x39
 [<c042b1c2>] ? kmap+0x4b/0x59
 [<c04256ea>] ? kmap_atomic_func+0x16/0x18
 [<c04b84b8>] ? handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] ? do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] ? error_code+0x73/0x78
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
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] kmap_high+0x32/0x39
 [<c042b1c2>] kmap+0x4b/0x59
 [<c04256ea>] kmap_atomic_func+0x16/0x18
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78
BUG: soft lockup - CPU#0 stuck for 61s! [gnome-session:2730]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2730, comm: gnome-session Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 0
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200292 EBX: c5e041ec ECX: 00000004 EDX: 00000020
ESI: 00000000 EDI: c5e04204 EBP: f2175e1c ESP: f2175e04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gnome-session (pid: 2730, ti=f2174000 task=f5f603b0
task.ti=f2174000)
Stack:
 01000000 00000000 c042a1a2 f2174000 c042a1a2 000000d5 f2175e2c c0465ce2
<0> 00000001 00000000 f2175e40 c04442f5 000000f6 00000020 000000d5
f2175e48
<0> c042a110 f2175ee4 c04b4784 00000020 00000020 000000d6 000000d7
000000d8
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
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78
BUG: soft lockup - CPU#2 stuck for 61s! [nautilus:2874]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2874, comm: nautilus Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 2
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200286 EBX: c5f041ec ECX: 00000004 EDX: 00000020
ESI: 00000002 EDI: c5f04204 EBP: f22a9d44 ESP: f22a9d2c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process nautilus (pid: 2874, ti=f22a8000 task=f632e2f0 task.ti=f22a8000)
Stack:
 01000000 00000000 c042a1a2 f22a8000 c042a1a2 000000f6 f22a9d54 c0465ce2
<0> 00000001 00000000 f22a9d68 c04442f5 00000117 00000020 000000f6
f22a9d70
<0> c042a110 f22a9e0c c04b4784 00000020 00000020 000000f7 000000f8
000000f9
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
 [<c04b68ec>] ? unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] ? zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] ? sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
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
 [<c04b68ec>] unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
BUG: soft lockup - CPU#3 stuck for 61s! [gvfs-gdu-volume:2792]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2792, comm: gvfs-gdu-volume Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 3
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200292 EBX: c5f841ec ECX: 00000004 EDX: 00000020
ESI: 00000003 EDI: c5f84204 EBP: f23bfe1c ESP: f23bfe04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gvfs-gdu-volume (pid: 2792, ti=f23be000 task=f2bf6330
task.ti=f23be000)
Stack:
 01000000 00000000 c042a1a2 f23be000 c042a1a2 000000b4 f23bfe2c c0465ce2
<0> 00000001 00000000 f23bfe40 c04442f5 000000d5 00000020 000000b4
f23bfe48
<0> c042a110 f23bfee4 c04b4784 00000000 00000020 000000b5 000000b6
000000b7
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] ? smp_call_function+0x26/0x43
 [<c04442f5>] ? on_each_cpu+0x1b/0x4c
 [<c042a110>] ? flush_tlb_all+0x14/0x16
 [<c04b4784>] ? pkmap_get_free+0x146/0x188
 [<c04b47de>] ? pkmap_insert+0x18/0x123
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] ? kmap_high+0x32/0x39
 [<c042b1c2>] ? kmap+0x4b/0x59
 [<c04256ea>] ? kmap_atomic_func+0x16/0x18
 [<c04b84b8>] ? handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] ? do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] ? error_code+0x73/0x78
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
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] kmap_high+0x32/0x39
 [<c042b1c2>] kmap+0x4b/0x59
 [<c04256ea>] kmap_atomic_func+0x16/0x18
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78
BUG: soft lockup - CPU#0 stuck for 61s! [gnome-session:2730]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2730, comm: gnome-session Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cb2>] EFLAGS: 00200202 CPU: 0
EIP is at smp_call_function_many+0x16b/0x175
EAX: 00200292 EBX: c5e041ec ECX: 00000004 EDX: 00000020
ESI: 00000000 EDI: c5e04204 EBP: f2175e1c ESP: f2175e04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gnome-session (pid: 2730, ti=f2174000 task=f5f603b0
task.ti=f2174000)
Stack:
 01000000 00000000 c042a1a2 f2174000 c042a1a2 000000d5 f2175e2c c0465ce2
<0> 00000001 00000000 f2175e40 c04442f5 000000f6 00000020 000000d5
f2175e48
<0> c042a110 f2175ee4 c04b4784 00000020 00000020 000000d6 000000d7
000000d8
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
Code: c0 89 c2 b8 c8 21 96 c0 89 59 04 e8 4f dc 32 00 0f ae f0 89 f6 89
f8 ff 15 b8 0f 99 c0 80 7d eb 00 75 04 eb 08 f3 90 f6 43 10 01 <75> f8
8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 e3 00 e0 ff 
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
BUG: soft lockup - CPU#2 stuck for 61s! [nautilus:2874]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2874, comm: nautilus Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cb2>] EFLAGS: 00200202 CPU: 2
EIP is at smp_call_function_many+0x16b/0x175
EAX: 00200286 EBX: c5f041ec ECX: 00000004 EDX: 00000020
ESI: 00000002 EDI: c5f04204 EBP: f22a9d44 ESP: f22a9d2c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process nautilus (pid: 2874, ti=f22a8000 task=f632e2f0 task.ti=f22a8000)
Stack:
 01000000 00000000 c042a1a2 f22a8000 c042a1a2 000000f6 f22a9d54 c0465ce2
<0> 00000001 00000000 f22a9d68 c04442f5 00000117 00000020 000000f6
f22a9d70
<0> c042a110 f22a9e0c c04b4784 00000020 00000020 000000f7 000000f8
000000f9
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
 [<c04b68ec>] ? unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] ? zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] ? sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
Code: c0 89 c2 b8 c8 21 96 c0 89 59 04 e8 4f dc 32 00 0f ae f0 89 f6 89
f8 ff 15 b8 0f 99 c0 80 7d eb 00 75 04 eb 08 f3 90 f6 43 10 01 <75> f8
8d 65 f4 5b 5e 5f 5d c3 55 89 e5 53 89 e3 81 e3 00 e0 ff 
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
 [<c04b68ec>] unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
BUG: soft lockup - CPU#3 stuck for 61s! [gvfs-gdu-volume:2792]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2792, comm: gvfs-gdu-volume Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 3
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200292 EBX: c5f841ec ECX: 00000004 EDX: 00000020
ESI: 00000003 EDI: c5f84204 EBP: f23bfe1c ESP: f23bfe04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gvfs-gdu-volume (pid: 2792, ti=f23be000 task=f2bf6330
task.ti=f23be000)
Stack:
 01000000 00000000 c042a1a2 f23be000 c042a1a2 000000b4 f23bfe2c c0465ce2
<0> 00000001 00000000 f23bfe40 c04442f5 000000d5 00000020 000000b4
f23bfe48
<0> c042a110 f23bfee4 c04b4784 00000000 00000020 000000b5 000000b6
000000b7
Call Trace:
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c042a1a2>] ? do_flush_tlb_all+0x0/0x37
 [<c0465ce2>] ? smp_call_function+0x26/0x43
 [<c04442f5>] ? on_each_cpu+0x1b/0x4c
 [<c042a110>] ? flush_tlb_all+0x14/0x16
 [<c04b4784>] ? pkmap_get_free+0x146/0x188
 [<c04b47de>] ? pkmap_insert+0x18/0x123
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] ? kmap_high+0x32/0x39
 [<c042b1c2>] ? kmap+0x4b/0x59
 [<c04256ea>] ? kmap_atomic_func+0x16/0x18
 [<c04b84b8>] ? handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] ? do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] ? error_code+0x73/0x78
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
 [<c07936b6>] ? rt_spin_unlock+0x8/0xa
 [<c04b491b>] kmap_high+0x32/0x39
 [<c042b1c2>] kmap+0x4b/0x59
 [<c04256ea>] kmap_atomic_func+0x16/0x18
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c0455a51>] ? autoremove_wake_function+0x0/0x2f
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78
BUG: soft lockup - CPU#0 stuck for 61s! [gnome-session:2730]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2730, comm: gnome-session Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 0
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200292 EBX: c5e041ec ECX: 00000004 EDX: 00000020
ESI: 00000000 EDI: c5e04204 EBP: f2175e1c ESP: f2175e04
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process gnome-session (pid: 2730, ti=f2174000 task=f5f603b0
task.ti=f2174000)
Stack:
 01000000 00000000 c042a1a2 f2174000 c042a1a2 000000d5 f2175e2c c0465ce2
<0> 00000001 00000000 f2175e40 c04442f5 000000f6 00000020 000000d5
f2175e48
<0> c042a110 f2175ee4 c04b4784 00000020 00000020 000000d6 000000d7
000000d8
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
 [<c04b84b8>] handle_mm_fault+0xdc/0x92a
 [<c07961ab>] do_page_fault+0x29d/0x2b3
 [<c0795f0e>] ? do_page_fault+0x0/0x2b3
 [<c0794267>] error_code+0x73/0x78
BUG: soft lockup - CPU#2 stuck for 61s! [nautilus:2874]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]
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
snd_cs8427 snd_ac97_codec ac97_bus snd_i2c snd_seq_dummy snd_mpu401_uart
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_rawmidi snd_seq_device snd_timer snd i2c_i801 iTCO_wdt ohci1394
iTCO_vendor_support asus_atk0110 soundcore sky2 snd_page_alloc serio_raw
joydev sata_sil24 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[last unloaded: microcode]

Pid: 2874, comm: nautilus Tainted: G      D
2.6.33.6-147.rt23.1.fc12.ccrma.i686.rtPAE #1 P5K/EPU/P5K/EPU
EIP: 0060:[<c0465cae>] EFLAGS: 00200202 CPU: 2
EIP is at smp_call_function_many+0x167/0x175
EAX: 00200286 EBX: c5f041ec ECX: 00000004 EDX: 00000020
ESI: 00000002 EDI: c5f04204 EBP: f22a9d44 ESP: f22a9d2c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 preempt:00010003
Process nautilus (pid: 2874, ti=f22a8000 task=f632e2f0 task.ti=f22a8000)
Stack:
 01000000 00000000 c042a1a2 f22a8000 c042a1a2 000000f6 f22a9d54 c0465ce2
<0> 00000001 00000000 f22a9d68 c04442f5 00000117 00000020 000000f6
f22a9d70
<0> c042a110 f22a9e0c c04b4784 00000020 00000020 000000f7 000000f8
000000f9
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
 [<c04b68ec>] ? unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] ? zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] ? sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] ? sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf
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
 [<c04b68ec>] unmap_vmas+0x27a/0x5ae
 [<c04ce6ac>] ? mem_cgroup_add_lru_list+0x56/0x64
 [<c04b6cbc>] zap_page_range+0x9c/0xc7
 [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
 [<c04b4d42>] sys_madvise+0x34e/0x4e8
 [<c047ddff>] ? audit_syscall_entry+0x113/0x135
 [<c0408adf>] sysenter_do_call+0x12/0x28
 [<c0790000>] ? timer_cpu_notify+0x11a/0x2bf


