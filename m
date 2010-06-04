Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0FDJ13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:27:29 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:58939
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab0FDJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:27:27 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jun 2010 05:27:26 EDT
Date: Fri, 4 Jun 2010 11:20:25 +0200
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [2.6.35-rc1] page alloc failure order:1, mode:0x4020
Message-ID: <20100604092025.GA96690@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Testing 2.6.35-rc1 on my powerpc based routerboard I saw the following page allocation
error happening during an apt-get update with a semi loaded wlan
interface

[309611.189267] __alloc_pages_slowpath: 52 callbacks suppressed
[309611.194959] gzip: page allocation failure. order:1, mode:0x4020
[309611.200981] Call Trace:
[309611.203547] [c399bc50] [c0008144] show_stack+0x48/0x15c (unreliable)
[309611.210041] [c399bc80] [c006268c] __alloc_pages_nodemask+0x3d4/0x52c
[309611.216512] [c399bd20] [c008619c] __slab_alloc+0x560/0x570
[309611.222111] [c399bd60] [c0086a98] __kmalloc_track_caller+0xd4/0x104
[309611.228505] [c399bd80] [c01dd220] __alloc_skb+0x64/0x124
[309611.233944] [c399bda0] [c994e034] ath_rxbuf_alloc+0x34/0xbc [ath]
[309611.240178] [c399bdc0] [c9a1ec9c] ath_rx_tasklet+0x480/0x7c4 [ath9k]
[309611.246658] [c399be80] [c9a1dae0] ath9k_tasklet+0x114/0x13c [ath9k]
[309611.253055] [c399bea0] [c002532c] tasklet_action+0x88/0x104
[309611.258746] [c399bec0] [c0025e30] __do_softirq+0xb4/0x134
[309611.264261] [c399bf00] [c0005ec4] do_softirq+0x58/0x5c
[309611.269514] [c399bf10] [c0025c20] irq_exit+0x7c/0x9c
[309611.274591] [c399bf20] [c0005f64] do_IRQ+0x9c/0xb4
[309611.279509] [c399bf40] [c00117d8] ret_from_except+0x0/0x14
[309611.285112] --- Exception: 501 at 0xff31f0c
[309611.285121]     LR = 0xff32548
[309611.292536] Mem-Info:
[309611.294899] DMA per-cpu:
[309611.297528] CPU    0: hi:   42, btch:   7 usd:  18
[309611.302444] active_anon:1040 inactive_anon:1160 isolated_anon:0
[309611.302455]  active_file:14871 inactive_file:9440 isolated_file:0
[309611.302467]  unevictable:491 dirty:1258 writeback:0 unstable:0
[309611.302478]  free:628 slab_reclaimable:832 slab_unreclaimable:2312
[309611.302490]  mapped:2254 shmem:36 pagetables:202 bounce:0
[309611.332409] DMA free:2512kB min:1440kB low:1800kB high:2160kB active_anon:4160kB inactive_anon:4640kB active_file:59484kB inactive_file:37760kB unevictable:1964kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:1964kB dirty:5032kB writeback:0kB mapped:9016kB shmem:144kB slab_reclaimable:3328kB slab_unreclaimable:9248kB kernel_stack:528kB pagetables:808kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[309611.372230] lowmem_reserve[]: 0 0 0
[309611.375835] DMA: 596*4kB 14*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2512kB
[309611.386215] 24770 total pagecache pages
[309611.390147] 0 pages in swap cache
[309611.393559] Swap cache stats: add 0, delete 0, find 0/0
[309611.398884] Free swap  = 0kB
[309611.401857] Total swap = 0kB
[309611.411877] 32768 pages RAM
[309611.414765] 1228 pages reserved
[309611.418000] 27690 pages shared
[309611.421147] 8802 pages non-shared
[309611.424560] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[309611.430764]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
[309611.440276]   node 0: slabs: 155, objs: 620, free: 0
[309611.445439] skbuff alloc of size 3872 failed
[309611.449862] gzip: page allocation failure. order:1, mode:0x4020
[309611.455887] Call Trace:
[309611.458448] [c399bc50] [c0008144] show_stack+0x48/0x15c (unreliable)
[309611.464939] [c399bc80] [c006268c] __alloc_pages_nodemask+0x3d4/0x52c
[309611.471410] [c399bd20] [c008619c] __slab_alloc+0x560/0x570
[309611.477010] [c399bd60] [c0086a98] __kmalloc_track_caller+0xd4/0x104
[309611.483402] [c399bd80] [c01dd220] __alloc_skb+0x64/0x124
[309611.488836] [c399bda0] [c994e034] ath_rxbuf_alloc+0x34/0xbc [ath]
[309611.495067] [c399bdc0] [c9a1ec9c] ath_rx_tasklet+0x480/0x7c4 [ath9k]
[309611.501547] [c399be80] [c9a1dae0] ath9k_tasklet+0x114/0x13c [ath9k]
[309611.507944] [c399bea0] [c002532c] tasklet_action+0x88/0x104
[309611.513634] [c399bec0] [c0025e30] __do_softirq+0xb4/0x134
[309611.519150] [c399bf00] [c0005ec4] do_softirq+0x58/0x5c
[309611.524403] [c399bf10] [c0025c20] irq_exit+0x7c/0x9c
[309611.529481] [c399bf20] [c0005f64] do_IRQ+0x9c/0xb4
[309611.534397] [c399bf40] [c00117d8] ret_from_except+0x0/0x14
[309611.539999] --- Exception: 501 at 0xff31f0c
[309611.540008]     LR = 0xff32548
[309611.547421] Mem-Info:
[309611.549784] DMA per-cpu:
[309611.552414] CPU    0: hi:   42, btch:   7 usd:  18
[309611.557328] active_anon:1040 inactive_anon:1160 isolated_anon:0
[309611.557340]  active_file:14871 inactive_file:9440 isolated_file:0
[309611.557351]  unevictable:491 dirty:1258 writeback:0 unstable:0
[309611.557362]  free:628 slab_reclaimable:832 slab_unreclaimable:2312
[309611.557374]  mapped:2254 shmem:36 pagetables:202 bounce:0
[309611.587293] DMA free:2512kB min:1440kB low:1800kB high:2160kB active_anon:4160kB inactive_anon:4640kB active_file:59484kB inactive_file:37760kB unevictable:1964kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:1964kB dirty:5032kB writeback:0kB mapped:9016kB shmem:144kB slab_reclaimable:3328kB slab_unreclaimable:9248kB kernel_stack:528kB pagetables:808kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[309611.627114] lowmem_reserve[]: 0 0 0
[309611.630719] DMA: 596*4kB 14*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2512kB
[309611.641099] 24770 total pagecache pages
[309611.645030] 0 pages in swap cache
[309611.648443] Swap cache stats: add 0, delete 0, find 0/0
[309611.653767] Free swap  = 0kB
[309611.656740] Total swap = 0kB
[309611.666761] 32768 pages RAM
[309611.669650] 1228 pages reserved
[309611.672884] 27690 pages shared
[309611.676030] 8802 pages non-shared
[309611.679444] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[309611.685648]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
[309611.695160]   node 0: slabs: 155, objs: 620, free: 0
[309611.700296] skbuff alloc of size 3872 failed
[309611.705347] gzip: page allocation failure. order:1, mode:0x4020
[309611.711374] Call Trace:
[309611.713939] [c399bc50] [c0008144] show_stack+0x48/0x15c (unreliable)
[309611.720433] [c399bc80] [c006268c] __alloc_pages_nodemask+0x3d4/0x52c
[309611.726904] [c399bd20] [c008619c] __slab_alloc+0x560/0x570
[309611.732504] [c399bd60] [c0086a98] __kmalloc_track_caller+0xd4/0x104
[309611.738899] [c399bd80] [c01dd220] __alloc_skb+0x64/0x124
[309611.744334] [c399bda0] [c994e034] ath_rxbuf_alloc+0x34/0xbc [ath]
[309611.750566] [c399bdc0] [c9a1ec9c] ath_rx_tasklet+0x480/0x7c4 [ath9k]
[309611.757047] [c399be80] [c9a1dae0] ath9k_tasklet+0x114/0x13c [ath9k]
[309611.763445] [c399bea0] [c002532c] tasklet_action+0x88/0x104
[309611.769135] [c399bec0] [c0025e30] __do_softirq+0xb4/0x134
[309611.774650] [c399bf00] [c0005ec4] do_softirq+0x58/0x5c
[309611.779903] [c399bf10] [c0025c20] irq_exit+0x7c/0x9c
[309611.784981] [c399bf20] [c0005f64] do_IRQ+0x9c/0xb4
[309611.789899] [c399bf40] [c00117d8] ret_from_except+0x0/0x14
[309611.795501] --- Exception: 501 at 0xff31f0c
[309611.795510]     LR = 0xff32548
[309611.802923] Mem-Info:
[309611.805287] DMA per-cpu:
[309611.807916] CPU    0: hi:   42, btch:   7 usd:  18
[309611.812831] active_anon:1040 inactive_anon:1160 isolated_anon:0
[309611.812842]  active_file:14871 inactive_file:9440 isolated_file:0
[309611.812854]  unevictable:491 dirty:1258 writeback:0 unstable:0
[309611.812865]  free:628 slab_reclaimable:832 slab_unreclaimable:2312
[309611.812877]  mapped:2254 shmem:36 pagetables:202 bounce:0
[309611.842797] DMA free:2512kB min:1440kB low:1800kB high:2160kB active_anon:4160kB inactive_anon:4640kB active_file:59484kB inactive_file:37760kB unevictable:1964kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:1964kB dirty:5032kB writeback:0kB mapped:9016kB shmem:144kB slab_reclaimable:3328kB slab_unreclaimable:9248kB kernel_stack:528kB pagetables:808kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[309611.882619] lowmem_reserve[]: 0 0 0
[309611.886224] DMA: 596*4kB 14*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2512kB
[309611.896602] 24770 total pagecache pages
[309611.900533] 0 pages in swap cache
[309611.903946] Swap cache stats: add 0, delete 0, find 0/0
[309611.909271] Free swap  = 0kB
[309611.912244] Total swap = 0kB
[309611.922262] 32768 pages RAM
[309611.925151] 1228 pages reserved
[309611.928386] 27690 pages shared
[309611.931532] 8802 pages non-shared
[309611.934946] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[309611.941150]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
[309611.950662]   node 0: slabs: 155, objs: 620, free: 0
[309611.955775] skbuff alloc of size 3872 failed
[309611.960443] gzip: page allocation failure. order:1, mode:0x4020
[309611.966467] Call Trace:
[309611.969029] [c399bc50] [c0008144] show_stack+0x48/0x15c (unreliable)
[309611.975522] [c399bc80] [c006268c] __alloc_pages_nodemask+0x3d4/0x52c
[309611.981993] [c399bd20] [c008619c] __slab_alloc+0x560/0x570
[309611.987592] [c399bd60] [c0086a98] __kmalloc_track_caller+0xd4/0x104
[309611.993986] [c399bd80] [c01dd220] __alloc_skb+0x64/0x124
[309611.999421] [c399bda0] [c994e034] ath_rxbuf_alloc+0x34/0xbc [ath]
[309612.005654] [c399bdc0] [c9a1ec9c] ath_rx_tasklet+0x480/0x7c4 [ath9k]
[309612.012134] [c399be80] [c9a1dae0] ath9k_tasklet+0x114/0x13c [ath9k]
[309612.018530] [c399bea0] [c002532c] tasklet_action+0x88/0x104
[309612.024220] [c399bec0] [c0025e30] __do_softirq+0xb4/0x134
[309612.029735] [c399bf00] [c0005ec4] do_softirq+0x58/0x5c
[309612.034988] [c399bf10] [c0025c20] irq_exit+0x7c/0x9c
[309612.040066] [c399bf20] [c0005f64] do_IRQ+0x9c/0xb4
[309612.044984] [c399bf40] [c00117d8] ret_from_except+0x0/0x14
[309612.050586] --- Exception: 501 at 0xff31f0c
[309612.050595]     LR = 0xff32548
[309612.058009] Mem-Info:
[309612.060372] DMA per-cpu:
[309612.063000] CPU    0: hi:   42, btch:   7 usd:  18
[309612.067914] active_anon:1040 inactive_anon:1160 isolated_anon:0
[309612.067926]  active_file:14871 inactive_file:9440 isolated_file:0
[309612.067937]  unevictable:491 dirty:1258 writeback:0 unstable:0
[309612.067948]  free:628 slab_reclaimable:832 slab_unreclaimable:2312
[309612.067960]  mapped:2254 shmem:36 pagetables:202 bounce:0
[309612.097879] DMA free:2512kB min:1440kB low:1800kB high:2160kB active_anon:4160kB inactive_anon:4640kB active_file:59484kB inactive_file:37760kB unevictable:1964kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:1964kB dirty:5032kB writeback:0kB mapped:9016kB shmem:144kB slab_reclaimable:3328kB slab_unreclaimable:9248kB kernel_stack:528kB pagetables:808kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[309612.137700] lowmem_reserve[]: 0 0 0
[309612.141306] DMA: 596*4kB 14*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2512kB
[309612.151684] 24770 total pagecache pages
[309612.155616] 0 pages in swap cache
[309612.159028] Swap cache stats: add 0, delete 0, find 0/0
[309612.164353] Free swap  = 0kB
[309612.167326] Total swap = 0kB
[309612.177342] 32768 pages RAM
[309612.180231] 1228 pages reserved
[309612.183465] 27690 pages shared
[309612.186612] 8802 pages non-shared
[309612.190025] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[309612.196229]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
[309612.205740]   node 0: slabs: 155, objs: 620, free: 0
[309612.210848] skbuff alloc of size 3872 failed
[309612.215258] gzip: page allocation failure. order:1, mode:0x4020
[309612.221282] Call Trace:
[309612.223842] [c399bc50] [c0008144] show_stack+0x48/0x15c (unreliable)
[309612.230333] [c399bc80] [c006268c] __alloc_pages_nodemask+0x3d4/0x52c
[309612.236804] [c399bd20] [c008619c] __slab_alloc+0x560/0x570
[309612.242405] [c399bd60] [c0086a98] __kmalloc_track_caller+0xd4/0x104
[309612.248797] [c399bd80] [c01dd220] __alloc_skb+0x64/0x124
[309612.254231] [c399bda0] [c994e034] ath_rxbuf_alloc+0x34/0xbc [ath]
[309612.260463] [c399bdc0] [c9a1ec9c] ath_rx_tasklet+0x480/0x7c4 [ath9k]
[309612.266944] [c399be80] [c9a1dae0] ath9k_tasklet+0x114/0x13c [ath9k]
[309612.273340] [c399bea0] [c002532c] tasklet_action+0x88/0x104
[309612.279029] [c399bec0] [c0025e30] __do_softirq+0xb4/0x134
[309612.284544] [c399bf00] [c0005ec4] do_softirq+0x58/0x5c
[309612.289798] [c399bf10] [c0025c20] irq_exit+0x7c/0x9c
[309612.294875] [c399bf20] [c0005f64] do_IRQ+0x9c/0xb4
[309612.299790] [c399bf40] [c00117d8] ret_from_except+0x0/0x14
[309612.305392] --- Exception: 501 at 0xff31f0c
[309612.305401]     LR = 0xff32548
[309612.312816] Mem-Info:
[309612.315179] DMA per-cpu:
[309612.317808] CPU    0: hi:   42, btch:   7 usd:  18
[309612.322723] active_anon:1040 inactive_anon:1160 isolated_anon:0
[309612.322734]  active_file:14871 inactive_file:9440 isolated_file:0
[309612.322746]  unevictable:491 dirty:1258 writeback:0 unstable:0
[309612.322757]  free:628 slab_reclaimable:832 slab_unreclaimable:2312
[309612.322769]  mapped:2254 shmem:36 pagetables:202 bounce:0
[309612.352687] DMA free:2512kB min:1440kB low:1800kB high:2160kB active_anon:4160kB inactive_anon:4640kB active_file:59484kB inactive_file:37760kB unevictable:1964kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:1964kB dirty:5032kB writeback:0kB mapped:9016kB shmem:144kB slab_reclaimable:3328kB slab_unreclaimable:9248kB kernel_stack:528kB pagetables:808kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[309612.392508] lowmem_reserve[]: 0 0 0
[309612.396113] DMA: 596*4kB 14*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2512kB
[309612.406493] 24770 total pagecache pages
[309612.410424] 0 pages in swap cache
[309612.413837] Swap cache stats: add 0, delete 0, find 0/0
[309612.419162] Free swap  = 0kB
[309612.422134] Total swap = 0kB
[309612.432142] 32768 pages RAM
[309612.435031] 1228 pages reserved
[309612.438264] 27690 pages shared
[309612.441411] 8802 pages non-shared
[309612.444825] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[309612.451029]   cache: kmalloc-8192, object size: 8192, buffer size: 8192, default order: 3, min order: 1
[309612.460540]   node 0: slabs: 155, objs: 620, free: 0
[309612.465644] skbuff alloc of size 3872 failed
[309612.470056] skbuff alloc of size 3872 failed
[309612.474462] skbuff alloc of size 3872 failed
[309612.478867] skbuff alloc of size 3872 failed
[309612.483272] skbuff alloc of size 3872 failed
[309612.487682] skbuff alloc of size 3872 failed
[309612.492091] skbuff alloc of size 3872 failed
[309612.496497] skbuff alloc of size 3872 failed
[309612.500906] skbuff alloc of size 3872 failed
[309612.505312] skbuff alloc of size 3872 failed
[309612.509724] skbuff alloc of size 3872 failed
[309612.514130] skbuff alloc of size 3872 failed
[309612.518540] skbuff alloc of size 3872 failed
[309612.523620] skbuff alloc of size 3872 failed
[309613.467566] skbuff alloc of size 3872 failed
[309613.472040] skbuff alloc of size 3872 failed
[309613.477735] phy0: failed to reallocate TX buffer
[309613.478377] skbuff alloc of size 3872 failed
[309613.488549] skbuff alloc of size 3872 failed
[309613.493021] skbuff alloc of size 3872 failed

I never saw this before on this board. Every kernel starting from .28
was rock solid and did not show me this kind of error at all. The board
does not freeze and continues to work but I still do not understand why
it cannot allocate memory here.


Kind regards,
Michael Guntsche
