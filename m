Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1DOO6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:58:02 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:45040 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1DOO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:58:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2011-04-14 - lockdep splats in sched.c during boot
In-Reply-To: Your message of "Thu, 14 Apr 2011 15:08:47 PDT."
             <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201104142244.p3EMiWTC010977@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302879429_4860P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Apr 2011 10:57:09 -0400
Message-ID: <9629.1302879429@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DA85CC7.0112,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302879429_4860P
Content-Type: text/plain; charset=us-ascii

On Thu, 14 Apr 2011 15:08:47 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2011-04-14-15-08 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

This throws at least two complaints about lockdep on the way up.  I've had
several complete hangs as well last night during boot following a WARN in
sched.c, but didn't have netconsole or a camera handy at the time.  Will follow up if I
catch one. Both whinges point at a 'for_each_domain()'. Not sure why I
haven't seen mention on lkml before - what am I doing different?

Splat number 1:
[    0.044382] smpboot cpu 1: start_ip = 99000
[    0.002999] calibrate_delay_direct() timer_rate_max=2526877 timer_rate_min=2526840 pre_start=520283431585 pre_end=520308700132
[    0.002999] calibrate_delay_direct() timer_rate_max=2526857 timer_rate_min=2526829 pre_start=520313753438 pre_end=520339021871
[    0.002999] calibrate_delay_direct() timer_rate_max=2526851 timer_rate_min=2526824 pre_start=520344075709 pre_end=520369344094
[    0.002999] calibrate_delay_direct() timer_rate_max=2526862 timer_rate_min=2526834 pre_start=520374397819 pre_end=520399666308
[    0.002999] calibrate_delay_direct() timer_rate_max=2526864 timer_rate_min=2526836 pre_start=520404719957 pre_end=520429988465
[    0.116010] 
[    0.116011] ===================================================
[    0.116989] [ INFO: suspicious rcu_dereference_check() usage. ]
[    0.116989] ---------------------------------------------------
[    0.116989] kernel/sched.c:2426 invoked rcu_dereference_check() without protection!
[    0.116989] 
[    0.116989] other info that might help us debug this:
[    0.116989] 
[    0.116989] 
[    0.116989] rcu_scheduler_active = 1, debug_locks = 1
[    0.116989] 2 locks held by swapper/1:
[    0.116989]  #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810394d2>] cpu_maps_update_begin+0x12/0x14
[    0.116989]  #1:  (&p->pi_lock){-.....}, at: [<ffffffff81032959>] try_to_wake_up+0x29/0x1aa
[    0.116989] 
[    0.116989] stack backtrace:
[    0.116989] Pid: 1, comm: swapper Not tainted 2.6.39-rc3-mmotm0414 #1
[    0.116989] Call Trace:
[    0.116989]  [<ffffffff81065bfc>] lockdep_rcu_dereference+0x9b/0xa4
[    0.116989]  [<ffffffff8102acd0>] ttwu_stat+0xcc/0xf5
[    0.116989]  [<ffffffff81032ab5>] try_to_wake_up+0x185/0x1aa
[    0.116989]  [<ffffffff81b5540a>] ? migration_call+0x9e/0xd0
[    0.116989]  [<ffffffff81564643>] ? _raw_spin_unlock_irqrestore+0x46/0x80
[    0.116989]  [<ffffffff81032b06>] wake_up_process+0x10/0x12
[    0.116989]  [<ffffffff81b56207>] cpu_stop_cpu_callback+0xe5/0x11b
[    0.116989]  [<ffffffff81567abe>] notifier_call_chain+0x54/0x81
[    0.116989]  [<ffffffff810596bc>] __raw_notifier_call_chain+0x9/0xb
[    0.116989]  [<ffffffff815434d1>] __cpu_notify+0x1b/0x2d
[    0.116989]  [<ffffffff81b55709>] _cpu_up.constprop.0+0xd1/0xe5
[    0.116989]  [<ffffffff81b55757>] cpu_up+0x3a/0x47
[    0.116989]  [<ffffffff81b2f3d2>] smp_init+0x41/0x93
[    0.116989]  [<ffffffff81b1dbc5>] kernel_init+0x9d/0x15b
[    0.116989]  [<ffffffff8156bb94>] kernel_thread_helper+0x4/0x10
[    0.116989]  [<ffffffff81564d84>] ? retint_restore_args+0xe/0xe
[    0.116989]  [<ffffffff81b1db28>] ? start_kernel+0x394/0x394
[    0.116989]  [<ffffffff8156bb90>] ? gs_change+0xb/0xb
[    0.117089] NMI watchdog enabled, takes one hw-pmu counter.
[    0.119006] Brought up 2 CPUs

