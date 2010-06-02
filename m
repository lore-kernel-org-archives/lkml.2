Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0FBLRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:17:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322Ab0FBLRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:17:07 -0400
Date: Wed, 2 Jun 2010 13:16:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: blkiocg_update_io_add_stats(): INFO: trying to register non-static
 key
Message-ID: <20100602111653.GA25662@elte.hu>
References: <4BF9EC69.5030709@example.com>
 <1274777422.5882.591.camel@twins>
 <20100601064120.GA3407@elte.hu>
 <20100601064726.GG1660@kernel.dk>
 <20100601065500.GA7876@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601065500.GA7876@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., there's another warning triggered by the new blk-cgroups stats code:

sda:INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 81, comm: async/2 Not tainted 2.6.35-rc1-tip-01073-gd2f7698-dirty #6765
Call Trace:
 [<ffffffff81065d6d>] register_lock_class+0x15f/0x365
 [<ffffffff8105c426>] ? sched_clock_local+0x1d/0x83
 [<ffffffff8105c557>] ? sched_clock_cpu+0xcb/0xd9
 [<ffffffff81067184>] __lock_acquire+0x97/0x481
 [<ffffffff810088d4>] ? native_sched_clock+0x37/0x6d
 [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
 [<ffffffff81067644>] lock_acquire+0xd6/0xfd
 [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
 [<ffffffff81850859>] _raw_spin_lock_irqsave+0x47/0x82
 [<ffffffff81321b74>] ? blkiocg_update_io_add_stats+0x32/0x12e
 [<ffffffff81321b74>] blkiocg_update_io_add_stats+0x32/0x12e
 [<ffffffff81325048>] cfq_insert_request+0xdd/0x47c
 [<ffffffff813135b9>] elv_insert+0x12a/0x1f4
 [<ffffffff8131371c>] __elv_add_request+0x99/0xa1
 [<ffffffff8131817a>] __make_request+0x3e2/0x45f
 [<ffffffff8131736e>] generic_make_request+0x2a0/0x316
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff8131749c>] submit_bio+0xb8/0xd6
 [<ffffffff81117e1b>] submit_bh+0xf5/0x117
 [<ffffffff8111b36e>] block_read_full_page+0x1f2/0x214
 [<ffffffff8111ce86>] ? blkdev_get_block+0x0/0x66
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff810c6ddd>] ? __lru_cache_add+0x79/0x97
 [<ffffffff8111de4d>] blkdev_readpage+0x18/0x1a
 [<ffffffff810becb0>] do_read_cache_page+0x95/0x128
 [<ffffffff8111de35>] ? blkdev_readpage+0x0/0x1a
 [<ffffffff810bed87>] read_cache_page_async+0x1c/0x1e
 [<ffffffff810bed97>] read_cache_page+0xe/0x18
 [<ffffffff8114698f>] read_dev_sector+0x33/0xbe
 [<ffffffff8114797d>] adfspart_check_EESOX+0x59/0x1e7
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff8185405e>] ? sub_preempt_count+0xf/0xb7
 [<ffffffff8103dede>] ? vprintk+0x395/0x3f0
 [<ffffffff811472f0>] ? kzalloc.clone.1+0x13/0x15
 [<ffffffff8184dfe5>] ? printk+0x69/0x6b
 [<ffffffff8114771d>] rescan_partitions+0x186/0x38d
 [<ffffffff81513cfb>] ? sd_open+0xf1/0x1bd
 [<ffffffff8111e512>] __blkdev_get+0x291/0x372
 [<ffffffff8132a4ba>] ? kobject_put+0x48/0x4c
 [<ffffffff8111e603>] blkdev_get+0x10/0x12
 [<ffffffff81146bcd>] register_disk+0xb9/0x11d
 [<ffffffff8131f3c4>] add_disk+0xb0/0x10c
 [<ffffffff81515d4c>] sd_probe_async+0x12a/0x200
 [<ffffffff8105f4a4>] ? ktime_get+0x65/0xbe
 [<ffffffff8105d742>] async_thread+0x10e/0x21c
 [<ffffffff81039390>] ? default_wake_function+0x0/0x14
 [<ffffffff8105d634>] ? async_thread+0x0/0x21c
 [<ffffffff81056c01>] kthread+0x9b/0xa3
 [<ffffffff810030f4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81056b66>] ? kthread+0x0/0xa3
 [<ffffffff810030f0>] ? kernel_thread_helper+0x0/0x10
 sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
device: 'sda1': device_add
PM: Adding info for No Bus:sda1

seems to be a lock taken by:

 [<ffffffff81321b74>] blkiocg_update_io_add_stats+0x32/0x12e

	Ingo
