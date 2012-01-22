Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2AVCi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 21:38:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64701 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2AVCiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 21:38:55 -0500
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
Date: Sat, 21 Jan 2012 21:38:54 -0500
Message-ID: <CAO9zADykAFW6omxbKfHj-6=srgcAqREqGAOyTqMt4PEEhM06KQ@mail.gmail.com>
Subject: 3.2.0 - page allocation failure: order:[2345] mode:0x20
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Question:
Is the below normal or is this a kernel bug?

Specs:
Kernel: 3.2.0
Arch: x86_64
Dist: Debian Testing

Running 3.2.0 on x86_64; generally little to no swap use depending on
what is running (e.g., chrome)
top--
Mem:   7925172k total,  7401552k used,   523620k free,    74472k buffers
Swap:  2097148k total,     6184k used,  2090964k free,  6384816k cached

Lots of page allocation failures:
[1434349.602309] sshd: page allocation failure: order:3, mode:0x20
[1434366.128757] sshd: page allocation failure: order:2, mode:0x20
[1434371.230589] sshd: page allocation failure: order:2, mode:0x20
[1434379.875637] sshd: page allocation failure: order:2, mode:0x20
[1434382.297359] sshd: page allocation failure: order:2, mode:0x20
[1434400.613413] sshd: page allocation failure: order:2, mode:0x20
[1434416.045552] sshd: page allocation failure: order:2, mode:0x20
[1434464.451536] sshd: page allocation failure: order:2, mode:0x20
[1434484.263995] sshd: page allocation failure: order:2, mode:0x20
[1434530.576964] sshd: page allocation failure: order:2, mode:0x20
[1434532.081766] sshd: page allocation failure: order:2, mode:0x20
[1434598.565047] sshd: page allocation failure: order:2, mode:0x20
[1435042.448475] sshd: page allocation failure: order:2, mode:0x20
[1435079.396197] sshd: page allocation failure: order:3, mode:0x20
[1435091.430738] sshd: page allocation failure: order:3, mode:0x20
[1435111.592390] sshd: page allocation failure: order:2, mode:0x20
[1437838.620185] Xvnc4: page allocation failure: order:3, mode:0x20
[1438731.114902] swapper/0: page allocation failure: order:4, mode:0x20
[1438751.732625] swapper/0: page allocation failure: order:5, mode:0x20
[1438766.984196] swapper/0: page allocation failure: order:5, mode:0x20
[1438770.524379] swapper/0: page allocation failure: order:4, mode:0x20
[1438774.992454] gpsd: page allocation failure: order:4, mode:0x20

