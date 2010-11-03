Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0KCWgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:36:38 -0400
Received: from www17.your-server.de ([213.133.104.17]:47572 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0KCWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:36:36 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Date: Wed, 3 Nov 2010 23:34:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-00004-geb8abb9; KDE/4.5.2; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011032334.30662.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

with 2.6.36 I'm starting to see a kernel panic and my system hangs completely.
This is what I could capture, i.e. write down, from the (KMS) text console:

[   300.000697] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36 #2 MS-7250/MS-7250
[   300.000815] RIP: 0010:[<ffffffff8105faf4>]  [<ffffffff8105faf4>] cascade+0x54/0x7a
[   300.000953] ...
[   300.008200] Call Trace:
[   300.008200]  <IRQ>
[   300.008200]  ? run_timer_softirq
[   300.008200]  ? ktime_get
[   300.008200]  ? __do_softirq
[   300.008200]  ? call_softirq
[   300.008200]  ? do_softirq
[   300.008200]  ? irq_exit
[   300.008200]  ? smp_apic_timer_interrupt
[   300.008200]  ? apic_timer_interrupt
[   300.008200]  <EOI>
[   300.008200]  ? _raw_spin_unlock_irq
[   300.008200]  ? finish_task_switch
[   300.008200]  ? schedule
[   300.008200]  ? sched_clock_local
[   300.008200]  ? cpu_idle
[   300.008200]  ? start_secondary
[   300.008200]  Code: 08 48...
[   300.008200]  RIP  [<ffffffff8105faf4>] cascade+0x54/0x7a
[   300.008200]   RSP <ffff880002103e40>
[   300.008200]  ---[ end trace 9511a8b4f653d08 ]---
[   300.008200]  Kernel panic - not syncing: Fatal exception in interrupt
[   300.000697] Pid: 0, comm: kworker/0:0 Tainted: G      D     2.6.36 #2
[   300.008200] Call Trace:
[   300.008200]  <IRQ>  [<ffffffff816d6a2c>] ? panic+0xa1/0x1a3
[   300.008200]  ? _raw_spin_unlock_irqrestore
[   300.008200]  ? oops_end
[   300.008200]  ? do_invalid_op
[   300.008200]  ? cascade
[   300.008200]  ? invalid_op
[   300.008200]  ? run_timer_softirq
[   300.008200]  ? ktime_get
[   300.008200]  ? __do_softirq
[   300.008200]  ? call_softirq
[   300.008200]  ? do_softirq
[   300.008200]  ? irq_exit
[   300.008200]  ? smp_apic_timer_interrupt
[   300.008200]  ? apic_timer_interrupt
[   300.008200]  <EOI> ? _raw_spin_unlock_irq
[   300.008200]  ? finish_task_switch
[   300.008200]  ? schedule
[   300.008200]  ? sched_clock_local
[   300.008200]  ? cpu_idle
[   300.008200]  ? start_secondary
[   300.008200]  panic occurred, switching back to text console

Help most appreciated!
