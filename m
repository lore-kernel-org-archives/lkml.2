Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0K2R2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:28:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752926Ab0K2R2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:28:21 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/YnlspuSfY2k2bEAUwR9/zRYH2knmHPJ8mSiMC0l
	ARXqDyfAkG2VR/
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: kmemleak disabled itself in 2.6.36
Date: Mon, 29 Nov 2010 18:28:16 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.1; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <201010272112.59520.toralf.foerster@gmx.de> <201010281513.26185.toralf.foerster@gmx.de> <1288272802.10238.216.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1288272802.10238.216.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wK+8Malhmv4AXjT"
Message-Id: <201011291828.16570.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wK+8Malhmv4AXjT
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Catalin Marinas wrote at 15:33:22
> What does /proc/meminfo say after you got this error?
> Catalin

here's it :=20

foerste@n22 ~ $ cat /proc/meminfo=20
MemTotal:        1968432 kB
MemFree:           58832 kB
Buffers:          150604 kB
Cached:           953000 kB
SwapCached:        19492 kB
Active:           735396 kB
Inactive:        1065744 kB
Active(anon):     491220 kB
Inactive(anon):   326504 kB
Active(file):     244176 kB
Inactive(file):   739240 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       1079724 kB
HighFree:           1876 kB
LowTotal:         888708 kB
LowFree:           56956 kB
SwapTotal:       2003364 kB
SwapFree:        1975956 kB
Dirty:            346636 kB
Writeback:             0 kB
AnonPages:        678212 kB
Mapped:            81988 kB
Shmem:            120156 kB
Slab:              88304 kB
SReclaimable:      70696 kB
SUnreclaim:        17608 kB
KernelStack:        2360 kB
PageTables:         5192 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2987580 kB
Committed_AS:    1693792 kB
VmallocTotal:     122880 kB
VmallocUsed:       20272 kB
VmallocChunk:      27116 kB
DirectMap4k:       16376 kB
DirectMap4M:      892928 kB                                                =
                                            =20


for this issue in 2.6.36.1 (attached).


=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_wK+8Malhmv4AXjT
Content-Type: text/plain;
  charset="UTF-8";
  name="dump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dump.txt"

