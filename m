Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0GMDpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:45:16 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:43750 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598Ab0GMDpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:45:14 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2010 23:45:14 EDT
Message-ID: <4C3BE00D.40907@tlinx.org>
Date: Mon, 12 Jul 2010 20:39:57 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING: at net/ipv4/tcp_input.c:2964 tcp_ack+0x104f/0x22d0()
X-Stationery: 0.5.1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone know what this might be warning me of?

The line involved:



unpatched 2.6.34


==> warn <==
Jul 12 20:06:29 Ishtar kernel: [55475.419285] ------------[ cut here 
]------------
Jul 12 20:06:29 Ishtar kernel: [55475.419297] WARNING: at 
net/ipv4/tcp_input.c:2964 tcp_ack+0x104f/0x22d0()
Jul 12 20:06:29 Ishtar kernel: [55475.419300] Hardware name: PowerEdge T610
Jul 12 20:06:29 Ishtar kernel: [55475.419302] Modules linked in: 
iptable_filter ip6t_REJECT ip6t_LOG nf_conntrack_ipv6 ip6table_raw 
xt_NOTRACK xt_limit iptable_raw ip6table_filter ip6_tables xt_state 
[last unloaded: kvm]
Jul 12 20:06:29 Ishtar kernel: [55475.419321] Pid: 0, comm: swapper Not 
tainted 2.6.34T610-Vanilla-1 #1
Jul 12 20:06:29 Ishtar kernel: [55475.419324] Call Trace:
Jul 12 20:06:29 Ishtar kernel: [55475.419327]  <IRQ>  
[<ffffffff81047feb>] warn_slowpath_common+0x7b/0xc0
Jul 12 20:06:29 Ishtar kernel: [55475.419340]  [<ffffffff81048044>] 
warn_slowpath_null+0x14/0x20
Jul 12 20:06:29 Ishtar kernel: [55475.419344]  [<ffffffff815077bf>] 
tcp_ack+0x104f/0x22d0
Jul 12 20:06:29 Ishtar kernel: [55475.419350]  [<ffffffff815096a8>] 
tcp_rcv_established+0x578/0xaa0
Jul 12 20:06:29 Ishtar kernel: [55475.419357]  [<ffffffff815115ad>] 
tcp_v4_do_rcv+0xcd/0x220
Jul 12 20:06:29 Ishtar kernel: [55475.419364]  [<ffffffff815c2cde>] ? 
_raw_spin_lock_nested+0x4e/0x60
Jul 12 20:06:29 Ishtar kernel: [55475.419369]  [<ffffffff81511c9e>] 
tcp_v4_rcv+0x59e/0x870
Jul 12 20:06:29 Ishtar kernel: [55475.419374]  [<ffffffff814f12b0>] ? 
ip_local_deliver_finish+0x0/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419379]  [<ffffffff814f1398>] 
ip_local_deliver_finish+0xe8/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419383]  [<ffffffff814f12eb>] ? 
ip_local_deliver_finish+0x3b/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419388]  [<ffffffff814f15b0>] 
ip_local_deliver+0x90/0xa0
Jul 12 20:06:29 Ishtar kernel: [55475.419392]  [<ffffffff814f0c9d>] 
ip_rcv_finish+0xfd/0x430
Jul 12 20:06:29 Ishtar kernel: [55475.419397]  [<ffffffff814f11ed>] 
ip_rcv+0x21d/0x2e0
Jul 12 20:06:29 Ishtar kernel: [55475.419404]  [<ffffffff814b3d63>] 
netif_receive_skb+0x3c3/0x6c0
Jul 12 20:06:29 Ishtar kernel: [55475.419408]  [<ffffffff814b3b00>] ? 
netif_receive_skb+0x160/0x6c0
Jul 12 20:06:29 Ishtar kernel: [55475.419414]  [<ffffffff814b4be0>] 
napi_skb_finish+0x50/0x70
Jul 12 20:06:29 Ishtar kernel: [55475.419418]  [<ffffffff814b4c39>] 
napi_gro_receive+0x39/0x50
Jul 12 20:06:29 Ishtar kernel: [55475.419426]  [<ffffffff813ce93b>] 
e1000_receive_skb+0x5b/0x90
Jul 12 20:06:29 Ishtar kernel: [55475.419430]  [<ffffffff813cec07>] 
e1000_clean_rx_irq+0x297/0x450
Jul 12 20:06:29 Ishtar kernel: [55475.419436]  [<ffffffff813d0bae>] 
e1000_clean+0x7e/0x280
Jul 12 20:06:29 Ishtar kernel: [55475.419440]  [<ffffffff814b44d0>] 
net_rx_action+0x190/0x320
Jul 12 20:06:29 Ishtar kernel: [55475.419445]  [<ffffffff814b4447>] ? 
net_rx_action+0x107/0x320
Jul 12 20:06:29 Ishtar kernel: [55475.419450]  [<ffffffff81042ba7>] ? 
scheduler_tick+0x47/0x290
Jul 12 20:06:29 Ishtar kernel: [55475.419457]  [<ffffffff8104f444>] 
__do_softirq+0x114/0x2c0
Jul 12 20:06:29 Ishtar kernel: [55475.419462]  [<ffffffff81003f0c>] 
call_softirq+0x1c/0x30
Jul 12 20:06:29 Ishtar kernel: [55475.419467]  [<ffffffff8100615d>] 
do_softirq+0x7d/0xb0
Jul 12 20:06:29 Ishtar kernel: [55475.419471]  [<ffffffff8104eec5>] 
irq_exit+0x95/0xa0
Jul 12 20:06:29 Ishtar kernel: [55475.419476]  [<ffffffff815c432c>] 
do_IRQ+0x7c/0xf0
Jul 12 20:06:29 Ishtar kernel: [55475.419480]  [<ffffffff815c3c13>] 
ret_from_intr+0x0/0xf
Jul 12 20:06:29 Ishtar kernel: [55475.419483]  <EOI>  
[<ffffffff8106f220>] ? __atomic_notifier_call_chain+0x0/0xd0
Jul 12 20:06:29 Ishtar kernel: [55475.419496]  [<ffffffff8100c39e>] ? 
mwait_idle+0x7e/0x100
Jul 12 20:06:29 Ishtar kernel: [55475.419500]  [<ffffffff8100c395>] ? 
mwait_idle+0x75/0x100
Jul 12 20:06:29 Ishtar kernel: [55475.419505]  [<ffffffff81001fa6>] 
cpu_idle+0x66/0xd0
Jul 12 20:06:29 Ishtar kernel: [55475.419510]  [<ffffffff815bc677>] 
start_secondary+0x1c3/0x1c8
Jul 12 20:06:29 Ishtar kernel: [55475.419514] ---[ end trace 
93de9c3e786d82ea ]---

