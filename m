Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1BIVC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:02:28 -0500
Received: from buffalo.tchmachines.com ([208.76.86.16]:47419 "EHLO
	buffalo.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1BIVC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:02:26 -0500
X-Greylist: delayed 5659 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Feb 2011 16:02:26 EST
Subject: [BUG] soft lockup while booting machine with more than 700 cores
From: raz ben yehuda <raz@scalemp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, raz@scalemp.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 09:27:33 +0200
Message-ID: <1297236453.2756.9.camel@raz.scalemp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - buffalo.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mingo Hello

Bellow is a boot of a 2.6.32.19 kernel over a machine with more than 700 cores. I am failing to boot it due to a soft lockup
in rebalance_domains area. I did not find anything related in mainline git and kernel's bugzilla.

thank you
Raz


 [  929.614315] TCP cubic registered 
 [  929.614577] NET: Registered protocol family 17 
 [  930.785915] Bridge firewalling registered 
 [  930.928396] Freeing unused kernel memory: 1380k freed 
 =============================================================================== 
 Running /disklessrc 
 Mounting /proc 
 Creating /dev 
 Creating initial device nodes 
[  931.327841] usb 5-1: configuration #1 chosen from 1 choice 
[  931.657469] input: HP Virtual Keyboard as /class/input/input0 
[  931.671560] generic-usb 0003:03F0:1027.0001: input: USB HID v1.01 Keyboard [H
P Virtual Keyboard] on usb-0000:01:04.0-1/input0 
 [  931.911480] input: HP Virtual Keyboard as /class/input/input1 
 [  931.926135] generic-usb 0003:03F0:1027.0002: input: USB HID v1.01 Mouse [HP V
 irtual Keyboard] on usb-0000:01:04.0-1/input1 
 [  932.247432] scsi 0:0:0:0: Direct-Access     Generic  USB Flash Disk   0.00 PQ
 : 0 ANSI: 2 
 [  932.301626] sd 0:0:0:0: Attached scsi generic sg0 type 0 
 [  932.416279] sd 0:0:0:0: [sda] 7892992 512-byte logical blocks: (4.04 GB/3.76 
 GiB) 
 [  932.559424] sd 0:0:0:0: [sda] Write Protect is off 
 [  932.563238] sd 0:0:0:0: [sda] Assuming drive cache: write through 
 [  932.802006] sd 0:0:0:0: [sda] Assuming drive cache: write through 
 [  932.805070]  sda: sda1 
 [  934.315071] sd 0:0:0:0: [sda] Assuming drive cache: write through 
 [  934.318055] sd 0:0:0:0: [sda] Attached SCSI removable disk 
 Loading nfs module... [ 1011.681028] BUG: soft lockup - CPU#240 stuck for 62s! [
 swapper:0] 
 [ 1011.744482] Modules linked in: sunrpc(+) 
 [ 1011.789117] CPU 240: 
 [ 1011.828757] Modules linked in: sunrpc(+) 
 [ 1011.874003] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1011.935843] RIP: 0010:[<ffffffff8105ac32>]  [<ffffffff8105ac32>] weighted_cpu
 load+0x12/0x20 
 [ 1012.051597] RSP: 0018:ffff89468e803c88  EFLAGS: 00010286 
 [ 1012.115020] RAX: 00000000000115c0 RBX: 0000000000000002 RCX: 000000000000001d
 [ 1012.162897] RDX: ffff8acd2e840000 RSI: 0000000000000002 RDI: 000000000000021d
 [ 1012.243858] RBP: ffffffff81033133 R08: 0000000000000200 R09: ffff894f0ca3d450
 [ 1012.309760] R10: 0000000000000000 R11: ffff89468e803dc0 R12: ffff89468e803c00
 [ 1012.358023] R13: 00000000000115c0 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1012.417072] FS:  0000000000000000(0000) GS:ffff89468e800000(0000) knlGS:00000
 00000000000 
 [ 1012.494488] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 1012.559412] CR2: 00000000008d3988 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1012.619828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1012.675491] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1012.739386] Call Trace: 
 [ 1012.790082]  <IRQ>  [<ffffffff81039705>] ? sched_clock+0x5/0x10 
 [ 1012.868687]  [<ffffffff8105ac6b>] ? source_load+0x2b/0x70 
 [ 1012.923473]  [<ffffffff810602d5>] ? find_busiest_group+0x1b5/0xa30 
 [ 1012.973482]  [<ffffffff81063487>] ? rebalance_domains+0x117/0x470 
 [ 1013.031838]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
 [ 1013.081837]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
 [ 1013.134496]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
[ 1013.182834]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1013.246263]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1013.314801]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1013.355605]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1013.391166]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 1013.391166]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1013.478307]  <EOI>  [<ffffffff8104dc92>] ? native_safe_halt+0x2/0x10 
 [ 1013.515916]  [<ffffffff8103a481>] ? default_idle+0x21/0x40 
 [ 1013.572168]  [<ffffffff81031537>] ? cpu_idle+0x57/0x90 
 [ 1112.445978] BUG: soft lockup - CPU#240 stuck for 62s! [swapper:0] 
 [ 1112.445978] Modules linked in: sunrpc(+) 