2010-11-29T18:22:57.519+01:00 n22 kernel: flush-254:0: page allocation failure. order:0, mode:0x0
2010-11-29T18:22:57.519+01:00 n22 kernel: Pid: 23142, comm: flush-254:0 Not tainted 2.6.36.1 #2
2010-11-29T18:22:57.519+01:00 n22 kernel: Call Trace:
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c125dbaf>] ? printk+0x18/0x21
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c108f1b4>] __alloc_pages_nodemask+0x514/0x570
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c1052dbe>] ? sched_clock_local+0xbe/0x1a0
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c106145b>] ? __module_text_address+0xb/0x50
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c10b0124>] cache_alloc_refill+0x2b4/0x4e0
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c100657e>] ? print_context_stack+0x4e/0xb0
2010-11-29T18:22:57.519+01:00 n22 kernel: [<c10afe5c>] kmem_cache_alloc+0xbc/0xd0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10b3c43>] create_object+0x23/0x240
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10b3d9d>] ? create_object+0x17d/0x240
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1031c1f>] ? wake_up_process+0xf/0x20
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1251877>] kmemleak_alloc+0x27/0x50
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10afe27>] kmem_cache_alloc+0x87/0xd0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c108b27e>] mempool_alloc_slab+0xe/0x10
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c108b3c1>] mempool_alloc+0x41/0xf0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c108b3c1>] ? mempool_alloc+0x41/0xf0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<f9c6bf03>] alloc_tio+0x23/0x50 [dm_mod]
2010-11-29T18:22:59.486+01:00 n22 kernel: [<f9c6d94d>] __split_and_process_bio+0x1bd/0x710 [dm_mod]
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10614a8>] ? is_module_text_address+0x8/0x10
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c104a8e7>] ? __kernel_text_address+0x47/0x70
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c100657e>] ? print_context_stack+0x4e/0xb0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c106145b>] ? __module_text_address+0xb/0x50
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c100657e>] ? print_context_stack+0x4e/0xb0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1260000>] ? _raw_spin_trylock+0x20/0x30
2010-11-29T18:22:59.486+01:00 n22 kernel: [<f9c6df5c>] dm_request+0xbc/0x1c0 [dm_mod]
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c112f46e>] generic_make_request+0x18e/0x340
2010-11-29T18:22:59.486+01:00 n22 kernel: [<fd0f7030>] ? crypt_merge+0x0/0x70 [dm_crypt]
2010-11-29T18:22:59.486+01:00 n22 kernel: [<f9c6d71d>] ? dm_merge_bvec+0xfd/0x170 [dm_mod]
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c112f68c>] submit_bio+0x6c/0x100
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10e0180>] ? mpage_end_io_read+0x0/0x70
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10df9fc>] mpage_bio_submit+0x1c/0x30
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10dfc7c>] __mpage_writepage+0x26c/0x6c0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1141d21>] ? radix_tree_gang_lookup_tag_slot+0x81/0xc0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1088dd2>] ? find_get_pages_tag+0x32/0x100
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c108fbf8>] write_cache_pages+0x158/0x330
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10dfa10>] ? __mpage_writepage+0x0/0x6c0
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10e022a>] mpage_writepages+0x3a/0x70
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c1115420>] ? ext2_get_block+0x0/0x850
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c111498d>] ext2_writepages+0xd/0x10
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c108fe17>] do_writepages+0x17/0x30
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d19f0>] writeback_single_inode+0x80/0x240
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d1fd4>] writeback_sb_inodes+0xb4/0x160
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d2554>] writeback_inodes_wb+0x84/0x120
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d27bb>] wb_writeback+0x1cb/0x210
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d2867>] wb_do_writeback+0x67/0x140
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d29b1>] bdi_writeback_thread+0x71/0x130
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c10d2940>] ? bdi_writeback_thread+0x0/0x130
2010-11-29T18:22:59.486+01:00 n22 kernel: [<c104cd34>] kthread+0x74/0x80
2010-11-29T18:22:59.487+01:00 n22 kernel: [<c104ccc0>] ? kthread+0x0/0x80
2010-11-29T18:22:59.487+01:00 n22 kernel: [<c10032be>] kernel_thread_helper+0x6/0x18
2010-11-29T18:22:59.487+01:00 n22 kernel: Mem-Info:
2010-11-29T18:22:59.487+01:00 n22 kernel: DMA per-cpu:
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    0: hi:    0, btch:   1 usd:   0
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    1: hi:    0, btch:   1 usd:   0
2010-11-29T18:22:59.487+01:00 n22 kernel: Normal per-cpu:
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd: 195
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd: 173
2010-11-29T18:22:59.487+01:00 n22 kernel: HighMem per-cpu:
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd: 178
2010-11-29T18:22:59.487+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd: 156
2010-11-29T18:22:59.487+01:00 n22 kernel: active_anon:118730 inactive_anon:77309 isolated_anon:0
2010-11-29T18:22:59.487+01:00 n22 kernel: active_file:49409 inactive_file:159947 isolated_file:0
2010-11-29T18:22:59.487+01:00 n22 kernel: unevictable:0 dirty:2256 writeback:77024 unstable:0
2010-11-29T18:22:59.487+01:00 n22 kernel: free:12240 slab_reclaimable:32666 slab_unreclaimable:35584
2010-11-29T18:22:59.487+01:00 n22 kernel: mapped:18187 shmem:23541 pagetables:1263 bounce:0
2010-11-29T18:22:59.487+01:00 n22 kernel: DMA free:3500kB min:64kB low:80kB high:96kB active_anon:2256kB inactive_anon:2904kB active_file:1424kB inactive_file:2444kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15860kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:1980kB slab_unreclaimable:1416kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-11-29T18:22:59.487+01:00 n22 kernel: lowmem_reserve[]: 0 865 1911 1911
2010-11-29T18:22:59.487+01:00 n22 kernel: Normal free:2680kB min:3728kB low:4660kB high:5592kB active_anon:113340kB inactive_anon:170544kB active_file:119876kB inactive_file:183648kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:3876kB writeback:118500kB mapped:8100kB shmem:3556kB slab_reclaimable:128684kB slab_unreclaimable:140920kB kernel_stack:2320kB pagetables:5052kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:159 all_unreclaimable? no
2010-11-29T18:22:59.487+01:00 n22 kernel: lowmem_reserve[]: 0 0 8369 8369
2010-11-29T18:22:59.487+01:00 n22 kernel: HighMem free:42780kB min:512kB low:1636kB high:2764kB active_anon:359324kB inactive_anon:135788kB active_file:76336kB inactive_file:453696kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1071256kB mlocked:0kB dirty:5148kB writeback:189596kB mapped:64648kB shmem:90608kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-11-29T18:22:59.487+01:00 n22 kernel: lowmem_reserve[]: 0 0 0 0
2010-11-29T18:22:59.487+01:00 n22 kernel: DMA: 72*4kB 86*8kB 156*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3504kB
2010-11-29T18:22:59.487+01:00 n22 kernel: Normal: 670*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2680kB
2010-11-29T18:22:59.487+01:00 n22 kernel: HighMem: 5375*4kB 1644*8kB 336*16kB 60*32kB 11*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 42780kB
2010-11-29T18:22:59.487+01:00 n22 kernel: 237605 total pagecache pages
2010-11-29T18:22:59.487+01:00 n22 kernel: 4677 pages in swap cache
2010-11-29T18:22:59.487+01:00 n22 kernel: Swap cache stats: add 5389, delete 712, find 6/6
2010-11-29T18:22:59.487+01:00 n22 kernel: Free swap  = 1981828kB
2010-11-29T18:22:59.487+01:00 n22 kernel: Total swap = 2003364kB
2010-11-29T18:22:59.487+01:00 n22 kernel: 498175 pages RAM
2010-11-29T18:22:59.487+01:00 n22 kernel: 270850 pages HighMem
2010-11-29T18:22:59.487+01:00 n22 kernel: 6067 pages reserved
2010-11-29T18:22:59.487+01:00 n22 kernel: 309799 pages shared
2010-11-29T18:22:59.487+01:00 n22 kernel: 282568 pages non-shared
2010-11-29T18:22:59.487+01:00 n22 kernel: kmemleak: Cannot allocate a kmemleak_object structure
2010-11-29T18:22:59.487+01:00 n22 kernel: Pid: 23142, comm: flush-254:0 Not tainted 2.6.36.1 #2
2010-11-29T18:22:59.487+01:00 n22 kernel: Call Trace:
2010-11-29T18:22:59.487+01:00 n22 kernel: [<c125dbaf>] ? printk+0x18/0x21
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10b3e48>] create_object+0x228/0x240
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10b3d9d>] ? create_object+0x17d/0x240
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1031c1f>] ? wake_up_process+0xf/0x20
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1251877>] kmemleak_alloc+0x27/0x50
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10afe27>] kmem_cache_alloc+0x87/0xd0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c108b27e>] mempool_alloc_slab+0xe/0x10
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c108b3c1>] mempool_alloc+0x41/0xf0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c108b3c1>] ? mempool_alloc+0x41/0xf0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<f9c6bf03>] alloc_tio+0x23/0x50 [dm_mod]
2010-11-29T18:22:59.488+01:00 n22 kernel: [<f9c6d94d>] __split_and_process_bio+0x1bd/0x710 [dm_mod]
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10614a8>] ? is_module_text_address+0x8/0x10
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c104a8e7>] ? __kernel_text_address+0x47/0x70
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c100657e>] ? print_context_stack+0x4e/0xb0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c106145b>] ? __module_text_address+0xb/0x50
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c100657e>] ? print_context_stack+0x4e/0xb0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1260000>] ? _raw_spin_trylock+0x20/0x30
2010-11-29T18:22:59.488+01:00 n22 kernel: [<f9c6df5c>] dm_request+0xbc/0x1c0 [dm_mod]
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c112f46e>] generic_make_request+0x18e/0x340
2010-11-29T18:22:59.488+01:00 n22 kernel: [<fd0f7030>] ? crypt_merge+0x0/0x70 [dm_crypt]
2010-11-29T18:22:59.488+01:00 n22 kernel: [<f9c6d71d>] ? dm_merge_bvec+0xfd/0x170 [dm_mod]
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c112f68c>] submit_bio+0x6c/0x100
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10e0180>] ? mpage_end_io_read+0x0/0x70
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10df9fc>] mpage_bio_submit+0x1c/0x30
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10dfc7c>] __mpage_writepage+0x26c/0x6c0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1141d21>] ? radix_tree_gang_lookup_tag_slot+0x81/0xc0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1088dd2>] ? find_get_pages_tag+0x32/0x100
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c108fbf8>] write_cache_pages+0x158/0x330
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10dfa10>] ? __mpage_writepage+0x0/0x6c0
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10e022a>] mpage_writepages+0x3a/0x70
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c1115420>] ? ext2_get_block+0x0/0x850
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c111498d>] ext2_writepages+0xd/0x10
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c108fe17>] do_writepages+0x17/0x30
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d19f0>] writeback_single_inode+0x80/0x240
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d1fd4>] writeback_sb_inodes+0xb4/0x160
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d2554>] writeback_inodes_wb+0x84/0x120
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d27bb>] wb_writeback+0x1cb/0x210
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d2867>] wb_do_writeback+0x67/0x140
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d29b1>] bdi_writeback_thread+0x71/0x130
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10d2940>] ? bdi_writeback_thread+0x0/0x130
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c104cd34>] kthread+0x74/0x80
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c104ccc0>] ? kthread+0x0/0x80
2010-11-29T18:22:59.488+01:00 n22 kernel: [<c10032be>] kernel_thread_helper+0x6/0x18
2010-11-29T18:22:59.488+01:00 n22 kernel: kmemleak: Kernel memory leak detector disabled
2010-11-29T18:22:59.488+01:00 n22 kernel: kmemleak: Automatic memory scanning thread ended

--Boundary-00=_wK+8Malhmv4AXjT--
