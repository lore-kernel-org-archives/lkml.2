Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2AQXWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:22:08 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:52655 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2AQXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:22:07 -0500
MIME-Version: 1.0
Date: Wed, 18 Jan 2012 00:22:05 +0100
X-Google-Sender-Auth: ysKXIMxtC1RftSa7tgxljGypzjU
Message-ID: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
Subject: rt-kernel 3.0.14-rt31: BUG: sleeping function called from invalid context
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a whole bunch of these in 3.0.14-rt31 that basically look alike.
Will try to drill deeper down. In the meantime, I'm happy to provide
more information if anyone would like.
Thanks, John

[ 4251.928097] BUG: sleeping function called from invalid context at
/home/jkacur/rt.linux.git/kernel/rtmutex.c:645
[ 4251.928100] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
[ 4251.928102] INFO: lockdep is turned off.
[ 4251.928103] irq event stamp: 5888
[ 4251.928104] hardirqs last  enabled at (5887): [<ffffffff810b2a69>]
rcu_preempt_note_context_switch+0x1c8/0x1d9
[ 4251.928109] hardirqs last disabled at (5888): [<ffffffff813e4326>]
_raw_spin_lock_irq+0x19/0x79
[ 4251.928113] softirqs last  enabled at (0): [<ffffffff81041c88>]
copy_process+0x517/0xfbd
[ 4251.928116] softirqs last disabled at (0): [<          (null)>]
      (null)
[ 4251.928119] Pid: 168, comm: irq/9-acpi Not tainted
3.0.14-rt31-debug-00322-g6aaac97b #1
[ 4251.928121] Call Trace:
[ 4251.928125]  [<ffffffff81037b06>] __might_sleep+0xf4/0xf9
[ 4251.928128]  [<ffffffff8107e4f5>] rt_spin_lock_fastlock.clone.0+0x24/0x31
[ 4251.928130]  [<ffffffff813e3b33>] rt_spin_lock+0x16/0x40
[ 4251.928133]  [<ffffffff8103eb60>] __wake_up+0x28/0x50
[ 4251.928136]  [<ffffffff8122ca51>] acpi_ec_gpe_handler+0x72/0xc4
[ 4251.928145]  [<ffffffff81238443>] acpi_ev_gpe_dispatch+0xbd/0x12e
[ 4251.928147]  [<ffffffff81238727>] acpi_ev_gpe_detect+0xbb/0x110
[ 4251.928150]  [<ffffffff81236e88>] acpi_ev_sci_xrupt_handler+0x22/0x2b
[ 4251.928152]  [<ffffffff81226e5e>] acpi_irq+0x16/0x31
[ 4251.928155]  [<ffffffff810adcab>] irq_forced_thread_fn+0x25/0x45
[ 4251.928157]  [<ffffffff813e45d1>] ? _raw_spin_unlock_irq+0x50/0x5e
[ 4251.928159]  [<ffffffff810adaee>] irq_thread+0xff/0x1e9
[ 4251.928162]  [<ffffffff810adc86>] ? exit_irq_thread+0x74/0x74
[ 4251.928164]  [<ffffffff810ad9ef>] ? irq_finalize_oneshot+0xaf/0xaf
[ 4251.928166]  [<ffffffff810ad9ef>] ? irq_finalize_oneshot+0xaf/0xaf
[ 4251.928169]  [<ffffffff81062b48>] kthread+0x94/0x9c
[ 4251.928171]  [<ffffffff813e1f99>] ? preempt_schedule+0x4b/0x53
[ 4251.928174]  [<ffffffff813e45da>] ? _raw_spin_unlock_irq+0x59/0x5e
[ 4251.928177]  [<ffffffff813ebb54>] kernel_thread_helper+0x4/0x10
[ 4251.928180]  [<ffffffff813e4984>] ? retint_restore_args+0xe/0xe
[ 4251.928182]  [<ffffffff81062ab4>] ? kthreadd+0x168/0x168
[ 4251.928184]  [<ffffffff813ebb50>] ? gs_change+0xb/0xb