[ 1112.445978] CPU 240: 
 [ 1112.445978] Modules linked in: sunrpc(+) 
 [ 1112.975961] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1112.975961] RIP: 0010:[<ffffffff81063597>]  [<ffffffff81063597>] rebalance_do
 mains+0x227/0x470 
 [ 1112.975961] RSP: 0018:ffff89468e803e20  EFLAGS: 00010202 
 [ 1112.975961] RAX: 0000000000000200 RBX: 00000000000115c0 RCX: 0000000000000073
 [ 1112.975961] RDX: 0000000000000200 RSI: 0000000000000200 RDI: 0000000000000000
 [ 1112.975961] RBP: ffffffff81033133 R08: 00000000000002c0 R09: 0000000000000000
 [ 1112.975961] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff89468e803da0
 [ 1112.975961] R13: ffff89468e80d740 R14: 0000000000000000 R15: ffffffff81046ea6
 [ 1113.509879] FS:  0000000000000000(0000) GS:ffff89468e800000(0000) knlGS:00000
 00000000000 
 [ 1113.509879] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
[ 1113.509879] CR2: 00000000008d3988 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1113.509879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1113.509879] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1113.509879] Call Trace: 
 [ 1113.509879]  <IRQ>  [<ffffffff810a21ad>] ? rcu_process_gp_end+0x4d/0xb0 
[ 1113.509879]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
 [ 1113.509879]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
 [ 1114.157064]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1114.214898]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
[ 1114.214898]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1114.214898]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1114.214898]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1114.214898]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 1114.214898]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1114.214898]  <EOI>  [<ffffffff81061dcc>] ? finish_task_switch+0x2c/0xb0 
 [ 1114.214898]  [<ffffffff81583fd7>] ? thread_return+0x3e/0x5a7 
   
 [ 1114.214898]  [<ffffffff8104dc92>] ? native_safe_halt+0x2/0x10
 [ 1114.214898]  [<ffffffff8103154f>] ? cpu_idle+0x6f/0x90 
 [ 1360.946352] RPC: Registered udp transport module. 
 [ 1360.959427] RPC: Registered tcp transport module. 
 [ 1360.971548] RPC: Registered tcp NFSv4.1 backchannel transport module. 
  Loaded nfs OK. 
 Mounting / 
 Running dhclient 
 [ 1420.218054] bnx2x: eth0 NIC Link is Down 
 [ 1420.577978] bnx2x: eth0 NIC Link is Down 
 [ 1420.623026] bnx2x: eth0 NIC Link is Up, 10000 Mbps full duplex, receive & tra
 nsmit flow control ON 
[ 1481.853029] BUG: soft lockup - CPU#698 stuck for 61s! [swapper:0] 
 [ 1481.853029] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1481.853029] CPU 698: 
 [ 1481.884051] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1481.887412] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1481.887412] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 1481.911149] RSP: 0018:ffff8b984e683f00  EFLAGS: 00000206 
 [ 1481.921860] RAX: ffff89948c951fd8 RBX: ffff8b984e683f58 RCX: 00000000000002ba
 [ 1481.921860] RDX: 000000000000dea0 RSI: 0000000000000aec RDI: 0000000000000838
 [ 1481.931948] RBP: ffffffff81033133 R08: ffff8b984e68b880 R09: 0000000000000010
 [ 1481.974484] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff8b984e683e80
 [ 1481.987933] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1481.987933] FS:  0000000000000000(0000) GS:ffff8b984e680000(0000) knlGS:00000
 00000000000 
 [ 1482.015278] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1482.026115] CR2: 000000308cc6bf50 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1482.034587] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1482.034587] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1482.051432] Call Trace: 
 [ 1482.051432]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1482.051432]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1482.061831]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1482.061831]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1482.091501]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1482.091501]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 1482.091501]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1482.118567]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1482.118567]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1482.144403]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1482.144403]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
    ssdd[ 1595.728022] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1595.728022] Modules linked in: nfs lockd nfs_acl sunrpc 
