Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1HRKLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:11:38 -0400
Received: from lucidpixels.com ([72.73.18.11]:56385 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab1HRKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:11:36 -0400
Date: Thu, 18 Aug 2011 06:11:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 3.0.1: irq/48-eth1-rx-: page allocation failure: order:1,
 mode:0x20
Message-ID: <alpine.DEB.2.02.1108180610310.11234@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mem:   8194732k total,  8061488k used,   133244k free,  3211684k buffers
Swap: 16787772k total,        0k used, 16787772k free,  3938768k cached

Any thoughts on what caused the error below?
No swap is used.

[228627.152963] irq/48-eth1-rx-: page allocation failure: order:1, mode:0x20
[228627.153929] Pid: 1863, comm: irq/48-eth1-rx- Not tainted 3.0.1 #2
[228627.153929] Call Trace:
[228627.153929]  <IRQ>  [<ffffffff81083f35>] ? warn_alloc_failed+0xf5/0x150
[228627.231003]  [<ffffffff81086f1e>] ? __alloc_pages_nodemask+0x57e/0x7a0
[228627.231003]  [<ffffffff814c5e5b>] ? __pskb_pull_tail+0x6b/0x3a0
[228627.231003]  [<ffffffff810b36f4>] ? kmem_getpages+0x54/0x160
[228627.231003]  [<ffffffff810b48e7>] ? fallback_alloc+0x1b7/0x1d0
[228627.231003]  [<ffffffff810b4dd2>] ? kmem_cache_alloc+0xa2/0xf0
[228627.231003]  [<ffffffff814c12bc>] ? sk_prot_alloc.isra.38+0x3c/0x180
[228627.231003]  [<ffffffff814c1490>] ? sk_clone+0x10/0x2b0
[228627.231003]  [<ffffffff8151567b>] ? inet_csk_clone+0xb/0xa0
[228627.231003]  [<ffffffff8152d271>] ? tcp_create_openreq_child+0x21/0x4e0
[228627.231003]  [<ffffffff8152a497>] ? tcp_v4_syn_recv_sock+0x47/0x240
[228627.231003]  [<ffffffff8152d094>] ? tcp_check_req+0x2d4/0x490
[228627.231003]  [<ffffffff8152a33f>] ? tcp_v4_do_rcv+0x1bf/0x2d0
[228627.231003]  [<ffffffff8150b3f0>] ? ip_rcv_finish+0x320/0x320
[228627.231003]  [<ffffffff8152c88f>] ? tcp_v4_rcv+0x5cf/0x8a0
[228627.231003]  [<ffffffff8150b4ac>] ? ip_local_deliver_finish+0xbc/0x200
[228627.231003]  [<ffffffff814cf2a2>] ? __netif_receive_skb+0x4b2/0x5a0
[228627.231003]  [<ffffffff814cf560>] ? netif_receive_skb+0x70/0x80
[228627.231003]  [<ffffffff814d02fb>] ? napi_gro_receive+0x9b/0xb0
[228627.231003]  [<ffffffff814d0248>] ? napi_skb_finish+0x38/0x50
[228627.231003]  [<ffffffff81401e17>] ? e1000_clean_rx_irq+0x297/0x3d0
[228627.231003]  [<ffffffff81403030>] ? e1000_clean+0xb0/0x2a0
[228627.231003]  [<ffffffff814cf7a9>] ? net_rx_action+0xf9/0x180
[228627.231003]  [<ffffffff8103b948>] ? __do_softirq+0x98/0x120
[228627.231003]  [<ffffffff8106ef90>] ? irq_thread_fn+0x50/0x50
[228627.231003]  [<ffffffff815dca4c>] ? call_softirq+0x1c/0x30
[228627.231003]  <EOI>  [<ffffffff81003bed>] ? do_softirq+0x4d/0x80
[228627.231003]  [<ffffffff8103b6f4>] ? local_bh_enable+0x94/0xa0
[228627.231003]  [<ffffffff8106ef90>] ? irq_thread_fn+0x50/0x50
[228627.231003]  [<ffffffff8106efcc>] ? irq_forced_thread_fn+0x3c/0x60
[228627.231003]  [<ffffffff8106eec2>] ? irq_thread+0x152/0x1d0
[228627.231003]  [<ffffffff8106ed70>] ? irq_finalize_oneshot+0x130/0x130
[228627.231003]  [<ffffffff8105066e>] ? kthread+0x7e/0x90
[228627.231003]  [<ffffffff815dc954>] ? kernel_thread_helper+0x4/0x10
[228627.231003]  [<ffffffff810505f0>] ? kthread_worker_fn+0x120/0x120
[228627.231003]  [<ffffffff815dc950>] ? gs_change+0xb/0xb
[228627.231003] Mem-Info:
[228627.231003] Node 0 DMA per-cpu:
[228627.231003] CPU    0: hi:    0, btch:   1 usd:   0
[228627.231003] CPU    1: hi:    0, btch:   1 usd:   0
[228627.231003] CPU    2: hi:    0, btch:   1 usd:   0
[228627.231003] CPU    3: hi:    0, btch:   1 usd:   0
[228627.231003] Node 0 DMA32 per-cpu:
[228627.231003] CPU    0: hi:  186, btch:  31 usd: 155
[228627.231003] CPU    1: hi:  186, btch:  31 usd: 155
[228627.231003] CPU    2: hi:  186, btch:  31 usd:   0
[228627.231003] CPU    3: hi:  186, btch:  31 usd: 173
[228627.231003] Node 0 Normal per-cpu:
[228627.231003] CPU    0: hi:  186, btch:  31 usd: 168
[228627.231003] CPU    1: hi:  186, btch:  31 usd: 155
[228627.231003] CPU    2: hi:  186, btch:  31 usd:  53
[228627.231003] CPU    3: hi:  186, btch:  31 usd: 150
[228627.231003] active_anon:110842 inactive_anon:24370 isolated_anon:0
[228627.231003]  active_file:879980 inactive_file:925206 isolated_file:0
[228627.231003]  unevictable:0 dirty:14 writeback:0 unstable:0
[228627.231003]  free:19359 slab_reclaimable:66177 slab_unreclaimable:5595
[228627.231003]  mapped:5257 shmem:321 pagetables:4235 bounce:0
[228627.231003] Node 0 DMA free:15916kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15696kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[228627.231003] lowmem_reserve[]: 0 3255 8052 8052
[228627.231003] Node 0 DMA32 free:37352kB min:6608kB low:8260kB high:9912kB active_anon:93112kB inactive_anon:28872kB active_file:1515304kB inactive_file:1522720kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3333216kB mlocked:0kB dirty:4kB writeback:0kB mapped:5928kB shmem:0kB slab_reclaimable:115040kB slab_unreclaimable:1004kB kernel_stack:72kB pagetables:236kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[228627.231003] lowmem_reserve[]: 0 0 4797 4797[228627.231003] Node 0 Normal free:24168kB min:9740kB low:12172kB high:14608kB active_anon:350256kB inactive_anon:68608kB active_file:2004616kB inactive_file:2178104kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4912640kB mlocked:0kB dirty:52kB writeback:0kB mapped:15100kB shmem:1284kB slab_reclaimable:149668kB slab_unreclaimable:21376kB kernel_stack:2592kB pagetables:16704kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2 all_unreclaimable? no
[228627.231003] lowmem_reserve[]: 0 0 0 0
[228627.231003] Node 0 DMA: 1*4kB 1*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15916kB
[228627.231003] Node 0 DMA32: 7987*4kB 667*8kB 12*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 37476kB
[228627.231003] Node 0 Normal: 4210*4kB 498*8kB 53*16kB 18*32kB 14*64kB 8*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 24168kB
[228627.231003] 1805528 total pagecache pages
[228627.231003] 0 pages in swap cache
[228627.231003] Swap cache stats: add 0, delete 0, find 0/0
[228627.231003] Free swap  = 16787772kB
[228627.231003] Total swap = 16787772kB
[228627.231003] 2097136 pages RAM
[228627.231003] 48453 pages reserved
[228627.231003] 876696 pages shared
[228627.231003] 1235957 pages non-shared

Justin.


