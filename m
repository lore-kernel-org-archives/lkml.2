Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2JMJad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 05:30:33 -0400
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:51550
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2JMJaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 05:30:30 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2012 05:30:30 EDT
Date: Sat, 13 Oct 2012 11:23:45 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1361433154.20121013112345@eikelenboom.it>
To: linux-kernel@vger.kernel.org
Subject: 3.7.0-pre-rc1 INFO: inconsistent lock state  kswapd0/792 [HC0[0]:SC0[0]:HE1:SE1] takes:   (&anon_vma->mutex){+.+.?.}, at: [<ffffffff81121a3d>] page_lock_anon_vma+0x12d/0x1a0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On linux kernel 3.7.0-pre-rc1 (last commit = 4d7127dace8cf4b05eb7c8c8531fc204fbb195f4)

I get:

[ 2954.552722]
[ 2954.563914] =================================
[ 2954.573011] [ INFO: inconsistent lock state ]
[ 2954.582002] 3.6.0pre-rc1-20121013 #1 Tainted: G        W   
[ 2954.591174] ---------------------------------
[ 2954.600275] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[ 2954.609099] kswapd0/792 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2954.617855]  (&anon_vma->mutex){+.+.?.}, at: [<ffffffff81121a3d>] page_lock_anon_vma+0x12d/0x1a0
[ 2954.626841] {RECLAIM_FS-ON-W} state was registered at:
[ 2954.635560]   [<ffffffff810ace94>] mark_held_locks+0xa4/0x130
[ 2954.644236]   [<ffffffff810ad004>] lockdep_trace_alloc+0xe4/0x130
[ 2954.652867]   [<ffffffff8113a203>] kmem_cache_alloc+0x33/0xd0
[ 2954.661416]   [<ffffffff811342df>] do_mmu_notifier_register+0x7f/0x160
[ 2954.669906]   [<ffffffff811343de>] mmu_notifier_register+0xe/0x10
[ 2954.678215]   [<ffffffff81342d53>] gntdev_open+0xa3/0xe0
[ 2954.686432]   [<ffffffff81375550>] misc_open+0xb0/0x1a0
[ 2954.694523]   [<ffffffff81147ce8>] chrdev_open+0x98/0x170
[ 2954.702526]   [<ffffffff811426ce>] do_dentry_open+0x25e/0x310
[ 2954.710471]   [<ffffffff81142890>] finish_open+0x30/0x50
[ 2954.718305]   [<ffffffff811517ee>] do_last+0x30e/0xe90
[ 2954.725953]   [<ffffffff8115241e>] path_openat+0xae/0x4e0
[ 2954.733444]   [<ffffffff81152984>] do_filp_open+0x44/0xa0
[ 2954.740911]   [<ffffffff811421e3>] do_sys_open+0x103/0x1f0
[ 2954.748388]   [<ffffffff8114230c>] sys_open+0x1c/0x20
[ 2954.755772]   [<ffffffff817488e9>] system_call_fastpath+0x16/0x1b
[ 2954.763015] irq event stamp: 2815
[ 2954.770156] hardirqs last  enabled at (2815): [<ffffffff81743c4d>] mutex_trylock+0x15d/0x200
[ 2954.777538] hardirqs last disabled at (2814): [<ffffffff81743b57>] mutex_trylock+0x67/0x200
[ 2954.784781] softirqs last  enabled at (0): [<ffffffff81064a1a>] copy_process+0x52a/0x14b0
[ 2954.792016] softirqs last disabled at (0): [<          (null)>]           (null)
[ 2954.799237] 
[ 2954.799237] other info that might help us debug this:
[ 2954.813342]  Possible unsafe locking scenario:
[ 2954.813342] 
[ 2954.827364]        CPU0
[ 2954.834223]        ----
[ 2954.840907]   lock(&anon_vma->mutex);
[ 2954.847630]   <Interrupt>
[ 2954.854238]     lock(&anon_vma->mutex);
[ 2954.860924] 
[ 2954.860924]  *** DEADLOCK ***
[ 2954.860924] 
[ 2954.880533] no locks held by kswapd0/792.
[ 2954.887085] 
[ 2954.887085] stack backtrace:
[ 2954.900162] Pid: 792, comm: kswapd0 Tainted: G        W    3.6.0pre-rc1-20121013 #1
[ 2954.906779] Call Trace:
[ 2954.913335]  [<ffffffff810ac6b4>] print_usage_bug+0x244/0x2e0
[ 2954.919970]  [<ffffffff810acd5c>] mark_lock+0x60c/0x6a0
[ 2954.926503]  [<ffffffff810b08e6>] __lock_acquire+0x636/0xdd0
[ 2954.933108]  [<ffffffff810ace94>] ? mark_held_locks+0xa4/0x130
[ 2954.939759]  [<ffffffff810b113a>] lock_acquire+0xba/0x100
[ 2954.946193]  [<ffffffff81121a3d>] ? page_lock_anon_vma+0x12d/0x1a0
[ 2954.952383]  [<ffffffff81121a3d>] ? page_lock_anon_vma+0x12d/0x1a0
[ 2954.958260]  [<ffffffff81744bfc>] mutex_lock_nested+0x4c/0x450
[ 2954.963944]  [<ffffffff81121a3d>] ? page_lock_anon_vma+0x12d/0x1a0
[ 2954.969414]  [<ffffffff810ad2e8>] ? trace_hardirqs_on_caller+0xf8/0x200
[ 2954.974640]  [<ffffffff810b15e7>] ? lock_release+0x117/0x250
[ 2954.979593]  [<ffffffff81121a3d>] page_lock_anon_vma+0x12d/0x1a0
[ 2954.984605]  [<ffffffff81121910>] ? page_mapped_in_vma+0xa0/0xa0
[ 2954.989597]  [<ffffffff81121ddb>] page_referenced+0x16b/0x2a0
[ 2954.994498]  [<ffffffff81747a1b>] ? _raw_spin_unlock_irq+0x2b/0x70
[ 2954.999459]  [<ffffffff81103a7d>] shrink_active_list+0x1bd/0x300
[ 2955.004413]  [<ffffffff811042b4>] shrink_lruvec+0x484/0x640
[ 2955.009311]  [<ffffffff810f75c4>] ? zone_watermark_ok_safe+0xa4/0xc0
[ 2955.014236]  [<ffffffff811056d4>] kswapd+0x854/0xda0
[ 2955.018987]  [<ffffffff810ad2e8>] ? trace_hardirqs_on_caller+0xf8/0x200
[ 2955.023806]  [<ffffffff81086b50>] ? wake_up_bit+0x40/0x40
[ 2955.028496]  [<ffffffff81747ab3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[ 2955.033247]  [<ffffffff81104e80>] ? zone_reclaim+0x420/0x420
[ 2955.037975]  [<ffffffff810864e6>] kthread+0xd6/0xe0
[ 2955.042682]  [<ffffffff81086410>] ? __init_kthread_worker+0x70/0x70
[ 2955.047400]  [<ffffffff8174883c>] ret_from_fork+0x7c/0xb0
[ 2955.052152]  [<ffffffff81086410>] ? __init_kthread_worker+0x70/0x70


--
Sander

