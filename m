Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0IURxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:53:44 -0400
Received: from [83.228.35.12] ([83.228.35.12]:50771 "EHLO fs.uni-ruse.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0IURxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:53:43 -0400
From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
To: linux-kernel@vger.kernel.org
Subject: [2.6.36-rc5 backtrace] NMI watchdog detects rcu_sched_state stall
Date: Tue, 21 Sep 2010 20:53:40 +0300
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.4C98F124.00000CF9@fs.uni-ruse.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello! 

Kernel 2.6.35-rc5 just wrote the following into system logs: 

Sep 21 19:57:33 fs kernel: [11358.100853] INFO: rcu_sched_state detected 
stall on CPU 0 (t=1000 jiffies)
Sep 21 19:57:33 fs kernel: [11358.100856] NMI backtrace for cpu 1
Sep 21 19:57:33 fs kernel: [11358.100856]
Sep 21 19:57:33 fs kernel: [11358.100856] Pid: 0, comm: kworker/0:0 Not 
tainted 2.6.36-rc5-FS #1 0YH299/PowerEdge SC440
Sep 21 19:57:33 fs kernel: [11358.100856] EIP: 0060:[<c102f166>] EFLAGS: 
00000246 CPU: 1
Sep 21 19:57:33 fs kernel: [11358.100856] EIP is at mwait_idle+0x45/0x57
Sep 21 19:57:33 fs kernel: [11358.100856] EAX: 00000000 EBX: c15f1f08 ECX: 
00000000 EDX: 00000000
Sep 21 19:57:33 fs kernel: [11358.100856] ESI: 00000001 EDI: 00000000 EBP: 
df8a1f84 ESP: df8a1f84
Sep 21 19:57:33 fs kernel: [11358.100856]  DS: 007b ES: 007b FS: 00d8 GS: 
0000 SS: 0068
Sep 21 19:57:33 fs kernel: [11358.100856] Process kworker/0:0 (pid: 0, 
ti=df8a0000 task=df836260 task.ti=df8a0000)
Sep 21 19:57:33 fs kernel: [11358.100856] Stack:
Sep 21 19:57:33 fs kernel: [11358.100856]  df8a1f94 c1028353 00000001 
00000000 df8a1fb0 c162d901 00000000 00000000
Sep 21 19:57:33 fs kernel: [11358.100856] <0> 00000000 00000000 01020800 
00000000 00000000 00000000 00000000 00000000
Sep 21 19:57:33 fs kernel: [11358.100856] <0> 00000000 00000000 00000000 
00000000 00000000 000000d8 00000000 00000000
Sep 21 19:57:33 fs kernel: [11358.100856] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c1028353>] ? cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c162d901>] ? 
start_secondary+0x1a4/0x1aa
Sep 21 19:57:33 fs kernel: [11358.100856] Code: 67 c1 f6 44 11 27 02 75 24 
83 c0 08 31 d2 89 d1 0f 01 c8 0f ae f0 89 f6 89 e0 25 00 e0 ff ff f6 40 08 
08 75 15 31 c0 fb 0f 01 c9 <5d> c3 0f ae 78 08 89 e0 25 00 e0 ff ff eb cf 
fb 5d c3 55 89 e5
Sep 21 19:57:33 fs kernel: [11358.100856] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c1028353>] cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c162d901>] 
start_secondary+0x1a4/0x1aa
Sep 21 19:57:33 fs kernel: [11358.100856] Pid: 0, comm: kworker/0:0 Not 
tainted 2.6.36-rc5-FS #1
Sep 21 19:57:33 fs kernel: [11358.100856] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c102f65d>] ? 
show_regs+0x20/0x26
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c103e69e>] 
nmi_watchdog_tick+0x13a/0x155
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c102a411>] do_nmi+0x1bb/0x32b
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c103d692>] ? 
smp_apic_timer_interrupt+0x56/0x85
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c140d829>] 
nmi_stack_correct+0x28/0x2d
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c102f166>] ? 
mwait_idle+0x45/0x57
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c1028353>] cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100856]  [<c162d901>] 
start_secondary+0x1a4/0x1aa
Sep 21 19:57:33 fs kernel: [11358.100853] NMI backtrace for cpu 0
Sep 21 19:57:33 fs kernel: [11358.100853]
Sep 21 19:57:33 fs kernel: [11358.100853] Pid: 0, comm: swapper Not tainted 
2.6.36-rc5-FS #1 0YH299/PowerEdge SC440
Sep 21 19:57:33 fs kernel: [11358.100853] EIP: 0060:[<c118b749>] EFLAGS: 
00000046 CPU: 0
Sep 21 19:57:33 fs kernel: [11358.100853] EIP is at delay_tsc+0x33/0x55
Sep 21 19:57:33 fs kernel: [11358.100853] EAX: 1f022b49 EBX: 1ed5724d ECX: 
00000000 EDX: 00001ef1
Sep 21 19:57:33 fs kernel: [11358.100853] ESI: 00000000 EDI: 002da920 EBP: 
c15a9984 ESP: c15a9970
Sep 21 19:57:33 fs kernel: [11358.100853]  DS: 007b ES: 007b FS: 00d8 GS: 
0000 SS: 0068
Sep 21 19:57:33 fs kernel: [11358.100853] Process swapper (pid: 0, 
ti=c15a8000 task=c15bb0a0 task.ti=c15a8000)
Sep 21 19:57:33 fs kernel: [11358.100853] Stack:
Sep 21 19:57:33 fs kernel: [11358.100853]  00000046 c16751e0 0000005b 
c15c1d80 c15c1d80 c15a998c c118b714 c15a9a00
Sep 21 19:57:33 fs kernel: [11358.100853] <0> c1055ade 00000054 c15a99e1 
c15a9a10 00000046 c15a99d2 c154ed00 00002c5e
Sep 21 19:57:33 fs kernel: [11358.100853] <0> 000189f5 c15a99d2 00000004 
00000000 c16d03c3 00000033 0000000f 00000000
Sep 21 19:57:33 fs kernel: [11358.100853] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] ? 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] ? 
vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] ? printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103e491>] ? 
arch_trigger_all_cpu_backtrace+0x1f/0x58
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c108013d>] ? 
__rcu_pending+0x14c/0x2d3
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1080313>] ? 
rcu_check_callbacks+0x4f/0xf7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c105ea0e>] ? 
update_process_times+0x2d/0x48
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075172>] ? 
tick_periodic+0x25/0x68
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10751ce>] ? 
tick_handle_periodic+0x19/0x7b
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075434>] ? 
tick_do_broadcast+0x2e/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10755a3>] ? 
tick_do_periodic_broadcast+0x29/0x31
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075828>] ? 
tick_handle_periodic_broadcast+0x10/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b6e7>] ? 
timer_interrupt+0x37/0x3e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107c3e8>] ? 
handle_IRQ_event+0x2a/0xae
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107f0b2>] ? 
move_native_irq+0xc/0x4a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107dfb4>] ? 
handle_edge_irq+0xa0/0x12e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106da3a>] ? 
notify_die+0x2d/0x2f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b2e8>] ? 
handle_irq+0x18/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8eb>] ? do_IRQ+0x41/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] ? 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10600d8>] ? 
flush_itimer_signals+0x39/0x4d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b73d>] ? 
delay_tsc+0x27/0x55
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] ? 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] ? 
vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] ? printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394095>] ? 
ipt_log_packet+0x111/0x1ba
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394185>] ? log_tg+0x47/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1391f44>] ? 
ipt_do_table+0x30c/0x514
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1337f54>] ? 
tcp_new+0x1d5/0x215
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392c0e>] ? 
nf_nat_rule_find+0x24/0x96
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392e4d>] ? 
nf_nat_fn+0xd0/0x102
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c139306b>] ? 
nf_nat_in+0x28/0x65
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13307e5>] ? 
nf_iterate+0x65/0x78
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1330908>] ? 
nf_hook_slow+0x53/0xbe
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134ecae>] ? ip_rcv+0x23b/0x30c
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fc624>] ? 
__netif_receive_skb+0x2dc/0x424
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fcd36>] ? 
netif_receive_skb+0x63/0x69
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1250434>] ? 
rtl8139_poll+0x13d/0x32e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fce95>] ? 
net_rx_action+0x7f/0x15a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059565>] ? 
__do_softirq+0x80/0x107
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103f69b>] ? 
ack_apic_level+0x5f/0x1d8
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1076284>] ? 
tick_nohz_stop_idle+0x39/0x3f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059617>] ? 
do_softirq+0x2b/0x2d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059765>] ? irq_exit+0x5f/0x64
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8f4>] ? do_IRQ+0x4a/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106e630>] ? 
sched_clock_idle_sleep_event+0xe/0x10
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] ? 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102f166>] ? 
mwait_idle+0x45/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1028353>] ? cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13f88b8>] ? 
rest_init+0x58/0x5a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa93a>] ? 
start_kernel+0x26a/0x270
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa4fb>] ? 
unknown_bootoption+0x0/0x19f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa089>] ? 
i386_start_kernel+0x89/0x8b
Sep 21 19:57:33 fs kernel: [11358.100853] Code: 08 89 c7 64 8b 35 54 51 67 
c1 8d 76 00 0f ae e8 0f 31 89 c3 eb 0d f3 90 64 8b 0d 54 51 67 c1 39 f1 75 
18 8d 76 00 0f ae e8 0f 31 <89> c1 29 d9 39 cf 77 e3 83 c4 08 5b 5e 5f 5d 
c3 29 c3 01 df 8d
Sep 21 19:57:33 fs kernel: [11358.100853] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103e491>] 
arch_trigger_all_cpu_backtrace+0x1f/0x58
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c108013d>] 
__rcu_pending+0x14c/0x2d3
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1080313>] 
rcu_check_callbacks+0x4f/0xf7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c105ea0e>] 
update_process_times+0x2d/0x48
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075172>] 
tick_periodic+0x25/0x68
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10751ce>] 
tick_handle_periodic+0x19/0x7b
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075434>] 
tick_do_broadcast+0x2e/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10755a3>] 
tick_do_periodic_broadcast+0x29/0x31
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075828>] 
tick_handle_periodic_broadcast+0x10/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b6e7>] 
timer_interrupt+0x37/0x3e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107c3e8>] 
handle_IRQ_event+0x2a/0xae
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107f0b2>] ? 
move_native_irq+0xc/0x4a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107dfb4>] 
handle_edge_irq+0xa0/0x12e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106da3a>] ? 
notify_die+0x2d/0x2f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b2e8>] handle_irq+0x18/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8eb>] do_IRQ+0x41/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10600d8>] ? 
flush_itimer_signals+0x39/0x4d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b73d>] ? 
delay_tsc+0x27/0x55
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394095>] 
ipt_log_packet+0x111/0x1ba
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394185>] log_tg+0x47/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1391f44>] 
ipt_do_table+0x30c/0x514
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1337f54>] ? 
tcp_new+0x1d5/0x215
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392c0e>] 
nf_nat_rule_find+0x24/0x96
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392e4d>] nf_nat_fn+0xd0/0x102
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c139306b>] nf_nat_in+0x28/0x65
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13307e5>] nf_iterate+0x65/0x78
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1330908>] 
nf_hook_slow+0x53/0xbe
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134ecae>] ip_rcv+0x23b/0x30c
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fc624>] 
__netif_receive_skb+0x2dc/0x424
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fcd36>] 
netif_receive_skb+0x63/0x69
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1250434>] 
rtl8139_poll+0x13d/0x32e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fce95>] 
net_rx_action+0x7f/0x15a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059565>] 
__do_softirq+0x80/0x107
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103f69b>] ? 
ack_apic_level+0x5f/0x1d8
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1076284>] ? 
tick_nohz_stop_idle+0x39/0x3f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059617>] do_softirq+0x2b/0x2d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059765>] irq_exit+0x5f/0x64
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8f4>] do_IRQ+0x4a/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106e630>] ? 
sched_clock_idle_sleep_event+0xe/0x10
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102f166>] ? 
mwait_idle+0x45/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1028353>] cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13f88b8>] rest_init+0x58/0x5a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa93a>] 
start_kernel+0x26a/0x270
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa4fb>] ? 
unknown_bootoption+0x0/0x19f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa089>] 
i386_start_kernel+0x89/0x8b
Sep 21 19:57:33 fs kernel: [11358.100853] Pid: 0, comm: swapper Not tainted 
2.6.36-rc5-FS #1
Sep 21 19:57:33 fs kernel: [11358.100853] Call Trace:
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102f65d>] ? 
show_regs+0x20/0x26
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103e69e>] 
nmi_watchdog_tick+0x13a/0x155
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a411>] do_nmi+0x1bb/0x32b
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140d829>] 
nmi_stack_correct+0x28/0x2d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118007b>] ? 
blkpg_ioctl+0x31/0x284
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b749>] ? 
delay_tsc+0x33/0x55
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103e491>] 
arch_trigger_all_cpu_backtrace+0x1f/0x58
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c108013d>] 
__rcu_pending+0x14c/0x2d3
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1080313>] 
rcu_check_callbacks+0x4f/0xf7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c105ea0e>] 
update_process_times+0x2d/0x48
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075172>] 
tick_periodic+0x25/0x68
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10751ce>] 
tick_handle_periodic+0x19/0x7b
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075434>] 
tick_do_broadcast+0x2e/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10755a3>] 
tick_do_periodic_broadcast+0x29/0x31
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1075828>] 
tick_handle_periodic_broadcast+0x10/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b6e7>] 
timer_interrupt+0x37/0x3e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107c3e8>] 
handle_IRQ_event+0x2a/0xae
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107f0b2>] ? 
move_native_irq+0xc/0x4a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c107dfb4>] 
handle_edge_irq+0xa0/0x12e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106da3a>] ? 
notify_die+0x2d/0x2f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102b2e8>] handle_irq+0x18/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8eb>] do_IRQ+0x41/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10600d8>] ? 
flush_itimer_signals+0x39/0x4d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b73d>] ? 
delay_tsc+0x27/0x55
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c118b714>] 
__const_udelay+0x34/0x36
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1055ade>] vprintk+0x2a2/0x37e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c140b103>] printk+0x18/0x1d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394095>] 
ipt_log_packet+0x111/0x1ba
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1394185>] log_tg+0x47/0x52
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1391f44>] 
ipt_do_table+0x30c/0x514
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1337f54>] ? 
tcp_new+0x1d5/0x215
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392c0e>] 
nf_nat_rule_find+0x24/0x96
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1392e4d>] nf_nat_fn+0xd0/0x102
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c139306b>] nf_nat_in+0x28/0x65
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13307e5>] nf_iterate+0x65/0x78
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1330908>] 
nf_hook_slow+0x53/0xbe
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134ecae>] ip_rcv+0x23b/0x30c
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c134e5f0>] ? 
ip_rcv_finish+0x0/0x3a0
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fc624>] 
__netif_receive_skb+0x2dc/0x424
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fcd36>] 
netif_receive_skb+0x63/0x69
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1250434>] 
rtl8139_poll+0x13d/0x32e
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c12fce95>] 
net_rx_action+0x7f/0x15a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059565>] 
__do_softirq+0x80/0x107
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c103f69b>] ? 
ack_apic_level+0x5f/0x1d8
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1076284>] ? 
tick_nohz_stop_idle+0x39/0x3f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059617>] do_softirq+0x2b/0x2d
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1059765>] irq_exit+0x5f/0x64
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102a8f4>] do_IRQ+0x4a/0xa7
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c106e630>] ? 
sched_clock_idle_sleep_event+0xe/0x10
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c10297a9>] 
common_interrupt+0x29/0x30
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c102f166>] ? 
mwait_idle+0x45/0x57
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c1028353>] cpu_idle+0x3d/0x7a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c13f88b8>] rest_init+0x58/0x5a
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa93a>] 
start_kernel+0x26a/0x270
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa4fb>] ? 
unknown_bootoption+0x0/0x19f
Sep 21 19:57:33 fs kernel: [11358.100853]  [<c15fa089>] 
i386_start_kernel+0x89/0x8b 

This got caught with the help of NMI watchdog. I enabled NMI after the 
machine got
so slow a couple of times I tought it hanged, but when I attached a monitor 
I saw
this: 

http://picpaste.com/536639578e2a95d666f695f4833453ed.jpg 

Unfortunately, I was too busy at the time to post, and in need of a quick 
solution
switched to an old stable kernel. 

Should I open a bugreport with the details (hardware, kernel config)? 

Any advise is welcome. 

Please, note that I'm not subscribed to the list.
 --
Plamen Petrov 

 -
 ---
 -----
 ------------------------------------------
This message was sent by the mail server
at fs.uni-ruse.bg using the web interface:
    http://webmail.fs.uni-ruse.bg/
E-mail postmaster@fs.uni-ruse.bg with anything,
regarding the server itself
