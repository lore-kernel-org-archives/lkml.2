Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0GaTCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:02:23 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:40137 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753598Ab0GaTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:02:21 -0400
Subject: Re: 2.6.33.6-rt26: oops (network related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1280460642.2173.3.camel@localhost.localdomain>
References: <1280460642.2173.3.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 12:01:42 -0700
Message-ID: <1280602902.11380.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Spam: Probability=8%, Report='
 DATE_TZ_NA 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_MEDIA_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 20:30 -0700, Fernando Lopez-Lezcano wrote:
> Hi all...
> This may not be rt related but here it goes anyway. It happened when I
> tried to restart my iptables service (/sbin/service iptables start). I
> think a day or two ago I had another network related hang, but it was a
> complete hang (no clues left behind - power button to reset). 

Ok this one is rt related (apparently). The workstation (4 core, intel
based) hang hard while a process was starting a daily backup but the
logs captured the BUG:

--------
Jul 31 06:48:35 localhost kernel: ------------[ cut here ]------------
Jul 31 06:48:35 localhost kernel: kernel BUG at kernel/rtmutex.c:808!
Jul 31 06:48:35 localhost kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jul 31 06:48:35 localhost kernel: last sysfs
file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
Jul 31 06:48:35 localhost kernel: Modules linked in: snd_seq_midi
autofs4 act_police cls_flow cls_fw cls_u32 sch_htb sch_hfsc sch_ingress
sch_sfq xt_time xt_connlimit xt_realm iptable_raw xt_comment xt_recent
xt_policy ipt_ULOG ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN
ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_TPROXY nf_tproxy_core xt_tcpmss xt_pkttype
xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport
xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper
xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY
ipt_LOG iptable_nat nf_nat iptable_mangle nfnetlink coretemp hwmon_vid
nfs lockd fscache nfs_acl auth_rp
Jul 31 06:48:35 localhost kernel: cgss sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath uinput
snd_hdspm snd_hdsp snd_hda_intel snd_hda_codec snd_usb_audio r8169
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq mii snd_pcm_oss
snd_mixer_oss snd_pcm ohci1394 ppdev snd_hwdep snd_usb_lib snd_rawmidi
snd_seq_device snd_timer snd parport_pc i2c_i801 parport snd_page_alloc
iTCO_wdt iTCO_vendor_support serio_raw soundcore ata_generic pata_acpi
pata_jmicron radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
unloaded: microcode]
Jul 31 06:48:35 localhost kernel:
Jul 31 06:48:35 localhost kernel: Pid: 50, comm: sirq-net-rx/3 Not
tainted 2.6.33.6-147.rt26.1.fc12.ccrma.i686.rtPAE #1 EP45-DS3R/EP45-DS3R
Jul 31 06:48:35 localhost kernel: EIP: 0060:[<c0791bf7>] EFLAGS:
00010046 CPU: 3
Jul 31 06:48:35 localhost kernel: EIP is at rt_spin_lock_slowlock
+0x43/0x1bb
Jul 31 06:48:35 localhost kernel: EAX: f715c0b0 EBX: c5f85c80 ECX:
c5f85c80 EDX: f715c0b0
Jul 31 06:48:35 localhost kernel: ESI: ed004fc0 EDI: f5fec240 EBP:
f7161dc0 ESP: f7161d68
Jul 31 06:48:35 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068 preempt:00000001
Jul 31 06:48:35 localhost kernel: Process sirq-net-rx/3 (pid: 50,
ti=f7160000 task=f715c0b0 task.ti=f7160000)
Jul 31 06:48:35 localhost kernel: Stack:
Jul 31 06:48:35 localhost kernel: f7161e04 c057783d c043a00f 00000039
00000292 c0420002 6d9c675d c5f881c0
Jul 31 06:48:35 localhost kernel: <0> f7161dd0 f7161d94 c041caac
f7161dd8 c0792979 ed7d99f4 c5f881c0 00000002
Jul 31 06:48:35 localhost kernel: <0> 00000000 00000000 00000246
c5f85c80 ed004fc0 f5fec240 f7161dcc c0465595
Jul 31 06:48:35 localhost kernel: Call Trace:
Jul 31 06:48:35 localhost kernel: [<c057783d>] ?
selinux_socket_sock_rcv_skb+0x8f/0x1c7
Jul 31 06:48:35 localhost kernel: [<c043a00f>] ? post_schedule_rt
+0xd/0x14
Jul 31 06:48:35 localhost kernel: [<c0420002>] ? hpet_msi_set_affinity
+0xf/0x75
Jul 31 06:48:35 localhost kernel: [<c041caac>] ?
smp_reschedule_interrupt+0x16/0x20
Jul 31 06:48:35 localhost kernel: [<c0792979>] ? reschedule_interrupt
+0x31/0x38
Jul 31 06:48:35 localhost kernel: [<c0465595>] ?
rt_spin_lock_fastlock.clone.1+0x5c/0x5f
Jul 31 06:48:35 localhost kernel: [<c0792332>] ? rt_spin_lock+0x8/0xa
Jul 31 06:48:35 localhost kernel: [<c075f896>] ? ipt_do_table+0xce/0x4f0
Jul 31 06:48:35 localhost kernel: [<c0791d51>] ? rt_spin_lock_slowlock
+0x19d/0x1bb
Jul 31 06:48:35 localhost kernel: [<c07923eb>] ? rt_read_unlock
+0x13/0x15
Jul 31 06:48:35 localhost kernel: [<c074c0d7>] ? udp_queue_rcv_skb
+0x193/0x1d2
Jul 31 06:48:35 localhost kernel: [<fa6ad0a2>] ? ipt_hook+0x1e/0x24
[iptable_raw]
Jul 31 06:48:35 localhost kernel: [<c0720ceb>] ? nf_iterate+0x2f/0x62
Jul 31 06:48:35 localhost kernel: [<c072d600>] ? ip_rcv_finish+0x0/0x2d9
Jul 31 06:48:35 localhost kernel: [<c0720e44>] ? nf_hook_slow+0x44/0xa1
Jul 31 06:48:35 localhost kernel: [<c072d600>] ? ip_rcv_finish+0x0/0x2d9
Jul 31 06:48:35 localhost kernel: [<c072dae6>] ? ip_rcv+0x20d/0x243
Jul 31 06:48:35 localhost kernel: [<c072d600>] ? ip_rcv_finish+0x0/0x2d9
Jul 31 06:48:35 localhost kernel: [<c07082fc>] ? netif_receive_skb
+0x3ca/0x3ea
Jul 31 06:48:35 localhost kernel: [<c070838f>] ? process_backlog
+0x73/0x9d
Jul 31 06:48:35 localhost kernel: [<c07088ef>] ? net_rx_action
+0x92/0x1a7
Jul 31 06:48:35 localhost kernel: [<c044445e>] ? run_ksoftirqd
+0x138/0x236
Jul 31 06:48:35 localhost kernel: [<c0444326>] ? run_ksoftirqd+0x0/0x236
Jul 31 06:48:35 localhost kernel: [<c04557ae>] ? kthread+0x5f/0x64
Jul 31 06:48:35 localhost kernel: [<c045574f>] ? kthread+0x0/0x64
Jul 31 06:48:35 localhost kernel: [<c040907e>] ? kernel_thread_helper
+0x6/0x10
Jul 31 06:48:35 localhost kernel: Code: 7b 08 00 89 45 b8 75 12 8d 43 04
89 43 04 89 43 08 8d 43 0c 89 43 0c 89 43 10 8b 43 14 64 8b 15 2c b1 a5
c0 83 e0 fc 39 c2 75 04 <0f> 0b eb fe 8b 3a 81 ff 08 01 00 00 74 0a 83
ff 02 b8 04 00 00 
Jul 31 06:48:35 localhost kernel: EIP: [<c0791bf7>]
rt_spin_lock_slowlock+0x43/0x1bb SS:ESP 0068:f7161d68
Jul 31 06:48:35 localhost kernel: ---[ end trace 1f65f0b05c43491f ]---
Jul 31 06:48:35 localhost kernel: note: sirq-net-rx/3[50] exited with
preempt_count 1
--------

