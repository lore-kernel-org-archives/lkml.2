Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1GKMKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:10:40 -0400
Received: from mail001.aei.ca ([206.123.6.130]:49124 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab1GKMKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:10:39 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: [BUG] with threadirqs active
Date: Mon, 11 Jul 2011 08:10:35 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc6-crc+; KDE/4.6.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107110810.35716.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've be running with threaded irq since they became available.  Today, runing 3.0.0-rc5, my box stalled.  After
reboot this was in messages (serial console was not active):

Jul 11 07:26:01 grover kernel: [42033.890391] irq 18: nobody cared (try booting with the "irqpoll" option)
Jul 11 07:26:01 grover kernel: [42033.897325] Pid: 1434, comm: irq/18-ohci_hcd Not tainted 3.0.0-rc5-crc+ #324
Jul 11 07:26:01 grover kernel: [42033.904585] Call Trace:
Jul 11 07:26:01 grover kernel: [42033.904596]  [<ffffffff810a9bf9>] __report_bad_irq+0x69/0x110
Jul 11 07:26:01 grover kernel: [42033.904599]  [<ffffffff810a9f0c>] note_interrupt+0x26c/0x2b0
Jul 11 07:26:01 grover kernel: [42033.904603]  [<ffffffff810a9879>] irq_thread+0x209/0x210
Jul 11 07:26:01 grover kernel: [42033.904605]  [<ffffffff810a9960>] ? exit_irq_thread+0x90/0x90
Jul 11 07:26:01 grover kernel: [42033.904608]  [<ffffffff810a9670>] ? irq_finalize_oneshot+0x160/0x160
Jul 11 07:26:01 grover kernel: [42033.904613]  [<ffffffff81070d56>] kthread+0xb6/0xc0
Jul 11 07:26:01 grover kernel: [42033.904618]  [<ffffffff8108945d>] ? trace_hardirqs_on_caller+0x14d/0x190
Jul 11 07:26:01 grover kernel: [42033.904622]  [<ffffffff81570c14>] kernel_thread_helper+0x4/0x10
Jul 11 07:26:01 grover kernel: [42033.904625]  [<ffffffff81568b84>] ? retint_restore_args+0xe/0xe
Jul 11 07:26:01 grover kernel: [42033.904628]  [<ffffffff81070ca0>] ? __init_kthread_worker+0x70/0x70
Jul 11 07:26:01 grover kernel: [42033.904631]  [<ffffffff81570c10>] ? gs_change+0xb/0xb
Jul 11 07:26:01 grover kernel: [42033.904633] handlers:
Jul 11 07:26:01 grover kernel: [42033.904635] [<ffffffff810a7e50>] irq_default_primary_handler threaded [<ffffffff813a2150>] radeon_driver_irq_handler_kms
Jul 11 07:26:01 grover kernel: [42033.904641] [<ffffffff810a7e50>] irq_default_primary_handler threaded [<ffffffff81464df0>] usb_hcd_irq
Jul 11 07:26:01 grover kernel: [42033.904647] [<ffffffff810a7e50>] irq_default_primary_handler threaded [<ffffffff81464df0>] usb_hcd_irq
Jul 11 07:26:01 grover kernel: [42033.904650] [<ffffffff810a7e50>] irq_default_primary_handler threaded [<ffffffff81464df0>] usb_hcd_irq
Jul 11 07:26:01 grover kernel: [42033.904653] Disabling IRQ #18

from proc:

 18:         10        148       1892     131017   IO-APIC-fasteoi   radeon, ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7

ideas?
Ed Tomlinson