[ 1595.728022] CPU 78: 
[ 1595.728022] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1595.787759] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
[ 1595.798002] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
+0x63/0x140 
[ 1595.799102] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
[ 1595.799102] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
[ 1595.799102] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
[ 1595.799102] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
[ 1595.799102] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
[ 1595.799102] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
[ 1595.799102] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
00000000000 
[ 1595.799102] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
[ 1595.799102] CR2: 00000000008c53ec CR3: 0000000001001000 CR4: 00000000000026e0
[ 1595.799102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1595.799102] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[ 1595.799102] Call Trace: 
[ 1595.799102]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
[ 1595.799102]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
[ 1595.799102]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
[ 1595.799102]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
[ 1595.799102]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
[ 1595.799102]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
[ 1595.799102]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
[ 1595.799102]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
[ 1595.799102]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
[ 1595.799102]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 fffddfsssssd 
 [ 1615.303908] INFO: task dhclient:18816 blocked for more than 120 seconds. 
 [ 1615.317018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
 message. 
 [ 1615.329095] dhclient      D ffffffff8105b4c9     0 18816      1 0x00000000 
 [ 1615.345469]  ffff8830ecfcc000 0000000000000086 0000000000000000 ffffffff810ab
 7b5 
 [ 1615.374894]  ffff8810a7507470 ffff8810a75070c0 ffff8810a7507000 ffff8810a7507
 470 
 [ 1615.396127]  000000010001b475 00000000000006a2 0000000000000001 ffff8810a7df9
 e50 
 [ 1615.419605] Call Trace: 
 [ 1615.435157]  [<ffffffff810ab7b5>] ? __alloc_pages_nodemask+0x105/0x5f0 
 [ 1615.448307]  [<ffffffff8158480b>] ? schedule_timeout+0x18b/0x200 
 [ 1615.471186]  [<ffffffff8103312e>] ? apic_timer_interrupt+0xe/0x20 
 [ 1615.485216]  [<ffffffff8152f9b0>] ? udp_ioctl+0x0/0x70 
 [ 1615.497141]  [<ffffffff8129a8a5>] ? cpumask_any_but+0x25/0x40 
 [ 1615.519954]  [<ffffffff81583b11>] ? wait_for_common+0xe1/0x1c0 
 [ 1616.069803]  [<ffffffff81062f30>] ? default_wake_function+0x0/0x10 
 [ 1616.078484]  [<ffffffff8107ccde>] ? synchronize_sched+0x4e/0x60 
 [ 1616.088994]  [<ffffffff8107cc80>] ? wakeme_after_rcu+0x0/0x10 
 [ 1616.099977]  [<ffffffff815595d7>] ? packet_do_bind+0x117/0x140 
 [ 1616.112533]  [<ffffffff8155a3e4>] ? packet_bind+0x64/0x90 
 [ 1616.123459]  [<ffffffff814d611e>] ? sys_bind+0x7e/0xd0 
 [ 1616.132543]  [<ffffffff810de865>] ? fd_install+0x25/0x60 
 [ 1616.139984]  [<ffffffff814d6364>] ? sock_map_fd+0x54/0x90 
[ 1616.153171]  [<ffffffff810eeae9>] ? sys_ioctl+0x49/0x80 
 [ 1616.159763]  [<ffffffff81032682>] ? system_call_fastpath+0x16/0x1b 
 [ 1632.401994] BUG: soft lockup - CPU#242 stuck for 63s! [swapper:0] 
 [ 1632.401994] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1632.401994] CPU 242: 
 [ 1633.144839] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1633.144839] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1633.144839] RIP: 0010:[<ffffffff810601ee>]  [<ffffffff810601ee>] find_busiest
 _group+0xce/0xa30 
 [ 1633.421004] RSP: 0018:ffff89468e883cb0  EFLAGS: 00010293 
 [ 1633.421004] RAX: ffff894f0ca19010 RBX: 00000000000115c0 RCX: ffff89468e883db0
[ 1633.519584] RDX: 00000000000000f2 RSI: 0000000000000000 RDI: ffff89468e883db0
 [ 1633.585328] RBP: ffffffff81033133 R08: 0000000000000000 R09: ffff89468e883d20
 [ 1633.630770] R10: 0000000000000000 R11: 0000000000000001 R12: ffff89468e883c30
 [ 1633.701656] R13: 00000000000115c0 R14: 0000000000000000 R15: ffffffff81046ea6
 [ 1633.701656] FS:  0000000000000000(0000) GS:ffff89468e880000(0000) knlGS:00000
 00000000000 
[ 1633.921309] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1633.971582] CR2: 0000000000006000 CR3: 0000000001001000 CR4: 00000000000026e0
[ 1634.066338] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1634.128021] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1634.258303] Call Trace: 
 [ 1634.346718]  <IRQ>  [<ffffffff81063487>] ? rebalance_domains+0x117/0x470 
[ 1634.462705]  [<ffffffff8105b9db>] ? __wake_up_common+0x5b/0x90 
 [ 1634.557567]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
 [ 1634.645974]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
 [ 1634.707717]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1634.768124]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
[ 1634.817133]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1634.817133]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1634.817133]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1634.817133]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 1634.817133]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1634.817133]  <EOI>  [<ffffffff81061dcc>] ? finish_task_switch+0x2c/0xb0 
 [ 1634.817133]  [<ffffffff81583fd7>] ? thread_return+0x3e/0x5a7 
 [ 1634.817133]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1634.817133]  [<ffffffff8103154f>] ? cpu_idle+0x6f/0x90 
 [ 1663.213497] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1663.213497] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1663.213497] CPU 78: 
 [ 1663.213497] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1663.213497] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1663.213497] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 1663.213497] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1663.213497] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1663.213497] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1663.213497] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
 [ 1663.213497] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1663.213497] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
