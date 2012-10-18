Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2JRBxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:53:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab2JRBxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:53:20 -0400
Date: Wed, 17 Oct 2012 21:53:12 -0400
From: Dave Jones <davej@redhat.com>
To: axboe@kernel.dk
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: MAX_LOCKDEP_ENTRIES too low  (called from ioc_release_fn)
Message-ID: <20121018015312.GA29865@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, axboe@kernel.dk,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Triggered while fuzz testing..


BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
Pid: 22788, comm: kworker/2:1 Not tainted 3.7.0-rc1+ #34
Call Trace:
 [<ffffffff810decdd>] add_lock_to_list.isra.29.constprop.45+0xdd/0xf0
 [<ffffffff810e2871>] __lock_acquire+0x1121/0x1ba0
 [<ffffffff810e3a12>] lock_acquire+0xa2/0x220
 [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff816c0800>] _raw_spin_lock+0x40/0x80
 [<ffffffff8117bad2>] ? free_one_page+0x32/0x450
 [<ffffffff8117bad2>] free_one_page+0x32/0x450
 [<ffffffff8117bf41>] ? __free_pages_ok.part.58+0x51/0x110
 [<ffffffff8117bf9c>] __free_pages_ok.part.58+0xac/0x110
 [<ffffffff8117cd73>] __free_pages+0x73/0x90
 [<ffffffff811cb4f3>] __free_slab+0xd3/0x1b0
 [<ffffffff811cb609>] discard_slab+0x39/0x50
 [<ffffffff816b77db>] __slab_free+0x378/0x3a3
 [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
 [<ffffffff81341289>] ? ioc_release_fn+0x99/0xe0
 [<ffffffff811cd4e2>] kmem_cache_free+0x2f2/0x320
 [<ffffffff816c5a59>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff81341289>] ioc_release_fn+0x99/0xe0
 [<ffffffff81095a37>] process_one_work+0x207/0x780
 [<ffffffff810959c7>] ? process_one_work+0x197/0x780
 [<ffffffff813411f0>] ? get_io_context+0x20/0x20
 [<ffffffff8109638e>] worker_thread+0x15e/0x440
 [<ffffffff81096230>] ? rescuer_thread+0x240/0x240
 [<ffffffff8109d0cd>] kthread+0xed/0x100
 [<ffffffff810de02e>] ? put_lock_stats.isra.25+0xe/0x40
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160
 [<ffffffff816c9dac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8109cfe0>] ? kthread_create_on_node+0x160/0x160

