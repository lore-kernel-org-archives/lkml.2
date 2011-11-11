Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab1KKSdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:33:40 -0500
Received: from server655-han.de-nserver.de ([85.158.177.45]:58320 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928Ab1KKSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:33:39 -0500
Message-ID: <4EBD6A81.3070307@profihost.ag>
Date: Fri, 11 Nov 2011 19:33:37 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: 3.0.8 hard LOCKUP WARNING: at arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x59/0x60()
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i've seen this error several times using Linux Kernel 3.0.8. Anybody any 
ideas?

2011-11-10 18:46:22     Kernel panic - not syncing: Watchdog detected 
hard LOCKUP on cpu 6
2011-11-10 18:46:22     Pid: 0, comm: kworker/0:1 Not tainted 
2.6.40.8intel #1
2011-11-10 18:46:22     Call Trace:
2011-11-10 18:46:22     <NMI> [<ffffffff815d4a88>] panic+0xba/0x1e5
2011-11-10 18:46:22     [<ffffffff810895f1>] 
watchdog_overflow_callback+0xb1/0xc0
2011-11-10 18:46:22     [<ffffffff810b21f1>] 
__perf_event_overflow+0xb1/0x250
2011-11-10 18:46:22     [<ffffffff810b27b4>] perf_event_overflow+0x14/0x20
2011-11-10 18:46:22     [<ffffffff81014b87>] 
intel_pmu_handle_irq+0x217/0x450
2011-11-10 18:46:22     [<ffffffff81010d36>] 
perf_event_nmi_handler+0x36/0xb0
2011-11-10 18:46:22     [<ffffffff8106bebf>] notifier_call_chain+0x3f/0x80
2011-11-10 18:46:22     [<ffffffff8106bf25>] 
atomic_notifier_call_chain+0x15/0x20
2011-11-10 18:46:22     [<ffffffff8106c01e>] notify_die+0x2e/0x30
2011-11-10 18:46:22     [<ffffffff81003ba2>] do_nmi+0xa2/0x240
2011-11-10 18:46:22     [<ffffffff815d837a>] nmi+0x1a/0x20
2011-11-10 18:46:22     [<ffffffff810c133d>] ? put_compound_page+0xcd/0x170
2011-11-10 18:46:22     <<EOE>> <IRQ> [<ffffffff810c1415>] 
put_page+0x35/0x40
2011-11-10 18:46:22     [<ffffffff8150902b>] skb_release_data+0xab/0xd0
2011-11-10 18:46:22     [<ffffffff81508ae9>] __kfree_skb+0x19/0xa0
2011-11-10 18:46:22     [<ffffffff81508bcd>] consume_skb+0x5d/0x80
2011-11-10 18:46:22     [<ffffffff815139c5>] dev_kfree_skb_any+0x35/0x40
2011-11-10 18:46:22     [<ffffffff8144ee42>] e1000_put_txbuf+0x62/0x90
2011-11-10 18:46:22     [<ffffffff8144ef34>] e1000_clean_tx_irq+0xc4/0x2c0
2011-11-10 18:46:22     [<ffffffff81451fa9>] e1000_clean+0x69/0x2f0
2011-11-10 18:46:22     [<ffffffff8151848a>] net_rx_action+0x10a/0x2b0
2011-11-10 18:46:22     [<ffffffff8104c390>] __do_softirq+0xd0/0x1c0
2011-11-10 18:46:22     [<ffffffff815d968c>] call_softirq+0x1c/0x30
2011-11-10 18:46:22     [<ffffffff810047b5>] do_softirq+0x55/0x90
2011-11-10 18:46:22     [<ffffffff8104c16d>] irq_exit+0xad/0xe0
2011-11-10 18:46:22     [<ffffffff81003f94>] do_IRQ+0x64/0xe0
2011-11-10 18:46:22     [<ffffffff815d7f13>] common_interrupt+0x13/0x13
2011-11-10 18:46:22     <EOI> [<ffffffff8100b0f7>] ? mwait_idle+0x117/0x120
2011-11-10 18:46:22     [<ffffffff8106bf25>] ? 
atomic_notifier_call_chain+0x15/0x20
2011-11-10 18:46:22     [<ffffffff81002091>] cpu_idle+0xb1/0x110
2011-11-10 18:46:22     [<ffffffff81b0d8ba>] start_secondary+0x201/0x297
2011-11-10 18:46:22     ------------[ cut here ]------------
2011-11-10 18:46:22     WARNING: at arch/x86/kernel/smp.c:118 
native_smp_send_reschedule+0x59/0x60()
2011-11-10 18:46:22     Hardware name: X7DVL
2011-11-10 18:46:22     Modules linked in: drbd xt_tcpudp ipt_REJECT 
iptable_filter ip_tables x_tables coretemp k8temp ipv6 dm_snapshot dm_mod
2011-11-10 18:46:22     Pid: 0, comm: kworker/0:1 Not tainted 
2.6.40.8intel #1
2011-11-10 18:46:22     Call Trace:
2011-11-10 18:46:22     <NMI> [<ffffffff8101ca09>] ? 
native_smp_send_reschedule+0x59/0x60
2011-11-10 18:46:22     [<ffffffff81045eb0>] warn_slowpath_common+0x80/0xc0
2011-11-10 18:46:22     [<ffffffff81045f05>] warn_slowpath_null+0x15/0x20
2011-11-10 18:46:22     [<ffffffff8101ca09>] 
native_smp_send_reschedule+0x59/0x60
2011-11-10 18:46:22     [<ffffffff810425a3>] try_to_wake_up+0x193/0x380
2011-11-10 18:46:22     [<ffffffff8104279d>] default_wake_function+0xd/0x10
2011-11-10 18:46:22     [<ffffffff810323da>] __wake_up_common+0x5a/0x90
2011-11-10 18:46:22     [<ffffffff810356c3>] __wake_up+0x43/0x70
2011-11-10 18:46:22     [<ffffffff813d7a0d>] aac_intr_normal+0x25d/0x340
2011-11-10 18:46:22     [<ffffffff813d8b6e>] aac_rx_intr_message+0x4e/0xd0
2011-11-10 18:46:22     [<ffffffff8108a29c>] 
handle_irq_event_percpu+0x6c/0x1e0
2011-11-10 18:46:22     [<ffffffff8108a446>] handle_irq_event+0x36/0x60
2011-11-10 18:46:22     [<ffffffff8108cd55>] handle_fasteoi_irq+0x55/0xd0
2011-11-10 18:46:22     [<ffffffff8100480f>] handle_irq+0x1f/0x30
2011-11-10 18:46:22     [<ffffffff81003f8b>] do_IRQ+0x5b/0xe0
2011-11-10 18:46:22     [<ffffffff815d7f13>] common_interrupt+0x13/0x13
2011-11-10 18:46:22     [<ffffffff815d4ae6>] ? panic+0x118/0x1e5
2011-11-10 18:46:22     [<ffffffff815d4abd>] ? panic+0xef/0x1e5
2011-11-10 18:46:22     [<ffffffff810895f1>] ? 
watchdog_overflow_callback+0xb1/0xc0
2011-11-10 18:46:22     [<ffffffff810b21f1>] ? 
__perf_event_overflow+0xb1/0x250
2011-11-10 18:46:22     [<ffffffff810b27b4>] ? perf_event_overflow+0x14/0x20
2011-11-10 18:46:22     [<ffffffff81014b87>] ? 
intel_pmu_handle_irq+0x217/0x450
2011-11-10 18:46:22     [<ffffffff81010d36>] ? 
perf_event_nmi_handler+0x36/0xb0
2011-11-10 18:46:22     [<ffffffff8106bebf>] ? notifier_call_chain+0x3f/0x80
2011-11-10 18:46:22     [<ffffffff8106bf25>] ? 
atomic_notifier_call_chain+0x15/0x20
2011-11-10 18:46:22     [<ffffffff8106c01e>] ? notify_die+0x2e/0x30
2011-11-10 18:46:22     [<ffffffff81003ba2>] ? do_nmi+0xa2/0x240
2011-11-10 18:46:22     [<ffffffff815d837a>] ? nmi+0x1a/0x20
2011-11-10 18:46:22     [<ffffffff810c133d>] ? put_compound_page+0xcd/0x170
2011-11-10 18:46:22     <<EOE>> <IRQ> [<ffffffff810c1415>] ? 
put_page+0x35/0x40
2011-11-10 18:46:22     [<ffffffff8150902b>] ? skb_release_data+0xab/0xd0
2011-11-10 18:46:22     [<ffffffff81508ae9>] ? __kfree_skb+0x19/0xa0
2011-11-10 18:46:22     [<ffffffff81508bcd>] ? consume_skb+0x5d/0x80
2011-11-10 18:46:22     [<ffffffff815139c5>] ? dev_kfree_skb_any+0x35/0x40
2011-11-10 18:46:22     [<ffffffff8144ee42>] ? e1000_put_txbuf+0x62/0x90
2011-11-10 18:46:22     [<ffffffff8144ef34>] ? e1000_clean_tx_irq+0xc4/0x2c0
2011-11-10 18:46:22     [<ffffffff81451fa9>] ? e1000_clean+0x69/0x2f0
2011-11-10 18:46:22     [<ffffffff8151848a>] ? net_rx_action+0x10a/0x2b0
2011-11-10 18:46:22     [<ffffffff8104c390>] ? __do_softirq+0xd0/0x1c0
2011-11-10 18:46:22     [<ffffffff815d968c>] ? call_softirq+0x1c/0x30
2011-11-10 18:46:22     [<ffffffff810047b5>] ? do_softirq+0x55/0x90
2011-11-10 18:46:22     [<ffffffff8104c16d>] ? irq_exit+0xad/0xe0
2011-11-10 18:46:22     [<ffffffff81003f94>] ? do_IRQ+0x64/0xe0
2011-11-10 18:46:22     [<ffffffff815d7f13>] ? common_interrupt+0x13/0x13
2011-11-10 18:46:22     <EOI> [<ffffffff8100b0f7>] ? mwait_idle+0x117/0x120
2011-11-10 18:46:22     [<ffffffff8106bf25>] ? 
atomic_notifier_call_chain+0x15/0x20
2011-11-10 18:46:22     [<ffffffff81002091>] ? cpu_idle+0xb1/0x110
2011-11-10 18:46:22     [<ffffffff81b0d8ba>] ? start_secondary+0x201/0x297
2011-11-10 18:46:22     ---[ end trace bf83ef853d09ab91 ]---

Greets
Stefan