[ 1663.213497] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
00000000000 
[ 1663.213497] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1663.213497] CR2: 00000000008c53ec CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1663.213497] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1663.213497] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1663.213497] Call Trace: 
 [ 1663.213497]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1663.213497]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1663.213497]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1663.213497]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1663.213497]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1663.213497]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1663.213497]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1663.213497]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1663.497244]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
[ 1663.497244]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1730.806470] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1730.806470] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1730.806470] CPU 78: 
 [ 1730.806470] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1730.806470] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1730.806470] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 [ 163
 [ 163
 00003
 [ 163
 [ 163
 [ 163
 [ 163
 [ 163
 [ 163
 [ 163
 [ 163
 [ 163
 [ 173
 [ 173
 [ 173
 [ 173
   
 +0x63/0x1407
 [ 1730.806470] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1730.806470] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1730.806470] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1730.806470] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
 [ 1730.806470] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1730.806470] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1730.806470] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
 00000000000 
 [ 1730.806470] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
[ 1730.806470] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1730.806470] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1730.806470] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1730.806470] Call Trace: 
 [ 1730.806470]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1730.806470]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1730.806470]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1730.806470]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1730.806470]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1730.806470]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1730.806470]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1730.806470]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1730.806470]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
[ 1730.806470]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1736.647080] INFO: task dhclient:18816 blocked for more than 120 seconds. 
[ 1736.668393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
 message. 
 [ 1737.194604] dhclient      D ffffffff8105b4c9     0 18816      1 0x00000000 
 [ 1737.217687]  ffff8830ecfcc000 0000000000000086 0000000000000000 ffffffff810ab
 7b5 
 [ 1737.249033]  ffff8810a7507470 ffff8810a75070c0 ffff8810a7507000 ffff8810a7507
 470 
 [ 1737.813554]  000000010001b475 00000000000006a2 0000000000000001 ffff8810a7df9
 e50 
 [ 1737.837648] Call Trace: 
 [ 1737.844817]  [<ffffffff810ab7b5>] ? __alloc_pages_nodemask+0x105/0x5f0 
[ 1737.855810]  [<ffffffff8158480b>] ? schedule_timeout+0x18b/0x200 
 [ 1737.866710]  [<ffffffff8103312e>] ? apic_timer_interrupt+0xe/0x20 
 [ 1738.384865]  [<ffffffff8152f9b0>] ? udp_ioctl+0x0/0x70 
 [ 1738.407597]  [<ffffffff8129a8a5>] ? cpumask_any_but+0x25/0x40 
 [ 1738.888936]  [<ffffffff81583b11>] ? wait_for_common+0xe1/0x1c0 
 [ 1738.888936]  [<ffffffff81062f30>] ? default_wake_function+0x0/0x10 
 [ 1738.909985]  [<ffffffff8107ccde>] ? synchronize_sched+0x4e/0x60 
 [ 1738.929008]  [<ffffffff8107cc80>] ? wakeme_after_rcu+0x0/0x10 
 [ 1738.936794]  [<ffffffff815595d7>] ? packet_do_bind+0x117/0x140 
 [ 1738.943435]  [<ffffffff8155a3e4>] ? packet_bind+0x64/0x90 
 [ 1738.948413]  [<ffffffff814d611e>] ? sys_bind+0x7e/0xd0 
 [ 1738.958205]  [<ffffffff810de865>] ? fd_install+0x25/0x60 
 [ 1738.964466]  [<ffffffff814d6364>] ? sock_map_fd+0x54/0x90 
 [ 1738.969223]  [<ffffffff810eeae9>] ? sys_ioctl+0x49/0x80 
 [ 1738.979004]  [<ffffffff81032682>] ? system_call_fastpath+0x16/0x1b 
 dfsgg[ 1797.555340] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1797.555340] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1797.555340] CPU 78: 
 [ 1797.555340] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1797.555340] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1797.555340] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 1797.555340] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1797.555340] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1797.555340] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1797.555340] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
[ 1797.555340] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1797.555340] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1797.555340] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
 00000000000 
 [ 1797.555340] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1797.555340] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1797.555340] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1797.555340] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1797.555340] Call Trace: 
 [ 1797.555340]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1797.555340]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1797.555340]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1797.555340]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1797.555340]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1797.555340]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1797.555340]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1797.555340]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1797.555340]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1797.555340]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1860.487671] INFO: task dhclient:18816 blocked for more than 120 seconds. 
 [ 1860.499758] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
 message. 
 [ 1860.526448] dhclient      D ffffffff8105b4c9     0 18816      1 0x00000000 
 [ 1860.543212]  ffff8830ecfcc000 0000000000000086 0000000000000000 ffffffff810ab
 7b5 
 [ 1860.572783]  ffff8810a7507470 ffff8810a75070c0 ffff8810a7507000 ffff8810a7507
 470 