dmesg output:
[1434347.219228]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434347.219231]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434347.219233]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434347.219236]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434347.219239]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434347.219243]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434347.219246]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434347.219249]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434347.219252]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434347.219254]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434347.219258]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434347.219260] Mem-Info:
[1434347.219261] DMA per-cpu:
[1434347.219263] CPU    0: hi:    0, btch:   1 usd:   0
[1434347.219265] CPU    1: hi:    0, btch:   1 usd:   0
[1434347.219267] CPU    2: hi:    0, btch:   1 usd:   0
[1434347.219269] CPU    3: hi:    0, btch:   1 usd:   0
[1434347.219270] DMA32 per-cpu:
[1434347.219272] CPU    0: hi:  186, btch:  31 usd: 174
[1434347.219274] CPU    1: hi:  186, btch:  31 usd:  77
[1434347.219275] CPU    2: hi:  186, btch:  31 usd:   3
[1434347.219277] CPU    3: hi:  186, btch:  31 usd:  50
[1434347.219279] Normal per-cpu:
[1434347.219280] CPU    0: hi:  186, btch:  31 usd:  80
[1434347.219282] CPU    1: hi:  186, btch:  31 usd:  30
[1434347.219283] CPU    2: hi:  186, btch:  31 usd:  43
[1434347.219285] CPU    3: hi:  186, btch:  31 usd:  86
[1434347.219289] active_anon:151193 inactive_anon:32860 isolated_anon:0
[1434347.219290]  active_file:296308 inactive_file:1120342 isolated_file:0
[1434347.219291]  unevictable:0 dirty:6 writeback:2 unstable:0
[1434347.219292]  free:151415 slab_reclaimable:205718 slab_unreclaimable:9639
[1434347.219293]  mapped:10994 shmem:1651 pagetables:6615 bounce:0
[1434347.219299] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434347.219304] lowmem_reserve[]: 0 2742 7792 7792
[1434347.219311] DMA32 free:480808kB min:47480kB low:59348kB
high:71220kB active_anon:52352kB inactive_anon:29732kB
active_file:524128kB inactive_file:1313928kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:0kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378480kB slab_unreclaimable:8708kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434347.219316] lowmem_reserve[]: 0 0 5050 5050
[1434347.219323] Normal free:109184kB min:87420kB low:109272kB
high:131128kB active_anon:552420kB inactive_anon:101708kB
active_file:661104kB inactive_file:3167440kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:24kB writeback:8kB mapped:40860kB shmem:6336kB
slab_reclaimable:444392kB slab_unreclaimable:29848kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434347.219328] lowmem_reserve[]: 0 0 0 0
[1434347.219331] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434347.219339] DMA32: 96214*4kB 11714*8kB 8*16kB 2*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 480808kB
[1434347.219346] Normal: 22302*4kB 1473*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109184kB
[1434347.219353] 1418527 total pagecache pages
[1434347.219355] 227 pages in swap cache
[1434347.219356] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434347.219358] Free swap  = 2091068kB
[1434347.219359] Total swap = 2097148kB
[1434347.220001] 2031600 pages RAM
[1434347.220001] 50307 pages reserved
[1434347.220001] 336536 pages shared
[1434347.220001] 1541462 pages non-shared
[1434349.602309] sshd: page allocation failure: order:3, mode:0x20
[1434349.602315] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434349.602317] Call Trace:
[1434349.602325]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434349.602329]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434349.602332]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434349.602336]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434349.602339]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434349.602343]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434349.602346]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434349.602348]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434349.602352]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434349.602355]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434349.602359]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434349.602362]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434349.602365]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434349.602368]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434349.602371]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434349.602374]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434349.602377]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434349.602380]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434349.602383]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434349.602386]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434349.602389]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434349.602391]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434349.602395]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434349.602399]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434349.602402]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434349.602405]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434349.602407]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434349.602410]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434349.602414]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434349.602416] Mem-Info:
[1434349.602417] DMA per-cpu:
[1434349.602419] CPU    0: hi:    0, btch:   1 usd:   0
[1434349.602421] CPU    1: hi:    0, btch:   1 usd:   0
[1434349.602423] CPU    2: hi:    0, btch:   1 usd:   0
[1434349.602425] CPU    3: hi:    0, btch:   1 usd:   0
[1434349.602426] DMA32 per-cpu:
[1434349.602428] CPU    0: hi:  186, btch:  31 usd: 164
[1434349.602430] CPU    1: hi:  186, btch:  31 usd:  56
[1434349.602431] CPU    2: hi:  186, btch:  31 usd:   6
[1434349.602433] CPU    3: hi:  186, btch:  31 usd: 106
[1434349.602435] Normal per-cpu:
[1434349.602436] CPU    0: hi:  186, btch:  31 usd: 185
[1434349.602438] CPU    1: hi:  186, btch:  31 usd:  40
[1434349.602439] CPU    2: hi:  186, btch:  31 usd:  51
[1434349.602441] CPU    3: hi:  186, btch:  31 usd: 164
[1434349.602445] active_anon:151448 inactive_anon:32860 isolated_anon:0
[1434349.602446]  active_file:296352 inactive_file:1116061 isolated_file:0
[1434349.602447]  unevictable:0 dirty:20 writeback:0 unstable:0
[1434349.602448]  free:155766 slab_reclaimable:205083 slab_unreclaimable:9783
[1434349.602449]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434349.602455] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434349.602460] lowmem_reserve[]: 0 2742 7792 7792
[1434349.602467] DMA32 free:498088kB min:47480kB low:59348kB
high:71220kB active_anon:52564kB inactive_anon:29732kB
active_file:524156kB inactive_file:1296120kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378480kB slab_unreclaimable:9072kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:79 all_unreclaimable? no
[1434349.602472] lowmem_reserve[]: 0 0 5050 5050
[1434349.602479] Normal free:109060kB min:87420kB low:109272kB
high:131128kB active_anon:553228kB inactive_anon:101708kB
active_file:661252kB inactive_file:3167852kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:76kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:441852kB slab_unreclaimable:30060kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:30 all_unreclaimable? no
[1434349.602484] lowmem_reserve[]: 0 0 0 0
[1434349.602487] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434349.602495] DMA32: 96047*4kB 12847*8kB 575*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 498212kB
[1434349.602502] Normal: 25204*4kB 14*8kB 2*16kB 1*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109184kB
[1434349.602509] 1414248 total pagecache pages
[1434349.602511] 227 pages in swap cache
[1434349.602512] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434349.602514] Free swap  = 2091068kB
[1434349.602515] Total swap = 2097148kB
[1434349.603001] 2031600 pages RAM
[1434349.603001] 50307 pages reserved
[1434349.603001] 336108 pages shared
[1434349.603001] 1532946 pages non-shared
[1434366.128757] sshd: page allocation failure: order:2, mode:0x20
[1434366.128763] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434366.128765] Call Trace:
[1434366.128773]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434366.128778]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434366.128781]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434366.128784]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434366.128788]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434366.128791]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434366.128795]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434366.128797]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434366.128801]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434366.128804]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434366.128808]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434366.128811]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434366.128814]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434366.128817]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434366.128820]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434366.128823]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434366.128826]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434366.128829]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434366.128832]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434366.128836]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434366.128838]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434366.128841]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434366.128844]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434366.128848]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434366.128851]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434366.128854]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434366.128857]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434366.128860]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434366.128863]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434366.128867]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434366.128869] Mem-Info:
[1434366.128870] DMA per-cpu:
[1434366.128872] CPU    0: hi:    0, btch:   1 usd:   0
[1434366.128874] CPU    1: hi:    0, btch:   1 usd:   0
[1434366.128876] CPU    2: hi:    0, btch:   1 usd:   0
[1434366.128877] CPU    3: hi:    0, btch:   1 usd:   0
[1434366.128879] DMA32 per-cpu:
[1434366.128881] CPU    0: hi:  186, btch:  31 usd: 151
[1434366.128883] CPU    1: hi:  186, btch:  31 usd:  26
[1434366.128884] CPU    2: hi:  186, btch:  31 usd:   2
[1434366.128886] CPU    3: hi:  186, btch:  31 usd:  23
[1434366.128888] Normal per-cpu:
[1434366.128889] CPU    0: hi:  186, btch:  31 usd: 178
[1434366.128891] CPU    1: hi:  186, btch:  31 usd:  46
[1434366.128893] CPU    2: hi:  186, btch:  31 usd:  32
[1434366.128894] CPU    3: hi:  186, btch:  31 usd:  47
[1434366.128898] active_anon:151608 inactive_anon:32860 isolated_anon:0
[1434366.128899]  active_file:296370 inactive_file:1175926 isolated_file:0
[1434366.128901]  unevictable:0 dirty:28 writeback:0 unstable:0
[1434366.128901]  free:98735 slab_reclaimable:202513 slab_unreclaimable:9677
[1434366.128903]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434366.128908] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434366.128913] lowmem_reserve[]: 0 2742 7792 7792
[1434366.128920] DMA32 free:269808kB min:47480kB low:59348kB
high:71220kB active_anon:52940kB inactive_anon:29732kB
active_file:524156kB inactive_file:1524888kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378444kB slab_unreclaimable:9120kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434366.128925] lowmem_reserve[]: 0 0 5050 5050
[1434366.128932] Normal free:109216kB min:87420kB low:109272kB
high:131128kB active_anon:553492kB inactive_anon:101708kB
active_file:661324kB inactive_file:3178816kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:108kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:431608kB slab_unreclaimable:29588kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434366.128937] lowmem_reserve[]: 0 0 0 0
[1434366.128940] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434366.128947] DMA32: 66878*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 269560kB
[1434366.128955] Normal: 25254*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109216kB
[1434366.128962] 1474232 total pagecache pages
[1434366.128964] 227 pages in swap cache
[1434366.128965] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434366.128967] Free swap  = 2091068kB
[1434366.128968] Total swap = 2097148kB
[1434366.129484] 2031600 pages RAM
[1434366.129484] 50307 pages reserved
[1434366.129484] 335301 pages shared
[1434366.129484] 1594629 pages non-shared
[1434371.230589] sshd: page allocation failure: order:2, mode:0x20
[1434371.230594] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434371.230596] Call Trace:
[1434371.230604]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434371.230608]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434371.230612]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434371.230615]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434371.230619]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434371.230622]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434371.230626]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434371.230628]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434371.230632]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434371.230635]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434371.230639]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434371.230642]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434371.230645]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434371.230648]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434371.230651]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434371.230654]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434371.230657]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434371.230660]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434371.230663]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434371.230667]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434371.230670]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434371.230672]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434371.230675]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434371.230679]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434371.230682]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434371.230686]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434371.230688]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434371.230691]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434371.230694]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434371.230698]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434371.230700] Mem-Info:
[1434371.230701] DMA per-cpu:
[1434371.230703] CPU    0: hi:    0, btch:   1 usd:   0
[1434371.230705] CPU    1: hi:    0, btch:   1 usd:   0
[1434371.230707] CPU    2: hi:    0, btch:   1 usd:   0
[1434371.230708] CPU    3: hi:    0, btch:   1 usd:   0
[1434371.230710] DMA32 per-cpu:
[1434371.230712] CPU    0: hi:  186, btch:  31 usd: 173
[1434371.230714] CPU    1: hi:  186, btch:  31 usd:  21
[1434371.230715] CPU    2: hi:  186, btch:  31 usd:   2
[1434371.230717] CPU    3: hi:  186, btch:  31 usd:  94
[1434371.230719] Normal per-cpu:
[1434371.230720] CPU    0: hi:  186, btch:  31 usd: 174
[1434371.230722] CPU    1: hi:  186, btch:  31 usd:  69
[1434371.230723] CPU    2: hi:  186, btch:  31 usd:  46
[1434371.230725] CPU    3: hi:  186, btch:  31 usd:  42
[1434371.230729] active_anon:151622 inactive_anon:32860 isolated_anon:0
[1434371.230730]  active_file:296327 inactive_file:1187218 isolated_file:0
[1434371.230731]  unevictable:0 dirty:43 writeback:0 unstable:0
[1434371.230732]  free:88348 slab_reclaimable:201550 slab_unreclaimable:9623
[1434371.230733]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434371.230739] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434371.230744] lowmem_reserve[]: 0 2742 7792 7792
[1434371.230751] DMA32 free:228260kB min:47480kB low:59348kB
high:71220kB active_anon:52960kB inactive_anon:29732kB
active_file:524156kB inactive_file:1565920kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378444kB slab_unreclaimable:9128kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:95 all_unreclaimable? no
[1434371.230757] lowmem_reserve[]: 0 0 5050 5050
[1434371.230763] Normal free:109216kB min:87420kB low:109272kB
high:131128kB active_anon:553528kB inactive_anon:101708kB
active_file:661152kB inactive_file:3182952kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:168kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:427756kB slab_unreclaimable:29364kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434371.230769] lowmem_reserve[]: 0 0 0 0
[1434371.230772] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434371.230779] DMA32: 56553*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 228260kB
[1434371.230786] Normal: 25256*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109216kB
[1434371.230794] 1485359 total pagecache pages
[1434371.230795] 227 pages in swap cache
[1434371.230797] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434371.230799] Free swap  = 2091068kB
[1434371.230800] Total swap = 2097148kB
[1434371.231315] 2031600 pages RAM
[1434371.231315] 50307 pages reserved
[1434371.231315] 334956 pages shared
[1434371.231315] 1604183 pages non-shared
[1434379.875637] sshd: page allocation failure: order:2, mode:0x20
[1434379.875642] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434379.875644] Call Trace:
[1434379.875652]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434379.875656]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434379.875659]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434379.875663]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434379.875666]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434379.875669]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434379.875673]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434379.875675]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434379.875684]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434379.875687]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434379.875691]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434379.875694]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434379.875697]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434379.875700]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434379.875703]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434379.875707]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434379.875709]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434379.875712]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434379.875716]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434379.875719]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434379.875722]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434379.875724]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434379.875728]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434379.875733]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434379.875737]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1434379.875740]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434379.875743]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434379.875747]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1434379.875750]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1434379.875753]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434379.875755]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434379.875760]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434379.875762] Mem-Info:
[1434379.875764] DMA per-cpu:
[1434379.875766] CPU    0: hi:    0, btch:   1 usd:   0
[1434379.875768] CPU    1: hi:    0, btch:   1 usd:   0
[1434379.875770] CPU    2: hi:    0, btch:   1 usd:   0
[1434379.875771] CPU    3: hi:    0, btch:   1 usd:   0
[1434379.875773] DMA32 per-cpu:
[1434379.875775] CPU    0: hi:  186, btch:  31 usd: 159
[1434379.875777] CPU    1: hi:  186, btch:  31 usd:  28
[1434379.875778] CPU    2: hi:  186, btch:  31 usd:   0
[1434379.875780] CPU    3: hi:  186, btch:  31 usd:  38
[1434379.875782] Normal per-cpu:
[1434379.875783] CPU    0: hi:  186, btch:  31 usd: 184
[1434379.875785] CPU    1: hi:  186, btch:  31 usd:  46
[1434379.875787] CPU    2: hi:  186, btch:  31 usd:   0
[1434379.875788] CPU    3: hi:  186, btch:  31 usd:  41
[1434379.875793] active_anon:151622 inactive_anon:32860 isolated_anon:0
[1434379.875794]  active_file:296321 inactive_file:1202708 isolated_file:0
[1434379.875795]  unevictable:0 dirty:38 writeback:0 unstable:0
[1434379.875796]  free:74669 slab_reclaimable:199851 slab_unreclaimable:9558
[1434379.875797]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434379.875803] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434379.875808] lowmem_reserve[]: 0 2742 7792 7792
[1434379.875815] DMA32 free:173616kB min:47480kB low:59348kB
high:71220kB active_anon:52960kB inactive_anon:29732kB
active_file:524156kB inactive_file:1620788kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378436kB slab_unreclaimable:9156kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434379.875821] lowmem_reserve[]: 0 0 5050 5050
[1434379.875827] Normal free:109144kB min:87420kB low:109272kB
high:131128kB active_anon:553528kB inactive_anon:101708kB
active_file:661128kB inactive_file:3190044kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:148kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:420968kB slab_unreclaimable:29076kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434379.875833] lowmem_reserve[]: 0 0 0 0
[1434379.875835] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434379.875843] DMA32: 36702*4kB 3095*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 173616kB
[1434379.875850] Normal: 25269*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109268kB
[1434379.875857] 1500903 total pagecache pages
[1434379.875859] 227 pages in swap cache
[1434379.875860] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434379.875862] Free swap  = 2091068kB
[1434379.875863] Total swap = 2097148kB
[1434379.876001] 2031600 pages RAM
[1434379.876001] 50307 pages reserved
[1434379.876001] 334281 pages shared
[1434379.876001] 1620356 pages non-shared
[1434382.297359] sshd: page allocation failure: order:2, mode:0x20
[1434382.297364] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434382.297366] Call Trace:
[1434382.297374]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434382.297378]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434382.297381]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434382.297385]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434382.297388]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434382.297392]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434382.297395]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434382.297397]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434382.297401]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434382.297404]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434382.297408]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434382.297411]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434382.297415]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434382.297418]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434382.297421]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434382.297424]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434382.297427]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434382.297429]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434382.297433]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434382.297436]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434382.297439]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434382.297442]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434382.297444]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434382.297448]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434382.297451]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434382.297455]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434382.297457]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434382.297460]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434382.297463]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434382.297467]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434382.297469] Mem-Info:
[1434382.297470] DMA per-cpu:
[1434382.297472] CPU    0: hi:    0, btch:   1 usd:   0
[1434382.297474] CPU    1: hi:    0, btch:   1 usd:   0
[1434382.297476] CPU    2: hi:    0, btch:   1 usd:   0
[1434382.297477] CPU    3: hi:    0, btch:   1 usd:   0
[1434382.297479] DMA32 per-cpu:
[1434382.297481] CPU    0: hi:  186, btch:  31 usd: 169
[1434382.297482] CPU    1: hi:  186, btch:  31 usd:  37
[1434382.297484] CPU    2: hi:  186, btch:  31 usd:   0
[1434382.297486] CPU    3: hi:  186, btch:  31 usd:  88
[1434382.297487] Normal per-cpu:
[1434382.297489] CPU    0: hi:  186, btch:  31 usd: 183
[1434382.297491] CPU    1: hi:  186, btch:  31 usd:  47
[1434382.297492] CPU    2: hi:  186, btch:  31 usd:  19
[1434382.297494] CPU    3: hi:  186, btch:  31 usd:  51
[1434382.297498] active_anon:151622 inactive_anon:32860 isolated_anon:0
[1434382.297499]  active_file:296324 inactive_file:1207924 isolated_file:0
[1434382.297500]  unevictable:0 dirty:17 writeback:28 unstable:0
[1434382.297501]  free:69912 slab_reclaimable:199415 slab_unreclaimable:9569
[1434382.297502]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434382.297508] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434382.297513] lowmem_reserve[]: 0 2742 7792 7792
[1434382.297520] DMA32 free:154712kB min:47480kB low:59348kB
high:71220kB active_anon:52960kB inactive_anon:29732kB
active_file:524156kB inactive_file:1639556kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:8kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378452kB slab_unreclaimable:9220kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:99 all_unreclaimable? no
[1434382.297525] lowmem_reserve[]: 0 0 5050 5050
[1434382.297532] Normal free:109020kB min:87420kB low:109272kB
high:131128kB active_anon:553528kB inactive_anon:101708kB
active_file:661140kB inactive_file:3192140kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:60kB writeback:112kB mapped:40876kB shmem:6336kB
slab_reclaimable:419208kB slab_unreclaimable:29056kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434382.297537] lowmem_reserve[]: 0 0 0 0
[1434382.297540] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434382.297547] DMA32: 38135*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 154588kB
[1434382.297555] Normal: 25207*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109020kB
[1434382.297562] 1506097 total pagecache pages
[1434382.297563] 227 pages in swap cache
[1434382.297565] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434382.297567] Free swap  = 2091068kB
[1434382.297568] Total swap = 2097148kB
[1434382.298078] 2031600 pages RAM
[1434382.298078] 50307 pages reserved
[1434382.298078] 334120 pages shared
[1434382.298078] 1624277 pages non-shared
[1434400.613413] sshd: page allocation failure: order:2, mode:0x20
[1434400.613419] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434400.613421] Call Trace:
[1434400.613429]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434400.613433]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434400.613437]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434400.613440]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434400.613444]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434400.613447]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434400.613450]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434400.613453]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434400.613456]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434400.613460]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434400.613463]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434400.613466]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434400.613470]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434400.613473]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434400.613476]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434400.613479]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434400.613482]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434400.613485]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434400.613488]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434400.613492]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434400.613494]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434400.613497]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434400.613500]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434400.613503]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434400.613507]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434400.613510]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434400.613513]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434400.613516]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434400.613518]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434400.613522]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434400.613524] Mem-Info:
[1434400.613526] DMA per-cpu:
[1434400.613528] CPU    0: hi:    0, btch:   1 usd:   0
[1434400.613530] CPU    1: hi:    0, btch:   1 usd:   0
[1434400.613531] CPU    2: hi:    0, btch:   1 usd:   0
[1434400.613533] CPU    3: hi:    0, btch:   1 usd:   0
[1434400.613535] DMA32 per-cpu:
[1434400.613536] CPU    0: hi:  186, btch:  31 usd: 178
[1434400.613538] CPU    1: hi:  186, btch:  31 usd:  33
[1434400.613540] CPU    2: hi:  186, btch:  31 usd:   0
[1434400.613542] CPU    3: hi:  186, btch:  31 usd: 105
[1434400.613543] Normal per-cpu:
[1434400.613545] CPU    0: hi:  186, btch:  31 usd: 162
[1434400.613546] CPU    1: hi:  186, btch:  31 usd:  52
[1434400.613548] CPU    2: hi:  186, btch:  31 usd:   1
[1434400.613550] CPU    3: hi:  186, btch:  31 usd:  36
[1434400.613554] active_anon:151628 inactive_anon:32860 isolated_anon:0
[1434400.613555]  active_file:295682 inactive_file:1226203 isolated_file:0
[1434400.613556]  unevictable:0 dirty:44 writeback:0 unstable:0
[1434400.613557]  free:55523 slab_reclaimable:196146 slab_unreclaimable:9516
[1434400.613558]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434400.613563] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434400.613568] lowmem_reserve[]: 0 2742 7792 7792
[1434400.613575] DMA32 free:97036kB min:47480kB low:59348kB
high:71220kB active_anon:52972kB inactive_anon:29732kB
active_file:524072kB inactive_file:1696792kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:24kB writeback:0kB mapped:3116kB shmem:268kB
slab_reclaimable:378416kB slab_unreclaimable:9136kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:104 all_unreclaimable? no
[1434400.613581] lowmem_reserve[]: 0 0 5050 5050
[1434400.613587] Normal free:109140kB min:87420kB low:109272kB
high:131128kB active_anon:553540kB inactive_anon:101708kB
active_file:658656kB inactive_file:3207860kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:152kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:406168kB slab_unreclaimable:28928kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434400.613593] lowmem_reserve[]: 0 0 0 0
[1434400.613596] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434400.613603] DMA32: 23747*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 97036kB
[1434400.613610] Normal: 25241*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB
1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 109140kB
[1434400.613618] 1523802 total pagecache pages
[1434400.613619] 227 pages in swap cache
[1434400.613621] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434400.613622] Free swap  = 2091068kB
[1434400.613624] Total swap = 2097148kB
[1434400.614139] 2031600 pages RAM
[1434400.614139] 50307 pages reserved
[1434400.614139] 331708 pages shared
[1434400.614139] 1634379 pages non-shared
[1434416.045552] sshd: page allocation failure: order:2, mode:0x20
[1434416.045558] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434416.045560] Call Trace:
[1434416.045568]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434416.045572]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434416.045576]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434416.045579]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434416.045582]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434416.045586]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434416.045589]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434416.045591]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434416.045595]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434416.045598]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434416.045602]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434416.045604]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434416.045608]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434416.045611]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434416.045614]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434416.045617]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434416.045620]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434416.045623]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434416.045626]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434416.045630]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434416.045632]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434416.045635]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434416.045638]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434416.045641]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434416.045645]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434416.045648]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434416.045651]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434416.045654]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434416.045656]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434416.045661]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434416.045663] Mem-Info:
[1434416.045664] DMA per-cpu:
[1434416.045667] CPU    0: hi:    0, btch:   1 usd:   0
[1434416.045669] CPU    1: hi:    0, btch:   1 usd:   0
[1434416.045670] CPU    2: hi:    0, btch:   1 usd:   0
[1434416.045672] CPU    3: hi:    0, btch:   1 usd:   0
[1434416.045674] DMA32 per-cpu:
[1434416.045675] CPU    0: hi:  186, btch:  31 usd: 171
[1434416.045677] CPU    1: hi:  186, btch:  31 usd:  55
[1434416.045679] CPU    2: hi:  186, btch:  31 usd:   0
[1434416.045681] CPU    3: hi:  186, btch:  31 usd:  33
[1434416.045682] Normal per-cpu:
[1434416.045684] CPU    0: hi:  186, btch:  31 usd: 176
[1434416.045685] CPU    1: hi:  186, btch:  31 usd:  23
[1434416.045687] CPU    2: hi:  186, btch:  31 usd:   0
[1434416.045689] CPU    3: hi:  186, btch:  31 usd:  49
[1434416.045693] active_anon:151628 inactive_anon:32860 isolated_anon:0
[1434416.045694]  active_file:295390 inactive_file:1217178 isolated_file:0
[1434416.045695]  unevictable:0 dirty:23 writeback:0 unstable:0
[1434416.045696]  free:66906 slab_reclaimable:194190 slab_unreclaimable:9509
[1434416.045697]  mapped:10997 shmem:1651 pagetables:6615 bounce:0
[1434416.045702] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434416.045707] lowmem_reserve[]: 0 2742 7792 7792
[1434416.045714] DMA32 free:142520kB min:47480kB low:59348kB
high:71220kB active_anon:52972kB inactive_anon:29732kB
active_file:524072kB inactive_file:1651972kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:378244kB slab_unreclaimable:9204kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434416.045719] lowmem_reserve[]: 0 0 5050 5050
[1434416.045726] Normal free:109188kB min:87420kB low:109272kB
high:131128kB active_anon:553540kB inactive_anon:101708kB
active_file:657488kB inactive_file:3216740kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:88kB writeback:0kB mapped:40876kB shmem:6336kB
slab_reclaimable:398516kB slab_unreclaimable:28832kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434416.045731] lowmem_reserve[]: 0 0 0 0
[1434416.045734] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434416.045742] DMA32: 35087*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 142396kB
[1434416.045749] Normal: 25253*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB
1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 109188kB
[1434416.045756] 1514471 total pagecache pages
[1434416.045757] 227 pages in swap cache
[1434416.045759] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434416.045761] Free swap  = 2091068kB
[1434416.045762] Total swap = 2097148kB
[1434416.046271] 2031600 pages RAM
[1434416.046271] 50307 pages reserved
[1434416.046271] 330289 pages shared
[1434416.046271] 1630801 pages non-shared
[1434464.451536] sshd: page allocation failure: order:2, mode:0x20
[1434464.451542] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434464.451544] Call Trace:
[1434464.451552]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434464.451556]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434464.451559]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434464.451563]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434464.451566]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434464.451569]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434464.451573]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434464.451575]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434464.451579]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434464.451582]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434464.451586]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434464.451589]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434464.451593]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434464.451596]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434464.451599]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434464.451602]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434464.451605]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434464.451608]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434464.451611]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434464.451614]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434464.451616]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434464.451619]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434464.451623]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434464.451627]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434464.451631]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1434464.451634]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434464.451637]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434464.451641]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1434464.451643]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1434464.451646]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434464.451649]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434464.451653]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434464.451655] Mem-Info:
[1434464.451657] DMA per-cpu:
[1434464.451659] CPU    0: hi:    0, btch:   1 usd:   0
[1434464.451661] CPU    1: hi:    0, btch:   1 usd:   0
[1434464.451663] CPU    2: hi:    0, btch:   1 usd:   0
[1434464.451664] CPU    3: hi:    0, btch:   1 usd:   0
[1434464.451666] DMA32 per-cpu:
[1434464.451668] CPU    0: hi:  186, btch:  31 usd: 171
[1434464.451670] CPU    1: hi:  186, btch:  31 usd:  22
[1434464.451672] CPU    2: hi:  186, btch:  31 usd:  40
[1434464.451674] CPU    3: hi:  186, btch:  31 usd:  30
[1434464.451675] Normal per-cpu:
[1434464.451677] CPU    0: hi:  186, btch:  31 usd: 156
[1434464.451678] CPU    1: hi:  186, btch:  31 usd:  54
[1434464.451680] CPU    2: hi:  186, btch:  31 usd:  53
[1434464.451682] CPU    3: hi:  186, btch:  31 usd:  35
[1434464.451686] active_anon:151647 inactive_anon:32860 isolated_anon:0
[1434464.451687]  active_file:281390 inactive_file:1246705 isolated_file:0
[1434464.451688]  unevictable:0 dirty:27 writeback:0 unstable:0
[1434464.451689]  free:55166 slab_reclaimable:190315 slab_unreclaimable:9490
[1434464.451690]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434464.451696] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434464.451701] lowmem_reserve[]: 0 2742 7792 7792
[1434464.451708] DMA32 free:95696kB min:47480kB low:59348kB
high:71220kB active_anon:53016kB inactive_anon:29732kB
active_file:471132kB inactive_file:1768984kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:12kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:361020kB slab_unreclaimable:9004kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434464.451713] lowmem_reserve[]: 0 0 5050 5050
[1434464.451720] Normal free:109052kB min:87420kB low:109272kB
high:131128kB active_anon:553572kB inactive_anon:101708kB
active_file:654428kB inactive_file:3217836kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:96kB writeback:0kB mapped:40880kB shmem:6336kB
slab_reclaimable:400240kB slab_unreclaimable:28956kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434464.451726] lowmem_reserve[]: 0 0 0 0
[1434464.451729] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434464.451736] DMA32: 23398*4kB 1*8kB 3*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 95696kB
[1434464.451744] Normal: 25215*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109052kB
[1434464.451751] 1530041 total pagecache pages
[1434464.451752] 227 pages in swap cache
[1434464.451755] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434464.451756] Free swap  = 2091068kB
[1434464.451758] Total swap = 2097148kB
[1434464.452001] 2031600 pages RAM
[1434464.452001] 50307 pages reserved
[1434464.452001] 328643 pages shared
[1434464.452001] 1641665 pages non-shared
[1434484.263995] sshd: page allocation failure: order:2, mode:0x20
[1434484.264001] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434484.264001] Call Trace:
[1434484.264001]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434484.264001]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434484.264001]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434484.264001]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434484.264001]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434484.264001]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434484.264001]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434484.264001]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434484.264001]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434484.264001]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434484.264001]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434484.264001]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434484.264001]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434484.264001]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434484.264001]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434484.264001]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434484.264001]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434484.264001]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434484.264001]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434484.264001]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434484.264001]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434484.264001]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434484.264001]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434484.264001]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434484.264001]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1434484.264001]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434484.264001]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434484.264001]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1434484.264001]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1434484.264001]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434484.264001]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434484.264001]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434484.264001] Mem-Info:
[1434484.264001] DMA per-cpu:
[1434484.264001] CPU    0: hi:    0, btch:   1 usd:   0
[1434484.264001] CPU    1: hi:    0, btch:   1 usd:   0
[1434484.264001] CPU    2: hi:    0, btch:   1 usd:   0
[1434484.264001] CPU    3: hi:    0, btch:   1 usd:   0
[1434484.264001] DMA32 per-cpu:
[1434484.264001] CPU    0: hi:  186, btch:  31 usd: 172
[1434484.264001] CPU    1: hi:  186, btch:  31 usd: 184
[1434484.264001] CPU    2: hi:  186, btch:  31 usd:  29
[1434484.264001] CPU    3: hi:  186, btch:  31 usd: 185
[1434484.264001] Normal per-cpu:
[1434484.264001] CPU    0: hi:  186, btch:  31 usd: 181
[1434484.264001] CPU    1: hi:  186, btch:  31 usd:  34
[1434484.264001] CPU    2: hi:  186, btch:  31 usd:  54
[1434484.264001] CPU    3: hi:  186, btch:  31 usd:  35
[1434484.264001] active_anon:151649 inactive_anon:32860 isolated_anon:0
[1434484.264001]  active_file:281398 inactive_file:1237931 isolated_file:0
[1434484.264001]  unevictable:0 dirty:19 writeback:0 unstable:0
[1434484.264001]  free:66475 slab_reclaimable:187479 slab_unreclaimable:9438
[1434484.264001]  mapped:10998 shmem:1651 pagetables:6615 bounce:0
[1434484.264001] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434484.264001] lowmem_reserve[]: 0 2742 7792 7792
[1434484.264001] DMA32 free:120788kB min:47480kB low:59348kB
high:71220kB active_anon:53016kB inactive_anon:29732kB
active_file:471136kB inactive_file:1748320kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:8kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:355736kB slab_unreclaimable:8908kB kernel_stack:544kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434484.264001] lowmem_reserve[]: 0 0 5050 5050
[1434484.264001] Normal free:129196kB min:87420kB low:109272kB
high:131128kB active_anon:553580kB inactive_anon:101708kB
active_file:654456kB inactive_file:3203404kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:68kB writeback:0kB mapped:40880kB shmem:6336kB
slab_reclaimable:394180kB slab_unreclaimable:28844kB
kernel_stack:2520kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434484.264001] lowmem_reserve[]: 0 0 0 0
[1434484.264001] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434484.264001] DMA32: 27756*4kB 666*8kB 151*16kB 1*32kB 1*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 120912kB
[1434484.264001] Normal: 30282*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 129320kB
[1434484.264001] 1521239 total pagecache pages
[1434484.264001] 227 pages in swap cache
[1434484.264001] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434484.264001] Free swap  = 2091068kB
[1434484.264001] Total swap = 2097148kB
[1434484.264001] 2031600 pages RAM
[1434484.264001] 50307 pages reserved
[1434484.264001] 328001 pages shared
[1434484.264001] 1631558 pages non-shared
[1434530.576964] sshd: page allocation failure: order:2, mode:0x20
[1434530.576970] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434530.576972] Call Trace:
[1434530.576980]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434530.576985]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434530.576988]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434530.576992]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434530.576996]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434530.576999]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434530.577001]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434530.577001]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434530.577001]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434530.577001]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434530.577001]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434530.577001]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434530.577001]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434530.577001]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434530.577001]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434530.577001]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434530.577001]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434530.577001]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434530.577001]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434530.577001]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434530.577001]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434530.577001]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434530.577001]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434530.577001]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434530.577001]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1434530.577001]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434530.577001]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434530.577001]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1434530.577001]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1434530.577001]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434530.577001]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434530.577001]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434530.577001] Mem-Info:
[1434530.577001] DMA per-cpu:
[1434530.577001] CPU    0: hi:    0, btch:   1 usd:   0
[1434530.577001] CPU    1: hi:    0, btch:   1 usd:   0
[1434530.577001] CPU    2: hi:    0, btch:   1 usd:   0
[1434530.577001] CPU    3: hi:    0, btch:   1 usd:   0
[1434530.577001] DMA32 per-cpu:
[1434530.577001] CPU    0: hi:  186, btch:  31 usd: 165
[1434530.577001] CPU    1: hi:  186, btch:  31 usd:  31
[1434530.577001] CPU    2: hi:  186, btch:  31 usd:   1
[1434530.577001] CPU    3: hi:  186, btch:  31 usd:  41
[1434530.577001] Normal per-cpu:
[1434530.577001] CPU    0: hi:  186, btch:  31 usd: 170
[1434530.577001] CPU    1: hi:  186, btch:  31 usd:  46
[1434530.577001] CPU    2: hi:  186, btch:  31 usd:  21
[1434530.577001] CPU    3: hi:  186, btch:  31 usd:  58
[1434530.577001] active_anon:151658 inactive_anon:32860 isolated_anon:0
[1434530.577001]  active_file:276341 inactive_file:1261051 isolated_file:0
[1434530.577001]  unevictable:0 dirty:2231 writeback:0 unstable:0
[1434530.577001]  free:65245 slab_reclaimable:171397 slab_unreclaimable:9136
[1434530.577001]  mapped:10951 shmem:1651 pagetables:6615 bounce:0
[1434530.577001] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434530.577001] lowmem_reserve[]: 0 2742 7792 7792
[1434530.577001] DMA32 free:135956kB min:47480kB low:59348kB
high:71220kB active_anon:53028kB inactive_anon:29732kB
active_file:465080kB inactive_file:1751816kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:16kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:344464kB slab_unreclaimable:8896kB kernel_stack:552kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434530.577001] lowmem_reserve[]: 0 0 5050 5050
[1434530.577001] Normal free:109108kB min:87420kB low:109272kB
high:131128kB active_anon:553604kB inactive_anon:101708kB
active_file:640284kB inactive_file:3292388kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:8908kB writeback:0kB mapped:40692kB shmem:6336kB
slab_reclaimable:341124kB slab_unreclaimable:27648kB
kernel_stack:2512kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434530.577001] lowmem_reserve[]: 0 0 0 0
[1434530.577001] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434530.577001] DMA32: 29405*4kB 2005*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 135708kB
[1434530.577001] Normal: 25198*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 108984kB
[1434530.577001] 1539279 total pagecache pages
[1434530.577001] 227 pages in swap cache
[1434530.577001] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434530.577001] Free swap  = 2091068kB
[1434530.577001] Total swap = 2097148kB
[1434530.577001] 2031600 pages RAM
[1434530.577001] 50307 pages reserved
[1434530.577001] 316365 pages shared
[1434530.577001] 1641600 pages non-shared
[1434532.081766] sshd: page allocation failure: order:2, mode:0x20
[1434532.081771] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434532.081774] Call Trace:
[1434532.081781]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434532.081785]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434532.081789]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434532.081792]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434532.081796]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434532.081799]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434532.081802]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434532.081804]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434532.081808]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434532.081811]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434532.081815]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434532.081818]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434532.081821]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434532.081824]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434532.081827]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434532.081830]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434532.081833]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434532.081836]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434532.081839]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434532.081843]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434532.081845]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434532.081848]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434532.081851]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434532.081854]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434532.081857]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434532.081861]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434532.081863]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434532.081866]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434532.081869]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434532.081872]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434532.081874] Mem-Info:
[1434532.081876] DMA per-cpu:
[1434532.081878] CPU    0: hi:    0, btch:   1 usd:   0
[1434532.081880] CPU    1: hi:    0, btch:   1 usd:   0
[1434532.081881] CPU    2: hi:    0, btch:   1 usd:   0
[1434532.081883] CPU    3: hi:    0, btch:   1 usd:   0
[1434532.081884] DMA32 per-cpu:
[1434532.081886] CPU    0: hi:  186, btch:  31 usd: 155
[1434532.081888] CPU    1: hi:  186, btch:  31 usd:  51
[1434532.081890] CPU    2: hi:  186, btch:  31 usd:   1
[1434532.081892] CPU    3: hi:  186, btch:  31 usd: 167
[1434532.081893] Normal per-cpu:
[1434532.081895] CPU    0: hi:  186, btch:  31 usd: 163
[1434532.081896] CPU    1: hi:  186, btch:  31 usd:  44
[1434532.081898] CPU    2: hi:  186, btch:  31 usd:  21
[1434532.081900] CPU    3: hi:  186, btch:  31 usd:  51
[1434532.081904] active_anon:151658 inactive_anon:32860 isolated_anon:0
[1434532.081905]  active_file:269898 inactive_file:1246070 isolated_file:0
[1434532.081906]  unevictable:0 dirty:2240 writeback:0 unstable:0
[1434532.081907]  free:87751 slab_reclaimable:170136 slab_unreclaimable:9114
[1434532.081908]  mapped:10940 shmem:1651 pagetables:6615 bounce:0
[1434532.081913] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434532.081918] lowmem_reserve[]: 0 2742 7792 7792
[1434532.081925] DMA32 free:170180kB min:47480kB low:59348kB
high:71220kB active_anon:53028kB inactive_anon:29732kB
active_file:464776kB inactive_file:1718340kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:16kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:343488kB slab_unreclaimable:8912kB kernel_stack:552kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1434532.081931] lowmem_reserve[]: 0 0 5050 5050
[1434532.081937] Normal free:164908kB min:87420kB low:109272kB
high:131128kB active_anon:553604kB inactive_anon:101708kB
active_file:614816kB inactive_file:3265940kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:8944kB writeback:0kB mapped:40648kB shmem:6336kB
slab_reclaimable:337056kB slab_unreclaimable:27544kB
kernel_stack:2512kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434532.081943] lowmem_reserve[]: 0 0 0 0
[1434532.081945] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434532.081953] DMA32: 35204*4kB 3164*8kB 133*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 170304kB
[1434532.081960] Normal: 38626*4kB 261*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 164784kB
[1434532.081968] 1517853 total pagecache pages
[1434532.081969] 227 pages in swap cache
[1434532.081971] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434532.081972] Free swap  = 2091068kB
[1434532.081974] Total swap = 2097148kB
[1434532.082494] 2031600 pages RAM
[1434532.082494] 50307 pages reserved
[1434532.082494] 316300 pages shared
[1434532.082494] 1622967 pages non-shared
[1434598.565047] sshd: page allocation failure: order:2, mode:0x20
[1434598.565053] Pid: 20350, comm: sshd Not tainted 3.2.0 #2
[1434598.565056] Call Trace:
[1434598.565063]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1434598.565068]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1434598.565072]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1434598.565075]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1434598.565079]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1434598.565082]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1434598.565085]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1434598.565088]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1434598.565091]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1434598.565094]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1434598.565098]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1434598.565101]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1434598.565105]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1434598.565107]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1434598.565110]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1434598.565114]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1434598.565116]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1434598.565119]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1434598.565123]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1434598.565126]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1434598.565129]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1434598.565132]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1434598.565134]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1434598.565138]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1434598.565142]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1434598.565145]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1434598.565148]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1434598.565150]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1434598.565153]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1434598.565157]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1434598.565159] Mem-Info:
[1434598.565160] DMA per-cpu:
[1434598.565162] CPU    0: hi:    0, btch:   1 usd:   0
[1434598.565164] CPU    1: hi:    0, btch:   1 usd:   0
[1434598.565166] CPU    2: hi:    0, btch:   1 usd:   0
[1434598.565168] CPU    3: hi:    0, btch:   1 usd:   0
[1434598.565169] DMA32 per-cpu:
[1434598.565171] CPU    0: hi:  186, btch:  31 usd: 175
[1434598.565173] CPU    1: hi:  186, btch:  31 usd:  28
[1434598.565175] CPU    2: hi:  186, btch:  31 usd:  19
[1434598.565177] CPU    3: hi:  186, btch:  31 usd: 108
[1434598.565178] Normal per-cpu:
[1434598.565179] CPU    0: hi:  186, btch:  31 usd: 169
[1434598.565181] CPU    1: hi:  186, btch:  31 usd:  61
[1434598.565183] CPU    2: hi:  186, btch:  31 usd:  55
[1434598.565184] CPU    3: hi:  186, btch:  31 usd:  49
[1434598.565189] active_anon:151658 inactive_anon:32860 isolated_anon:0
[1434598.565190]  active_file:256786 inactive_file:1318116 isolated_file:0
[1434598.565191]  unevictable:0 dirty:28 writeback:0 unstable:0
[1434598.565192]  free:51519 slab_reclaimable:147983 slab_unreclaimable:8561
[1434598.565193]  mapped:10850 shmem:1651 pagetables:6615 bounce:0
[1434598.565198] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1434598.565203] lowmem_reserve[]: 0 2742 7792 7792
[1434598.565210] DMA32 free:80880kB min:47480kB low:59348kB
high:71220kB active_anon:53028kB inactive_anon:29732kB
active_file:444000kB inactive_file:1839660kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:20kB writeback:0kB mapped:3112kB shmem:268kB
slab_reclaimable:332036kB slab_unreclaimable:8828kB kernel_stack:552kB
pagetables:656kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:117 all_unreclaimable? no
[1434598.565216] lowmem_reserve[]: 0 0 5050 5050
[1434598.565222] Normal free:109280kB min:87420kB low:109272kB
high:131128kB active_anon:553604kB inactive_anon:101708kB
active_file:583144kB inactive_file:3432600kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:92kB writeback:0kB mapped:40288kB shmem:6336kB
slab_reclaimable:259896kB slab_unreclaimable:25416kB
kernel_stack:2512kB pagetables:25804kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1434598.565228] lowmem_reserve[]: 0 0 0 0
[1434598.565230] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1434598.565238] DMA32: 19708*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 80880kB
[1434598.565245] Normal: 25272*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109280kB
[1434598.565252] 1576780 total pagecache pages
[1434598.565254] 227 pages in swap cache
[1434598.565256] Swap cache stats: add 26025, delete 25798, find 11689/13282
[1434598.565257] Free swap  = 2091068kB
[1434598.565259] Total swap = 2097148kB
[1434598.574790] 2031600 pages RAM
[1434598.574790] 50307 pages reserved
[1434598.574790] 307632 pages shared
[1434598.574790] 1665214 pages non-shared
[1435042.448475] sshd: page allocation failure: order:2, mode:0x20
[1435042.448481] Pid: 20551, comm: sshd Not tainted 3.2.0 #2
[1435042.448483] Call Trace:
[1435042.448490]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1435042.448495]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1435042.448499]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1435042.448502]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1435042.448506]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1435042.448510]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1435042.448513]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1435042.448516]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1435042.448520]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1435042.448522]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1435042.448526]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1435042.448529]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1435042.448533]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1435042.448536]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1435042.448539]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1435042.448542]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1435042.448545]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1435042.448548]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1435042.448551]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1435042.448554]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1435042.448557]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1435042.448559]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1435042.448563]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1435042.448566]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1435042.448570]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1435042.448573]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1435042.448576]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1435042.448579]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1435042.448582]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1435042.448585]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1435042.448588]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1435042.448591]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1435042.448593] Mem-Info:
[1435042.448595] DMA per-cpu:
[1435042.448597] CPU    0: hi:    0, btch:   1 usd:   0
[1435042.448599] CPU    1: hi:    0, btch:   1 usd:   0
[1435042.448600] CPU    2: hi:    0, btch:   1 usd:   0
[1435042.448602] CPU    3: hi:    0, btch:   1 usd:   0
[1435042.448604] DMA32 per-cpu:
[1435042.448605] CPU    0: hi:  186, btch:  31 usd: 175
[1435042.448607] CPU    1: hi:  186, btch:  31 usd:  27
[1435042.448609] CPU    2: hi:  186, btch:  31 usd:   1
[1435042.448611] CPU    3: hi:  186, btch:  31 usd:  14
[1435042.448612] Normal per-cpu:
[1435042.448614] CPU    0: hi:  186, btch:  31 usd: 172
[1435042.448615] CPU    1: hi:  186, btch:  31 usd:  40
[1435042.448617] CPU    2: hi:  186, btch:  31 usd:  10
[1435042.448619] CPU    3: hi:  186, btch:  31 usd:  20
[1435042.448623] active_anon:155300 inactive_anon:32734 isolated_anon:0
[1435042.448624]  active_file:686417 inactive_file:810908 isolated_file:0
[1435042.448625]  unevictable:0 dirty:15 writeback:0 unstable:0
[1435042.448626]  free:85594 slab_reclaimable:187062 slab_unreclaimable:9491
[1435042.448627]  mapped:10073 shmem:1649 pagetables:6720 bounce:0
[1435042.448632] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1435042.448637] lowmem_reserve[]: 0 2742 7792 7792
[1435042.448644] DMA32 free:217248kB min:47480kB low:59348kB
high:71220kB active_anon:61564kB inactive_anon:29732kB
active_file:902752kB inactive_file:1171768kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3092kB shmem:268kB
slab_reclaimable:395156kB slab_unreclaimable:10376kB
kernel_stack:568kB pagetables:680kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:8 all_unreclaimable? no
[1435042.448650] lowmem_reserve[]: 0 0 5050 5050
[1435042.448656] Normal free:109212kB min:87420kB low:109272kB
high:131128kB active_anon:559636kB inactive_anon:101204kB
active_file:1842916kB inactive_file:2071864kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:56kB writeback:0kB mapped:37200kB shmem:6328kB
slab_reclaimable:353092kB slab_unreclaimable:27588kB
kernel_stack:2528kB pagetables:26200kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[1435042.448662] lowmem_reserve[]: 0 0 0 0
[1435042.448665] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1435042.448672] DMA32: 53795*4kB 2*8kB 10*16kB 1*32kB 1*64kB 1*128kB
1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 217372kB
[1435042.448680] Normal: 25255*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109212kB
[1435042.448688] 1499241 total pagecache pages
[1435042.448689] 234 pages in swap cache
[1435042.448691] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1435042.448693] Free swap  = 2090964kB
[1435042.448694] Total swap = 2097148kB
[1435042.449001] 2031600 pages RAM
[1435042.449001] 50307 pages reserved
[1435042.449001] 862463 pages shared
[1435042.449001] 1079216 pages non-shared
[1435079.396197] sshd: page allocation failure: order:3, mode:0x20
[1435079.396203] Pid: 20551, comm: sshd Not tainted 3.2.0 #2
[1435079.396205] Call Trace:
[1435079.396213]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1435079.396217]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1435079.396221]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1435079.396225]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1435079.396228]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1435079.396231]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1435079.396234]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1435079.396238]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1435079.396241]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1435079.396244]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1435079.396247]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1435079.396251]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1435079.396253]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1435079.396256]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1435079.396260]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1435079.396262]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1435079.396265]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1435079.396268]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1435079.396271]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1435079.396274]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1435079.396277]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1435079.396280]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1435079.396284]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1435079.396287]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1435079.396290]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1435079.396293]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1435079.396295]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1435079.396299]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1435079.396301] Mem-Info:
[1435079.396303] DMA per-cpu:
[1435079.396305] CPU    0: hi:    0, btch:   1 usd:   0
[1435079.396306] CPU    1: hi:    0, btch:   1 usd:   0
[1435079.396308] CPU    2: hi:    0, btch:   1 usd:   0
[1435079.396310] CPU    3: hi:    0, btch:   1 usd:   0
[1435079.396311] DMA32 per-cpu:
[1435079.396313] CPU    0: hi:  186, btch:  31 usd: 161
[1435079.396315] CPU    1: hi:  186, btch:  31 usd: 114
[1435079.396317] CPU    2: hi:  186, btch:  31 usd:   4
[1435079.396318] CPU    3: hi:  186, btch:  31 usd:  44
[1435079.396320] Normal per-cpu:
[1435079.396321] CPU    0: hi:  186, btch:  31 usd: 181
[1435079.396323] CPU    1: hi:  186, btch:  31 usd:  85
[1435079.396325] CPU    2: hi:  186, btch:  31 usd:   9
[1435079.396326] CPU    3: hi:  186, btch:  31 usd:  61
[1435079.396331] active_anon:155300 inactive_anon:32734 isolated_anon:0
[1435079.396332]  active_file:686452 inactive_file:802980 isolated_file:0
[1435079.396333]  unevictable:0 dirty:24 writeback:0 unstable:0
[1435079.396334]  free:94501 slab_reclaimable:185921 slab_unreclaimable:9423
[1435079.396335]  mapped:10069 shmem:1649 pagetables:6720 bounce:0
[1435079.396340] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1435079.396345] lowmem_reserve[]: 0 2742 7792 7792
[1435079.396352] DMA32 free:253084kB min:47480kB low:59348kB
high:71220kB active_anon:61564kB inactive_anon:29732kB
active_file:902788kB inactive_file:1140104kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:16kB writeback:0kB mapped:3092kB shmem:268kB
slab_reclaimable:390844kB slab_unreclaimable:10160kB
kernel_stack:568kB pagetables:680kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:71 all_unreclaimable? no
[1435079.396358] lowmem_reserve[]: 0 0 5050 5050
[1435079.396364] Normal free:109004kB min:87420kB low:109272kB
high:131128kB active_anon:559636kB inactive_anon:101204kB
active_file:1843020kB inactive_file:2071816kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:80kB writeback:0kB mapped:37184kB shmem:6328kB
slab_reclaimable:352840kB slab_unreclaimable:27532kB
kernel_stack:2528kB pagetables:26200kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:104 all_unreclaimable? no
[1435079.396370] lowmem_reserve[]: 0 0 0 0
[1435079.396373] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1435079.396381] DMA32: 57133*4kB 2813*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 253084kB
[1435079.396388] Normal: 25203*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109004kB
[1435079.396395] 1491309 total pagecache pages
[1435079.396396] 234 pages in swap cache
[1435079.396398] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1435079.396400] Free swap  = 2090964kB
[1435079.396401] Total swap = 2097148kB
[1435079.397001] 2031600 pages RAM
[1435079.397001] 50307 pages reserved
[1435079.397001] 853363 pages shared
[1435079.397001] 1074238 pages non-shared
[1435091.430738] sshd: page allocation failure: order:3, mode:0x20
[1435091.430751] Pid: 20551, comm: sshd Not tainted 3.2.0 #2
[1435091.430756] Call Trace:
[1435091.430772]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1435091.430783]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1435091.430792]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1435091.430801]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1435091.430809]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1435091.430817]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1435091.430825]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1435091.430832]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1435091.430841]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1435091.430849]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1435091.430858]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1435091.430866]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1435091.430874]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1435091.430882]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1435091.430891]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1435091.430899]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1435091.430907]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1435091.430915]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1435091.430923]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1435091.430932]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1435091.430939]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1435091.430947]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1435091.430954]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1435091.430963]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1435091.430971]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1435091.430980]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1435091.430987]  [<ffffffff8102aa12>] ? pick_next_task_fair+0xa2/0x150
[1435091.430995]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1435091.431002]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1435091.431006]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1435091.431006] Mem-Info:
[1435091.431006] DMA per-cpu:
[1435091.431006] CPU    0: hi:    0, btch:   1 usd:   0
[1435091.431006] CPU    1: hi:    0, btch:   1 usd:   0
[1435091.431006] CPU    2: hi:    0, btch:   1 usd:   0
[1435091.431006] CPU    3: hi:    0, btch:   1 usd:   0
[1435091.431006] DMA32 per-cpu:
[1435091.431006] CPU    0: hi:  186, btch:  31 usd: 163
[1435091.431006] CPU    1: hi:  186, btch:  31 usd:  30
[1435091.431006] CPU    2: hi:  186, btch:  31 usd:   7
[1435091.431006] CPU    3: hi:  186, btch:  31 usd:  11
[1435091.431006] Normal per-cpu:
[1435091.431006] CPU    0: hi:  186, btch:  31 usd: 165
[1435091.431006] CPU    1: hi:  186, btch:  31 usd:  37
[1435091.431006] CPU    2: hi:  186, btch:  31 usd:  14
[1435091.431006] CPU    3: hi:  186, btch:  31 usd:  53
[1435091.431006] active_anon:155300 inactive_anon:32734 isolated_anon:0
[1435091.431006]  active_file:686484 inactive_file:791040 isolated_file:0
[1435091.431006]  unevictable:0 dirty:43 writeback:0 unstable:0
[1435091.431006]  free:107470 slab_reclaimable:185029 slab_unreclaimable:9434
[1435091.431006]  mapped:10067 shmem:1649 pagetables:6720 bounce:0
[1435091.431006] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1435091.431006] lowmem_reserve[]: 0 2742 7792 7792
[1435091.431006] DMA32 free:304636kB min:47480kB low:59348kB
high:71220kB active_anon:61564kB inactive_anon:29732kB
active_file:902796kB inactive_file:1092416kB unevictable:0kB
isolated(anon):0kB isolated(file):148kB present:2808608kB mlocked:0kB
dirty:20kB writeback:0kB mapped:3092kB shmem:268kB
slab_reclaimable:387364kB slab_unreclaimable:10160kB
kernel_stack:568kB pagetables:680kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:39 all_unreclaimable? no
[1435091.431006] lowmem_reserve[]: 0 0 5050 5050
[1435091.431006] Normal free:109576kB min:87420kB low:109272kB
high:131128kB active_anon:559636kB inactive_anon:101204kB
active_file:1843140kB inactive_file:2071588kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:152kB writeback:0kB mapped:37176kB shmem:6328kB
slab_reclaimable:352752kB slab_unreclaimable:27576kB
kernel_stack:2528kB pagetables:26200kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1435091.431006] lowmem_reserve[]: 0 0 0 0
[1435091.431006] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1435091.431006] DMA32: 75613*4kB 32*8kB 6*16kB 1*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 304884kB
[1435091.431006] Normal: 25335*4kB 17*8kB 2*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109700kB
[1435091.431006] 1479307 total pagecache pages
[1435091.431006] 234 pages in swap cache
[1435091.431006] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1435091.431006] Free swap  = 2090964kB
[1435091.431006] Total swap = 2097148kB
[1435091.460292] 2031600 pages RAM
[1435091.460292] 50307 pages reserved
[1435091.460292] 848662 pages shared
[1435091.460292] 1057914 pages non-shared
[1435111.592390] sshd: page allocation failure: order:2, mode:0x20
[1435111.592395] Pid: 20551, comm: sshd Not tainted 3.2.0 #2
[1435111.592398] Call Trace:
[1435111.592405]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1435111.592409]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1435111.592417]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1435111.592421]  [<ffffffff81053b1d>] ? sched_clock_local+0x1d/0x90
[1435111.592424]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1435111.592428]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1435111.592431]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1435111.592434]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1435111.592438]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1435111.592441]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1435111.592445]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1435111.592448]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1435111.592451]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1435111.592454]  [<ffffffff814f09ff>] ip_finish_output+0x13f/0x2c0
[1435111.592457]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1435111.592461]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1435111.592463]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1435111.592466]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1435111.592469]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1435111.592472]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1435111.592475]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1435111.592478]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1435111.592481]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1435111.592485]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1435111.592488]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1435111.592492]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1435111.592494]  [<ffffffff810294c9>] ? dequeue_pushable_task+0x29/0x70
[1435111.592498]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1435111.592501]  [<ffffffff81041302>] ? recalc_sigpending+0x12/0x30
[1435111.592503]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1435111.592506]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1435111.592510]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1435111.592512] Mem-Info:
[1435111.592513] DMA per-cpu:
[1435111.592515] CPU    0: hi:    0, btch:   1 usd:   0
[1435111.592517] CPU    1: hi:    0, btch:   1 usd:   0
[1435111.592519] CPU    2: hi:    0, btch:   1 usd:   0
[1435111.592521] CPU    3: hi:    0, btch:   1 usd:   0
[1435111.592522] DMA32 per-cpu:
[1435111.592524] CPU    0: hi:  186, btch:  31 usd: 180
[1435111.592526] CPU    1: hi:  186, btch:  31 usd:  34
[1435111.592528] CPU    2: hi:  186, btch:  31 usd:   1
[1435111.592530] CPU    3: hi:  186, btch:  31 usd:  94
[1435111.592531] Normal per-cpu:
[1435111.592533] CPU    0: hi:  186, btch:  31 usd: 160
[1435111.592534] CPU    1: hi:  186, btch:  31 usd:  33
[1435111.592536] CPU    2: hi:  186, btch:  31 usd:   3
[1435111.592538] CPU    3: hi:  186, btch:  31 usd:  33
[1435111.592542] active_anon:155294 inactive_anon:32734 isolated_anon:0
[1435111.592543]  active_file:687088 inactive_file:787395 isolated_file:0
[1435111.592544]  unevictable:0 dirty:24 writeback:0 unstable:0
[1435111.592545]  free:111962 slab_reclaimable:183572 slab_unreclaimable:9420
[1435111.592546]  mapped:10064 shmem:1649 pagetables:6720 bounce:0
[1435111.592552] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1435111.592556] lowmem_reserve[]: 0 2742 7792 7792
[1435111.592563] DMA32 free:322712kB min:47480kB low:59348kB
high:71220kB active_anon:61564kB inactive_anon:29732kB
active_file:904128kB inactive_file:1077772kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:4kB writeback:0kB mapped:3092kB shmem:268kB
slab_reclaimable:382396kB slab_unreclaimable:10188kB
kernel_stack:568kB pagetables:680kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:66 all_unreclaimable? no
[1435111.592569] lowmem_reserve[]: 0 0 5050 5050
[1435111.592576] Normal free:109220kB min:87420kB low:109272kB
high:131128kB active_anon:559612kB inactive_anon:101204kB
active_file:1844224kB inactive_file:2071808kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:92kB writeback:0kB mapped:37164kB shmem:6328kB
slab_reclaimable:351892kB slab_unreclaimable:27492kB
kernel_stack:2528kB pagetables:26200kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:65 all_unreclaimable? no
[1435111.592581] lowmem_reserve[]: 0 0 0 0
[1435111.592584] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1435111.592592] DMA32: 80135*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 322588kB
[1435111.592599] Normal: 25257*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 109220kB
[1435111.592606] 1476390 total pagecache pages
[1435111.592608] 234 pages in swap cache
[1435111.592609] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1435111.592611] Free swap  = 2090964kB
[1435111.592612] Total swap = 2097148kB
[1435111.593001] 2031600 pages RAM
[1435111.593001] 50307 pages reserved
[1435111.593001] 825997 pages shared
[1435111.593001] 1087225 pages non-shared
[1437838.620185] Xvnc4: page allocation failure: order:3, mode:0x20
[1437838.620197] Pid: 3848, comm: Xvnc4 Not tainted 3.2.0 #2
[1437838.620202] Call Trace:
[1437838.620218]  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1437838.620229]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1437838.620238]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1437838.620247]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1437838.620255]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1437838.620263]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1437838.620270]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1437838.620279]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1437838.620286]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1437838.620295]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1437838.620303]  [<ffffffff814b7607>] dev_queue_xmit+0x167/0x590
[1437838.620312]  [<ffffffff814c3c29>] neigh_resolve_output+0x119/0x1e0
[1437838.620320]  [<ffffffff814d481d>] ? nf_hook_slow+0x6d/0x140
[1437838.620328]  [<ffffffff814f08c0>] ? ip_fragment+0x770/0x770
[1437838.620336]  [<ffffffff814f0a16>] ip_finish_output+0x156/0x2c0
[1437838.620344]  [<ffffffff814f0e28>] ip_output+0x88/0x90
[1437838.620353]  [<ffffffff814efb4f>] ? __ip_local_out+0x9f/0xb0
[1437838.620361]  [<ffffffff814efb84>] ip_local_out+0x24/0x30
[1437838.620368]  [<ffffffff814efef5>] ip_queue_xmit+0x155/0x3b0
[1437838.620376]  [<ffffffff815055d2>] tcp_transmit_skb+0x3d2/0x880
[1437838.620384]  [<ffffffff81505c14>] tcp_write_xmit+0xf4/0xa20
[1437838.620392]  [<ffffffff81506591>] __tcp_push_pending_frames+0x21/0x80
[1437838.620399]  [<ffffffff814f80fa>] tcp_sendmsg+0x92a/0xd40
[1437838.620407]  [<ffffffff81519153>] inet_sendmsg+0x43/0xb0
[1437838.620416]  [<ffffffff810c17b0>] ? __pollwait+0xf0/0xf0
[1437838.620425]  [<ffffffff814a4c14>] sock_aio_write+0x104/0x130
[1437838.620433]  [<ffffffff810c244d>] ? core_sys_select+0x27d/0x2e0
[1437838.620442]  [<ffffffff810b0a8a>] do_sync_write+0xca/0x110
[1437838.620450]  [<ffffffff810c1675>] ? poll_select_copy_remaining+0xe5/0x130
[1437838.620458]  [<ffffffff810b0c15>] vfs_write+0x145/0x160
[1437838.620466]  [<ffffffff810b0d05>] sys_write+0x45/0x90
[1437838.620475]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1437838.620480] Mem-Info:
[1437838.620483] DMA per-cpu:
[1437838.620488] CPU    0: hi:    0, btch:   1 usd:   0
[1437838.620493] CPU    1: hi:    0, btch:   1 usd:   0
[1437838.620498] CPU    2: hi:    0, btch:   1 usd:   0
[1437838.620502] CPU    3: hi:    0, btch:   1 usd:   0
[1437838.620506] DMA32 per-cpu:
[1437838.620511] CPU    0: hi:  186, btch:  31 usd:  62
[1437838.620516] CPU    1: hi:  186, btch:  31 usd:   0
[1437838.620521] CPU    2: hi:  186, btch:  31 usd:   0
[1437838.620526] CPU    3: hi:  186, btch:  31 usd:   0
[1437838.620529] Normal per-cpu:
[1437838.620534] CPU    0: hi:  186, btch:  31 usd: 183
[1437838.620538] CPU    1: hi:  186, btch:  31 usd:  48
[1437838.620543] CPU    2: hi:  186, btch:  31 usd:   5
[1437838.620548] CPU    3: hi:  186, btch:  31 usd:  12
[1437838.620559] active_anon:141217 inactive_anon:31710 isolated_anon:0
[1437838.620562]  active_file:760484 inactive_file:734979 isolated_file:0
[1437838.620565]  unevictable:0 dirty:12 writeback:0 unstable:0
[1437838.620567]  free:120894 slab_reclaimable:169673 slab_unreclaimable:9092
[1437838.620570]  mapped:9632 shmem:1647 pagetables:6459 bounce:0
[1437838.620585] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1437838.620598] lowmem_reserve[]: 0 2742 7792 7792
[1437838.620616] DMA32 free:203404kB min:47480kB low:59348kB
high:71220kB active_anon:32892kB inactive_anon:27716kB
active_file:1082624kB inactive_file:1082380kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:0kB writeback:0kB mapped:3064kB shmem:268kB
slab_reclaimable:350972kB slab_unreclaimable:9572kB kernel_stack:496kB
pagetables:620kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:153 all_unreclaimable? no
[1437838.620631] lowmem_reserve[]: 0 0 5050 5050
[1437838.620648] Normal free:264256kB min:87420kB low:109272kB
high:131128kB active_anon:531976kB inactive_anon:99124kB
active_file:1959312kB inactive_file:1857288kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:48kB writeback:0kB mapped:35464kB shmem:6320kB
slab_reclaimable:327720kB slab_unreclaimable:26796kB
kernel_stack:2528kB pagetables:25216kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:97 all_unreclaimable? no
[1437838.620664] lowmem_reserve[]: 0 0 0 0
[1437838.620671] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1437838.620691] DMA32: 38789*4kB 3789*8kB 989*16kB 2*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 203404kB
[1437838.620710] Normal: 43186*4kB 8183*8kB 1523*16kB 4*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 264752kB
[1437838.620732] 1497231 total pagecache pages
[1437838.620736] 234 pages in swap cache
[1437838.620740] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1437838.620745] Free swap  = 2090964kB
[1437838.620749] Total swap = 2097148kB
[1437838.621001] 2031600 pages RAM
[1437838.621001] 50307 pages reserved
[1437838.621001] 736651 pages shared
[1437838.621001] 1163488 pages non-shared
[1438731.114902] swapper/0: page allocation failure: order:4, mode:0x20
[1438731.114915] Pid: 0, comm: swapper/0 Not tainted 3.2.0 #2
[1438731.114920] Call Trace:
[1438731.114925]  <IRQ>  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1438731.114949]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1438731.114959]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1438731.114968]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1438731.114976]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1438731.114984]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1438731.114991]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1438731.115000]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1438731.115007]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1438731.115016]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1438731.115024]  [<ffffffff814ceca3>] __qdisc_run+0xb3/0x140
[1438731.115033]  [<ffffffff814b45b1>] net_tx_action+0xb1/0x150
[1438731.115041]  [<ffffffff8103a130>] __do_softirq+0x90/0x120
[1438731.115048]  [<ffffffff815a242c>] call_softirq+0x1c/0x30
[1438731.115056]  [<ffffffff810036fd>] do_softirq+0x4d/0x80
[1438731.115063]  [<ffffffff8103a406>] irq_exit+0x86/0xa0
[1438731.115069]  [<ffffffff8100359e>] do_IRQ+0x5e/0xd0
[1438731.115078]  [<ffffffff815a0b6b>] common_interrupt+0x6b/0x6b
[1438731.115082]  <EOI>  [<ffffffff81009124>] ? default_idle+0x24/0x40
[1438731.115098]  [<ffffffff81009234>] amd_e400_idle+0x54/0x100
[1438731.115104]  [<ffffffff8100079f>] cpu_idle+0x7f/0xd0
[1438731.115111]  [<ffffffff81589e64>] rest_init+0x68/0x74
[1438731.115119]  [<ffffffff8187fa67>] start_kernel+0x29f/0x2aa
[1438731.115127]  [<ffffffff8187f2ee>] x86_64_start_reservations+0xfe/0x102
[1438731.115134]  [<ffffffff8187f3e2>] x86_64_start_kernel+0xf0/0xf7
[1438731.115139] Mem-Info:
[1438731.115142] DMA per-cpu:
[1438731.115147] CPU    0: hi:    0, btch:   1 usd:   0
[1438731.115152] CPU    1: hi:    0, btch:   1 usd:   0
[1438731.115157] CPU    2: hi:    0, btch:   1 usd:   0
[1438731.115161] CPU    3: hi:    0, btch:   1 usd:   0
[1438731.115165] DMA32 per-cpu:
[1438731.115170] CPU    0: hi:  186, btch:  31 usd: 162
[1438731.115175] CPU    1: hi:  186, btch:  31 usd: 173
[1438731.115180] CPU    2: hi:  186, btch:  31 usd:  18
[1438731.115185] CPU    3: hi:  186, btch:  31 usd: 177
[1438731.115189] Normal per-cpu:
[1438731.115193] CPU    0: hi:  186, btch:  31 usd: 152
[1438731.115197] CPU    1: hi:  186, btch:  31 usd:  33
[1438731.115202] CPU    2: hi:  186, btch:  31 usd:  13
[1438731.115207] CPU    3: hi:  186, btch:  31 usd: 193
[1438731.115218] active_anon:142749 inactive_anon:31709 isolated_anon:0
[1438731.115221]  active_file:683478 inactive_file:883923 isolated_file:0
[1438731.115224]  unevictable:0 dirty:14794 writeback:14912 unstable:512
[1438731.115226]  free:65328 slab_reclaimable:150309 slab_unreclaimable:9989
[1438731.115229]  mapped:9575 shmem:1647 pagetables:6475 bounce:0
[1438731.115244] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1438731.115258] lowmem_reserve[]: 0 2742 7792 7792
[1438731.115276] DMA32 free:119972kB min:47480kB low:59348kB
high:71220kB active_anon:32892kB inactive_anon:27716kB
active_file:958328kB inactive_file:1324556kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:3564kB writeback:14520kB mapped:3064kB shmem:268kB
slab_reclaimable:314292kB slab_unreclaimable:10212kB
kernel_stack:496kB pagetables:620kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438731.115291] lowmem_reserve[]: 0 0 5050 5050
[1438731.115309] Normal free:125424kB min:87420kB low:109272kB
high:131128kB active_anon:538104kB inactive_anon:99120kB
active_file:1775584kB inactive_file:2211136kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:55172kB writeback:45568kB mapped:35236kB shmem:6320kB
slab_reclaimable:286944kB slab_unreclaimable:29744kB
kernel_stack:2552kB pagetables:25280kB unstable:2048kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438731.115324] lowmem_reserve[]: 0 0 0 0
[1438731.115331] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1438731.115352] DMA32: 28951*4kB 275*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 120052kB
[1438731.115371] Normal: 30786*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 125192kB
[1438731.115391] 1569364 total pagecache pages
[1438731.115395] 234 pages in swap cache
[1438731.115399] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1438731.115404] Free swap  = 2090964kB
[1438731.115407] Total swap = 2097148kB
[1438731.115754] 2031600 pages RAM
[1438731.115754] 50307 pages reserved
[1438731.115754] 778733 pages shared
[1438731.115754] 1224384 pages non-shared
[1438751.732625] swapper/0: page allocation failure: order:5, mode:0x20
[1438751.732638] Pid: 0, comm: swapper/0 Not tainted 3.2.0 #2
[1438751.732643] Call Trace:
[1438751.732648]  <IRQ>  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1438751.732671]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1438751.732681]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1438751.732691]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1438751.732699]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1438751.732706]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1438751.732713]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1438751.732722]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1438751.732730]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1438751.732739]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1438751.732747]  [<ffffffff814ceca3>] __qdisc_run+0xb3/0x140
[1438751.732755]  [<ffffffff814b45b1>] net_tx_action+0xb1/0x150
[1438751.732763]  [<ffffffff8103a130>] __do_softirq+0x90/0x120
[1438751.732771]  [<ffffffff815a242c>] call_softirq+0x1c/0x30
[1438751.732778]  [<ffffffff810036fd>] do_softirq+0x4d/0x80
[1438751.732785]  [<ffffffff8103a406>] irq_exit+0x86/0xa0
[1438751.732792]  [<ffffffff8100359e>] do_IRQ+0x5e/0xd0
[1438751.732801]  [<ffffffff815a0b6b>] common_interrupt+0x6b/0x6b
[1438751.732805]  <EOI>  [<ffffffff81009124>] ? default_idle+0x24/0x40
[1438751.732820]  [<ffffffff81009234>] amd_e400_idle+0x54/0x100
[1438751.732827]  [<ffffffff8100079f>] cpu_idle+0x7f/0xd0
[1438751.732834]  [<ffffffff81589e64>] rest_init+0x68/0x74
[1438751.732842]  [<ffffffff8187fa67>] start_kernel+0x29f/0x2aa
[1438751.732850]  [<ffffffff8187f2ee>] x86_64_start_reservations+0xfe/0x102
[1438751.732857]  [<ffffffff8187f3e2>] x86_64_start_kernel+0xf0/0xf7
[1438751.732862] Mem-Info:
[1438751.732865] DMA per-cpu:
[1438751.732870] CPU    0: hi:    0, btch:   1 usd:   0
[1438751.732875] CPU    1: hi:    0, btch:   1 usd:   0
[1438751.732880] CPU    2: hi:    0, btch:   1 usd:   0
[1438751.732885] CPU    3: hi:    0, btch:   1 usd:   0
[1438751.732888] DMA32 per-cpu:
[1438751.732893] CPU    0: hi:  186, btch:  31 usd: 183
[1438751.732898] CPU    1: hi:  186, btch:  31 usd:  41
[1438751.732903] CPU    2: hi:  186, btch:  31 usd:   6
[1438751.732908] CPU    3: hi:  186, btch:  31 usd: 163
[1438751.732911] Normal per-cpu:
[1438751.732915] CPU    0: hi:  186, btch:  31 usd: 188
[1438751.732920] CPU    1: hi:  186, btch:  31 usd:  46
[1438751.732925] CPU    2: hi:  186, btch:  31 usd:  41
[1438751.732929] CPU    3: hi:  186, btch:  31 usd: 168
[1438751.732941] active_anon:142749 inactive_anon:31709 isolated_anon:0
[1438751.732944]  active_file:689551 inactive_file:923287 isolated_file:0
[1438751.732946]  unevictable:0 dirty:28 writeback:384 unstable:256
[1438751.732949]  free:58747 slab_reclaimable:113089 slab_unreclaimable:8408
[1438751.732952]  mapped:8786 shmem:1647 pagetables:6475 bounce:0
[1438751.732966] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1438751.732980] lowmem_reserve[]: 0 2742 7792 7792
[1438751.732998] DMA32 free:92848kB min:47480kB low:59348kB
high:71220kB active_anon:32892kB inactive_anon:27716kB
active_file:976024kB inactive_file:1402336kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:28kB writeback:0kB mapped:3064kB shmem:268kB
slab_reclaimable:248388kB slab_unreclaimable:8276kB kernel_stack:496kB
pagetables:620kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1438751.733013] lowmem_reserve[]: 0 0 5050 5050
[1438751.733030] Normal free:126224kB min:87420kB low:109272kB
high:131128kB active_anon:538104kB inactive_anon:99120kB
active_file:1782180kB inactive_file:2290812kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:84kB writeback:1536kB mapped:32080kB shmem:6320kB
slab_reclaimable:203968kB slab_unreclaimable:25356kB
kernel_stack:2552kB pagetables:25280kB unstable:1024kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438751.733045] lowmem_reserve[]: 0 0 0 0
[1438751.733053] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1438751.733073] DMA32: 22362*4kB 155*8kB 7*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 92848kB
[1438751.733092] Normal: 31013*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 126100kB
[1438751.733111] 1614739 total pagecache pages
[1438751.733114] 234 pages in swap cache
[1438751.733119] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1438751.733123] Free swap  = 2090964kB
[1438751.733127] Total swap = 2097148kB
[1438751.733431] 2031600 pages RAM
[1438751.733431] 50307 pages reserved
[1438751.733431] 622619 pages shared
[1438751.733431] 1356178 pages non-shared
[1438766.984196] swapper/0: page allocation failure: order:5, mode:0x20
[1438766.984209] Pid: 0, comm: swapper/0 Not tainted 3.2.0 #2
[1438766.984214] Call Trace:
[1438766.984219]  <IRQ>  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1438766.984241]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1438766.984251]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1438766.984261]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1438766.984269]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1438766.984276]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1438766.984283]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1438766.984292]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1438766.984300]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1438766.984309]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1438766.984317]  [<ffffffff814ceca3>] __qdisc_run+0xb3/0x140
[1438766.984325]  [<ffffffff814b45b1>] net_tx_action+0xb1/0x150
[1438766.984333]  [<ffffffff8103a130>] __do_softirq+0x90/0x120
[1438766.984341]  [<ffffffff815a242c>] call_softirq+0x1c/0x30
[1438766.984348]  [<ffffffff810036fd>] do_softirq+0x4d/0x80
[1438766.984355]  [<ffffffff8103a406>] irq_exit+0x86/0xa0
[1438766.984362]  [<ffffffff8100359e>] do_IRQ+0x5e/0xd0
[1438766.984370]  [<ffffffff815a0b6b>] common_interrupt+0x6b/0x6b
[1438766.984375]  <EOI>  [<ffffffff81009124>] ? default_idle+0x24/0x40
[1438766.984391]  [<ffffffff81009234>] amd_e400_idle+0x54/0x100
[1438766.984397]  [<ffffffff8100079f>] cpu_idle+0x7f/0xd0
[1438766.984404]  [<ffffffff81589e64>] rest_init+0x68/0x74
[1438766.984412]  [<ffffffff8187fa67>] start_kernel+0x29f/0x2aa
[1438766.984420]  [<ffffffff8187f2ee>] x86_64_start_reservations+0xfe/0x102
[1438766.984428]  [<ffffffff8187f3e2>] x86_64_start_kernel+0xf0/0xf7
[1438766.984432] Mem-Info:
[1438766.984435] DMA per-cpu:
[1438766.984440] CPU    0: hi:    0, btch:   1 usd:   0
[1438766.984445] CPU    1: hi:    0, btch:   1 usd:   0
[1438766.984450] CPU    2: hi:    0, btch:   1 usd:   0
[1438766.984455] CPU    3: hi:    0, btch:   1 usd:   0
[1438766.984459] DMA32 per-cpu:
[1438766.984463] CPU    0: hi:  186, btch:  31 usd: 166
[1438766.984468] CPU    1: hi:  186, btch:  31 usd:  32
[1438766.984473] CPU    2: hi:  186, btch:  31 usd:  26
[1438766.984478] CPU    3: hi:  186, btch:  31 usd:  45
[1438766.984482] Normal per-cpu:
[1438766.984486] CPU    0: hi:  186, btch:  31 usd: 162
[1438766.984491] CPU    1: hi:  186, btch:  31 usd:  62
[1438766.984495] CPU    2: hi:  186, btch:  31 usd:  46
[1438766.984500] CPU    3: hi:  186, btch:  31 usd:  19
[1438766.984511] active_anon:142750 inactive_anon:31709 isolated_anon:0
[1438766.984514]  active_file:680720 inactive_file:944323 isolated_file:0
[1438766.984517]  unevictable:0 dirty:33 writeback:440 unstable:330
[1438766.984519]  free:72285 slab_reclaimable:87913 slab_unreclaimable:8214
[1438766.984522]  mapped:8683 shmem:1647 pagetables:6475 bounce:0
[1438766.984537] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1438766.984550] lowmem_reserve[]: 0 2742 7792 7792
[1438766.984570] DMA32 free:164176kB min:47480kB low:59348kB
high:71220kB active_anon:32968kB inactive_anon:27716kB
active_file:976056kB inactive_file:1360132kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:24kB writeback:1760kB mapped:3036kB shmem:268kB
slab_reclaimable:219828kB slab_unreclaimable:8328kB kernel_stack:496kB
pagetables:620kB unstable:1320kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1438766.984585] lowmem_reserve[]: 0 0 5050 5050
[1438766.984602] Normal free:109048kB min:87420kB low:109272kB
high:131128kB active_anon:538032kB inactive_anon:99120kB
active_file:1746824kB inactive_file:2417160kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:108kB writeback:0kB mapped:31696kB shmem:6320kB
slab_reclaimable:131824kB slab_unreclaimable:24528kB
kernel_stack:2552kB pagetables:25280kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438766.984617] lowmem_reserve[]: 0 0 0 0
[1438766.984624] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1438766.984644] DMA32: 40470*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 163928kB
[1438766.984663] Normal: 26781*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 109172kB
[1438766.984682] 1626941 total pagecache pages
[1438766.984685] 234 pages in swap cache
[1438766.984690] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1438766.984695] Free swap  = 2090964kB
[1438766.984698] Total swap = 2097148kB
[1438766.985063] 2031600 pages RAM
[1438766.985063] 50307 pages reserved
[1438766.985063] 528435 pages shared
[1438766.985063] 1436360 pages non-shared
[1438770.524379] swapper/0: page allocation failure: order:4, mode:0x20
[1438770.524391] Pid: 0, comm: swapper/0 Not tainted 3.2.0 #2
[1438770.524396] Call Trace:
[1438770.524401]  <IRQ>  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1438770.524423]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1438770.524433]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1438770.524443]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1438770.524450]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1438770.524458]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1438770.524465]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1438770.524474]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1438770.524481]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1438770.524490]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1438770.524498]  [<ffffffff814ceca3>] __qdisc_run+0xb3/0x140
[1438770.524507]  [<ffffffff814b45b1>] net_tx_action+0xb1/0x150
[1438770.524515]  [<ffffffff8103a130>] __do_softirq+0x90/0x120
[1438770.524522]  [<ffffffff815a242c>] call_softirq+0x1c/0x30
[1438770.524530]  [<ffffffff810036fd>] do_softirq+0x4d/0x80
[1438770.524536]  [<ffffffff8103a406>] irq_exit+0x86/0xa0
[1438770.524543]  [<ffffffff8100359e>] do_IRQ+0x5e/0xd0
[1438770.524552]  [<ffffffff815a0b6b>] common_interrupt+0x6b/0x6b
[1438770.524556]  <EOI>  [<ffffffff81009124>] ? default_idle+0x24/0x40
[1438770.524572]  [<ffffffff81009234>] amd_e400_idle+0x54/0x100
[1438770.524579]  [<ffffffff8100079f>] cpu_idle+0x7f/0xd0
[1438770.524586]  [<ffffffff81589e64>] rest_init+0x68/0x74
[1438770.524594]  [<ffffffff8187fa67>] start_kernel+0x29f/0x2aa
[1438770.524601]  [<ffffffff8187f2ee>] x86_64_start_reservations+0xfe/0x102
[1438770.524609]  [<ffffffff8187f3e2>] x86_64_start_kernel+0xf0/0xf7
[1438770.524613] Mem-Info:
[1438770.524617] DMA per-cpu:
[1438770.524622] CPU    0: hi:    0, btch:   1 usd:   0
[1438770.524627] CPU    1: hi:    0, btch:   1 usd:   0
[1438770.524632] CPU    2: hi:    0, btch:   1 usd:   0
[1438770.524636] CPU    3: hi:    0, btch:   1 usd:   0
[1438770.524640] DMA32 per-cpu:
[1438770.524645] CPU    0: hi:  186, btch:  31 usd: 169
[1438770.524650] CPU    1: hi:  186, btch:  31 usd: 164
[1438770.524655] CPU    2: hi:  186, btch:  31 usd:  26
[1438770.524659] CPU    3: hi:  186, btch:  31 usd: 158
[1438770.524663] Normal per-cpu:
[1438770.524667] CPU    0: hi:  186, btch:  31 usd: 197
[1438770.524672] CPU    1: hi:  186, btch:  31 usd: 189
[1438770.524676] CPU    2: hi:  186, btch:  31 usd:  50
[1438770.524681] CPU    3: hi:  186, btch:  31 usd: 102
[1438770.524692] active_anon:142750 inactive_anon:31709 isolated_anon:0
[1438770.524695]  active_file:680722 inactive_file:953004 isolated_file:0
[1438770.524698]  unevictable:0 dirty:84 writeback:265 unstable:256
[1438770.524701]  free:65464 slab_reclaimable:85518 slab_unreclaimable:8158
[1438770.524704]  mapped:8681 shmem:1647 pagetables:6475 bounce:0
[1438770.524719] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1438770.524732] lowmem_reserve[]: 0 2742 7792 7792
[1438770.524751] DMA32 free:120276kB min:47480kB low:59348kB
high:71220kB active_anon:32968kB inactive_anon:27716kB
active_file:976060kB inactive_file:1412332kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:172kB writeback:0kB mapped:3036kB shmem:268kB
slab_reclaimable:210848kB slab_unreclaimable:8092kB kernel_stack:496kB
pagetables:620kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1438770.524766] lowmem_reserve[]: 0 0 5050 5050
[1438770.524784] Normal free:125664kB min:87420kB low:109272kB
high:131128kB active_anon:538032kB inactive_anon:99120kB
active_file:1746828kB inactive_file:2399684kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:164kB writeback:1280kB mapped:31688kB shmem:6320kB
slab_reclaimable:131224kB slab_unreclaimable:24540kB
kernel_stack:2552kB pagetables:25280kB unstable:1024kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438770.524799] lowmem_reserve[]: 0 0 0 0
[1438770.524806] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1438770.524826] DMA32: 29188*4kB 188*8kB 6*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 120400kB
[1438770.524845] Normal: 30873*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 125540kB
[1438770.524864] 1635696 total pagecache pages
[1438770.524868] 234 pages in swap cache
[1438770.524873] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1438770.524877] Free swap  = 2090964kB
[1438770.524881] Total swap = 2097148kB
[1438770.525266] 2031600 pages RAM
[1438770.525266] 50307 pages reserved
[1438770.525266] 527669 pages shared
[1438770.525266] 1443120 pages non-shared
[1438774.992454] gpsd: page allocation failure: order:4, mode:0x20
[1438774.992467] Pid: 13426, comm: gpsd Not tainted 3.2.0 #2
[1438774.992472] Call Trace:
[1438774.992477]  <IRQ>  [<ffffffff8107be84>] warn_alloc_failed+0xf4/0x140
[1438774.992501]  [<ffffffff8102e496>] ? __wake_up+0x46/0x60
[1438774.992511]  [<ffffffff8107e92b>] __alloc_pages_nodemask+0x50b/0x710
[1438774.992521]  [<ffffffff81599b34>] cache_alloc_refill+0x255/0x4a6
[1438774.992529]  [<ffffffff810a7423>] __kmalloc+0xb3/0xe0
[1438774.992537]  [<ffffffff814ac28a>] __alloc_skb+0x6a/0x220
[1438774.992544]  [<ffffffff814adee0>] skb_copy+0x40/0xb0
[1438774.992553]  [<ffffffff8138c555>] tg3_start_xmit+0x9e5/0xd00
[1438774.992560]  [<ffffffff814b703d>] dev_hard_start_xmit+0x27d/0x5f0
[1438774.992570]  [<ffffffff814ceb1f>] sch_direct_xmit+0xef/0x1c0
[1438774.992578]  [<ffffffff814ceca3>] __qdisc_run+0xb3/0x140
[1438774.992586]  [<ffffffff814b45b1>] net_tx_action+0xb1/0x150
[1438774.992594]  [<ffffffff8103a130>] __do_softirq+0x90/0x120
[1438774.992602]  [<ffffffff815a242c>] call_softirq+0x1c/0x30
[1438774.992609]  [<ffffffff810036fd>] do_softirq+0x4d/0x80
[1438774.992616]  [<ffffffff8103a406>] irq_exit+0x86/0xa0
[1438774.992623]  [<ffffffff8100359e>] do_IRQ+0x5e/0xd0
[1438774.992631]  [<ffffffff815a0b6b>] common_interrupt+0x6b/0x6b
[1438774.992636]  <EOI>  [<ffffffff81028b1e>] ? update_curr+0xee/0x100
[1438774.992650]  [<ffffffff81029e34>] ? finish_task_switch+0x54/0xb0
[1438774.992658]  [<ffffffff8159e835>] __schedule+0x295/0x810
[1438774.992666]  [<ffffffff8159e87f>] ? __schedule+0x2df/0x810
[1438774.992673]  [<ffffffff8159edea>] schedule+0x3a/0x50
[1438774.992680]  [<ffffffff8159f2b5>] schedule_timeout+0x1a5/0x200
[1438774.992689]  [<ffffffff815a0858>] ? _raw_spin_unlock_irqrestore+0x8/0x10
[1438774.992696]  [<ffffffff8159e41a>] sleep_on_common+0x6a/0xc0
[1438774.992705]  [<ffffffff81030e10>] ? try_to_wake_up+0x250/0x250
[1438774.992712]  [<ffffffff8159e538>] interruptible_sleep_on+0x18/0x20
[1438774.992721]  [<ffffffff813de552>] pl2303_ioctl+0x112/0x260
[1438774.992730]  [<ffffffff8105dad6>] ? wake_futex+0x36/0x60
[1438774.992738]  [<ffffffff8105e6f7>] ? futex_wake+0x107/0x130
[1438774.992745]  [<ffffffff813d7653>] serial_ioctl+0x53/0xa0
[1438774.992752]  [<ffffffff81321354>] tty_ioctl+0x274/0xb60
[1438774.992759]  [<ffffffff810016f4>] ? do_signal+0x1c4/0x6f0
[1438774.992766]  [<ffffffff81599963>] ? cache_alloc_refill+0x84/0x4a6
[1438774.992775]  [<ffffffff81009e6c>] ? fpu_finit+0x1c/0x30
[1438774.992783]  [<ffffffff810c0b8e>] do_vfs_ioctl+0x8e/0x4e0
[1438774.992791]  [<ffffffff810439ea>] ? set_current_blocked+0x3a/0x60
[1438774.992797]  [<ffffffff81001f8b>] ? sys_rt_sigreturn+0x1eb/0x200
[1438774.992805]  [<ffffffff810c102a>] sys_ioctl+0x4a/0x80
[1438774.992814]  [<ffffffff815a117b>] system_call_fastpath+0x16/0x1b
[1438774.992819] Mem-Info:
[1438774.992823] DMA per-cpu:
[1438774.992827] CPU    0: hi:    0, btch:   1 usd:   0
[1438774.992833] CPU    1: hi:    0, btch:   1 usd:   0
[1438774.992837] CPU    2: hi:    0, btch:   1 usd:   0
[1438774.992842] CPU    3: hi:    0, btch:   1 usd:   0
[1438774.992846] DMA32 per-cpu:
[1438774.992851] CPU    0: hi:  186, btch:  31 usd: 155
[1438774.992855] CPU    1: hi:  186, btch:  31 usd: 184
[1438774.992860] CPU    2: hi:  186, btch:  31 usd:  57
[1438774.992865] CPU    3: hi:  186, btch:  31 usd: 164
[1438774.992869] Normal per-cpu:
[1438774.992873] CPU    0: hi:  186, btch:  31 usd: 175
[1438774.992877] CPU    1: hi:  186, btch:  31 usd: 174
[1438774.992882] CPU    2: hi:  186, btch:  31 usd: 122
[1438774.992886] CPU    3: hi:  186, btch:  31 usd: 173
[1438774.992898] active_anon:142750 inactive_anon:31709 isolated_anon:0
[1438774.992900]  active_file:680728 inactive_file:956208 isolated_file:0
[1438774.992903]  unevictable:0 dirty:97 writeback:960 unstable:0
[1438774.992906]  free:65425 slab_reclaimable:82231 slab_unreclaimable:8056
[1438774.992909]  mapped:8672 shmem:1647 pagetables:6475 bounce:0
[1438774.992924] DMA free:15916kB min:264kB low:328kB high:396kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15692kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[1438774.992937] lowmem_reserve[]: 0 2742 7792 7792
[1438774.992956] DMA32 free:120648kB min:47480kB low:59348kB
high:71220kB active_anon:32968kB inactive_anon:27716kB
active_file:976060kB inactive_file:1416132kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2808608kB mlocked:0kB
dirty:8kB writeback:0kB mapped:3036kB shmem:268kB
slab_reclaimable:206452kB slab_unreclaimable:7820kB kernel_stack:496kB
pagetables:620kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[1438774.992970] lowmem_reserve[]: 0 0 5050 5050
[1438774.992988] Normal free:125632kB min:87420kB low:109272kB
high:131128kB active_anon:538032kB inactive_anon:99120kB
active_file:1746852kB inactive_file:2408488kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:5171200kB mlocked:0kB
dirty:380kB writeback:3840kB mapped:31652kB shmem:6320kB
slab_reclaimable:122472kB slab_unreclaimable:24404kB
kernel_stack:2552kB pagetables:25280kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1438774.993003] lowmem_reserve[]: 0 0 0 0
[1438774.993010] DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB
0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[1438774.993034] DMA32: 29195*4kB 226*8kB 12*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 120860kB
[1438774.993054] Normal: 30839*4kB 26*8kB 19*16kB 4*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 126044kB
[1438774.993074] 1638641 total pagecache pages
[1438774.993078] 234 pages in swap cache
[1438774.993082] Swap cache stats: add 26051, delete 25817, find 11689/13282
[1438774.993087] Free swap  = 2090964kB
[1438774.993090] Total swap = 2097148kB
[1438774.993274] 2031600 pages RAM
[1438774.993274] 50307 pages reserved
[1438774.993274] 528476 pages shared
[1438774.993274] 1402088 pages non-shared

Justin.