==> messages <==
Jul 12 20:06:29 Ishtar kernel: [55475.419285] ------------[ cut here 
]------------
Jul 12 20:06:29 Ishtar kernel: [55475.419297] WARNING: at 
net/ipv4/tcp_input.c:2964 tcp_ack+0x104f/0x22d0()
Jul 12 20:06:29 Ishtar kernel: [55475.419300] Hardware name: PowerEdge T610
Jul 12 20:06:29 Ishtar kernel: [55475.419302] Modules linked in: 
iptable_filter ip6t_REJECT ip6t_LOG nf_conntrack_ipv6 ip6table_raw 
xt_NOTRACK xt_limit iptable_raw ip6table_filter ip6_tables xt_state 
[last unloaded: kvm]
Jul 12 20:06:29 Ishtar kernel: [55475.419321] Pid: 0, comm: swapper Not 
tainted 2.6.34T610-Vanilla-1 #1
Jul 12 20:06:29 Ishtar kernel: [55475.419324] Call Trace:
Jul 12 20:06:29 Ishtar kernel: [55475.419327]  <IRQ>  
[<ffffffff81047feb>] warn_slowpath_common+0x7b/0xc0
Jul 12 20:06:29 Ishtar kernel: [55475.419340]  [<ffffffff81048044>] 
warn_slowpath_null+0x14/0x20
Jul 12 20:06:29 Ishtar kernel: [55475.419344]  [<ffffffff815077bf>] 
tcp_ack+0x104f/0x22d0
Jul 12 20:06:29 Ishtar kernel: [55475.419350]  [<ffffffff815096a8>] 
tcp_rcv_established+0x578/0xaa0
Jul 12 20:06:29 Ishtar kernel: [55475.419357]  [<ffffffff815115ad>] 
tcp_v4_do_rcv+0xcd/0x220
Jul 12 20:06:29 Ishtar kernel: [55475.419364]  [<ffffffff815c2cde>] ? 
_raw_spin_lock_nested+0x4e/0x60
Jul 12 20:06:29 Ishtar kernel: [55475.419369]  [<ffffffff81511c9e>] 
tcp_v4_rcv+0x59e/0x870
Jul 12 20:06:29 Ishtar kernel: [55475.419374]  [<ffffffff814f12b0>] ? 
ip_local_deliver_finish+0x0/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419379]  [<ffffffff814f1398>] 
ip_local_deliver_finish+0xe8/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419383]  [<ffffffff814f12eb>] ? 
ip_local_deliver_finish+0x3b/0x270
Jul 12 20:06:29 Ishtar kernel: [55475.419388]  [<ffffffff814f15b0>] 
ip_local_deliver+0x90/0xa0
Jul 12 20:06:29 Ishtar kernel: [55475.419392]  [<ffffffff814f0c9d>] 
ip_rcv_finish+0xfd/0x430
Jul 12 20:06:29 Ishtar kernel: [55475.419397]  [<ffffffff814f11ed>] 
ip_rcv+0x21d/0x2e0
Jul 12 20:06:29 Ishtar kernel: [55475.419404]  [<ffffffff814b3d63>] 
netif_receive_skb+0x3c3/0x6c0
Jul 12 20:06:29 Ishtar kernel: [55475.419408]  [<ffffffff814b3b00>] ? 
netif_receive_skb+0x160/0x6c0
Jul 12 20:06:29 Ishtar kernel: [55475.419414]  [<ffffffff814b4be0>] 
napi_skb_finish+0x50/0x70
Jul 12 20:06:29 Ishtar kernel: [55475.419418]  [<ffffffff814b4c39>] 
napi_gro_receive+0x39/0x50
Jul 12 20:06:29 Ishtar kernel: [55475.419426]  [<ffffffff813ce93b>] 
e1000_receive_skb+0x5b/0x90
Jul 12 20:06:29 Ishtar kernel: [55475.419430]  [<ffffffff813cec07>] 
e1000_clean_rx_irq+0x297/0x450
Jul 12 20:06:29 Ishtar kernel: [55475.419436]  [<ffffffff813d0bae>] 
e1000_clean+0x7e/0x280
Jul 12 20:06:29 Ishtar kernel: [55475.419440]  [<ffffffff814b44d0>] 
net_rx_action+0x190/0x320
Jul 12 20:06:29 Ishtar kernel: [55475.419445]  [<ffffffff814b4447>] ? 
net_rx_action+0x107/0x320
Jul 12 20:06:29 Ishtar kernel: [55475.419450]  [<ffffffff81042ba7>] ? 
scheduler_tick+0x47/0x290
Jul 12 20:06:29 Ishtar kernel: [55475.419457]  [<ffffffff8104f444>] 
__do_softirq+0x114/0x2c0
Jul 12 20:06:29 Ishtar kernel: [55475.419462]  [<ffffffff81003f0c>] 
call_softirq+0x1c/0x30
Jul 12 20:06:29 Ishtar kernel: [55475.419467]  [<ffffffff8100615d>] 
do_softirq+0x7d/0xb0
Jul 12 20:06:29 Ishtar kernel: [55475.419471]  [<ffffffff8104eec5>] 
irq_exit+0x95/0xa0
Jul 12 20:06:29 Ishtar kernel: [55475.419476]  [<ffffffff815c432c>] 
do_IRQ+0x7c/0xf0
Jul 12 20:06:29 Ishtar kernel: [55475.419480]  [<ffffffff815c3c13>] 
ret_from_intr+0x0/0xf
Jul 12 20:06:29 Ishtar kernel: [55475.419483]  <EOI>  
[<ffffffff8106f220>] ? __atomic_notifier_call_chain+0x0/0xd0
Jul 12 20:06:29 Ishtar kernel: [55475.419496]  [<ffffffff8100c39e>] ? 
mwait_idle+0x7e/0x100
Jul 12 20:06:29 Ishtar kernel: [55475.419500]  [<ffffffff8100c395>] ? 
mwait_idle+0x75/0x100
Jul 12 20:06:29 Ishtar kernel: [55475.419505]  [<ffffffff81001fa6>] 
cpu_idle+0x66/0xd0
Jul 12 20:06:29 Ishtar kernel: [55475.419510]  [<ffffffff815bc677>] 
start_secondary+0x1c3/0x1c8
Jul 12 20:06:29 Ishtar kernel: [55475.419514] ---[ end trace 
93de9c3e786d82ea ]---
Jul 12 20:07:01 Ishtar /usr/sbin/cron[8345]: (law) CMD 
(/home/law/scripts/process_despam 2>&1 >/dev/null)