[ 1860.609237]  000000010001b475 00000000000006a2 0000000000000001 ffff8810a7df9
 e50 
 [ 1860.644940] Call Trace: 
 [ 1860.649929]  [<ffffffff810ab7b5>] ? __alloc_pages_nodemask+0x105/0x5f0 
 [ 1860.661169]  [<ffffffff8158480b>] ? schedule_timeout+0x18b/0x200 
 [ 1860.668791]  [<ffffffff8103312e>] ? apic_timer_interrupt+0xe/0x20 
 [ 1860.675496]  [<ffffffff8152f9b0>] ? udp_ioctl+0x0/0x70 
[ 1860.687375]  [<ffffffff8129a8a5>] ? cpumask_any_but+0x25/0x40 
 [ 1860.702806]  [<ffffffff81583b11>] ? wait_for_common+0xe1/0x1c0 
 [ 1860.709979]  [<ffffffff81062f30>] ? default_wake_function+0x0/0x10 
 [ 1860.717698]  [<ffffffff8107ccde>] ? synchronize_sched+0x4e/0x60 
 [ 1860.724719]  [<ffffffff8107cc80>] ? wakeme_after_rcu+0x0/0x10 
 [ 1860.729439]  [<ffffffff815595d7>] ? packet_do_bind+0x117/0x140 
 [ 1860.742608]  [<ffffffff8155a3e4>] ? packet_bind+0x64/0x90 
 [ 1860.748459]  [<ffffffff814d611e>] ? sys_bind+0x7e/0xd0 
 [ 1860.755926]  [<ffffffff810de865>] ? fd_install+0x25/0x60 
 [ 1860.763614]  [<ffffffff814d6364>] ? sock_map_fd+0x54/0x90 
 [ 1860.768300]  [<ffffffff810eeae9>] ? sys_ioctl+0x49/0x80 
 [ 1860.776603]  [<ffffffff81032682>] ? system_call_fastpath+0x16/0x1b 
 [ 1864.124505] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1864.124505] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1864.124505] CPU 78: 
 [ 1864.124505] Modules linked in: nfs lockd nfs_acl sunrpc 
[ 1864.124505] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1864.124505] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
[ 1864.124505] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1864.124505] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1864.124505] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1864.124505] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
[ 1864.124505] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1864.124505] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1864.124505] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
 00000000000 
 [ 1864.124505] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
[ 1864.124505] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1864.124505] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1864.124505] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1864.124505] Call Trace: 
 [ 1864.124505]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1864.124505]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1864.124505]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1864.124505]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1864.124505]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1864.124505]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1864.124505]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
[ 1864.124505]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1864.124505]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1864.124505]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1931.222027] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1931.222027] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1931.222027] CPU 78: 
 [ 1931.352843] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1931.352843] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1931.375035] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 1931.375035] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1931.397468] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1931.403719] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1931.403719] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
 [ 1931.403719] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1931.403719] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 1931.403719] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
 00000000000 
 [ 1931.403719] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1931.403719] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1931.403719] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 1931.403719] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1931.403719] Call Trace: 
 [ 1931.403719]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1931.403719]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1931.403719]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1931.403719]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1931.403719]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1931.403719]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1931.403719]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1931.403719]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1931.403719]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1931.403719]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1979.921730] BUG: soft lockup - CPU#246 stuck for 61s! [swapper:0] 
 [ 1979.997450] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1980.088250] CPU 246: 
 [ 1980.088250] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1980.306872] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1980.344942] RIP: 0010:[<ffffffff81585d10>]  [<ffffffff81585d10>] _spin_tryloc
 k+0x0/0x30 
 [ 1980.428450] RSP: 0018:ffff893f88c03e18  EFLAGS: 00010206 
 [ 1980.469296] RAX: 0000000000000400 RBX: 00000000000115c0 RCX: 0000000000000400
 [ 1980.469296] RDX: 0000000000000034 RSI: 0000000000000200 RDI: ffffffff81b03134
 [ 1980.469296] RBP: ffffffff81033133 R08: 0000000000000000 R09: 0000000000000000
 [ 1980.469296] R10: 0000000000000000 R11: ffffffff8104b8b0 R12: ffff893f88c03d90
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 [ 198
 k+0x8
 [ 198
 [ 198
 [ 198
 [ 198
   
 [ 1980.848988] R13: ffff893f88c0d740 R14: 0000000000000002 R15: ffffffff81046ea6
 [ 1980.914997] FS:  0000000000000000(0000) GS:ffff893f88c00000(0000) knlGS:00000
 00000000000 
 [ 1980.974445] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1981.014591] INFO: task dhclient:18816 blocked for more than 120 seconds. 
 [ 1981.014619] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
 message. 
 [ 1981.014621] dhclient      D ffffffff8105b4c9     0 18816      1 0x00000000 
 [ 1981.014623]  ffff8830ecfcc000 0000000000000086 0000000000000000 ffffffff810ab
 7b5 
 [ 1981.014625]  ffff8810a7507470 ffff8810a75070c0 ffff8810a7507000 ffff8810a7507
 470 
 [ 1981.014627]  000000010001b475 00000000000006a2 0000000000000001 ffff8810a7df9
 e50 
 [ 1981.014628] Call Trace: 
 [ 1981.014655]  [<ffffffff810ab7b5>] ? __alloc_pages_nodemask+0x105/0x5f0 
 [ 1981.014658]  [<ffffffff8158480b>] ? schedule_timeout+0x18b/0x200 
 [ 1981.014662]  [<ffffffff8103312e>] ? apic_timer_interrupt+0xe/0x20 
[ 1981.014664]  [<ffffffff8152f9b0>] ? udp_ioctl+0x0/0x70 
 [ 1981.014666]  [<ffffffff8129a8a5>] ? cpumask_any_but+0x25/0x40 
 [ 1981.014668]  [<ffffffff81583b11>] ? wait_for_common+0xe1/0x1c0 
 [ 1981.014670]  [<ffffffff81062f30>] ? default_wake_function+0x0/0x10 
 [ 1981.014672]  [<ffffffff8107ccde>] ? synchronize_sched+0x4e/0x60 
 [ 1981.014674]  [<ffffffff8107cc80>] ? wakeme_after_rcu+0x0/0x10 
 [ 1981.014678]  [<ffffffff815595d7>] ? packet_do_bind+0x117/0x140 
 [ 1981.014679]  [<ffffffff8155a3e4>] ? packet_bind+0x64/0x90 
 [ 1981.014682]  [<ffffffff814d611e>] ? sys_bind+0x7e/0xd0 
 [ 1981.014684]  [<ffffffff810de865>] ? fd_install+0x25/0x60 
 [ 1981.014686]  [<ffffffff814d6364>] ? sock_map_fd+0x54/0x90 
 [ 1981.014688]  [<ffffffff810eeae9>] ? sys_ioctl+0x49/0x80 
[ 1981.014690]  [<ffffffff81032682>] ? system_call_fastpath+0x16/0x1b 
 [ 1982.280441] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1982.352604] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1982.401269] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1982.454170] Call Trace: 
 [ 1982.492010]  <IRQ>  [<ffffffff81063635>] ? rebalance_domains+0x2c5/0x470 
 [ 1982.573380]  [<ffffffff8104b8b0>] ? x2apic_send_IPI_mask+0x0/0x90 
 [ 1982.642218]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
 [ 1982.724503]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
 [ 1982.776659]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1982.795125]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 1982.848569]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1982.848569]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1982.848569]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1982.848569]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 1982.848569]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
