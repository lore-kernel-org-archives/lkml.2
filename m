Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab2H3WBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:01:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49587 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2H3WBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:01:11 -0400
MIME-Version: 1.0
Date: Thu, 30 Aug 2012 15:01:10 -0700
Message-ID: <CAOdLEaqkpKzbJY33jakQQpqvFtwtVP4wgNAB=r6VA9Xnd5k-yA@mail.gmail.com>
Subject: Continuous warn slow path warning messages from top of the kernel tree
From: Sam Gandhi <samgandhi9@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using the latest git repo (3.6.-rc3) to boot my ARM mx28 based board.

When I boot this board via nfs I see continuous messages shown below.

I looked at ip_auto_config net/ipv4/ipconfig.c and I don't see
explicit prink() call although there are DBG() or pr_info/pr_err calls
but I thought those functions were slow path safe?

I was wondering if this some new regression that anybody else has seen?

-Sam

---
[    4.180000]      device=eth0, addr=192.168.137.1,
mask=255.255.255.0, gw=192.168.137.254
[    4.180000] Dumping ftrace buffer:
[    4.180000]    (ftrace buffer empty)
[    4.180000] ------------[ cut here ]------------
[    4.180000] WARNING: at /src/git/kernel/kernel/rcutiny.c:135
rcu_idle_exit_common+0x88/0xa0()
[    4.180000] Current pid: 1 comm: swapper / Idle pid: 0 comm: swapper
[    4.180000] Modules linked in:
[    4.180000] [<c0014fec>] (unwind_backtrace+0x0/0xf0) from
[<c001eb80>] (warn_slowpath_common+0x4c/0x64)
[    4.180000] [<c001eb80>] (warn_slowpath_common+0x4c/0x64) from
[<c001ec2c>] (warn_slowpath_fmt+0x30/0x40)
[    4.180000] [<c001ec2c>] (warn_slowpath_fmt+0x30/0x40) from
[<c0076908>] (rcu_idle_exit_common+0x88/0xa0)
[    4.180000] [<c0076908>] (rcu_idle_exit_common+0x88/0xa0) from
[<c0076a24>] (rcu_irq_enter+0x40/0x7c)
[    4.180000] [<c0076a24>] (rcu_irq_enter+0x40/0x7c) from
[<c0027584>] (irq_enter+0x8/0x64)
[    4.180000] [<c0027584>] (irq_enter+0x8/0x64) from [<c000fe94>]
(handle_IRQ+0x18/0x84)
[    4.180000] [<c000fe94>] (handle_IRQ+0x18/0x84) from [<c000ec54>]
(__irq_svc+0x34/0x58)
[    4.180000] [<c000ec54>] (__irq_svc+0x34/0x58) from [<c0021588>]
(vprintk_emit+0x134/0x504)
[    4.180000] [<c0021588>] (vprintk_emit+0x134/0x504) from
[<c03ff59c>] (printk+0x34/0x44)
[    4.180000] [<c03ff59c>] (printk+0x34/0x44) from [<c05925e8>]
(ip_auto_config+0xda0/0xf4c)
[    4.180000] [<c05925e8>] (ip_auto_config+0xda0/0xf4c) from
[<c0008870>] (do_one_initcall+0x30/0x16c)
[    4.180000] [<c0008870>] (do_one_initcall+0x30/0x16c) from
[<c0576828>] (kernel_init+0xf0/0x1b8)
[    4.180000] [<c0576828>] (kernel_init+0xf0/0x1b8) from [<c000ff90>]
(kernel_thread_exit+0x0/0x8)
[    4.180000] ---[ end trace 837047ef750231b9 ]---
[    4.340000] ------------[ cut here ]------------
[    4.340000] WARNING: at /src/git/kernel/kernel/rcutiny.c:75
rcu_idle_enter_common.clone.6+0x9c/0x)
[    4.340000] Current pid: 1 comm: swapper / Idle pid: 0 comm: swapper
[    4.340000] Modules linked in:
[    4.340000] [<c0014fec>] (unwind_backtrace+0x0/0xf0) from
[<c001eb80>] (warn_slowpath_common+0x4c/0x64)
[    4.340000] [<c001eb80>] (warn_slowpath_common+0x4c/0x64) from
[<c001ec2c>] (warn_slowpath_fmt+0x30/0x40)
[    4.340000] [<c001ec2c>] (warn_slowpath_fmt+0x30/0x40) from
[<c0076ba4>] (rcu_idle_enter_common.clone.6+0x)
[    4.340000] [<c0076ba4>] (rcu_idle_enter_common.clone.6+0x9c/0xb8)
from [<c0076bfc>] (rcu_irq_exit+0x3c/0x)
[    4.340000] [<c0076bfc>] (rcu_irq_exit+0x3c/0x78) from [<c000feb0>]
(handle_IRQ+0x34/0x84)
[    4.340000] [<c000feb0>] (handle_IRQ+0x34/0x84) from [<c000ec54>]
(__irq_svc+0x34/0x58)
[    4.340000] [<c000ec54>] (__irq_svc+0x34/0x58) from [<c0021588>]
(vprintk_emit+0x134/0x504)
[    4.340000] [<c0021588>] (vprintk_emit+0x134/0x504) from
[<c03ff59c>] (printk+0x34/0x44)
[    4.340000] [<c03ff59c>] (printk+0x34/0x44) from [<c05925e8>]
(ip_auto_config+0xda0/0xf4c)
[    4.340000] [<c05925e8>] (ip_auto_config+0xda0/0xf4c) from
[<c0008870>] (do_one_initcall+0x30/0x16c)
[    4.340000] [<c0008870>] (do_one_initcall+0x30/0x16c) from
[<c0576828>] (kernel_init+0xf0/0x1b8)
[    4.340000] [<c0576828>] (kernel_init+0xf0/0x1b8) from [<c000ff90>]
(kernel_thread_exit+0x0/0x8)
[    4.340000] ---[ end trace 837047ef750231ba ]---
[    4.470000]      host=192.168.137.1, domain=, nis-domain=(none)
[    4.480000]      bootserver=255.255.255.255,
rootserver=192.168.137.254, rootpath=
[    4.490000] ------------[ cut here ]------------
