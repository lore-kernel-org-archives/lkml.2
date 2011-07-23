Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1GWRRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 13:17:20 -0400
Received: from mail001.aei.ca ([206.123.6.130]:57751 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1GWRRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 13:17:12 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt2
Date: Sat, 23 Jul 2011 13:17:04 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rt2-crc+; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1107231706380.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107231706380.2702@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107231317.05234.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 July 2011 11:13:30 Thomas Gleixner wrote:
> I'm pleased to announce the 3.0-rt2 release.
> 
> Changes versus 3.0-rt1:
> 
>   * mqueue fix (Yoshitake Kobayashi)
> 
>   * dca locking fix (Mike Galbraith)
> 
>   * trace updates (Carsten Emde)
> 
>   * Fixed vprintk wreckage and rcutorture (tglx)
> 
> Known issues:
> 
>   * Some weird "console=..." commandline + config dependent
>     interactions which have been not yet investigated down to their
>     root cause. Result in a boot hang. YMMV

Got this during boot with rt2.  The kernel survives and seems to work (eg X starts and kmail can sent this).

[    1.142427] pci 0000:01:05.0: Boot video device
[    1.142483] PCI: CLS 64 bytes, default 64
[    1.145555] PCI-DMA: Disabling AGP.
[    1.145758] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    1.145759] PCI-DMA: using GART IOMMU.
[    1.145764] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.176417] 
[    1.176419] =================================
[    1.176420] [ INFO: inconsistent lock state ]
[    1.176422] 3.0.0-rt2-crc+ #351
[    1.176424] ---------------------------------
[    1.176425] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.176428] swapper/0 [HC1[1]:SC0[18446612140904153088]:HE0:SE1] takes:
[    1.176430]  (&(&(&(*({ do { const void *__vpp_verify = (typeof((&(slab_lock))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(slab_lock))) *)(&(slab_lock)))); (typeof((typeof(*(&(slab_lock))) *)(&(slab_lock)))) (__ptr + (((__per_cpu_offset[__cpu])))); }); })).lock)->lock)->wait_lock){?.+...}, at: [<ffffffff815820db>] rt_spin_lock_slowlock+0x4b/0x250
[    1.176440] {HARDIRQ-ON-W} state was registered at:
[    1.176442]   [<ffffffff8108c3ed>] __lock_acquire+0x5ed/0x16a0
[    1.176446]   [<ffffffff8108daa5>] lock_acquire+0x95/0x140
[    1.176449]   [<ffffffff8158351b>] _raw_spin_lock+0x3b/0x50
[    1.176452]   [<ffffffff815820db>] rt_spin_lock_slowlock+0x4b/0x250
[    1.176455]   [<ffffffff815829ac>] rt_spin_lock+0x2c/0x60
[    1.176458]   [<ffffffff81146cde>] kmem_cache_alloc_trace+0x7e/0x3f0
[    1.176461]   [<ffffffff811475e7>] do_tune_cpucache+0x47/0x580
[    1.176463]   [<ffffffff81147d00>] enable_cpucache+0x30/0xc0
[    1.176466]   [<ffffffff81bbc879>] kmem_cache_init_late+0x2f/0x82
[    1.176470]   [<ffffffff81ba1ac7>] start_kernel+0x267/0x325
[    1.176473]   [<ffffffff81ba12eb>] x86_64_start_reservations+0xfb/0xff
[    1.176476]   [<ffffffff81ba13dc>] x86_64_start_kernel+0xed/0xf4
[    1.176478] irq event stamp: 125372
[    1.176479] hardirqs last  enabled at (125371): [<ffffffff8100ac4d>] default_idle+0x19d/0x1b0
[    1.176483] hardirqs last disabled at (125372): [<ffffffff81583b67>] save_args+0x67/0x70
[    1.176486] softirqs last  enabled at (0): [<          (null)>]           (null)
[    1.176487] softirqs last disabled at (0): [<          (null)>]           (null)
[    1.176489] 
[    1.176490] other info that might help us debug this:
[    1.176491]  Possible unsafe locking scenario:
[    1.176491] 
[    1.176492]        CPU0
[    1.176493]        ----
[    1.176493]   lock(&(&(&(*({ do { const void *__vpp_verify = (typeof((&(slab_lock))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(slab_lock))) *)(&(slab_lock)))); (typeof((typeof(*(&(slab_lock))) *)(&(slab_lock)))) (__ptr + (((__per_cpu_offset[__cpu])))); }); })).lock)->lock)->wait_lock);
[    1.176498]   <Interrupt>
[    1.176498]     lock(&(&(&(*({ do { const void *__vpp_verify = (typeof((&(slab_lock))))((void *)0); (void)__vpp_verify; } while (0); ({ unsigned long __ptr; __asm__ ("" : "=r"(__ptr) : "0"((typeof(*(&(slab_lock))) *)(&(slab_lock)))); (typeof((typeof(*(&(slab_lock))) *)(&(slab_lock)))) (__ptr + (((__per_cpu_offset[__cpu])))); }); })).lock)->lock)->wait_lock);
[    1.176502] 
[    1.176503]  *** DEADLOCK ***
[    1.176503] 
[    1.176504] no locks held by swapper/0.
[    1.176505] 
[    1.176506] stack backtrace:
[    1.176508] Pid: 0, comm: swapper Not tainted 3.0.0-rt2-crc+ #351
[    1.176509] Call Trace:
[    1.176510]  <IRQ>  [<ffffffff8108ae1f>] print_usage_bug+0x21f/0x270
[    1.176514]  [<ffffffff8108b742>] mark_lock+0x332/0x400
[    1.176517]  [<ffffffff8108c55e>] __lock_acquire+0x75e/0x16a0
[    1.176519]  [<ffffffff8108b608>] ? mark_lock+0x1f8/0x400
[    1.176521]  [<ffffffff815820db>] ? rt_spin_lock_slowlock+0x4b/0x250
[    1.176523]  [<ffffffff8108daa5>] lock_acquire+0x95/0x140
[    1.176525]  [<ffffffff815820db>] ? rt_spin_lock_slowlock+0x4b/0x250
[    1.176528]  [<ffffffff81010294>] ? kzalloc+0x14/0x20
[    1.176530]  [<ffffffff8158351b>] _raw_spin_lock+0x3b/0x50
[    1.176533]  [<ffffffff815820db>] ? rt_spin_lock_slowlock+0x4b/0x250
[    1.176535]  [<ffffffff815820db>] rt_spin_lock_slowlock+0x4b/0x250
[    1.176537]  [<ffffffff81010294>] ? kzalloc+0x14/0x20
[    1.176539]  [<ffffffff815829ac>] rt_spin_lock+0x2c/0x60
[    1.176541]  [<ffffffff81147149>] __kmalloc+0xf9/0x4b0
[    1.176544]  [<ffffffff81010294>] kzalloc+0x14/0x20
[    1.176546]  [<ffffffff81576999>] cpuid4_cache_lookup_regs+0x1bc/0x33a
[    1.176549]  [<ffffffff81079257>] ? __hrtimer_start_range_ns+0x157/0x4a0
[    1.176551]  [<ffffffff81077b48>] ? hrtimer_get_next_event+0xe8/0x110
[    1.176553]  [<ffffffff81581c38>] ? rt_spin_lock_slowunlock+0x78/0x80
[    1.176555]  [<ffffffff815775da>] get_cpu_leaves+0x88/0x318
[    1.176558]  [<ffffffff81095586>] generic_smp_call_function_single_interrupt+0x136/0x190
[    1.176562]  [<ffffffff8101e087>] smp_call_function_single_interrupt+0x27/0x40
[    1.176565]  [<ffffffff8158bb33>] call_function_single_interrupt+0x13/0x20
[    1.176566]  <EOI>  [<ffffffff8100ac4f>] ? default_idle+0x19f/0x1b0
[    1.176570]  [<ffffffff8100ac4d>] ? default_idle+0x19d/0x1b0
[    1.176572]  [<ffffffff8100acd0>] amd_e400_idle+0x70/0x120
[    1.176575]  [<ffffffff8100123f>] cpu_idle+0xdf/0x120
[    1.176577]  [<ffffffff8156a7dc>] rest_init+0xbc/0xd0
[    1.176579]  [<ffffffff8156a720>] ? csum_partial_copy_generic+0x170/0x170
[    1.176582]  [<ffffffff81ba1b7a>] start_kernel+0x31a/0x325
[    1.176584]  [<ffffffff81ba12eb>] x86_64_start_reservations+0xfb/0xff
[    1.176586]  [<ffffffff81ba13dc>] x86_64_start_kernel+0xed/0xf4
[    1.182619] audit: initializing netlink socket (disabled)
[    1.182648] type=2000 audit(1311440614.181:1): initialized
[    1.211068] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.246054] VFS: Disk quotas dquot_6.5.2
[    1.246104] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.246873] msgmni has been set to 15445

Hope this helps.
Ed
