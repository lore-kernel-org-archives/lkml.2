Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965465Ab1JGLlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:41:22 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:42990 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397Ab1JGLlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:41:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYFAHXkjk5Io8UR/2dsb2JhbABEpj2CAIEFgVUBAQMSAQcBFQoxIAEqBhgHVwEECxAan3WBJgGeLIZQYQSHe5EljB8
X-IronPort-AV: E=Sophos;i="4.68,502,1312156800"; 
   d="scan'208";a="57308070"
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-puzzleid: {98FAA123-C568-4EEA-B18B-F0BEFE1A8569}
x-cr-hashedpuzzle: AUqR Ajvu BRkB CBpm CoBh ECKa EWs5 FKsZ FdzZ G7hK IAOD IEYz IO9X J2RI Ku0r Kx/n;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{98FAA123-C568-4EEA-B18B-F0BEFE1A8569};cwBiAHUAcgBuAHcAYQBsAEAAYwBpAHMAYwBvAC4AYwBvAG0A;Fri, 07 Oct 2011 11:41:05 GMT;SwBlAHIAbgBlAGwAOgAgAGwAbwB3ACAAcwB0AGEAYwBrACAAZABlAHQAZQBjAHQAZQBkACAAYgB5ACAAaQByAHEAIABoAGEAbgBkAGwAZQByAA==
Content-class: urn:content-classes:message
Subject: Kernel: low stack detected by irq handler
Date: Fri, 7 Oct 2011 17:11:05 +0530
Message-ID: <3A8C969225424C4D8E6BEE65ED8552DA05BA1C0C@XMB-BGL-41C.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel: low stack detected by irq handler
Thread-Index: AcyE5f+FYVPnrnxyTvOxAZ3je/CaSQ==
From: "Satish Burnwal (sburnwal)" <sburnwal@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 Oct 2011 11:41:14.0266 (UTC) FILETIME=[04AC7FA0:01CC84E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello experts,
I have recently moved from kernel 2.6.18-128 to 2.6.18-194. I have my
own kernel module also (click). With the new 2.6.18-194 version of
kernel, I am getting this error:

Kernel: low stack detected by irq handler

This comes once in a while during normal operation (once in 3-4 hrs).
This stack trace is printed in /var/log/messages and on the console. I
am aware this is somewhat related to my kernel module but I want to
someone to throw some light here. How I start debugging this ? Any
pointers would be helpful. I am a newcomer to kernel. Thanks in advance.
I am just looking for any pointer where someone experienced can tell me
where the issue is likely to be.

Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24e76d>]
_ZN11MacThrottle10l3PushProcEiP6Packet+0x4d/0x4a0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dce3>]
_ZN10IPRewriter13apply_patternEPN4IPRw7PatternEiRK8IPFlowIDii+0x153/0x16
0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24f998>]
_ZN11MacThrottle4pushEiP6Packet+0x108/0x1890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb284881>]
_ZN15RecycledSkbPool7recycleEP7sk_buff+0x31/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb260fdb>]
_ZN14PerfigoDiscard4pushEiP6Packet+0x4b/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb23de86>]
_ZN11HashIPTable4pushEiP6Packet+0xf6/0x2d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c05b83d4>]
__ip_route_output_key+0x782/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb249517>]
_ZN12IPPortLookup4pushEiP6Packet+0x47/0x9e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05e1648>]
fn_hash_lookup+0x5d/0x88
Oct  6 04:33:14 481fipscas kernel:  [<fb2325d4>]
_ZN10DnsHandler17is_packet_allowedEPK6Packeti+0x64/0x5e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb284849>]
_Z20skbmgr_allocate_skbsjjPi+0x29/0x30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb232bb8>]
_ZN10DnsHandler4pushEiP6Packet+0x68/0xb00 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb223a56>]
_ZN11ARPQuerier49handle_ipEP6Packet+0x6f6/0xe30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c059b077>]
sock_def_readable+0x26/0x4b
Oct  6 04:33:14 481fipscas kernel:  [<c05d4cbb>]
__udp_queue_rcv_skb+0x8/0x31
Oct  6 04:33:14 481fipscas kernel:  [<c05d639d>] udp_rcv+0x35a/0x44a
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<fb24734f>]
_ZN13IPFilterGroup4pushEiP6Packet+0x19f/0xa80 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22567b>]
_ZN11ARPQuerier44pushEiP6Packet+0x2ab/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb238492>]
_ZN13HashIPLookup34pushEiP6Packet+0x112/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24b6cf>]
_ZN15LinearIPFilter24pushEiP6Packet+0x4f/0x3f0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21d0e8>]
_ZN11ARPQuerier420handle_arp_retaggingEP6Packett+0x58/0x940 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb242344>]
_ZN14HashMACLookup54pushEiP6Packet+0x304/0x890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb228b4a>]
_ZN13ARPResponder34pushEiP6Packet+0x4a/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb218100>]
_ZN11ARPQuerier24pushEiP6Packet+0x10/0x110 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d7777>] arp_rcv+0xd0/0xe1
Oct  6 04:33:14 481fipscas kernel:  [<fb1b6934>]
_ZN6Packet19expensive_uniqueifyEiib+0x54/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<f8921061>]
tg3_start_xmit_dma_bug+0x461/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<f89212ed>]
tg3_start_xmit_dma_bug+0x6ed/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb263516>]
_ZN10Classifier4pushEiP6Packet+0x76/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2102a5>]
_ZN10FromDevice8run_taskEP4Task+0xa5/0x120 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1d1127>]
_ZN12RouterThread6driverEv+0x177/0x290 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb281822>]
_Z11click_schedPv+0x82/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2817a0>]
_Z11click_schedPv+0x0/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0404987>]
kernel_thread_helper+0x7/0x10
Oct  6 04:33:14 481fipscas kernel:  =======================
Oct  6 04:33:14 481fipscas kernel: low stack detected by irq handler
Oct  6 04:33:14 481fipscas kernel:  [<c0405e9b>] do_IRQ+0x86/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c05b66be>] rt_hash_code+0x3a/0x7f
Oct  6 04:33:14 481fipscas kernel:  [<c05b7c7e>]
__ip_route_output_key+0x2c/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb211e32>]
_ZN8FromHost5fl_txEP7sk_buffP10net_device+0xc2/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a1b23>]
dev_hard_start_xmit+0x1b4/0x25a
Oct  6 04:33:14 481fipscas kernel:  [<c05af12f>] __qdisc_run+0xd6/0x153
Oct  6 04:33:14 481fipscas kernel:  [<c05a3196>]
dev_queue_xmit+0x1f8/0x216
Oct  6 04:33:14 481fipscas kernel:  [<c05b8403>]
ip_route_output_flow+0x13/0x1d4
Oct  6 04:33:14 481fipscas kernel:  [<c05c2073>]
inet_csk_route_req+0xd7/0x14c
Oct  6 04:33:14 481fipscas kernel:  [<c05d0a7a>]
tcp_v4_syn_recv_sock+0x39/0x292
Oct  6 04:33:14 481fipscas kernel:  [<c05d2ec3>]
tcp_check_req+0x1c8/0x2a0
Oct  6 04:33:14 481fipscas kernel:  [<c05b8612>]
ip_route_input+0x43/0xbca
Oct  6 04:33:14 481fipscas kernel:  [<c05d06cd>]
tcp_v4_do_rcv+0x94/0x269
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<c0599c63>] sk_reset_timer+0xc/0x15
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24e76d>]
_ZN11MacThrottle10l3PushProcEiP6Packet+0x4d/0x4a0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dce3>]
_ZN10IPRewriter13apply_patternEPN4IPRw7PatternEiRK8IPFlowIDii+0x153/0x16
0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24f998>]
_ZN11MacThrottle4pushEiP6Packet+0x108/0x1890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb284881>]
_ZN15RecycledSkbPool7recycleEP7sk_buff+0x31/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb260fdb>]
_ZN14PerfigoDiscard4pushEiP6Packet+0x4b/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb23de86>]
_ZN11HashIPTable4pushEiP6Packet+0xf6/0x2d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c05b83d4>]
__ip_route_output_key+0x782/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb249517>]
_ZN12IPPortLookup4pushEiP6Packet+0x47/0x9e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05e1648>]
fn_hash_lookup+0x5d/0x88
Oct  6 04:33:14 481fipscas kernel:  [<fb2325d4>]
_ZN10DnsHandler17is_packet_allowedEPK6Packeti+0x64/0x5e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb284849>]
_Z20skbmgr_allocate_skbsjjPi+0x29/0x30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb232bb8>]
_ZN10DnsHandler4pushEiP6Packet+0x68/0xb00 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb223a56>]
_ZN11ARPQuerier49handle_ipEP6Packet+0x6f6/0xe30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c059b077>]
sock_def_readable+0x26/0x4b
Oct  6 04:33:14 481fipscas kernel:  [<c05d4cbb>]
__udp_queue_rcv_skb+0x8/0x31
Oct  6 04:33:14 481fipscas kernel:  [<c05d639d>] udp_rcv+0x35a/0x44a
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<fb24734f>]
_ZN13IPFilterGroup4pushEiP6Packet+0x19f/0xa80 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22567b>]
_ZN11ARPQuerier44pushEiP6Packet+0x2ab/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb238492>]
_ZN13HashIPLookup34pushEiP6Packet+0x112/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24b6cf>]
_ZN15LinearIPFilter24pushEiP6Packet+0x4f/0x3f0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21d0e8>]
_ZN11ARPQuerier420handle_arp_retaggingEP6Packett+0x58/0x940 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb242344>]
_ZN14HashMACLookup54pushEiP6Packet+0x304/0x890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb228b4a>]
_ZN13ARPResponder34pushEiP6Packet+0x4a/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb218100>]
_ZN11ARPQuerier24pushEiP6Packet+0x10/0x110 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d7777>] arp_rcv+0xd0/0xe1
Oct  6 04:33:14 481fipscas kernel:  [<fb1b6934>]
_ZN6Packet19expensive_uniqueifyEiib+0x54/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<f8921061>]
tg3_start_xmit_dma_bug+0x461/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<f89212ed>]
tg3_start_xmit_dma_bug+0x6ed/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb263516>]
_ZN10Classifier4pushEiP6Packet+0x76/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2102a5>]
_ZN10FromDevice8run_taskEP4Task+0xa5/0x120 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1d1127>]
_ZN12RouterThread6driverEv+0x177/0x290 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb281822>]
_Z11click_schedPv+0x82/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2817a0>]
_Z11click_schedPv+0x0/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0404987>]
kernel_thread_helper+0x7/0x10
Oct  6 04:33:14 481fipscas kernel:  =======================
Oct  6 04:33:14 481fipscas kernel: low stack detected by irq handler
Oct  6 04:33:14 481fipscas kernel:  [<c0405e9b>] do_IRQ+0x86/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c05b66be>] rt_hash_code+0x3a/0x7f
Oct  6 04:33:14 481fipscas kernel:  [<c05b7c7e>]
__ip_route_output_key+0x2c/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb211e32>]
_ZN8FromHost5fl_txEP7sk_buffP10net_device+0xc2/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a1b23>]
dev_hard_start_xmit+0x1b4/0x25a
Oct  6 04:33:14 481fipscas kernel:  [<c05af12f>] __qdisc_run+0xd6/0x153
Oct  6 04:33:14 481fipscas kernel:  [<c05a3196>]
dev_queue_xmit+0x1f8/0x216
Oct  6 04:33:14 481fipscas kernel:  [<c05b8403>]
ip_route_output_flow+0x13/0x1d4
Oct  6 04:33:14 481fipscas kernel:  [<c05c2073>]
inet_csk_route_req+0xd7/0x14c
Oct  6 04:33:14 481fipscas kernel:  [<c05d0a7a>]
tcp_v4_syn_recv_sock+0x39/0x292
Oct  6 04:33:14 481fipscas kernel:  [<c05d2ec3>]
tcp_check_req+0x1c8/0x2a0
Oct  6 04:33:14 481fipscas kernel:  [<c05b8612>]
ip_route_input+0x43/0xbca
Oct  6 04:33:14 481fipscas kernel:  [<c05d06cd>]
tcp_v4_do_rcv+0x94/0x269
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<c0599c63>] sk_reset_timer+0xc/0x15
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24e76d>]
_ZN11MacThrottle10l3PushProcEiP6Packet+0x4d/0x4a0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dce3>]
_ZN10IPRewriter13apply_patternEPN4IPRw7PatternEiRK8IPFlowIDii+0x153/0x16
0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24f998>]
_ZN11MacThrottle4pushEiP6Packet+0x108/0x1890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb284881>]
_ZN15RecycledSkbPool7recycleEP7sk_buff+0x31/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb260fdb>]
_ZN14PerfigoDiscard4pushEiP6Packet+0x4b/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb23de86>]
_ZN11HashIPTable4pushEiP6Packet+0xf6/0x2d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c05b83d4>]
__ip_route_output_key+0x782/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb249517>]
_ZN12IPPortLookup4pushEiP6Packet+0x47/0x9e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05e1648>]
fn_hash_lookup+0x5d/0x88
Oct  6 04:33:14 481fipscas kernel:  [<fb2325d4>]
_ZN10DnsHandler17is_packet_allowedEPK6Packeti+0x64/0x5e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb284849>]
_Z20skbmgr_allocate_skbsjjPi+0x29/0x30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb232bb8>]
_ZN10DnsHandler4pushEiP6Packet+0x68/0xb00 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb223a56>]
_ZN11ARPQuerier49handle_ipEP6Packet+0x6f6/0xe30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c059b077>]
sock_def_readable+0x26/0x4b
Oct  6 04:33:14 481fipscas kernel:  [<c05d4cbb>]
__udp_queue_rcv_skb+0x8/0x31
Oct  6 04:33:14 481fipscas kernel:  [<c05d639d>] udp_rcv+0x35a/0x44a
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<fb24734f>]
_ZN13IPFilterGroup4pushEiP6Packet+0x19f/0xa80 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22567b>]
_ZN11ARPQuerier44pushEiP6Packet+0x2ab/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb238492>]
_ZN13HashIPLookup34pushEiP6Packet+0x112/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24b6cf>]
_ZN15LinearIPFilter24pushEiP6Packet+0x4f/0x3f0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21d0e8>]
_ZN11ARPQuerier420handle_arp_retaggingEP6Packett+0x58/0x940 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb242344>]
_ZN14HashMACLookup54pushEiP6Packet+0x304/0x890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb228b4a>]
_ZN13ARPResponder34pushEiP6Packet+0x4a/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb218100>]
_ZN11ARPQuerier24pushEiP6Packet+0x10/0x110 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d7777>] arp_rcv+0xd0/0xe1
Oct  6 04:33:14 481fipscas kernel:  [<fb1b6934>]
_ZN6Packet19expensive_uniqueifyEiib+0x54/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<f8921061>]
tg3_start_xmit_dma_bug+0x461/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<f89212ed>]
tg3_start_xmit_dma_bug+0x6ed/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb263516>]
_ZN10Classifier4pushEiP6Packet+0x76/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2102a5>]
_ZN10FromDevice8run_taskEP4Task+0xa5/0x120 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1d1127>]
_ZN12RouterThread6driverEv+0x177/0x290 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb281822>]
_Z11click_schedPv+0x82/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2817a0>]
_Z11click_schedPv+0x0/0x130 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0404987>]
kernel_thread_helper+0x7/0x10
Oct  6 04:33:14 481fipscas kernel:  =======================
Oct  6 04:33:14 481fipscas kernel: low stack detected by irq handler
Oct  6 04:33:14 481fipscas kernel:  [<c0405e9b>] do_IRQ+0x86/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:14 481fipscas kernel:  [<c05b66be>] rt_hash_code+0x3a/0x7f
Oct  6 04:33:14 481fipscas kernel:  [<c05b7c7e>]
__ip_route_output_key+0x2c/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb211e32>]
_ZN8FromHost5fl_txEP7sk_buffP10net_device+0xc2/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a1b23>]
dev_hard_start_xmit+0x1b4/0x25a
Oct  6 04:33:14 481fipscas kernel:  [<c05af12f>] __qdisc_run+0xd6/0x153
Oct  6 04:33:14 481fipscas kernel:  [<c05a3196>]
dev_queue_xmit+0x1f8/0x216
Oct  6 04:33:14 481fipscas kernel:  [<c05b8403>]
ip_route_output_flow+0x13/0x1d4
Oct  6 04:33:14 481fipscas kernel:  [<c05c2073>]
inet_csk_route_req+0xd7/0x14c
Oct  6 04:33:14 481fipscas kernel:  [<c05d0a7a>]
tcp_v4_syn_recv_sock+0x39/0x292
Oct  6 04:33:14 481fipscas kernel:  [<c05d2ec3>]
tcp_check_req+0x1c8/0x2a0
Oct  6 04:33:14 481fipscas kernel:  [<c05b8612>]
ip_route_input+0x43/0xbca
Oct  6 04:33:14 481fipscas kernel:  [<c05d06cd>]
tcp_v4_do_rcv+0x94/0x269
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<c0599c63>] sk_reset_timer+0xc/0x15
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24e76d>]
_ZN11MacThrottle10l3PushProcEiP6Packet+0x4d/0x4a0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dce3>]
_ZN10IPRewriter13apply_patternEPN4IPRw7PatternEiRK8IPFlowIDii+0x153/0x16
0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24f998>]
_ZN11MacThrottle4pushEiP6Packet+0x108/0x1890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb284881>]
_ZN15RecycledSkbPool7recycleEP7sk_buff+0x31/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb260fdb>]
_ZN14PerfigoDiscard4pushEiP6Packet+0x4b/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:14 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:14 481fipscas kernel:  [<fb23de86>]
_ZN11HashIPTable4pushEiP6Packet+0xf6/0x2d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:14 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:14 481fipscas kernel:  [<c05b83d4>]
__ip_route_output_key+0x782/0x79e
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb249517>]
_ZN12IPPortLookup4pushEiP6Packet+0x47/0x9e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05e1648>]
fn_hash_lookup+0x5d/0x88
Oct  6 04:33:14 481fipscas kernel:  [<fb2325d4>]
_ZN10DnsHandler17is_packet_allowedEPK6Packeti+0x64/0x5e0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb284849>]
_Z20skbmgr_allocate_skbsjjPi+0x29/0x30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb232bb8>]
_ZN10DnsHandler4pushEiP6Packet+0x68/0xb00 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb223a56>]
_ZN11ARPQuerier49handle_ipEP6Packet+0x6f6/0xe30 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c059b077>]
sock_def_readable+0x26/0x4b
Oct  6 04:33:14 481fipscas kernel:  [<c05d4cbb>]
__udp_queue_rcv_skb+0x8/0x31
Oct  6 04:33:14 481fipscas kernel:  [<c05d639d>] udp_rcv+0x35a/0x44a
Oct  6 04:33:14 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:14 481fipscas kernel:  [<fb24734f>]
_ZN13IPFilterGroup4pushEiP6Packet+0x19f/0xa80 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb22567b>]
_ZN11ARPQuerier44pushEiP6Packet+0x2ab/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb238492>]
_ZN13HashIPLookup34pushEiP6Packet+0x112/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb24b6cf>]
_ZN15LinearIPFilter24pushEiP6Packet+0x4f/0x3f0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb21d0e8>]
_ZN11ARPQuerier420handle_arp_retaggingEP6Packett+0x58/0x940 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb242344>]
_ZN14HashMACLookup54pushEiP6Packet+0x304/0x890 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb228b4a>]
_ZN13ARPResponder34pushEiP6Packet+0x4a/0x100 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:14 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb218100>]
_ZN11ARPQuerier24pushEiP6Packet+0x10/0x110 [click]
Oct  6 04:33:14 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:14 481fipscas kernel:  [<c05d7777>] arp_rcv+0xd0/0xe1
Oct  6 04:33:14 481fipscas kernel:  [<fb1b6934>]
_ZN6Packet19expensive_uniqueifyEiib+0x54/0x1c0 [click]
Oct  6 04:33:14 481fipscas kernel:  [<f8921061>]
tg3_start_xmit_dma_bug+0x461/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<f89212ed>]
tg3_start_xmit_dma_bug+0x6ed/0x77f [tg3]
Oct  6 04:33:14 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:15 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:15 481fipscas kernel:  [<fb263516>]
_ZN10Classifier4pushEiP6Packet+0x76/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2102a5>]
_ZN10FromDevice8run_taskEP4Task+0xa5/0x120 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1d1127>]
_ZN12RouterThread6driverEv+0x177/0x290 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb281822>]
_Z11click_schedPv+0x82/0x130 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2817a0>]
_Z11click_schedPv+0x0/0x130 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c0404987>]
kernel_thread_helper+0x7/0x10
Oct  6 04:33:15 481fipscas kernel:  =======================
Oct  6 04:33:15 481fipscas kernel: low stack detected by irq handler
Oct  6 04:33:15 481fipscas kernel:  [<c0405e9b>] do_IRQ+0x86/0xc3
Oct  6 04:33:15 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:15 481fipscas kernel:  [<c05b66be>] rt_hash_code+0x3a/0x7f
Oct  6 04:33:15 481fipscas kernel:  [<c05b7c7e>]
__ip_route_output_key+0x2c/0x79e
Oct  6 04:33:15 481fipscas kernel:  [<fb211e32>]
_ZN8FromHost5fl_txEP7sk_buffP10net_device+0xc2/0x100 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05a1b23>]
dev_hard_start_xmit+0x1b4/0x25a
Oct  6 04:33:15 481fipscas kernel:  [<c05af12f>] __qdisc_run+0xd6/0x153
Oct  6 04:33:15 481fipscas kernel:  [<c05a3196>]
dev_queue_xmit+0x1f8/0x216
Oct  6 04:33:15 481fipscas kernel:  [<c05b8403>]
ip_route_output_flow+0x13/0x1d4
Oct  6 04:33:15 481fipscas kernel:  [<c05c2073>]
inet_csk_route_req+0xd7/0x14c
Oct  6 04:33:15 481fipscas kernel:  [<c05d0a7a>]
tcp_v4_syn_recv_sock+0x39/0x292
Oct  6 04:33:15 481fipscas kernel:  [<c05d2ec3>]
tcp_check_req+0x1c8/0x2a0
Oct  6 04:33:15 481fipscas kernel:  [<c05b8612>]
ip_route_input+0x43/0xbca
Oct  6 04:33:15 481fipscas kernel:  [<c05d06cd>]
tcp_v4_do_rcv+0x94/0x269
Oct  6 04:33:15 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:15 481fipscas kernel:  [<c0599c63>] sk_reset_timer+0xc/0x15
Oct  6 04:33:15 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:15 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:15 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:15 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05d28cb>] tcp_v4_rcv+0x7f7/0x848
Oct  6 04:33:15 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:15 481fipscas kernel:  [<c05baff2>] ip_rcv+0x3cb/0x3f5
Oct  6 04:33:15 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:15 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb24e76d>]
_ZN11MacThrottle10l3PushProcEiP6Packet+0x4d/0x4a0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb27dce3>]
_ZN10IPRewriter13apply_patternEPN4IPRw7PatternEiRK8IPFlowIDii+0x153/0x16
0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb27dd9e>]
_ZN10IPRewriter4pushEiP6Packet+0xae/0x260 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb24f998>]
_ZN11MacThrottle4pushEiP6Packet+0x108/0x1890 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:15 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:15 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:15 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:15 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:15 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:15 481fipscas kernel:  [<fb284881>]
_ZN15RecycledSkbPool7recycleEP7sk_buff+0x31/0xf0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb260fdb>]
_ZN14PerfigoDiscard4pushEiP6Packet+0x4b/0x1c0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c0411f41>]
smp_apic_timer_interrupt+0x32/0x45
Oct  6 04:33:15 481fipscas kernel:  [<c040470b>]
apic_timer_interrupt+0x1f/0x24
Oct  6 04:33:15 481fipscas kernel:  [<fb23de86>]
_ZN11HashIPTable4pushEiP6Packet+0xf6/0x2d0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c043f334>] __do_IRQ+0x0/0x9f
Oct  6 04:33:15 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:15 481fipscas kernel:  [<c05b83d4>]
__ip_route_output_key+0x782/0x79e
Oct  6 04:33:15 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb249517>]
_ZN12IPPortLookup4pushEiP6Packet+0x47/0x9e0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05e1648>]
fn_hash_lookup+0x5d/0x88
Oct  6 04:33:15 481fipscas kernel:  [<fb2325d4>]
_ZN10DnsHandler17is_packet_allowedEPK6Packeti+0x64/0x5e0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb22b9d8>]
_ZN8BWShaper4pushEiP6Packet+0x58/0xe90 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb284849>]
_Z20skbmgr_allocate_skbsjjPi+0x29/0x30 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb232bb8>]
_ZN10DnsHandler4pushEiP6Packet+0x68/0xb00 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:15 481fipscas kernel:  [<fb223a56>]
_ZN11ARPQuerier49handle_ipEP6Packet+0x6f6/0xe30 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c059b077>]
sock_def_readable+0x26/0x4b
Oct  6 04:33:15 481fipscas kernel:  [<c05d4cbb>]
__udp_queue_rcv_skb+0x8/0x31
Oct  6 04:33:15 481fipscas kernel:  [<c05d639d>] udp_rcv+0x35a/0x44a
Oct  6 04:33:15 481fipscas kernel:  [<c05bb173>]
ip_local_deliver+0x157/0x1d0
Oct  6 04:33:15 481fipscas kernel:  [<fb24734f>]
_ZN13IPFilterGroup4pushEiP6Packet+0x19f/0xa80 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb22567b>]
_ZN11ARPQuerier44pushEiP6Packet+0x2ab/0x2370 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb21621e>]
_ZN6ToHost4pushEiP6Packet+0xee/0x210 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb238492>]
_ZN13HashIPLookup34pushEiP6Packet+0x112/0x1c0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb24b6cf>]
_ZN15LinearIPFilter24pushEiP6Packet+0x4f/0x3f0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb21d0e8>]
_ZN11ARPQuerier420handle_arp_retaggingEP6Packett+0x58/0x940 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb242344>]
_ZN14HashMACLookup54pushEiP6Packet+0x304/0x890 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26079e>]
_ZN6Passer4pushEiP6Packet+0x12e/0x860 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c0417f22>] enqueue_task+0x29/0x39
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2061d1>]
_ZN14LinearIPLookup4pushEiP6Packet+0x71/0x100 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb253075>]
_ZN17NtlmLoginDetector4pushEiP6Packet+0x65/0x15d0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb228b4a>]
_ZN13ARPResponder34pushEiP6Packet+0x4a/0x100 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb26c674>]
_ZN11PaintSwitch4pushEiP6Packet+0x44/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1f7904>]
_ZN8IPFilter4pushEiP6Packet+0x64/0xf0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb225895>]
_ZN11ARPQuerier44pushEiP6Packet+0x4c5/0x2370 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05a141d>]
__netif_receive_skb+0x3b3/0x3d5
Oct  6 04:33:15 481fipscas kernel:  [<fb23385d>]
_ZN12EnsureEther24pushEiP6Packet+0x1d/0x20 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb218100>]
_ZN11ARPQuerier24pushEiP6Packet+0x10/0x110 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb23c62e>]
_ZN12HashIPTable24pushEiP6Packet+0x18e/0x580 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c05d7777>] arp_rcv+0xd0/0xe1
Oct  6 04:33:15 481fipscas kernel:  [<fb1b6934>]
_ZN6Packet19expensive_uniqueifyEiib+0x54/0x1c0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<f8921061>]
tg3_start_xmit_dma_bug+0x461/0x77f [tg3]
Oct  6 04:33:15 481fipscas kernel:  [<f89212ed>]
tg3_start_xmit_dma_bug+0x6ed/0x77f [tg3]
Oct  6 04:33:15 481fipscas kernel:  [<c04046e6>]
common_interrupt+0x1a/0x20
Oct  6 04:33:15 481fipscas kernel:  [<c0405ecc>] do_IRQ+0xb7/0xc3
Oct  6 04:33:15 481fipscas kernel:  [<fb263516>]
_ZN10Classifier4pushEiP6Packet+0x76/0xe0 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1ba806>]
_ZN7Element4pushEiP6Packet+0x26/0x40 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2102a5>]
_ZN10FromDevice8run_taskEP4Task+0xa5/0x120 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb1d1127>]
_ZN12RouterThread6driverEv+0x177/0x290 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb281822>]
_Z11click_schedPv+0x82/0x130 [click]
Oct  6 04:33:15 481fipscas kernel:  [<fb2817a0>]
_Z11click_schedPv+0x0/0x130 [click]
Oct  6 04:33:15 481fipscas kernel:  [<c0404987>]
kernel_thread_helper+0x7/0x10