[ 1982.848569]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1982.848569]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1982.848569]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1982.848569]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 1997.995723] BUG: soft lockup - CPU#78 stuck for 61s! [swapper:0] 
 [ 1998.073588] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1998.073588] CPU 78: 
 [ 1998.073588] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 1998.073588] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 1998.156494] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 1998.156494] RSP: 0018:ffff886169603f00  EFLAGS: 00000206 
 [ 1998.156494] RAX: ffff8adcacfddfd8 RBX: ffff886169603f58 RCX: 000000000000004e
 [ 1998.156494] RDX: 000000000000dea0 RSI: 0000000000008f2a RDI: 0000000000000838
 [ 1998.156494] RBP: ffffffff81033133 R08: ffff88616960b880 R09: 000000000000000a
[ 1998.156494] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff886169603e80
 [ 1998.156494] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
[ 1998.156494] FS:  0000000000000000(0000) GS:ffff886169600000(0000) knlGS:00000
 00000000000 
 [ 1998.156494] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050039 
 [ 1998.156494] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 1998.156494] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1998.156494] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 1998.156494] Call Trace: 
 [ 1998.156494]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 1998.156494]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
[ 1998.156494]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 1998.156494]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 1998.156494]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 1998.156494]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 1998.156494]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 1998.156494]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 1998.156494]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 1998.156494]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 2109.274409] BUG: soft lockup - CPU#240 stuck for 61s! [swapper:0] 
 [ 2109.274409] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2109.274409] CPU 240: 
 [ 2109.274409] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2109.274409] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 2109.274409] RIP: 0010:[<ffffffff8105ac32>]  [<ffffffff8105ac32>] weighted_cpu
 load+0x12/0x20 
[ 2109.274409] RSP: 0018:ffff89468e803c88  EFLAGS: 00010286 
 [ 2109.274409] RAX: 00000000000115c0 RBX: 0000000000000002 RCX: 0000000000000000
 [ 2109.274409] RDX: ffff89274e600000 RSI: 0000000000000002 RDI: 00000000000000d8
 [ 2109.274409] RBP: ffffffff81033133 R08: 00000000000000c0 R09: ffff894f0ca4e428
 [ 2109.274409] R10: 0000000000000001 R11: 0000000000000000 R12: ffff89468e803c00
 [ 2109.274409] R13: 00000000000115c0 R14: ffffffff8104b6dc R15: ffffffff81046ea6
[ 2109.274409] FS:  0000000000000000(0000) GS:ffff89468e800000(0000) knlGS:00000
00000000000 
 [ 2109.274409] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 2109.274409] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 2109.274409] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 2109.274409] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 2109.274409] Call Trace: 
 [ 2109.274409]  <IRQ>  [<ffffffff8105ac6b>] ? source_load+0x2b/0x70 
