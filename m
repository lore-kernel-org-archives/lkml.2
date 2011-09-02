Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab1IBBxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:53:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62669 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab1IBBxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:53:37 -0400
Date: Fri, 2 Sep 2011 03:53:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: linux-next RCU complaint during boot
Message-ID: <20110902015330.GA28121@somewhere.redhat.com>
References: <8867.1314894817@turing-police.cc.vt.edu>
 <20110902014424.GB2405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902014424.GB2405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 06:44:24PM -0700, Paul E. McKenney wrote:
> On Thu, Sep 01, 2011 at 12:33:37PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > Seen during boot of linux-next 20110831:
> > 
> > [    8.823047] ------------[ cut here ]------------
> > [    8.823177] WARNING: at kernel/rcutree.c:1821 rcu_needs_cpu_quick_check+0x6e/0x204()
> > [    8.823314] Hardware name: Latitude E6500
> > [    8.823418] Modules linked in:
> > [    8.823601] Pid: 0, comm: swapper Not tainted 3.1.0-rc4-next-20110831-dirty #11
> > [    8.823724] Call Trace:
> > [    8.823824]  <IRQ>  [<ffffffff81039682>] warn_slowpath_common+0x7e/0x96
> > [    8.824015]  [<ffffffff81092467>] ? note_new_gpnum+0x32/0x96
> > [    8.824034]  [<ffffffff810396af>] warn_slowpath_null+0x15/0x17
> > [    8.824034]  [<ffffffff810917de>] rcu_needs_cpu_quick_check+0x6e/0x204
> > [    8.824034]  [<ffffffff81093df8>] rcu_needs_cpu+0x9/0xd
> > [    8.824034]  [<ffffffff81065933>] tick_nohz_stop_sched_tick+0x20a/0x420
> > [    8.824034]  [<ffffffff8103fd77>] irq_exit+0xd2/0xe0
> > [    8.824034]  [<ffffffff81018f91>] smp_apic_timer_interrupt+0x8b/0x99
> > [    8.824034]  [<ffffffff815a1b30>] apic_timer_interrupt+0x70/0x80
> > [    8.824034]  <EOI>  [<ffffffff8159dbbf>] ? notifier_call_chain+0x20/0x81
> > [    8.824034]  [<ffffffff8159dc7e>] __atomic_notifier_call_chain+0x5e/0x90
> > [    8.824034]  [<ffffffff8159dc20>] ? notifier_call_chain+0x81/0x81
> > [    8.824034]  [<ffffffff8159dcbf>] atomic_notifier_call_chain+0xf/0x11
> > [    8.824034]  [<ffffffff8100092d>] cpu_idle+0xaf/0x102
> > [    8.824034]  [<ffffffff81569ddc>] rest_init+0xd0/0xd7
> > [    8.824034]  [<ffffffff81569d0c>] ? csum_partial_copy_generic+0x16c/0x16c
> > [    8.824034]  [<ffffffff81b31b09>] start_kernel+0x375/0x380
> > [    8.824034]  [<ffffffff81b3129f>] x86_64_start_reservations+0xaf/0xb3
> > [    8.824034]  [<ffffffff81b31393>] x86_64_start_kernel+0xf0/0xf7
> > [    8.824034] ---[ end trace f6289633ba846f8f ]---
> > 
> > Any ideas?
> 
> This is a bug where someone uses RCU at a time when RCU has been told
> that the CPU is in dyntick-idle mode.  Frederic Weisbecker has some
> patches that should address this.

Yep, see there: https://lkml.org/lkml/2011/8/20/81