Splat number 2:
[    1.179319] netconsole: remote ethernet address 00:b0:d0:c3:bd:a7
[    1.179430] netconsole: device eth0 not up yet, forcing it
[    1.247705] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    1.298111] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    1.298312] 
[    1.298313] ===================================================
[    1.298516] [ INFO: suspicious rcu_dereference_check() usage. ]
[    1.298623] ---------------------------------------------------
[    1.298731] kernel/sched.c:1211 invoked rcu_dereference_check() without protection!
[    1.298858] 
[    1.298858] other info that might help us debug this:
[    1.298859] 
[    1.299152] 
[    1.299152] rcu_scheduler_active = 1, debug_locks = 1
[    1.299294] 1 lock held by swapper/0:
[    1.299294]  #0:  (&(&base->lock)->rlock){-.-.-.}, at: [<ffffffff810443fd>] lock_timer_base+0x49/0x92
[    1.299294] 
[    1.299294] stack backtrace:
[    1.299294] Pid: 0, comm: swapper Not tainted 2.6.39-rc3-mmotm0414 #1
[    1.299294] Call Trace:
[    1.299294]  <IRQ>  [<ffffffff81065bfc>] lockdep_rcu_dereference+0x9b/0xa4
[    1.299294]  [<ffffffff810337a7>] get_nohz_timer_target+0x79/0xbe
[    1.299294]  [<ffffffff810452ec>] __mod_timer+0xc7/0x16d
[    1.299294]  [<ffffffff810454bf>] mod_timer+0x87/0x8e
[    1.299294]  [<ffffffff8130814c>] e1000_intr_msi+0xa2/0xef
[    1.299294]  [<ffffffff8108acab>] handle_irq_event_percpu+0xba/0x29f
[    1.299294]  [<ffffffff8108aecc>] handle_irq_event+0x3c/0x5c
[    1.299294]  [<ffffffff810193c6>] ? ack_APIC_irq+0x10/0x12
[    1.299294]  [<ffffffff8108d197>] handle_edge_irq+0xf4/0x121
[    1.299294]  [<ffffffff810031aa>] handle_irq+0x122/0x133
[    1.299294]  [<ffffffff81002fdf>] do_IRQ+0x48/0xa0
[    1.299294]  [<ffffffff81564cd3>] common_interrupt+0x13/0x13
[    1.299294]  <EOI>  [<ffffffff81008009>] ? default_idle+0x52/0x89
[    1.299294]  [<ffffffff81008007>] ? default_idle+0x50/0x89
[    1.299294]  [<ffffffff8100084c>] cpu_idle+0x87/0x102
[    1.299294]  [<ffffffff81535587>] rest_init+0xcb/0xd2
[    1.299294]  [<ffffffff815354bc>] ? csum_partial_copy_generic+0x16c/0x16c
[    1.299294]  [<ffffffff81b1db1d>] start_kernel+0x389/0x394
[    1.299294]  [<ffffffff81b1d29f>] x86_64_start_reservations+0xaf/0xb3
[    1.299294]  [<ffffffff81b1d393>] x86_64_start_kernel+0xf0/0xf7
[    1.309814] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)


--==_Exmh_1302879429_4860P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqFzFcC3lWbTT17ARAjZXAKCovK3iHOfj/joUAwuxHKC0IIO21gCg4HbI
B4sgJD3MgQ48Xi/QxXAcAhU=
=vHam
-----END PGP SIGNATURE-----

--==_Exmh_1302879429_4860P--

