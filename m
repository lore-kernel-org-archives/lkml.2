Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0EYIPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:15:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41391 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0EYIPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:15:48 -0400
Date: Tue, 25 May 2010 10:15:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH]cfq-iosched: fix an oops caused by slab leak
Message-ID: <20100525081546.GB23411@kernel.dk>
References: <20100525011849.GA29820@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525011849.GA29820@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25 2010, Shaohua Li wrote:
> I got below oops when unloading cfq-iosched. Considering scenario:
> queue A merge to B, C merge to D and B will be merged to D. Before B is merged
> to D, we do split B. We should put B's reference for D.
> 
> [  807.768536] =============================================================================
> [  807.768539] BUG cfq_queue: Objects remaining on kmem_cache_close()
> [  807.768541] -----------------------------------------------------------------------------
> [  807.768543]
> [  807.768546] INFO: Slab 0xffffea0003e6b4e0 objects=26 used=1 fp=0xffff88011d584fd8 flags=0x200000000004082
> [  807.768550] Pid: 5946, comm: rmmod Tainted: G        W   2.6.34-07097-gf4b87de-dirty #724
> [  807.768552] Call Trace:
> [  807.768560]  [<ffffffff81104e8d>] slab_err+0x8f/0x9d
> [  807.768564]  [<ffffffff811059e1>] ? flush_cpu_slab+0x0/0x93
> [  807.768569]  [<ffffffff8164be52>] ? add_preempt_count+0xe/0xca
> [  807.768572]  [<ffffffff8164bd9c>] ? sub_preempt_count+0xe/0xb6
> [  807.768577]  [<ffffffff81648871>] ? _raw_spin_unlock+0x15/0x30
> [  807.768580]  [<ffffffff8164bd9c>] ? sub_preempt_count+0xe/0xb6
> [  807.768584]  [<ffffffff811061bc>] list_slab_objects+0x9b/0x19f
> [  807.768588]  [<ffffffff8164bf0a>] ? add_preempt_count+0xc6/0xca
> [  807.768591]  [<ffffffff81109e27>] kmem_cache_destroy+0x13f/0x21d
> [  807.768597]  [<ffffffffa000ff13>] cfq_slab_kill+0x1a/0x43 [cfq_iosched]
> [  807.768601]  [<ffffffffa000ffcf>] cfq_exit+0x93/0x9e [cfq_iosched]
> [  807.768606]  [<ffffffff810973a2>] sys_delete_module+0x1b1/0x219
> [  807.768612]  [<ffffffff8102fb5b>] system_call_fastpath+0x16/0x1b
> [  807.768618] INFO: Object 0xffff88011d584618 @offset=1560
> [  807.768622] INFO: Allocated in cfq_get_queue+0x11e/0x274 [cfq_iosched] age=7173 cpu=1 pid=5496
> [  807.768626] =============================================================================
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Good catch, I will apply it and mark for -stable.

-- 
Jens Axboe

