Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1LDOKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:10:39 -0500
Received: from out1.rolmail.net ([195.254.252.212]:42918 "EHLO
	out1.rolmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1LDOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:10:37 -0500
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Dec 2011 09:10:36 EST
Message-ID: <4EDB7CE0.9010105@enas.net>
Date: Sun, 04 Dec 2011 15:00:00 +0100
From: Urban Loesch <bind@enas.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: divide by zero error: find busiest group on kernel 2.6.38.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm new to the list.

I'm running a DELL PE R610 with kernel
2.6.38.4 patched with linux vserver version vs2.3.0.37-rc15 from 
http://linux-vserver.org.

The server runs fine about 220 days without any problems.
But last night there was a kernel panic and the server totally hangs.

Thanks to netconsole I got the following error in my syslogserver:


2011-12-04 00:32:16 divide error: 0000 [#1]
2011-12-04 00:32:16 SMP
2011-12-04 00:32:16
2011-12-04 00:32:16 last sysfs file: /sys/module/drbd/parameters/cn_idx 

2011-12-04 00:32:16 CPU 17
2011-12-04 00:32:16
2011-12-04 00:32:16 Modules linked in:
2011-12-04 00:32:16 netconsole
2011-12-04 00:32:16 configfs
2011-12-04 00:32:16 af_packet
2011-12-04 00:32:16 ext4
2011-12-04 00:32:16 jbd2
2011-12-04 00:32:16 crc16
2011-12-04 00:32:16 crc32c
2011-12-04 00:32:16 drbd
2011-12-04 00:32:16 lru_cache
2011-12-04 00:32:16 cn
2011-12-04 00:32:16 ip6_queue
2011-12-04 00:32:16 act_police
2011-12-04 00:32:16 cls_flow
2011-12-04 00:32:16 cls_fw
2011-12-04 00:32:16 cls_u32
2011-12-04 00:32:16 sch_hfsc
2011-12-04 00:32:16 sch_htb
2011-12-04 00:32:16 sch_ingress
2011-12-04 00:32:16 sch_sfq
2011-12-04 00:32:16 ip6t_LOG
2011-12-04 00:32:16 xt_realm
2011-12-04 00:32:16 xt_connlimit
2011-12-04 00:32:16 iptable_raw
2011-12-04 00:32:16 ip6table_raw
2011-12-04 00:32:16 xt_comment
2011-12-04 00:32:16 ip6t_REJECT
2011-12-04 00:32:16 xt_recent
2011-12-04 00:32:16 ipt_ULOG
2011-12-04 00:32:16 ipt_REJECT
2011-12-04 00:32:16 ipt_REDIRECT
2011-12-04 00:32:16 ipt_NETMAP
2011-12-04 00:32:16 ipt_MASQUERADE
2011-12-04 00:32:16 ipt_ECN
2011-12-04 00:32:16 ipt_ecn
2011-12-04 00:32:16 ipt_CLUSTERIP
2011-12-04 00:32:16 ipt_ah
2011-12-04 00:32:16 ipt_addrtype
2011-12-04 00:32:16 nf_nat_tftp
2011-12-04 00:32:16 nf_nat_snmp_basic
2011-12-04 00:32:16 nf_nat_pptp
2011-12-04 00:32:16 nf_nat_proto_gre
2011-12-04 00:32:16 nf_nat_irc
2011-12-04 00:32:16 nf_nat_ftp
2011-12-04 00:32:16 nf_nat_amanda
2011-12-04 00:32:16 ip6table_mangle
2011-12-04 00:32:16 nf_conntrack_ipv6
2011-12-04 00:32:16 nf_conntrack_tftp
2011-12-04 00:32:16 nf_conntrack_proto_udplite
2011-12-04 00:32:16 nf_conntrack_pptp
2011-12-04 00:32:16 nf_conntrack_proto_gre
2011-12-04 00:32:16 nf_conntrack_netlink
2011-12-04 00:32:16 nf_conntrack_irc
2011-12-04 00:32:16 nf_conntrack_ftp
2011-12-04 00:32:16 ts_kmp
2011-12-04 00:32:16 xt_NFLOG
2011-12-04 00:32:16 nfnetlink_log
2011-12-04 00:32:16 nf_conntrack_amanda
2011-12-04 00:32:16 xt_TPROXY
2011-12-04 00:32:16 nf_tproxy_core
2011-12-04 00:32:16 nf_defrag_ipv6
2011-12-04 00:32:16 xt_time
2011-12-04 00:32:16 xt_TCPMSS
2011-12-04 00:32:16 xt_tcpmss
2011-12-04 00:32:16 xt_policy
2011-12-04 00:32:16 xt_pkttype
2011-12-04 00:32:16 xt_physdev
2011-12-04 00:32:16 ipt_LOG
2011-12-04 00:32:16 xt_owner
2011-12-04 00:32:16 xt_NFQUEUE
2011-12-04 00:32:16 xt_multiport
2011-12-04 00:32:16 iptable_nat
2011-12-04 00:32:16 xt_mark
2011-12-04 00:32:16 nf_nat
2011-12-04 00:32:16 xt_mac
2011-12-04 00:32:16 xt_limit
2011-12-04 00:32:16 xt_length
2011-12-04 00:32:16 nf_conntrack_ipv4
2011-12-04 00:32:16 xt_iprange
2011-12-04 00:32:16 xt_helper
2011-12-04 00:32:16 nf_defrag_ipv4
2011-12-04 00:32:16 xt_hashlimit
2011-12-04 00:32:16 xt_DSCP
2011-12-04 00:32:16 iptable_mangle
2011-12-04 00:32:16 xt_dscp
2011-12-04 00:32:16 xt_dccp
2011-12-04 00:32:16 xt_connmark
2011-12-04 00:32:16 xt_CLASSIFY
2011-12-04 00:32:16 xt_tcpudp
2011-12-04 00:32:16 xt_state
2011-12-04 00:32:16 xt_conntrack
2011-12-04 00:32:16 nf_conntrack
2011-12-04 00:32:16 nfnetlink
2011-12-04 00:32:16 iptable_filter
2011-12-04 00:32:16 ip_tables
2011-12-04 00:32:16 ip6table_filter
2011-12-04 00:32:16 ip6_tables
2011-12-04 00:32:16 x_tables
2011-12-04 00:32:16 ipmi_devintf
2011-12-04 00:32:16 ipmi_si
2011-12-04 00:32:16 ipmi_msghandler
2011-12-04 00:32:16 loop
2011-12-04 00:32:16 psmouse
2011-12-04 00:32:16 rtc_cmos
2011-12-04 00:32:16 rtc_core
2011-12-04 00:32:16 tpm_tis
2011-12-04 00:32:16 rtc_lib
2011-12-04 00:32:16 tpm
2011-12-04 00:32:16 i7core_edac
2011-12-04 00:32:16 processor
2011-12-04 00:32:16 tpm_bios
2011-12-04 00:32:16 serio_raw
2011-12-04 00:32:16 power_meter
2011-12-04 00:32:16 evdev
2011-12-04 00:32:16 dcdbas
2011-12-04 00:32:16 edac_core
2011-12-04 00:32:16 thermal_sys
2011-12-04 00:32:16 button
2011-12-04 00:32:16 pcspkr
2011-12-04 00:32:16 ext3
2011-12-04 00:32:16 jbd
2011-12-04 00:32:16 mbcache
2011-12-04 00:32:16 dm_mod
2011-12-04 00:32:16 sg
2011-12-04 00:32:16 sr_mod
2011-12-04 00:32:16 cdrom
2011-12-04 00:32:16 ata_generic
2011-12-04 00:32:16 pata_acpi
2011-12-04 00:32:16 sd_mod
2011-12-04 00:32:16 uhci_hcd
2011-12-04 00:32:16 ata_piix
2011-12-04 00:32:16 libata
2011-12-04 00:32:16 megaraid_sas
2011-12-04 00:32:16 scsi_mod
2011-12-04 00:32:16 ixgbe
2011-12-04 00:32:16 dca
2011-12-04 00:32:16 ide_pci_generic
2011-12-04 00:32:16 ide_core
2011-12-04 00:32:16 ehci_hcd
2011-12-04 00:32:16 bnx2
2011-12-04 00:32:16 usbcore
2011-12-04 00:32:16 mdio
2011-12-04 00:32:16 crc32
2011-12-04 00:32:16 unix
2011-12-04 00:32:16 [last unloaded: scsi_wait_scan]
2011-12-04 00:32:16
2011-12-04 00:32:16
2011-12-04 00:32:16 Pid: 0, comm: kworker/0:1 Not tainted 
2.6.38.4-vs2.3.0.37-rc15-rol-em64t #1
2011-12-04 00:32:16
2011-12-04 00:32:16 Dell Inc. PowerEdge R610
2011-12-04 00:32:16 /
2011-12-04 00:32:16 0F0XJ6
2011-12-04 00:32:16
2011-12-04 00:32:16 RIP: 0010:[<ffffffff8103abb8>]
2011-12-04 00:32:16 [<ffffffff8103abb8>] find_busiest_group+0x428/0xdd0 

2011-12-04 00:32:16 RSP: 0018:ffff8800ce823bc0 EFLAGS: 00010246
2011-12-04 00:32:16 RAX: 0000000000000000 RBX: ffff8800ce823e48 RCX: 
0000000000000000
2011-12-04 00:32:16 RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
0000000000000000
2011-12-04 00:32:16 RBP: ffff8800ce823d90 R08: 0000000000000001 R09: 
ffff8800ce82db80
2011-12-04 00:32:16 R10: 0000000000000000 R11: 0000000000000000 R12: 
0000000000011980
2011-12-04 00:32:16 R13: 00000000ffffffff R14: 0000000000011980 R15: 
ffffffffffffffff
2011-12-04 00:32:16 FS: 0000000000000000(0000) GS:ffff8800ce820000(0000) 
knlGS:0000000000000000
2011-12-04 00:32:16 CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
2011-12-04 00:32:16 CR2: 00007f11c537c4a8 CR3: 0000000001603000 CR4: 
00000000000006e0
2011-12-04 00:32:16 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
2011-12-04 00:32:16 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
2011-12-04 00:32:16 Process kworker/0:1 (pid: 0, threadinfo 
ffff88080fb58000, task ffff88080faf87c0)
2011-12-04 00:32:16 Stack:
2011-12-04 00:32:16 ffff8800ce823be0
2011-12-04 00:32:16 ffff8800ce823d20
2011-12-04 00:32:16 000000000000c4ea
2011-12-04 00:32:16 000000000000024d
2011-12-04 00:32:16
2011-12-04 00:32:16 ffff8800ce82db80
2011-12-04 00:32:16 ffffffffa0044701
2011-12-04 00:32:16 ffff8800ce823e40
2011-12-04 00:32:16 0000000001823c18
2011-12-04 00:32:16
2011-12-04 00:32:16 0000001100000000
2011-12-04 00:32:16 ffff8800ce82da60
2011-12-04 00:32:16 0000001100011980
2011-12-04 00:32:16 0000000000000000
2011-12-04 00:32:16
2011-12-04 00:32:16 Call Trace:
2011-12-04 00:32:16 <IRQ>
2011-12-04 00:32:16
2011-12-04 00:32:16 [<ffffffffa0044701>] ? bnx2_start_xmit+0x151/0x7d0 
[bnx2]
2011-12-04 00:32:16 [<ffffffff8103b630>] load_balance+0xd0/0x760
2011-12-04 00:32:16 [<ffffffff810339e6>] ? enqueue_task_fair+0x1c6/0x350 

2011-12-04 00:32:16 [<ffffffff81038f18>] ? scheduler_tick+0x1b8/0x230
2011-12-04 00:32:16 [<ffffffff8103bd65>] 
run_rebalance_domains+0xa5/0x190
2011-12-04 00:32:16 [<ffffffff810746e8>] ? 
tick_dev_program_event+0x48/0x110
2011-12-04 00:32:16 [<ffffffff81044a69>] __do_softirq+0x99/0x130
2011-12-04 00:32:16 [<ffffffff8105dcbb>] ? hrtimer_interrupt+0x12b/0x240 

2011-12-04 00:32:16 [<ffffffff8100339c>] call_softirq+0x1c/0x30
2011-12-04 00:32:16 [<ffffffff810051c5>] do_softirq+0x65/0xa0
2011-12-04 00:32:16 [<ffffffff810445bd>] irq_exit+0x3d/0x50
2011-12-04 00:32:16 [<ffffffff8101cf6b>] 
smp_apic_timer_interrupt+0x6b/0xa0
2011-12-04 00:32:16 [<ffffffff81002e53>] apic_timer_interrupt+0x13/0x20 

2011-12-04 00:32:16 <EOI>
2011-12-04 00:32:16
2011-12-04 00:32:16 [<ffffffffa0338ecc>] ? 
acpi_idle_enter_bm+0x23c/0x274 [processor]
2011-12-04 00:32:16 [<ffffffffa0338ec5>] ? 
acpi_idle_enter_bm+0x235/0x274 [processor]
2011-12-04 00:32:16 [<ffffffff8121bfe2>] ? 
ladder_select_state+0x32/0x1f0
2011-12-04 00:32:16 [<ffffffff8121b382>] cpuidle_idle_call+0x82/0x100 

2011-12-04 00:32:16 [<ffffffff8100172f>] cpu_idle+0x5f/0xb0
2011-12-04 00:32:16 [<ffffffff8168ac50>] start_secondary+0x193/0x198
2011-12-04 00:32:16 Code:
2011-12-04 00:32:16 48
2011-12-04 00:32:16 89
2011-12-04 00:32:16 94
2011-12-04 00:32:16 01
2011-12-04 00:32:16 e8
2011-12-04 00:32:16 07
2011-12-04 00:32:16 00
2011-12-04 00:32:16 00
2011-12-04 00:32:16 41
2011-12-04 00:32:16 89
2011-12-04 00:32:16 71
2011-12-04 00:32:16 08
2011-12-04 00:32:16 0f
2011-12-04 00:32:16 1f
2011-12-04 00:32:16 80
2011-12-04 00:32:16 00
2011-12-04 00:32:16 00
2011-12-04 00:32:16 00
2011-12-04 00:32:16 00
2011-12-04 00:32:16 31
2011-12-04 00:32:16 d2
2011-12-04 00:32:16 48
2011-12-04 00:32:16 8b
2011-12-04 00:32:16 7d
2011-12-04 00:32:16 98
2011-12-04 00:32:16 4c
2011-12-04 00:32:16 8b
2011-12-04 00:32:16 8d
2011-12-04 00:32:16 b0
2011-12-04 00:32:16 fe
2011-12-04 00:32:16 ff
2011-12-04 00:32:16 ff
2011-12-04 00:32:16 48
2011-12-04 00:32:16 89
2011-12-04 00:32:16 f8
2011-12-04 00:32:16 41
2011-12-04 00:32:16 8b
2011-12-04 00:32:16 49
2011-12-04 00:32:16 08
2011-12-04 00:32:16 48
2011-12-04 00:32:16 c1
2011-12-04 00:32:16 e0
2011-12-04 00:32:16 0a
2011-12-04 00:32:16
2011-12-04 00:32:16 f7
2011-12-04 00:32:16 f1
2011-12-04 00:32:16 48
2011-12-04 00:32:16 8b
2011-12-04 00:32:16 4d
2011-12-04 00:32:16 a0
2011-12-04 00:32:16 48
2011-12-04 00:32:16 89
2011-12-04 00:32:16 45
2011-12-04 00:32:16 90
2011-12-04 00:32:16 31
2011-12-04 00:32:16 c0
2011-12-04 00:32:16 48
2011-12-04 00:32:16 85
2011-12-04 00:32:16 c9
2011-12-04 00:32:16 74
2011-12-04 00:32:16 0c
2011-12-04 00:32:16 48
2011-12-04 00:32:16 8b
2011-12-04 00:32:16 45
2011-12-04 00:32:16
2011-12-04 00:32:16 RIP
2011-12-04 00:32:16 [<ffffffff8103abb8>] find_busiest_group+0x428/0xdd0 

2011-12-04 00:32:16 RSP <ffff8800ce823bc0>
2011-12-04 00:32:16 ---[ end trace b0c5a4835e856207 ]---


Technical information of the server:
DELL PE R610
32GB RAM
2x Intel(R) Xeon(R) CPU X5650  @2.67GHz Hyper Threading
shows up to 24 Cores in /proc/cpuinfo
PERC H700 Raidcontroller
4 Broadcom 1GBit Nic's
2 Intel 10GBit Nic's

I searched the archives but I didn't find any related information.
Have you any idea what this error could be and is it fixed in kernel 3.1?

Many thanks for your help and regards
Urban Loesch
South Tyrol
