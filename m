Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1BJOP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:15:56 -0500
Received: from mx1.guavus.com ([204.232.241.167]:7210 "EHLO mx1.guavus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab1BJOPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:15:54 -0500
From: Preeti Khurana <Preeti.Khurana@guavus.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.35-45.fc14 :rcu_sched_state detected stall on CPU
Thread-Topic: 2.6.35-45.fc14 :rcu_sched_state detected stall on CPU
Thread-Index: AcvJLTEqg7Ofzp5iR76yzG3JG4qqnA==
Date: Thu, 10 Feb 2011 14:11:38 +0000
Message-ID: <9F0C2539CB50A743894F8FCEEB1D569206F217@mx1.guavus.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upgraded the kernel from 2.6.26 to 2.6.35 and getting these error messages in syslog and the system  hangs. The machine (Intel Xeon) became unresponsive.  Downgraded the kernel after this since it was a customer box. Never encountered the issue locally ever.


Here  are the logs.. Unfortunately there are no dmesg logs available.


Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: INFO: rcu_sched_state detected stall on CPU 0 (t=10000 jiffies)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 667, comm: kswapd0 Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 10, t=10323 jiffies)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff8120e42f>]  [<ffffffff8120e42f>] delay_tsc+0x37/0x7c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880695203d30  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 00000000000000b8 RBX: 0000000000000000 RCX: 0000000006364684
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000006364684 RSI: 0000000000000001 RDI: 0000000000040f17
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880695203d68 R08: 0000000000000040 R09: ffffffff81b2ed20
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffffffff81cc1da5 R11: 0000000000000005 R12: 0000000000040f17
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000000 R14: 00000000063645cc R15: ffffffff81b2ed20
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880695200000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 00007fb4e40db790 CR3: 000000074090b000 CR4: 00000000000006f0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process kswapd0 (pid: 667, threadinfo ffff880c7c3b4000, task ffff880c7c3c96b0)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  000000008103d875 0000003000000008 ffff880695203e18 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> 0000000000001000 0000000000000001 ffffffff81060000 ffff880695203d78
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffffffff8120e3b5 ffff880695203d88 ffffffff8120e3f6 ffff880695203da8
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <IRQ>
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060000>] ? tick_notify+0x18f/0x358
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3b5>] __delay+0xa/0xc
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3f6>] __const_udelay+0x3f/0x41
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81019a2b>] native_safe_apic_wait_icr_idle+0x31/0x45
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a412>] default_send_IPI_mask_sequence_phys+0x54/0xbe
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81008b07>] ? native_sched_clock+0x31/0x6a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc82>] physflat_send_IPI_mask+0x9/0xb
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc98>] physflat_send_IPI_all+0x14/0x16
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a6d0>] arch_trigger_all_cpu_backtrace+0x3c/0x5e
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090031>] __rcu_pending+0x80/0x301
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090496>] rcu_check_callbacks+0x85/0xb6
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810481bd>] update_process_times+0x3a/0x5a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060fea>] tick_sched_timer+0x73/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8105796d>] __run_hrtimer+0xd9/0x13a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81057bb1>] hrtimer_interrupt+0xae/0x191
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a0d6>] smp_apic_timer_interrupt+0x83/0x99
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81003453>] apic_timer_interrupt+0x13/0x20
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <EOI>
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810b8968>] ? sleeping_prematurely+0x69/0x6b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba7ef>] kswapd+0x13c/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054e80>] ? autoremove_wake_function+0x0/0x38
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba6b3>] ? kswapd+0x0/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054b2a>] kthread+0x7d/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a4>] kernel_thread_helper+0x4/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054aad>] ? kthread+0x0/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a0>] ? kernel_thread_helper+0x0/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: fc 53 48 83 ec 18 65 8b 04 25 c0 d3 00 00 89 45 cc 66 66 90 0f ae e8 e8 1f af df ff 66 90 44 8b 6d cc 4c 63 f0 66 66 90 0f ae e8 <e8> 0b af df ff 66 90 48 98 4c 29 f0 4c 39 e0 73 27 f3 90 65 8b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <IRQ>  [<ffffffff81060000>] ? tick_notify+0x18f/0x358
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3b5>] __delay+0xa/0xc
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3f6>] __const_udelay+0x3f/0x41
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81019a2b>] native_safe_apic_wait_icr_idle+0x31/0x45
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a412>] default_send_IPI_mask_sequence_phys+0x54/0xbe
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81008b07>] ? native_sched_clock+0x31/0x6a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc82>] physflat_send_IPI_mask+0x9/0xb
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc98>] physflat_send_IPI_all+0x14/0x16
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a6d0>] arch_trigger_all_cpu_backtrace+0x3c/0x5e
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090031>] __rcu_pending+0x80/0x301
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090496>] rcu_check_callbacks+0x85/0xb6
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810481bd>] update_process_times+0x3a/0x5a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060fea>] tick_sched_timer+0x73/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8105796d>] __run_hrtimer+0xd9/0x13a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81057bb1>] hrtimer_interrupt+0xae/0x191
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a0d6>] smp_apic_timer_interrupt+0x83/0x99
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81003453>] apic_timer_interrupt+0x13/0x20
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <EOI>  [<ffffffff810b8968>] ? sleeping_prematurely+0x69/0x6b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba7ef>] kswapd+0x13c/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054e80>] ? autoremove_wake_function+0x0/0x38
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba6b3>] ? kswapd+0x0/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054b2a>] kthread+0x7d/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a4>] kernel_thread_helper+0x4/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054aad>] ? kthread+0x0/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a0>] ? kernel_thread_helper+0x0/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 667, comm: kswapd0 Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e42f>] ? delay_tsc+0x37/0x7c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  <IRQ>  [<ffffffff81060000>] ? tick_notify+0x18f/0x358
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3b5>] __delay+0xa/0xc
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8120e3f6>] __const_udelay+0x3f/0x41
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81019a2b>] native_safe_apic_wait_icr_idle+0x31/0x45
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a412>] default_send_IPI_mask_sequence_phys+0x54/0xbe
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81008b07>] ? native_sched_clock+0x31/0x6a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc82>] physflat_send_IPI_mask+0x9/0xb
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101cc98>] physflat_send_IPI_all+0x14/0x16
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a6d0>] arch_trigger_all_cpu_backtrace+0x3c/0x5e
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090031>] __rcu_pending+0x80/0x301
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060f77>] ? tick_sched_timer+0x0/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81090496>] rcu_check_callbacks+0x85/0xb6
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810481bd>] update_process_times+0x3a/0x5a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81060fea>] tick_sched_timer+0x73/0x9c
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8105796d>] __run_hrtimer+0xd9/0x13a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81057bb1>] hrtimer_interrupt+0xae/0x191
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff8101a0d6>] smp_apic_timer_interrupt+0x83/0x99
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81003453>] apic_timer_interrupt+0x13/0x20
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <EOI>  [<ffffffff810b8968>] ? sleeping_prematurely+0x69/0x6b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba7ef>] kswapd+0x13c/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054e80>] ? autoremove_wake_function+0x0/0x38
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810ba6b3>] ? kswapd+0x0/0x5c9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054b2a>] kthread+0x7d/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a4>] kernel_thread_helper+0x4/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81054aad>] ? kthread+0x0/0x85
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810038a0>] ? kernel_thread_helper+0x0/0x10
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 1
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 21 on CPU 0.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 1
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7cc9be78  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 0000000000000020 RBX: 1200509030e751aa RCX: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7cc9bfd8 RDI: ffff880c7cc9a010
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880c7cc9be98 R08: 0000000000000000 R09: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffff880c7cc9bedc R11: ffff880741a03858 R12: 0000000000000020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 00007fba0b61a268 CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7cc9a000, task ffff880c7cc94410)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  1200509030e751aa ffff88067cf384b0 ffff88067cf38020 ffff88067cf38000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7cc9bea8 ffffffff810182f9 ffff880c7cc9bee8 ffffffff812646df
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7cc9bee8 ffffffff813c1660 ffff88067cf380f0 ffff88067cf38020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 2
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 1.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 2
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7cca7e78  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 0000000000000020 RBX: 1200509030f0b6c6 RCX: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7cca7fd8 RDI: ffff880c7cca6010
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880c7cca7e98 R08: 0000000000000000 R09: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffff880c7cca7d98 R11: ffff880c7ba91d88 R12: 0000000000000020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880695220000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 00007f167c0ca000 CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7cca6000, task ffff880c7ccaad60)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  1200509030f0b6c6 ffff88067cf38cb0 ffff88067cf38820 ffff88067cf38800
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7cca7ea8 ffffffff810182f9 ffff880c7cca7ee8 ffffffff812646df
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7cca7ee8 ffffffff813c1660 ffff88067cf388f0 ffff88067cf38820
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 3
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 2.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 3
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7ccb7e78  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 0000000000000020 RBX: 1200509030e7560a RCX: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7ccb7fd8 RDI: ffff880c7ccb6010
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880c7ccb7e98 R08: 0000000000000000 R09: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffff880c7ccb7edc R11: ffff880740b23a58 R12: 0000000000000020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880002020000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 00007fba0ff25190 CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7ccb6000, task ffff880c7ccb96b0)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  1200509030e7560a ffff88067cf394b0 ffff88067cf39020 ffff88067cf39000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccb7ea8 ffffffff810182f9 ffff880c7ccb7ee8 ffffffff812646df
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccb7ee8 ffffffff813c1660 ffff88067cf390f0 ffff88067cf39020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 3.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7ccd3e78  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 0000000000000020 RBX: 1200509030e4d467 RCX: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7ccd3fd8 RDI: ffff880c7ccd2010
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880c7ccd3e98 R08: 0000000000000000 R09: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffff880c7ccd3edc R11: ffff88067b33ba58 R12: 0000000000000020
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880695240000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 0000000001e8931c CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7ccd2000, task ffff88067cc80000)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  1200509030e4d467 ffff88067cf39cb0 ffff88067cf39820 ffff88067cf39800
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccd3ea8 ffffffff810182f9 ffff880c7ccd3ee8 ffffffff812646df
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccd3ee8 ffffffff813c1660 ffff88067cf398f0 ffff88067cf39820
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 5
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 4.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CPU 5
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7ccdbe68  EFLAGS: 00000046
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RAX: 0000000000000000 RBX: 120050901e9aae9b RCX: 0000000000000001
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7ccdbfd8 RDI: ffff880c7ccda010
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: RBP: ffff880c7ccdbe88 R08: 0000000000000002 R09: 000000000000000b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R10: ffff88067cc82d60 R11: ffff88067a951a58 R12: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880002040000(0000) knlGS:0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: CR2: 00007f167c0cc000 CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7ccda000, task ffff88067cc85ac0)
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  120050901e9aae9b ffff88067cf3a460 ffff88067cf3a000 0000000000000000
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccdbe98 ffffffff810182f9 ffff880c7ccdbee8 ffffffff812642e4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccdbee8 ffffffff81b2ed20 ffff880c7ccdbee8 ffffffff813c1660
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812642e4>] acpi_idle_enter_c1+0x79/0xe4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812642e4>] acpi_idle_enter_c1+0x79/0xe4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff812642e4>] acpi_idle_enter_c1+0x79/0xe4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 6
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 5.
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:55 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: CPU 6
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Modules linked in: bond1 deflate zlib_deflate aes_generic ecb af_key 8021q sbs sbshc battery ac serio_raw tpm_tis tpm tpm_bios iTCO_wdt iTCO_vendor_support [last unloaded: bond1]
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus 0XDN97/PowerEdge R610
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: RIP: 0010:[<ffffffff81009e5e>]  [<ffffffff81009e5e>] mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: RSP: 0018:ffff880c7ccefe78  EFLAGS: 00000046
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: RAX: 0000000000000020 RBX: 1200509030b629c9 RCX: 0000000000000001
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: RDX: 0000000000000000 RSI: ffff880c7cceffd8 RDI: ffff880c7ccee010
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: RBP: ffff880c7ccefe98 R08: 0000000000000000 R09: 0000000000000001
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: R10: ffff880c7ccefedc R11: ffff88067cce1a58 R12: 0000000000000020
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: FS:  0000000000000000(0000) GS:ffff880695260000(0000) knlGS:0000000000000000
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: CR2: 00007f7a92e50000 CR3: 0000000001ab0000 CR4: 00000000000006e0
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Process swapper (pid: 0, threadinfo ffff880c7ccee000, task ffff880c7cce4410)
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Stack:
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  1200509030b629c9 ffff88067cf3acb0 ffff88067cf3a820 ffff88067cf3a800
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccefea8 ffffffff810182f9 ffff880c7ccefee8 ffffffff812646df
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: <0> ffff880c7ccefee8 ffffffff813c1660 ffff88067cf3a8f0 ffff88067cf3a820
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Code: 23 02 74 07 0f ae be 38 e0 ff ff 31 c9 48 89 f8 48 89 ca 0f 01 c8 0f ae f0 f6 86 38 e0 ff ff 08 75 09 4c 89 e0 4c 89 f1 0f 01 c9 <5b> 41 5c 41 5d 41 5e c9 c3 55 65 48 8b 04 25 48 b5 00 00 48 89
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Pid: 0, comm: swapper Not tainted 2.6.35-45.fc14GUAVUSsmp guavus
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Call Trace:
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  <NMI>  [<ffffffff81009990>] ? show_regs+0x26/0x2a
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814af2ad>] nmi_watchdog_tick+0xcc/0x1a9
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae692>] do_nmi+0xa6/0x258
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814ae2d0>] nmi+0x20/0x30
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff81009e5e>] ? mwait_idle_with_hints+0xa0/0xa9
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  <<EOE>>  [<ffffffff810182f9>] acpi_processor_ffh_cstate_enter+0x2d/0x2f
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff812646df>] acpi_idle_enter_bm+0x1d6/0x28b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c1660>] ? menu_select+0x186/0x2b0
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff813c08b7>] cpuidle_idle_call+0x8b/0xec
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff81001ad6>] cpu_idle+0x58/0x7b
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel:  [<ffffffff814a7d39>] start_secondary+0x1bf/0x1c4
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: NMI backtrace for cpu 7
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Uhhuh. NMI received for unknown reason 00 on CPU 6.
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Do you have a strange power saving mode enabled?
Feb  8 00:34:58 GNS-SRV-CMP-009 kernel: Dazed and confused, but trying to continue


What could be the probable reason of cpu stalling here? Is it some known bug or settings ?


Thanks
Preeti

P.S : Kindly CC me explicitly in response to this query.



