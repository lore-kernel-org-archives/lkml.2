Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0KVJH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:07:57 -0500
Received: from tomasu.net ([64.85.170.234]:56553 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0KVJHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:07:55 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: occasional glitches with 2.6.36+
Date: Mon, 22 Nov 2010 02:07:45 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-nofp; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011220207.45410.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the past couple months I've noticed a couple problems that don't always 
happen.

First, the framebuffer (intel gfx) thinks its about 1/4 the size it really is, 
even after logging in.

Second, my sdhci device likes to error out:
[    1.615309] irq 17: nobody cared (try booting with the "irqpoll" option)
[    1.615365] Pid: 0, comm: kworker/0:0 Not tainted 2.6.36-nofp #25
[    1.615418] Call Trace:
[    1.615467]  <IRQ>  [<ffffffff810a6086>] __report_bad_irq+0x26/0xa0
[    1.615564]  [<ffffffff810a628c>] note_interrupt+0x18c/0x1d0
[    1.615618]  [<ffffffff810a6a3d>] handle_fasteoi_irq+0xcd/0x100
[    1.615673]  [<ffffffff810057cd>] handle_irq+0x1d/0x30
[    1.615725]  [<ffffffff81004cee>] do_IRQ+0x6e/0xf0
[    1.615779]  [<ffffffff81385dd3>] ret_from_intr+0x0/0xa
[    1.615831]  <EOI>  [<ffffffff8100b4d7>] ? mwait_idle+0xa7/0xf0
[    1.615923]  [<ffffffff8100b474>] ? mwait_idle+0x44/0xf0
[    1.615977]  [<ffffffff81388fb1>] ? atomic_notifier_call_chain+0x11/0x20
[    1.616033]  [<ffffffff810019fa>] cpu_idle+0xba/0x180
[    1.616088]  [<ffffffff810743b9>] ? clockevents_register_device+0xd9/0xf0
[    1.616144]  [<ffffffff8137d6f5>] start_secondary+0x1e5/0x1ec
[    1.616197] handlers:
[    1.616245] [<ffffffffa02a8100>] (sdhci_irq+0x0/0x5f0 [sdhci])
[    1.616306] Disabling IRQ #17

Neither of these always happen. I've tested with memtest86+ a couple times, 
nothing so far.

But they both seem to happen at the same time.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
