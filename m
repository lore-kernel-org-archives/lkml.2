Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1LUQ3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:29:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46553 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1LUQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:29:29 -0500
Message-ID: <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 21 Dec 2011 17:29:16 +0100
In-Reply-To: <4EF200BB.7000209@bootc.net>
References: <4EF200BB.7000209@bootc.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 décembre 2011 à 15:52 +0000, Chris Boot a écrit :
> Hi folks,
> 
> I'm working on getting a 2-node VM cluster up and running, with DRBD and 
> Corosync/Pacemaker, running KVM VMs.
> 
> I can trigger a kernel panic in either _host_ system when running an 
> rsync on a _guest_ VM. The rsync is simply SSH over IPv6 from a remote 
> mail store (containing maildirs) to a local filesystem. I'm basically 
> working on migrating a physical IMAP server to one inside a VM.
> 
> After a few seconds of fairly heavy IPv6 traffic, I get the panic below. 
> You'll notice the panic refers to vhost_net, but I tried without that 
> and the kernel panics at exactly the same call point.
> 
> Panic:
> 
> [  461.232932] BUG: unable to handle kernel NULL pointer dereference at 
> 0000000000000298
> [  461.240790] IP: [<ffffffff812dde61>] ipv6_select_ident+0x31/0xa7
> [  461.246916] PGD 42d3e8067 PUD 41facf067 PMD 0
> [  461.251537] Oops: 0000 [#1] SMP
> [  461.254795] CPU 4
> [  461.256648] Modules linked in: sha1_generic hmac sha256_generic dlm 
> configfs ebtable_nat ebtables acpi_cpufreq mperf cpufreq_stats 
> cpufreq_conservative cpufreq_powersave cpufreq_userspace microcode 
> xt_NOTRACK ip_set_hash_net act_police cls_basic cls_flow cls_fw cls_u32 sch_
> tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_realm xt_connlimit 
> xt_addrtype ip_set_hash_ip iptable_raw xt_comment xt_recent ipt_ULOG 
> ipt_REJECT ipt_REDIRECT ip6_queue ipt_NETMAP ipt_MASQUERADE ipt_ECN 
> ipt_ecn nf_conntrack_proto_udplite ipt_CLUSTERIP ipt_ah xt_time xt_s
> et xt_TCPMSS ip_set xt_sctp xt_policy nf_nat_tftp nf_nat_snmp_basic 
> nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc 
> nf_nat_h323 nf_nat_ftp nf_nat_amanda ip6t_LOG ts_kmp ip6t_REJECT 
> nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf
> _conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre 
> nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_broadcast 
> nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPROXY 
> nf_tproxy_core xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE 
> xt_NFLOG nfnetlin
> k_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_iprange 
> xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_connmark xt_CLASSIFY 
> xt_AUDIT ipt_LOG xt_tcpudp xt_state nf_conntrack_ipv6 nf_defrag_ipv6 
> iptable_nat nf_nat xt_conntrack nf_conntrack_ipv4 nf_defrag_ipv4 ip6table
> _raw nf_conntrack ip6table_mangle iptable_mangle nfnetlink 
> iptable_filter ip_tables ip6table_filter ip6_tables x_tables bridge stp 
> bonding w83627ehf hwmon_vid coretemp crc32c_intel aesni_intel cryptd 
> aes_x86_64 aes_generic ipmi_poweroff ipmi_devintf ipmi_si 
> ipmi_msghandler vho
> st_net macvtap macvlan tun drbd lru_cache cn loop kvm_intel kvm snd_pcm 
> snd_timer snd soundcore snd_page_alloc psmouse i2c_i801 processor 
> iTCO_wdt iTCO_vendor_support i2c_core evdev thermal_sys joydev serio_raw 
> pcspkr button ext4 mbcache jbd2 crc16 dm_mod raid1 md_mod sd_mod c
> rc_t10dif usb_storage uas usbhid hid ahci libahci libata igb ehci_hcd 
> scsi_mod usbcore e1000e dca [last unloaded: scsi_wait_scan]
> [  461.446246]
> [  461.447812] Pid: 5756, comm: vhost-5753 Not tainted 3.1.0-1-amd64 #1 
> Supermicro X9SCL/X9SCM/X9SCL/X9SCM
> [  461.457562] RIP: 0010:[<ffffffff812dde61>]  [<ffffffff812dde61>] 
> ipv6_select_ident+0x31/0xa7
> [  461.466271] RSP: 0018:ffff88043fd03758  EFLAGS: 00010202
> [  461.471708] RAX: ffff8803f7159038 RBX: 00000000000001f4 RCX: 
> 0000000000000000
> [  461.478979] RDX: 0000000000000016 RSI: ffff88042dadcf30 RDI: 
> ffff8803f715906e
> [  461.486207] RBP: ffff8803f715906e R08: 0ea8c9feff005256 R09: 
> 00000000000080fe
> [  461.493542] R10: 5256000000000000 R11: 80fe4e6fdcfeff00 R12: 
> 0000000040115ba9
> [  461.500851] R13: ffffffff8168ed11 R14: 0000000000000011 R15: 
> ffff8803f7159880
> [  461.508167] FS:  0000000000000000(0000) GS:ffff88043fd00000(0000) 
> knlGS:0000000000000000
> [  461.516444] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  461.522317] CR2: 0000000000000298 CR3: 000000042d87e000 CR4: 
> 00000000000426e0
> [  461.529607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> [  461.536916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400
> [  461.544267] Process vhost-5753 (pid: 5756, threadinfo 
> ffff88042cb4a000, task ffff88042d13c970)
> [  461.553108] Stack:
> [  461.555202]  ffff8803f7159038 ffff88042be0e280 0000000000000028 
> ffffffff812efa7f
> [  461.562840]  0000000000000246 ffff8803f7159054 ffff88042be0e318 
> ffff88042be0e280
> [  461.570544]  ffffffffffffffa3 0000000040115ba9 ffffffff8168edc0 
> ffffffff812dbfe0
> [  461.578229] Call Trace:
> [  461.580742] <IRQ>
> [  461.582870]  [<ffffffff812efa7f>] ? udp6_ufo_fragment+0x124/0x1a2
> [  461.589054]  [<ffffffff812dbfe0>] ? ipv6_gso_segment+0xc0/0x155
> [  461.595140]  [<ffffffff812700c6>] ? skb_gso_segment+0x208/0x28b
> [  461.601198]  [<ffffffffa03f236b>] ? ipv6_confirm+0x146/0x15e 
> [nf_conntrack_ipv6]
> [  461.608786]  [<ffffffff81291c4d>] ? nf_iterate+0x41/0x77
> [  461.614227]  [<ffffffff81271d64>] ? dev_hard_start_xmit+0x357/0x543
> [  461.620659]  [<ffffffff81291cf6>] ? nf_hook_slow+0x73/0x111
> [  461.626440]  [<ffffffffa0379745>] ? br_parse_ip_options+0x19a/0x19a 
> [bridge]
> [  461.633581]  [<ffffffff812722ff>] ? dev_queue_xmit+0x3af/0x459
> [  461.639577]  [<ffffffffa03747d2>] ? br_dev_queue_push_xmit+0x72/0x76 
> [bridge]
> [  461.646887]  [<ffffffffa03791e3>] ? br_nf_post_routing+0x17d/0x18f 
> [bridge]
> [  461.653997]  [<ffffffff81291c4d>] ? nf_iterate+0x41/0x77
> [  461.659473]  [<ffffffffa0374760>] ? br_flood+0xfa/0xfa [bridge]
> [  461.665485]  [<ffffffff81291cf6>] ? nf_hook_slow+0x73/0x111
> [  461.671234]  [<ffffffffa0374760>] ? br_flood+0xfa/0xfa [bridge]
> [  461.677299]  [<ffffffffa0379215>] ? 
> nf_bridge_update_protocol+0x20/0x20 [bridge]
> [  461.684891]  [<ffffffffa03bb0e5>] ? nf_ct_zone+0xa/0x17 [nf_conntrack]
> [  461.691520]  [<ffffffffa0374760>] ? br_flood+0xfa/0xfa [bridge]
> [  461.697572]  [<ffffffffa0374812>] ? NF_HOOK.constprop.8+0x3c/0x56 
> [bridge]
> [  461.704616]  [<ffffffffa0379031>] ? 
> nf_bridge_push_encap_header+0x1c/0x26 [bridge]
> [  461.712329]  [<ffffffffa037929f>] ? br_nf_forward_finish+0x8a/0x95 
> [bridge]
> [  461.719490]  [<ffffffffa037900a>] ? 
> nf_bridge_pull_encap_header+0x1c/0x27 [bridge]
> [  461.727223]  [<ffffffffa0379974>] ? br_nf_forward_ip+0x1c0/0x1d4 [bridge]
> [  461.734292]  [<ffffffff81291c4d>] ? nf_iterate+0x41/0x77
> [  461.739758]  [<ffffffffa03748cc>] ? __br_deliver+0xa0/0xa0 [bridge]
> [  461.746203]  [<ffffffff81291cf6>] ? nf_hook_slow+0x73/0x111
> [  461.751950]  [<ffffffffa03748cc>] ? __br_deliver+0xa0/0xa0 [bridge]
> [  461.758378]  [<ffffffffa037533a>] ? NF_HOOK.constprop.4+0x56/0x56 
> [bridge]
> [  461.765454]  [<ffffffffa03748cc>] ? __br_deliver+0xa0/0xa0 [bridge]
> [  461.771881]  [<ffffffffa0374812>] ? NF_HOOK.constprop.8+0x3c/0x56 
> [bridge]
> [  461.778908]  [<ffffffffa03749a6>] ? br_forward+0x16/0x5a [bridge]
> [  461.785041]  [<ffffffffa03754db>] ? 
> br_handle_frame_finish+0x1a1/0x20f [bridge]
> [  461.792604]  [<ffffffffa0379333>] ? 
> br_nf_pre_routing_finish_ipv6+0x89/0x92 [bridge]
> [  461.800513]  [<ffffffffa0378e7b>] ? setup_pre_routing+0x38/0x5d [bridge]
> [  461.807440]  [<ffffffffa0379e65>] ? br_nf_pre_routing+0x3e8/0x3f5 
> [bridge]
> [  461.814463]  [<ffffffff81291c4d>] ? nf_iterate+0x41/0x77
> [  461.819908]  [<ffffffff8103f89d>] ? select_task_rq_fair+0x369/0x610
> [  461.826347]  [<ffffffffa037533a>] ? NF_HOOK.constprop.4+0x56/0x56 
> [bridge]
> [  461.833463]  [<ffffffffa037533a>] ? NF_HOOK.constprop.4+0x56/0x56 
> [bridge]
> [  461.840532]  [<ffffffff81291cf6>] ? nf_hook_slow+0x73/0x111
> [  461.846134]  [<ffffffffa037533a>] ? NF_HOOK.constprop.4+0x56/0x56 
> [bridge]
> [  461.853222]  [<ffffffff81036010>] ? test_tsk_need_resched+0xa/0x13
> [  461.859601]  [<ffffffffa037533a>] ? NF_HOOK.constprop.4+0x56/0x56 
> [bridge]
> [  461.866650]  [<ffffffffa0375320>] ? NF_HOOK.constprop.4+0x3c/0x56 
> [bridge]
> [  461.873686]  [<ffffffffa03756ed>] ? br_handle_frame+0x1a4/0x1bb [bridge]
> [  461.880569]  [<ffffffffa0375549>] ? 
> br_handle_frame_finish+0x20f/0x20f [bridge]
> [  461.888042]  [<ffffffff8126f132>] ? __netif_receive_skb+0x2d6/0x415
> [  461.894467]  [<ffffffff8126f2dd>] ? process_backlog+0x6c/0x123
> [  461.900414]  [<ffffffff81026b37>] ? native_apic_msr_write+0x2c/0x2f
> [  461.906790]  [<ffffffff81271034>] ? net_rx_action+0xa1/0x1af
> [  461.912625]  [<ffffffff81036010>] ? test_tsk_need_resched+0xa/0x13
> [  461.919010]  [<ffffffff8104ad04>] ? __do_softirq+0xb9/0x177
> [  461.924796]  [<ffffffff8133452c>] ? call_softirq+0x1c/0x30
> [  461.930474] <EOI>
> [  461.932684]  [<ffffffff8100f845>] ? do_softirq+0x3c/0x7b
> [  461.938106]  [<ffffffff81271324>] ? netif_rx_ni+0x1e/0x27
> [  461.943610]  [<ffffffffa0298721>] ? tun_get_user+0x39a/0x3c2 [tun]
> [  461.949923]  [<ffffffffa0298766>] ? tun_sendmsg+0x1d/0x1f [tun]
> [  461.955938]  [<ffffffffa02a6b50>] ? handle_tx+0x340/0x3de [vhost_net]
> [  461.962609]  [<ffffffffa02a46cb>] ? vhost_worker+0x10b/0x121 [vhost_net]
> [  461.969447]  [<ffffffffa02a45c0>] ? 
> vhost_attach_cgroups_work+0x1b/0x1b [vhost_net]
> [  461.977274]  [<ffffffff8105e5d1>] ? kthread+0x76/0x7e
> [  461.982440]  [<ffffffff81334434>] ? kernel_thread_helper+0x4/0x10
> [  461.988667]  [<ffffffff8105e55b>] ? kthread_worker_fn+0x139/0x139
> [  461.994940]  [<ffffffff81334430>] ? gs_change+0x13/0x13
> [  462.000283] Code: fd 53 48 89 f3 50 74 70 48 83 be 10 01 00 00 00 75 
> 0d be 01 00 00 00 48 89 df e8 be 9d 00 00 48 8b 9b 10 01 00 00 48 85 db 
> 74 4d <8b> 83 a4 00 00 00 85 c0 7f 21 80 3d 2e e5 51 00 01 74 18 be 68
> [  462.021671] RIP  [<ffffffff812dde61>] ipv6_select_ident+0x31/0xa7
> [  462.027977]  RSP <ffff88043fd03758>
> [  462.031554] CR2: 0000000000000298
> [  462.034892] ---[ end trace d158e8d429419372 ]---
> [  462.039878] Kernel panic - not syncing: Fatal exception in interrupt
> 
> Any insight will be gratefully received.
> 
> Thanks,
> Chris
> 

Is it a debian kernel ?

You need : https://lkml.org/lkml/2011/10/11/291



