Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2GJP6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2GJP6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:58:49 -0400
Date: Tue, 10 Jul 2012 11:58:40 -0400
From: Dave Jones <davej@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 3.5rc6 cryptomgr_test slab corruption..
Message-ID: <20120710155840.GA23882@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=============================================================================
BUG kmalloc-32 (Not tainted): Invalid object pointer 0xffff8801054f6600
-----------------------------------------------------------------------------

INFO: Slab 0xffffea0004153d00 objects=45 used=37 fp=0xffff8801054f5ab8 flags=0x20000000004081
Pid: 22220, comm: cryptomgr_test Not tainted 3.5.0-rc6+ #100
Call Trace:
 [<ffffffff811932bf>] slab_err+0xaf/0xd0
 [<ffffffff81193d76>] ? slab_pad_check.part.38+0xc6/0x170
 [<ffffffff81646749>] ? free_debug_processing+0x2c/0x1ea
 [<ffffffff8164678d>] free_debug_processing+0x70/0x1ea
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81646944>] __slab_free+0x3d/0x254
 [<ffffffff813303dc>] ? debug_check_no_obj_freed+0x16c/0x210
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81196299>] kfree+0x269/0x270
 [<ffffffff81041b0a>] rfc4106_set_key+0x12a/0x320
 [<ffffffff812e59ce>] test_aead+0x50e/0xe50
 [<ffffffff810b97dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81646fcd>] ? __slab_alloc+0x472/0x4c4
 [<ffffffff812db552>] ? __crypto_alloc_tfm+0x52/0x170
 [<ffffffff812db576>] ? __crypto_alloc_tfm+0x76/0x170
 [<ffffffff812dc0fc>] ? crypto_spawn_tfm+0x4c/0x90
 [<ffffffff811970ef>] ? __kmalloc+0x27f/0x290
 [<ffffffff812e9a7b>] ? cryptd_aead_init_tfm+0x2b/0x50
 [<ffffffff812db5f9>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff812de00b>] ? crypto_alloc_aead+0x6b/0xc0
 [<ffffffff812ea506>] ? cryptd_alloc_aead+0x76/0xb0
 [<ffffffff81040f87>] ? rfc4106_init+0x47/0x80
 [<ffffffff812db5f9>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff812dc0fc>] ? crypto_spawn_tfm+0x4c/0x90
 [<ffffffff812e6362>] alg_test_aead+0x52/0xc0
 [<ffffffff812e4f10>] alg_test+0x100/0x320
 [<ffffffff8164e072>] ? __schedule+0x462/0x9d0
 [<ffffffff812e3aa0>] ? cryptomgr_probe+0xf0/0xf0
 [<ffffffff812e3ae5>] cryptomgr_test+0x45/0x50
 [<ffffffff81074fa7>] kthread+0xb7/0xc0
 [<ffffffff81653e99>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff81659414>] kernel_thread_helper+0x4/0x10
 [<ffffffff81082ddc>] ? finish_task_switch+0x7c/0x120
 [<ffffffff8165042b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff8165071d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81074ef0>] ? flush_kthread_worker+0x190/0x190
 [<ffffffff81659410>] ? gs_change+0xb/0xb
FIX kmalloc-32: Object at 0xffff8801054f6600 not freed
=============================================================================
BUG kmalloc-32 (Not tainted): Invalid object pointer 0xffff8801054f5ac0
-----------------------------------------------------------------------------

INFO: Slab 0xffffea0004153d00 objects=45 used=38 fp=0xffff8801054f6490 flags=0x20000000004081
Pid: 22220, comm: cryptomgr_test Not tainted 3.5.0-rc6+ #100
Call Trace:
 [<ffffffff811932bf>] slab_err+0xaf/0xd0
 [<ffffffff81193d76>] ? slab_pad_check.part.38+0xc6/0x170
 [<ffffffff81646749>] ? free_debug_processing+0x2c/0x1ea
 [<ffffffff8164678d>] free_debug_processing+0x70/0x1ea
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81646944>] __slab_free+0x3d/0x254
 [<ffffffff813303dc>] ? debug_check_no_obj_freed+0x16c/0x210
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81041b0a>] ? rfc4106_set_key+0x12a/0x320
 [<ffffffff81196299>] kfree+0x269/0x270
 [<ffffffff81041b0a>] rfc4106_set_key+0x12a/0x320
 [<ffffffff812e59ce>] test_aead+0x50e/0xe50
 [<ffffffff810b97dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81646fcd>] ? __slab_alloc+0x472/0x4c4
 [<ffffffff812db552>] ? __crypto_alloc_tfm+0x52/0x170
 [<ffffffff812db576>] ? __crypto_alloc_tfm+0x76/0x170
 [<ffffffff812dc0fc>] ? crypto_spawn_tfm+0x4c/0x90
 [<ffffffff811970ef>] ? __kmalloc+0x27f/0x290
 [<ffffffff812e9a7b>] ? cryptd_aead_init_tfm+0x2b/0x50
 [<ffffffff812db5f9>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff812de00b>] ? crypto_alloc_aead+0x6b/0xc0
 [<ffffffff812ea506>] ? cryptd_alloc_aead+0x76/0xb0
 [<ffffffff81040f87>] ? rfc4106_init+0x47/0x80
 [<ffffffff812db5f9>] ? __crypto_alloc_tfm+0xf9/0x170
 [<ffffffff812dc0fc>] ? crypto_spawn_tfm+0x4c/0x90
 [<ffffffff812e6362>] alg_test_aead+0x52/0xc0
 [<ffffffff812e4f10>] alg_test+0x100/0x320
 [<ffffffff8164e072>] ? __schedule+0x462/0x9d0
 [<ffffffff812e3aa0>] ? cryptomgr_probe+0xf0/0xf0
 [<ffffffff812e3ae5>] cryptomgr_test+0x45/0x50
 [<ffffffff81074fa7>] kthread+0xb7/0xc0
 [<ffffffff81653e99>] ? sub_preempt_count+0x79/0xd0
 [<ffffffff81659414>] kernel_thread_helper+0x4/0x10
 [<ffffffff81082ddc>] ? finish_task_switch+0x7c/0x120
 [<ffffffff8165042b>] ? _raw_spin_unlock_irq+0x3b/0x60
 [<ffffffff8165071d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81074ef0>] ? flush_kthread_worker+0x190/0x190
 [<ffffffff81659410>] ? gs_change+0xb/0xb
FIX kmalloc-32: Object at 0xffff8801054f5ac0 not freed

