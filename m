Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2GCEzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:55:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:5468 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2GCEzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:55:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172791663"
Date: Tue, 3 Jul 2012 12:54:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000000
 (lirc_sir)
Message-ID: <20120703045448.GA8639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarod,

Since commit 4b71ca6 ("[media] lirc_sir: make device registration work"),
I see warnings "IRQ handler type mismatch for IRQ 4" in the
samsung/v4l-fimc-next branch.

The warning is made more obvious by Thomas' commit in linux-next
f5d89470f9 ("genirq: Be more informative on irq type mismatch"):

[   96.064731] genirq: Flags mismatch irq 4. 00000000 (serial) vs. 00000000 (lirc_sir)

[   96.067097] Pid: 3941, comm: rc.local Not tainted 3.5.0-rc5+ #42
[   96.068013] Call Trace:
[   96.068013]  [<ffffffff8110825c>] __setup_irq+0x36f/0x3e6
[   96.068013]  [<ffffffff8110719d>] ? kzalloc.constprop.34+0x1a/0x1c
[   96.068013]  [<ffffffff8117a022>] ? kmem_cache_alloc_trace+0x110/0x122
[   96.068013]  [<ffffffff811083a2>] request_threaded_irq+0xcf/0x10a
[   96.068013]  [<ffffffff817e1ecd>] ? serial8250_backup_timeout+0x112/0x112
[   96.068013]  [<ffffffff817e338a>] serial8250_startup+0x4f3/0x6b7
[   96.068013]  [<ffffffff817deea0>] uart_startup.part.6+0x86/0x178
[   96.068013]  [<ffffffff817dfa1c>] uart_open+0xf2/0x13e
[   96.068013]  [<ffffffff817c038c>] ? check_tty_count+0x4b/0xa8
[   96.068013]  [<ffffffff817c2369>] tty_open+0x306/0x492
[   96.068013]  [<ffffffff81187a5b>] chrdev_open+0x11f/0x14a
[   96.068013]  [<ffffffff810c3b14>] ? local_clock+0x19/0x52
[   96.068013]  [<ffffffff8118793c>] ? cdev_put+0x26/0x26
[   96.068013]  [<ffffffff81182b9b>] do_dentry_open+0x1dd/0x28a
[   96.068013]  [<ffffffff81182cb3>] finish_open+0x6b/0x81
[   96.068013]  [<ffffffff8119095a>] do_last+0x89d/0xa4b
[   96.068013]  [<ffffffff8118e428>] ? inode_permission+0xac/0xe0
[   96.068013]  [<ffffffff811950bc>] ? spin_lock+0x9/0xb
[   96.068013]  [<ffffffff8118e521>] ? link_path_walk+0xc5/0x49e
[   96.068013]  [<ffffffff81190bc7>] path_openat+0xbf/0x33b
[   96.068013]  [<ffffffff810de3a0>] ? trace_hardirqs_off_caller+0x1f/0x9e
[   96.068013]  [<ffffffff810c3b36>] ? local_clock+0x3b/0x52
[   96.068013]  [<ffffffff81191050>] do_filp_open+0x38/0x86
[   96.068013]  [<ffffffff82e9ff8a>] ? _raw_spin_unlock+0x28/0x3b
[   96.068013]  [<ffffffff8119b5df>] ? alloc_fd+0xe5/0xf7
[   96.068013]  [<ffffffff811837bd>] do_sys_open+0x6e/0xfb
[   96.068013]  [<ffffffff8118386b>] sys_open+0x21/0x23
[   96.068013]  [<ffffffff82ea6d29>] system_call_fastpath+0x16/0x1b

Thanks,
Fengguang