There is something fishy going on in rt26 and it appears to be related
to network activity. 

-- Fernando



> Jul 29 18:27:57 localhost kernel: BUG: unable to handle kernel NULL
> pointer dereference at (null)
> Jul 29 18:27:57 localhost kernel: IP: [<c045ad40>] exit_creds+0xc/0x54
> Jul 29 18:27:57 localhost kernel: *pdpt = 0000000000a68001 *pde =
> 0000000000000000 
> Jul 29 18:27:57 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
> Jul 29 18:27:57 localhost kernel: last sysfs
> file: /sys/devices/virtual/net/pan0/statistics/collisions
> Jul 29 18:27:57 localhost kernel: Modules linked in: snd_seq_midi
> snd_seq_midi_event snd_seq_dummy snd_usb_audio snd_usb_lib snd_rawmidi
> fuse rfcomm sco bridge stp llc bnep l2cap sunrpc cpufreq_ondemand
> acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
> ipv6 dm_multipath uinput arc4 snd_hda_codec_analog ecb iwl3945
> snd_hda_intel snd_hda_codec iwlcore thinkpad_acpi btusb sdhci_pci sdhci
> mmc_core snd_hwdep e1000e snd_seq ohci1394 ricoh_mmc snd_seq_device
> snd_pcm snd_timer snd mac80211 i2c_i801 iTCO_wdt iTCO_vendor_support
> joydev cfg80211 bluetooth snd_page_alloc rfkill soundcore yenta_socket
> rsrc_nonstatic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> output [last unloaded: microcode]


