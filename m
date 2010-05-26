Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0EZPoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:44:11 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:46244 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0EZPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:44:08 -0400
Date: Wed, 26 May 2010 17:45:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dagmar Volkmann <dagmar.volkmann@de.ibm.com>
Subject: rcu: inet_timewait_sock.h:227 invoked rcu_dereference_check()
 without protection
Message-ID: <20100526154507.GC2232@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

we got the following RCU trace here while doing some tests with 2.6.34
vanilla with some extra patches on top, but which do not touch RCU nor
inet code.
Would be nice if you could have a look at it.

May 21 09:05:16 h0515017 kernel: ===================================================
May 21 09:05:16 h0515017 kernel: [ INFO: suspicious rcu_dereference_check() usage. ]
May 21 09:05:16 h0515017 kernel: ---------------------------------------------------
May 21 09:05:16 h0515017 kernel: /home/autobuild/BUILD/linux-2.6.34-20100520/include/net/inet_timewait_sock.h:227 invoked rcu_dereference_check() without protection!
May 21 09:05:16 h0515017 kernel:
May 21 09:05:16 h0515017 kernel: other info that might help us debug this:
May 21 09:05:16 h0515017 kernel:
May 21 09:05:16 h0515017 kernel:
May 21 09:05:16 h0515017 kernel: rcu_scheduler_active = 1, debug_locks = 0
May 21 09:05:16 h0515017 kernel: 1 lock held by swapper/0:
May 21 09:05:16 h0515017 kernel: #0:  (/home/autobuild/BUILD/linux-2.6.34-20100520/net/ipv4/tcp_minisocks.c:41){+.-...}, at: [<0000000000158398>] run_timer_softirq+0x1b4/0x354
May 21 09:05:16 h0515017 kernel:
May 21 09:05:16 h0515017 kernel: stack backtrace:
May 21 09:05:16 h0515017 kernel: CPU: 0 Not tainted 2.6.34-42.x.20100520-s390xdefault #1
May 21 09:05:16 h0515017 kernel: Process swapper (pid: 0, task: 0000000000812a18, ksp: 0000000000807e00)
May 21 09:05:16 h0515017 kernel: 0000000000000000 000000003ffa7bc8 0000000000000002 0000000000000000
May 21 09:05:16 h0515017 kernel:       000000003ffa7c68 000000003ffa7be0 000000003ffa7be0 000000000056ba7c
May 21 09:05:16 h0515017 kernel:       0000000000000000 0000000000000002 00000000000002d8 0000000000000000
May 21 09:05:16 h0515017 kernel:       000000000000000d 0000000000000000 000000003ffa7c38 000000000000000e
May 21 09:05:16 h0515017 kernel:       00000000005c48a8 0000000000105a20 000000003ffa7bc8 000000003ffa7c10
May 21 09:05:16 h0515017 kernel: Call Trace:
May 21 09:05:16 h0515017 kernel: ([<000000000010596e>] show_trace+0x142/0x148)
May 21 09:05:16 h0515017 kernel: [<00000000004a5068>] __inet_twsk_kill+0x140/0x14c
May 21 09:05:16 h0515017 kernel: [<00000000004a566c>] inet_twdr_do_twkill_work+0x90/0x130
May 21 09:05:16 h0515017 kernel: [<00000000004a585a>] inet_twdr_hangman+0x5e/0xec
May 21 09:05:16 h0515017 kernel: [<000000000015842a>] run_timer_softirq+0x246/0x354
May 21 09:05:16 h0515017 kernel: [<00000000001514ae>] __do_softirq+0xfa/0x1b8
May 21 09:05:16 h0515017 kernel: [<0000000000112608>] do_softirq+0xe4/0xe8
May 21 09:05:16 h0515017 kernel: [<0000000000150f3c>] irq_exit+0xc0/0xe0
May 21 09:05:16 h0515017 kernel: [<000000000010f9ce>] do_extint+0x126/0x17c
May 21 09:05:16 h0515017 kernel: [<0000000000119e5c>] ext_no_vtime+0x28/0x2c
May 21 09:05:16 h0515017 kernel: [<0000000000116c10>] vtime_stop_cpu+0xac/0x100
May 21 09:05:16 h0515017 kernel: ([<0000000000116bb6>] vtime_stop_cpu+0x52/0x100)
May 21 09:05:16 h0515017 kernel: [<000000000010c1a8>] cpu_idle+0xf8/0x190
May 21 09:05:16 h0515017 kernel: [<0000000000859cf0>] start_kernel+0x3b4/0x418
May 21 09:05:16 h0515017 kernel: [<0000000000100020>] _stext+0x20/0x80
May 21 09:05:16 h0515017 kernel: INFO: lockdep is turned off.

Thanks,
Heiko
