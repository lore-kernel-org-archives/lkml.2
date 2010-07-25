Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab0GYQLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:11:51 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50034 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0GYQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:11:18 -0400
Date: Sun, 25 Jul 2010 17:53:25 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: page allocation failure frequency
Message-ID: <20100725155324.GG31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  There's a strange accumulation of page allocation failures order 1 or 2.
  This happens over a variety of processes: swapper, postconf, iwlagn, firefox,
  Xorg 

  What does this mean?

  Thanks,

    Nils

Feb 21 20:25:12 localhost kernel: [947437.807940] swapper: page allocation failure. order:2, mode:0x20
Feb 21 20:25:12 localhost kernel: [947437.807940] Pid: 0, comm: swapper Tainted: G        W  2.6.32.7 #8
Feb 21 20:25:12 localhost kernel: [947437.807940] Call Trace:
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c10bc2f6>] ? __alloc_pages_nodemask+0x546/0x620
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c10e2f08>] ? cache_alloc_refill+0x2a8/0x500
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c10e32b3>] ? __kmalloc+0x153/0x160
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c15cc312>] ? __alloc_skb+0x52/0x130
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<fd336fed>] ? iwl_rx_allocate+0x6d/0x240 [iwlcore]
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c174694e>] ? _spin_unlock_irqrestore+0xe/0x30
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<fd3371cd>] ? iwl_rx_replenish_now+0xd/0x20 [iwlcore]
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<fd36e056>] ? iwl_irq_tasklet_legacy+0x196/0x440 [iwlagn]
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c101007b>] ? perf_callchain+0x2bb/0x310
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c104c4f9>] ? tasklet_action+0x69/0xe0
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c104dc77>] ? __do_softirq+0xe7/0x1e0
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1092bcf>] ? handle_IRQ_event+0x7f/0x1a0
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c106809e>] ? sched_clock_local+0xce/0x170
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c104dd9d>] ? do_softirq+0x2d/0x40
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c104df85>] ? irq_exit+0x65/0x80
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1004ed5>] ? do_IRQ+0x55/0xc0
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c106f715>] ? tick_notify+0x1d5/0x3b0
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1389726>] ? acpi_hw_read_port+0x23/0x71
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c10035a9>] ? common_interrupt+0x29/0x30
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c13988e6>] ? acpi_idle_enter_bm+0x27c/0x2b1
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c152a935>] ? cpuidle_idle_call+0x85/0x130
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1001f3d>] ? cpu_idle+0x4d/0x90
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1a5c85a>] ? start_kernel+0x2bd/0x31b
Feb 21 20:25:12 localhost kernel: [947437.807940]  [<c1a5c38d>] ? unknown_bootoption+0x0/0x1c2
Feb 21 20:25:12 localhost kernel: [947437.807940] Mem-Info:
Feb 21 20:25:12 localhost kernel: [947437.807940] DMA per-cpu:
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    0: hi:    0, btch:   1 usd:   0
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    1: hi:    0, btch:   1 usd:   0
Feb 21 20:25:12 localhost kernel: [947437.807940] Normal per-cpu:
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    0: hi:  186, btch:  31 usd: 173
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    1: hi:  186, btch:  31 usd: 185
Feb 21 20:25:12 localhost kernel: [947437.807940] HighMem per-cpu:
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    0: hi:  186, btch:  31 usd:  82
Feb 21 20:25:12 localhost kernel: [947437.807940] CPU    1: hi:  186, btch:  31 usd:  97
Feb 21 20:25:12 localhost kernel: [947437.807940] active_anon:362667 inactive_anon:106149 isolated_anon:0
Feb 21 20:25:12 localhost kernel: [947437.807940]  active_file:191215 inactive_file:182867 isolated_file:0
Feb 21 20:25:12 localhost kernel: [947437.807940]  unevictable:64015 dirty:0 writeback:0 unstable:0
Feb 21 20:25:12 localhost kernel: [947437.807940]  free:34920 slab_reclaimable:9508 slab_unreclaimable:26469
Feb 21 20:25:12 localhost kernel: [947437.807940]  mapped:40870 shmem:108648 pagetables:3070 bounce:0
Feb 21 20:25:12 localhost kernel: [947437.807940] DMA free:3492kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:4936kB inactive_file:1668kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:208kB slab_unreclaimable:4976kB kernel_stack:120kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:25:12 localhost kernel: [947437.807940] lowmem_reserve[]: 0 867 3967 3967
Feb 21 20:25:12 localhost kernel: [947437.807940] Normal free:111392kB min:3732kB low:4664kB high:5596kB active_anon:113264kB inactive_anon:145124kB active_file:144564kB inactive_file:120980kB unevictable:7968kB isolated(anon):0kB isolated(file):0kB present:887976kB mlocked:7968kB dirty:0kB writeback:0kB mapped:11432kB shmem:135904kB slab_reclaimable:37824kB slab_unreclaimable:100900kB kernel_stack:3488kB pagetables:12280kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:25:12 localhost kernel: [947437.807940] lowmem_reserve[]: 0 0 24801 24801
Feb 21 20:25:12 localhost kernel: [947437.807940] HighMem free:24796kB min:512kB low:3848kB high:7184kB active_anon:1337404kB inactive_anon:279472kB active_file:615360kB inactive_file:608820kB unevictable:248092kB isolated(anon):0kB isolated(file):0kB present:3174548kB mlocked:244768kB dirty:0kB writeback:0kB mapped:152048kB shmem:298688kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:25:12 localhost kernel: [947437.807940] lowmem_reserve[]: 0 0 0 0
Feb 21 20:25:12 localhost kernel: [947437.807940] DMA: 165*4kB 122*8kB 115*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3476kB
Feb 21 20:25:12 localhost kernel: [947437.807940] Normal: 27680*4kB 4*8kB 0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 111392kB
Feb 21 20:25:12 localhost kernel: [947437.807940] HighMem: 3385*4kB 1121*8kB 131*16kB 4*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 24796kB
Feb 21 20:25:12 localhost kernel: [947437.807940] 537014 total pagecache pages
Feb 21 20:25:12 localhost kernel: [947437.807940] 52990 pages in swap cache
Feb 21 20:25:12 localhost kernel: [947437.807940] Swap cache stats: add 238545, delete 185555, find 17179303/17187128
Feb 21 20:25:12 localhost kernel: [947437.807940] Free swap  = 1552428kB
Feb 21 20:25:12 localhost kernel: [947437.807940] Total swap = 1951856kB
Feb 21 20:25:12 localhost kernel: [947437.807940] 1294336 pages RAM
Feb 21 20:25:12 localhost kernel: [947437.807940] 1066498 pages HighMem
Feb 21 20:25:12 localhost kernel: [947437.807940] 304794 pages reserved
Feb 21 20:25:12 localhost kernel: [947437.807940] 357608 pages shared
Feb 21 20:25:12 localhost kernel: [947437.807940] 697526 pages non-shared
Feb 21 20:25:12 localhost kernel: [947437.843258] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:25:12 localhost kernel: [947437.843258] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:25:12 localhost kernel: [947437.843258] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:25:13 localhost kernel: [947439.181985] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:27:11 localhost kernel: [947557.500222] No probe response from AP 02:24:01:aa:bb:cc after 500ms, disconnecting.
Feb 21 20:27:11 localhost wpa_supplicant[7391]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
Feb 21 20:27:12 localhost kernel: [947557.611009] __ratelimit: 1 callbacks suppressed
Feb 21 20:27:12 localhost kernel: [947557.611009] postconf: page allocation failure. order:2, mode:0x20
Feb 21 20:27:12 localhost kernel: [947557.611009] Pid: 26427, comm: postconf Tainted: G        W  2.6.32.7 #8
Feb 21 20:27:12 localhost kernel: [947557.611009] Call Trace:
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10bc2f6>] ? __alloc_pages_nodemask+0x546/0x620
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1746759>] ? _spin_lock_irqsave+0x19/0x40
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10e2f08>] ? cache_alloc_refill+0x2a8/0x500
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10e32b3>] ? __kmalloc+0x153/0x160
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c15cc312>] ? __alloc_skb+0x52/0x130
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd336fed>] ? iwl_rx_allocate+0x6d/0x240 [iwlcore]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd3371cd>] ? iwl_rx_replenish_now+0xd/0x20 [iwlcore]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd36de35>] ? iwl_rx_handle+0x215/0x2a0 [iwlagn]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd36e056>] ? iwl_irq_tasklet_legacy+0x196/0x440 [iwlagn]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104c4f9>] ? tasklet_action+0x69/0xe0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104dc77>] ? __do_softirq+0xe7/0x1e0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1092bcf>] ? handle_IRQ_event+0x7f/0x1a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10d00fa>] ? handle_mm_fault+0x17a/0x8a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104dd9d>] ? do_softirq+0x2d/0x40
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104df85>] ? irq_exit+0x65/0x80
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1004ed5>] ? do_IRQ+0x55/0xc0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c174691d>] ? _spin_unlock_irq+0xd/0x30
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1057c22>] ? do_sigaction+0x112/0x1a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10035a9>] ? common_interrupt+0x29/0x30
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1002ec1>] ? sysenter_past_esp+0x3a/0x57
Feb 21 20:27:12 localhost kernel: [947557.611009] Mem-Info:
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:    0, btch:   1 usd:   0
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:    0, btch:   1 usd:   0
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:  186, btch:  31 usd: 177
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:  186, btch:  31 usd: 164
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:  186, btch:  31 usd:  59
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:  186, btch:  31 usd: 119
Feb 21 20:27:12 localhost kernel: [947557.611009] active_anon:361246 inactive_anon:106144 isolated_anon:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  active_file:191049 inactive_file:185331 isolated_file:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  unevictable:64016 dirty:0 writeback:0 unstable:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  free:34039 slab_reclaimable:9502 slab_unreclaimable:26440
Feb 21 20:27:12 localhost kernel: [947557.611009]  mapped:42229 shmem:109240 pagetables:3076 bounce:0
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA free:3492kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:4936kB inactive_file:1668kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:208kB slab_unreclaimable:4896kB kernel_stack:208kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 867 3967 3967
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal free:117044kB min:3732kB low:4664kB high:5596kB active_anon:110688kB inactive_anon:145088kB active_file:142208kB inactive_file:120428kB unevictable:7968kB isolated(anon):0kB isolated(file):0kB present:887976kB mlocked:7968kB dirty:0kB writeback:0kB mapped:11368kB shmem:134932kB slab_reclaimable:37800kB slab_unreclaimable:100864kB kernel_stack:3456kB pagetables:12304kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 0 24801 24801
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem free:15620kB min:512kB low:3848kB high:7184kB active_anon:1334296kB inactive_anon:279488kB active_file:617052kB inactive_file:619228kB unevictable:248096kB isolated(anon):0kB isolated(file):0kB present:3174548kB mlocked:244772kB dirty:0kB writeback:0kB mapped:157548kB shmem:302028kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 0 0 0
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA: 165*4kB 118*8kB 118*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3492kB
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal: 29085*4kB 2*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 117044kB
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem: 1701*4kB 1096*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15620kB
Feb 21 20:27:12 localhost kernel: [947557.611009] 539924 total pagecache pages
Feb 21 20:27:12 localhost kernel: [947557.611009] 52985 pages in swap cache
Feb 21 20:27:12 localhost kernel: [947557.611009] Swap cache stats: add 238549, delete 185564, find 17181458/17189284
Feb 21 20:27:12 localhost kernel: [947557.611009] Free swap  = 1552456kB
Feb 21 20:27:12 localhost kernel: [947557.611009] Total swap = 1951856kB
Feb 21 20:27:12 localhost kernel: [947557.611009] 1294336 pages RAM
Feb 21 20:27:12 localhost kernel: [947557.611009] 1066498 pages HighMem
Feb 21 20:27:12 localhost kernel: [947557.611009] 304794 pages reserved
Feb 21 20:27:12 localhost kernel: [947557.611009] 360140 pages shared
Feb 21 20:27:12 localhost kernel: [947557.611009] 696726 pages non-shared
Feb 21 20:27:12 localhost kernel: [947557.611009] postconf: page allocation failure. order:2, mode:0x20
Feb 21 20:27:12 localhost kernel: [947557.611009] Pid: 26427, comm: postconf Tainted: G        W  2.6.32.7 #8
Feb 21 20:27:12 localhost kernel: [947557.611009] Call Trace:
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10bc2f6>] ? __alloc_pages_nodemask+0x546/0x620
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10e3073>] ? cache_alloc_refill+0x413/0x500
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10e2f08>] ? cache_alloc_refill+0x2a8/0x500
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10e32b3>] ? __kmalloc+0x153/0x160
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c15cc312>] ? __alloc_skb+0x52/0x130
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd336799>] ? iwl_rx_queue_restock+0x129/0x330 [iwlcore]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd336fed>] ? iwl_rx_allocate+0x6d/0x240 [iwlcore]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd3371cd>] ? iwl_rx_replenish_now+0xd/0x20 [iwlcore]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<fd36e056>] ? iwl_irq_tasklet_legacy+0x196/0x440 [iwlagn]
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104c4f9>] ? tasklet_action+0x69/0xe0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104dc77>] ? __do_softirq+0xe7/0x1e0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1092bcf>] ? handle_IRQ_event+0x7f/0x1a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10d00fa>] ? handle_mm_fault+0x17a/0x8a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104dd9d>] ? do_softirq+0x2d/0x40
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c104df85>] ? irq_exit+0x65/0x80
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1004ed5>] ? do_IRQ+0x55/0xc0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c174691d>] ? _spin_unlock_irq+0xd/0x30
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1057c22>] ? do_sigaction+0x112/0x1a0
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c10035a9>] ? common_interrupt+0x29/0x30
Feb 21 20:27:12 localhost kernel: [947557.611009]  [<c1002ec1>] ? sysenter_past_esp+0x3a/0x57
Feb 21 20:27:12 localhost kernel: [947557.611009] Mem-Info:
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:    0, btch:   1 usd:   0
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:    0, btch:   1 usd:   0
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:  186, btch:  31 usd: 177
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:  186, btch:  31 usd: 164
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem per-cpu:
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    0: hi:  186, btch:  31 usd:  59
Feb 21 20:27:12 localhost kernel: [947557.611009] CPU    1: hi:  186, btch:  31 usd: 119
Feb 21 20:27:12 localhost kernel: [947557.611009] active_anon:361246 inactive_anon:106144 isolated_anon:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  active_file:191049 inactive_file:185331 isolated_file:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  unevictable:64016 dirty:0 writeback:0 unstable:0
Feb 21 20:27:12 localhost kernel: [947557.611009]  free:34039 slab_reclaimable:9502 slab_unreclaimable:26440
Feb 21 20:27:12 localhost kernel: [947557.611009]  mapped:42229 shmem:109240 pagetables:3076 bounce:0
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA free:3492kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:4936kB inactive_file:1668kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15844kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:208kB slab_unreclaimable:4896kB kernel_stack:208kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 867 3967 3967
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal free:117044kB min:3732kB low:4664kB high:5596kB active_anon:110688kB inactive_anon:145088kB active_file:142208kB inactive_file:120428kB unevictable:7968kB isolated(anon):0kB isolated(file):0kB present:887976kB mlocked:7968kB dirty:0kB writeback:0kB mapped:11368kB shmem:134932kB slab_reclaimable:37800kB slab_unreclaimable:100864kB kernel_stack:3456kB pagetables:12304kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 0 24801 24801
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem free:15620kB min:512kB low:3848kB high:7184kB active_anon:1334296kB inactive_anon:279488kB active_file:617052kB inactive_file:619228kB unevictable:248096kB isolated(anon):0kB isolated(file):0kB present:3174548kB mlocked:244772kB dirty:0kB writeback:0kB mapped:157548kB shmem:302028kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 21 20:27:12 localhost kernel: [947557.611009] lowmem_reserve[]: 0 0 0 0
Feb 21 20:27:12 localhost kernel: [947557.611009] DMA: 165*4kB 118*8kB 118*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3492kB
Feb 21 20:27:12 localhost kernel: [947557.611009] Normal: 29085*4kB 2*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 117044kB
Feb 21 20:27:12 localhost kernel: [947557.611009] HighMem: 1701*4kB 1096*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15620kB
Feb 21 20:27:12 localhost kernel: [947557.611009] 539924 total pagecache pages
Feb 21 20:27:12 localhost kernel: [947557.611009] 52985 pages in swap cache
Feb 21 20:27:12 localhost kernel: [947557.611009] Swap cache stats: add 238549, delete 185564, find 17181458/17189284
Feb 21 20:27:12 localhost kernel: [947557.611009] Free swap  = 1552456kB
Feb 21 20:27:12 localhost kernel: [947557.611009] Total swap = 1951856kB
Feb 21 20:27:12 localhost kernel: [947557.611009] 1294336 pages RAM
Feb 21 20:27:12 localhost kernel: [947557.611009] 1066498 pages HighMem
Feb 21 20:27:12 localhost kernel: [947557.611009] 304794 pages reserved
Feb 21 20:27:12 localhost kernel: [947557.611009] 360140 pages shared
Feb 21 20:27:12 localhost kernel: [947557.611009] 696726 pages non-shared
Feb 21 20:27:12 localhost kernel: [947557.681967] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:27:12 localhost kernel: [947557.681980] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:27:12 localhost kernel: [947557.682411] ALSA sound/usb/usbaudio.c:354: frame 0 active: -18
Feb 21 20:27:12 localhost postfix/master[5160]: reload -- version 2.6.5, configuration /etc/postfix
Feb 21 20:27:12 localhost smokeping[26048]: Got TERM signal, terminating child processes.
Feb 21 20:27:12 localhost smokeping[26048]: All child processes successfully terminated, exiting.
Feb 21 20:27:49 localhost wpa_supplicant[7391]: Authentication with 02:24:01:aa:bb:cc timed out.