[ 2109.274409]  [<ffffffff810602d5>] ? find_busiest_group+0x1b5/0xa30 
 [ 2109.274409]  [<ffffffff81063487>] ? rebalance_domains+0x117/0x470 
 [ 2109.274409]  [<ffffffff810a21ad>] ? rcu_process_gp_end+0x4d/0xb0 
 [ 2109.274409]  [<ffffffff81065a4e>] ? run_rebalance_domains+0x3e/0xe0 
 [ 2109.274409]  [<ffffffff8106fbbe>] ? __do_softirq+0xae/0x140 
 [ 2109.274409]  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 2109.274409]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 2109.274409]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 2109.274409]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
[ 2109.274409]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 2109.274409]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 2109.274409]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 2109.274409]  <EOI>  [<ffffffff81061dcc>] ? finish_task_switch+0x2c/0xb0 
[ 2109.274409]  [<ffffffff81583fd7>] ? thread_return+0x3e/0x5a7 
 [ 2109.274409]  [<ffffffff8104dc92>] ? native_safe_halt+0x2/0x10 
 [ 2109.274409]  [<ffffffff8103154f>] ? cpu_idle+0x6f/0x90 
 Internet Systems Consortium DHCP Client V3.0.5-RedHat 
 Copyright 2004-2006 Internet Systems Consortium. 
 All rights reserved. 
For info, please visit http://www.isc.org/sw/dhcp/ 
 /etc/sysconfig/network-scripts/network-functions: line 10: /etc/init.d/functions
 : No such file or directory 
 Listening on LPF/eth0/3c:4a:92:6c:dd:c2 
 Sending on   LPF/eth0/3c:4a:92:6c:dd:c2 
 Sending on   Socket/fallback 
 DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 8 
 No DHCPOFFERS received. 
 Unable to obtain a lease on first try.  Exiting. 
 ERROR! dhclient failed! 
 [ 2186.229066] BUG: soft lockup - CPU#84 stuck for 61s! [swapper:0] 
 [ 2186.229066] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2186.229066] CPU 84: 
 [ 2186.229066] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2186.229066] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 2186.229066] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 2186.229066] RSP: 0018:ffff8878bfa03f00  EFLAGS: 00000206 
 [ 2186.229066] RAX: ffff8898dcffdfd8 RBX: ffff8878bfa03f58 RCX: 0000000000000054
 [ 2186.229066] RDX: 000000000000dea0 RSI: 000000000000d88b RDI: 0000000000000838
 [ 2186.229066] RBP: ffffffff81033133 R08: ffff8878bfa0b880 R09: 0000000000000010
 [ 2186.229066] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff8878bfa03e80
 [ 2186.229066] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 2186.229066] FS:  0000000000000000(0000) GS:ffff8878bfa00000(0000) knlGS:00000
 00000000000 
 [ 2186.229066] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 2186.229066] CR2: 000000308cc9a6e0 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 2186.229066] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 2186.229066] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 2186.229066] Call Trace: 
 [ 2186.229066]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 2186.229066]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 2186.229066]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 2186.229066]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 2186.229066]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 2186.229066]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 2186.229066]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
[ 2186.229066]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 2186.229066]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 2186.229066]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 2186.229066]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 2253.452631] BUG: soft lockup - CPU#84 stuck for 61s! [swapper:0] 
 [ 2253.452631] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2253.452631] CPU 84: 
 [ 2253.452631] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2253.452631] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
[ 2253.452631] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 2253.452631] RSP: 0018:ffff8878bfa03f00  EFLAGS: 00000206 
 [ 2253.452631] RAX: ffff8898dcffdfd8 RBX: ffff8878bfa03f58 RCX: 0000000000000054
 [ 2253.452631] RDX: 000000000000dea0 RSI: 000000000000d88b RDI: 0000000000000838
 [ 2253.452631] RBP: ffffffff81033133 R08: ffff8878bfa0b880 R09: 0000000000000010
 [ 2253.452631] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff8878bfa03e80
 [ 2253.452631] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
[ 2253.452631] FS:  0000000000000000(0000) GS:ffff8878bfa00000(0000) knlGS:00000
 00000000000 
