Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1JYJ2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:28:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44434 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1JYJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:28:42 -0400
Date: Tue, 25 Oct 2011 17:28:31 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.7-rt20
Message-ID: <20111025092831.GA32744@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LFD.2.02.1110191150280.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110191150280.3240@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:59:09AM +0200, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0.7-rt20 release.
> 
> 3.0.7-rt19 is an not announced intermediate release, which only
> updates to 3.0.7. No rt changes except dropping patches which made it
> into 3.0.7.
> 

Got below warning during cpu hotplug:

[  356.523928] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: posixcputmr/9/63
[  356.523935] caller is kmem_cache_free+0x43/0x240
[  356.523937] Pid: 63, comm: posixcputmr/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.523939] Call Trace:
[  356.523947]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.523951]  [<ffffffff81134c23>] kmem_cache_free+0x43/0x240
[  356.523956]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.523960]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.523964]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.523969]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.523973]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.523978]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.523981]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.523986]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.523991]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.523996]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.524000]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524005]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.524009]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524013]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.524017]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.524021]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.524026] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: posixcputmr/9/63
[  356.524029] caller is kmem_cache_free+0xb9/0x240
[  356.524031] Pid: 63, comm: posixcputmr/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.524032] Call Trace:
[  356.524036]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.524040]  [<ffffffff81134c99>] kmem_cache_free+0xb9/0x240
[  356.524044]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.524048]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.524051]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.524055]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.524058]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.524062]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524065]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524069]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.524073]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.524077]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.524081]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524085]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.524089]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524093]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.524097]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.524100]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.524103] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: posixcputmr/9/63
[  356.524105] caller is kmem_cache_free+0xd0/0x240
[  356.524107] Pid: 63, comm: posixcputmr/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.524108] Call Trace:
[  356.524112]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.524116]  [<ffffffff81134cb0>] kmem_cache_free+0xd0/0x240
[  356.524120]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.524123]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.524127]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.524130]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.524134]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.524138]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524141]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524145]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.524149]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.524153]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.524157]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524161]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.524165]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524169]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.524173]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.524176]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.524179] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: posixcputmr/9/63
[  356.524182] caller is unlock_slab_and_free_delayed+0x28/0xf0
[  356.524183] Pid: 63, comm: posixcputmr/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.524185] Call Trace:
[  356.524189]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.524193]  [<ffffffff81134648>] unlock_slab_and_free_delayed+0x28/0xf0
[  356.524197]  [<ffffffff81134ce5>] kmem_cache_free+0x105/0x240
[  356.524201]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.524204]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.524208]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.524212]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.524215]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.524219]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524222]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524226]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.524230]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.524234]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.524238]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524242]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.524246]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524250]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.524254]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.524257]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.524259] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: posixcputmr/9/63
[  356.524262] caller is unlock_slab_and_free_delayed+0x5d/0xf0
[  356.524264] Pid: 63, comm: posixcputmr/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.524265] Call Trace:
[  356.524269]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.524273]  [<ffffffff8113467d>] unlock_slab_and_free_delayed+0x5d/0xf0
[  356.524277]  [<ffffffff81134ce5>] kmem_cache_free+0x105/0x240
[  356.524281]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.524284]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.524288]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.524292]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.524295]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.524299]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524302]  [<ffffffff810793b0>] ? cpu_timer_fire+0xa0/0xa0
[  356.524306]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.524310]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.524314]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.524318]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524322]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.524326]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.524330]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.524334]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.524337]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.528436] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: watchdog/9/68
[  356.528440] caller is kmem_cache_free+0x43/0x240
[  356.528442] Pid: 68, comm: watchdog/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.528443] Call Trace:
[  356.528449]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.528453]  [<ffffffff81134c23>] kmem_cache_free+0x43/0x240
[  356.528457]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.528461]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.528464]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.528468]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.528472]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.528478]  [<ffffffff810bd9a0>] ? watchdog_enable+0x220/0x220
[  356.528482]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.528486]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.528491]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.528495]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528499]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.528503]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528507]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.528511]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.528515]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.528520] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: watchdog/9/68
[  356.528523] caller is kmem_cache_free+0xb9/0x240
[  356.528525] Pid: 68, comm: watchdog/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.528526] Call Trace:
[  356.528530]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.528534]  [<ffffffff81134c99>] kmem_cache_free+0xb9/0x240
[  356.528538]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.528541]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.528544]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.528548]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.528552]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.528556]  [<ffffffff810bd9a0>] ? watchdog_enable+0x220/0x220
[  356.528560]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.528564]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.528568]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.528572]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528576]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.528579]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528583]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.528587]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.528591]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.528593] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: watchdog/9/68
[  356.528596] caller is kmem_cache_free+0xd0/0x240
[  356.528597] Pid: 68, comm: watchdog/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.528599] Call Trace:
[  356.528602]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.528606]  [<ffffffff81134cb0>] kmem_cache_free+0xd0/0x240
[  356.528610]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.528613]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.528617]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.528621]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.528624]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.528628]  [<ffffffff810bd9a0>] ? watchdog_enable+0x220/0x220
[  356.528632]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.528636]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.528640]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.528644]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528648]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.528652]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528656]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.528660]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.528663]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.528666] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: watchdog/9/68
[  356.528668] caller is unlock_slab_and_free_delayed+0x28/0xf0
[  356.528670] Pid: 68, comm: watchdog/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.528671] Call Trace:
[  356.528675]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.528679]  [<ffffffff81134648>] unlock_slab_and_free_delayed+0x28/0xf0
[  356.528683]  [<ffffffff81134ce5>] kmem_cache_free+0x105/0x240
[  356.528687]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.528690]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.528694]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.528698]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.528701]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.528705]  [<ffffffff810bd9a0>] ? watchdog_enable+0x220/0x220
[  356.528709]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.528713]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.528717]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.528721]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528725]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.528729]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528733]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.528737]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.528740]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  356.528743] BUG: using smp_processor_id() in preemptible [00000000 00000000] code: watchdog/9/68
[  356.528746] caller is unlock_slab_and_free_delayed+0x5d/0xf0
[  356.528747] Pid: 68, comm: watchdog/9 Tainted: G        W   3.0.7-rt20-00826-g3a88799 #3
[  356.528749] Call Trace:
[  356.528752]  [<ffffffff81357db0>] debug_smp_processor_id+0x110/0x130
[  356.528757]  [<ffffffff8113467d>] unlock_slab_and_free_delayed+0x5d/0xf0
[  356.528761]  [<ffffffff81134ce5>] kmem_cache_free+0x105/0x240
[  356.528765]  [<ffffffff8104c577>] __cleanup_sighand+0x27/0x30
[  356.528768]  [<ffffffff81052e76>] release_task+0x246/0x540
[  356.528771]  [<ffffffff81052c4d>] ? release_task+0x1d/0x540
[  356.528775]  [<ffffffff815bfe55>] ? _raw_spin_unlock+0x35/0x60
[  356.528779]  [<ffffffff81054c9e>] do_exit+0x65e/0x8e0
[  356.528783]  [<ffffffff810bd9a0>] ? watchdog_enable+0x220/0x220
[  356.528787]  [<ffffffff81076600>] kthread+0xa0/0xb0
[  356.528791]  [<ffffffff815be17e>] ? rt_spin_lock_slowunlock+0x1e/0x80
[  356.528795]  [<ffffffff81037d29>] ? sub_preempt_count+0xa9/0xe0
[  356.528799]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528803]  [<ffffffff815c1a54>] kernel_thread_helper+0x4/0x10
[  356.528807]  [<ffffffff815bfdeb>] ? _raw_spin_unlock_irq+0x3b/0x70
[  356.528811]  [<ffffffff815c0184>] ? retint_restore_args+0xe/0xe
[  356.528815]  [<ffffffff81076560>] ? kthreadd+0x160/0x160
[  356.528818]  [<ffffffff815c1a50>] ? gs_change+0xb/0xb
[  357.967865] CPU 21 MCA banks CMCI:2 CMCI:3 CMCI:5