[ 210
 [ 210
 [ 210
 [ 210
 [ 210
 [ 210
 [ 210
 [ 220
 [ 220
 [ 220
 [ 220
 [ 220
+0x60
 [ 220
 [ 220
 [ 220
 [ 220
 [ 220
 [ 220
 00000
  0
 [ 2253.452631] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 2253.452631] CR2: 000000308cc9a6e0 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 2253.452631] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2253.452631] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[ 2253.452631] Call Trace: 
 [ 2253.452631]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 2253.452631]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 2253.452631]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 2253.452631]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
[ 2253.452631]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
[ 2253.452631]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 2253.452631]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 2253.452631]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
[ 2253.452631]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 2253.452631]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 2253.452631]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 2319.403798] BUG: soft lockup - CPU#84 stuck for 61s! [swapper:0] 
 [ 2319.403798] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2319.403798] CPU 84: 
 [ 2319.403798] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2319.403798] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 2319.403798] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 2319.403798] RSP: 0018:ffff8878bfa03f00  EFLAGS: 00000206 
 [ 2319.403798] RAX: ffff8898dcffdfd8 RBX: ffff8878bfa03f58 RCX: 0000000000000054
 [ 2319.403798] RDX: 000000000000dea0 RSI: 000000000000d88b RDI: 0000000000000838
 [ 2319.403798] RBP: ffffffff81033133 R08: ffff8878bfa0b880 R09: 0000000000000010
 [ 2319.403798] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff8878bfa03e80
 [ 2319.403798] R13: 0000000000000282 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 2319.403798] FS:  0000000000000000(0000) GS:ffff8878bfa00000(0000) knlGS:00000
 00000000000 
 [ 2319.403798] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 2319.403798] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 2319.403798] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 2319.403798] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[ 2319.403798] Call Trace: 
 [ 2319.403798]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 2319.403798]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 2319.403798]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 2319.403798]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 2319.403798]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 2319.403798]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 2319.403798]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 2319.403798]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 2319.403798]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 2319.403798]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 2319.403798]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 2410.734721] BUG: soft lockup - CPU#84 stuck for 62s! [swapper:0] 
 [ 2410.734721] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2410.734721] CPU 84: 
 [ 2410.734721] Modules linked in: nfs lockd nfs_acl sunrpc 
 [ 2410.734721] Pid: 0, comm: swapper Not tainted 2.6.32.19-3.vSMP #2 vSMP 3.5 
 [ 2410.734721] RIP: 0010:[<ffffffff8106fb73>]  [<ffffffff8106fb73>] __do_softirq
 +0x63/0x140 
 [ 2410.734721] RSP: 0018:ffff8878bfa03f00  EFLAGS: 00000206 
 [ 2410.734721] RAX: ffff8898dcffdfd8 RBX: ffff8878bfa03f58 RCX: 0000000000000054
 [ 2410.734721] RDX: 000000000000dea0 RSI: 0000000000002258 RDI: 0000000000000838
 [ 2410.734721] RBP: ffffffff81033133 R08: ffff8878bfa0b880 R09: 0000000000000010
 [ 2410.875847] R10: 0000000000000000 R11: ffffffff81046900 R12: ffff8878bfa03e80
 [ 2410.875847] R13: 0000000000000082 R14: ffffffff8104b6dc R15: ffffffff81046ea6
 [ 2410.875847] FS:  0000000000000000(0000) GS:ffff8878bfa00000(0000) knlGS:00000
 00000000000 
 [ 2410.875847] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b 
 [ 2410.875847] CR2: ffff8800000b8ef8 CR3: 0000000001001000 CR4: 00000000000026e0
 [ 2410.875847] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 [ 2410.875847] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 [ 2410.875847] Call Trace: 
 [ 2410.875847]  <IRQ>  [<ffffffff81085da0>] ? ktime_get+0x50/0xd0 
 [ 2410.985474]  [<ffffffff8103374c>] ? call_softirq+0x1c/0x30 
 [ 2410.985474]  [<ffffffff81035745>] ? do_softirq+0x65/0xa0 
 [ 2410.985474]  [<ffffffff8106fb0c>] ? irq_exit+0x7c/0x80 
 [ 2410.985474]  [<ffffffff81046eab>] ? smp_apic_timer_interrupt+0x6b/0xa0 
 [ 2410.985474]  [<ffffffff8104b6dc>] ? native_apic_msr_write+0x2c/0x40 
 [ 2410.985474]  [<ffffffff81033133>] ? apic_timer_interrupt+0x13/0x20 
 [ 2410.985474]  <EOI>  [<ffffffff81046900>] ? lapic_next_event+0x0/0x20 
 [ 2410.985474]  [<ffffffff8108a9dd>] ? tick_nohz_restart_sched_tick+0x14d/0x160 
 [ 2411.046196]  [<ffffffff8108a98b>] ? tick_nohz_restart_sched_tick+0xfb/0x160 
 [ 2411.046196]  [<ffffffff8103154a>] ? cpu_idle+0x6a/0x90 
 [ 2457.329801] Kernel panic - not syncing: Attempted to kill init! 
 [ 2457.331048] Pid: 1, comm: init Not tainted 2.6.32.19-3.vSMP #2 
 [ 2457.331329] Call Trace: 
 [ 2457.331530]  [<ffffffff8106a7d6>] ? panic+0x86/0x160 
 [ 2457.331776]  [<ffffffff810738df>] ? exit_ptrace+0x2f/0x120 
 [ 2457.332026]  [<ffffffff8106dd2d>] ? do_exit+0x5ed/0x720 
 [ 2457.332262]  [<ffffffff8106de99>] ? do_group_exit+0x39/0xa0 
 [ 2457.332515]  [<ffffffff8106df12>] ? sys_exit_group+0x12/0x20 
 [ 2457.332770]  [<ffffffff81032682>] ? system_call_fastpath+0x16/0x1b 


