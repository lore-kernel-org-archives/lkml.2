Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1AEVhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:37:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60148 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751351Ab1AEVhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:37:40 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+doEU+tAmdbLCikGTwqzyksam/ru0O9FvfxGLGcF
	YDT08VQMoAa6lL
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: mke2fs: page allocation failure w/ kernel 2.6.37
Date: Wed, 5 Jan 2011 22:37:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101052237.36735.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got this in /var/log/messages today (created a ext2 partition at an external USB drive, worked fine) :

...
2011-01-05T19:43:19.464+01:00 n22 kernel: mke2fs: page allocation failure. order:0, mode:0x0
2011-01-05T19:43:19.464+01:00 n22 kernel: Pid: 26241, comm: mke2fs Not tainted 2.6.37 #1
2011-01-05T19:43:19.464+01:00 n22 kernel: Call Trace:
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c1260b2b>] ? printk+0x18/0x1d
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c108b3e4>] __alloc_pages_nodemask+0x514/0x570
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c106099b>] ? __module_text_address+0xb/0x50
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c10adf10>] cache_alloc_refill+0x2c0/0x4f0
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c100676e>] ? print_context_stack+0x4e/0xb0
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c10adc3c>] kmem_cache_alloc+0xbc/0xd0
2011-01-05T19:43:19.464+01:00 n22 kernel: [<c10b0083>] create_object+0x23/0x240
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10b01dd>] ? create_object+0x17d/0x240
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c102ff7f>] ? wake_up_process+0xf/0x20
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1254307>] kmemleak_alloc+0x27/0x50
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10adc07>] kmem_cache_alloc+0x87/0xd0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108732e>] mempool_alloc_slab+0xe/0x10
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1087471>] mempool_alloc+0x41/0xf0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1087471>] ? mempool_alloc+0x41/0xf0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<f90ab023>] alloc_tio+0x23/0x50 [dm_mod]
2011-01-05T19:43:19.466+01:00 n22 kernel: [<f90ac7b4>] __split_and_process_bio+0x244/0x6f0 [dm_mod]
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c106099b>] ? __module_text_address+0xb/0x50
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10609e8>] ? is_module_text_address+0x8/0x10
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1049e67>] ? __kernel_text_address+0x47/0x70
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c100676e>] ? print_context_stack+0x4e/0xb0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10054f7>] ? dump_trace+0x87/0xe0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<f90acd16>] dm_request+0xb6/0x150 [dm_mod]
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c112cd0f>] generic_make_request+0x28f/0x380
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10adc07>] ? kmem_cache_alloc+0x87/0xd0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c112ce6a>] submit_bio+0x6a/0x100
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d8b5c>] ? bio_alloc_bioset+0x3c/0xb0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d3c33>] submit_bh+0xe3/0x120
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d67b9>] __block_write_full_page+0x229/0x3a0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d91e0>] ? blkdev_get_block+0x0/0xd0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d6a1a>] block_write_full_page_endio+0xea/0x100
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d91e0>] ? blkdev_get_block+0x0/0xd0
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d6a42>] block_write_full_page+0x12/0x20
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10da0af>] blkdev_writepage+0xf/0x20
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108b70b>] __writepage+0xb/0x30
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108be58>] write_cache_pages+0x158/0x330
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108b700>] ? __writepage+0x0/0x30
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10da0a0>] ? blkdev_writepage+0x0/0x20
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108c04f>] generic_writepages+0x1f/0x30
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108c077>] do_writepages+0x17/0x30
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1085909>] __filemap_fdatawrite_range+0x59/0x70
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c108596f>] filemap_write_and_wait_range+0x4f/0x90
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d23cc>] vfs_fsync_range+0x4c/0x90
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d24c2>] vfs_fsync+0x22/0x30
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d24fa>] do_fsync+0x2a/0x50
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c10d254d>] sys_fsync+0xd/0x10
2011-01-05T19:43:19.466+01:00 n22 kernel: [<c1002e93>] sysenter_do_call+0x12/0x22
2011-01-05T19:43:19.466+01:00 n22 kernel: Mem-Info:
2011-01-05T19:43:19.466+01:00 n22 kernel: DMA per-cpu:
2011-01-05T19:43:19.466+01:00 n22 kernel: CPU    0: hi:    0, btch:   1 usd:   0
2011-01-05T19:43:19.466+01:00 n22 kernel: CPU    1: hi:    0, btch:   1 usd:   0
2011-01-05T19:43:19.466+01:00 n22 kernel: Normal per-cpu:
2011-01-05T19:43:19.466+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd: 115
2011-01-05T19:43:19.466+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd:  30
2011-01-05T19:43:19.466+01:00 n22 kernel: HighMem per-cpu:
2011-01-05T19:43:19.467+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd: 178
2011-01-05T19:43:19.467+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd: 115
2011-01-05T19:43:19.467+01:00 n22 kernel: active_anon:144831 inactive_anon:60757 isolated_anon:0
2011-01-05T19:43:19.467+01:00 n22 kernel: active_file:57044 inactive_file:117883 isolated_file:0
2011-01-05T19:43:19.467+01:00 n22 kernel: unevictable:0 dirty:68283 writeback:14601 unstable:0
2011-01-05T19:43:19.467+01:00 n22 kernel: free:45254 slab_reclaimable:10486 slab_unreclaimable:49038
2011-01-05T19:43:19.467+01:00 n22 kernel: mapped:30904 shmem:29488 pagetables:1340 bounce:0
2011-01-05T19:43:19.467+01:00 n22 kernel: DMA free:3500kB min:64kB low:80kB high:96kB active_anon:596kB inactive_anon:768kB active_file:132kB 
inactive_file:8024kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15800kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB 
slab_reclaimable:604kB slab_unreclaimable:2284kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
2011-01-05T19:43:19.467+01:00 n22 kernel: lowmem_reserve[]: 0 865 1911 1911
2011-01-05T19:43:19.467+01:00 n22 kernel: Normal free:2756kB min:3728kB low:4660kB high:5592kB active_anon:73792kB inactive_anon:73856kB 
active_file:131732kB inactive_file:339856kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:273092kB 
writeback:58404kB mapped:12580kB shmem:43028kB slab_reclaimable:41340kB slab_unreclaimable:193868kB kernel_stack:2504kB pagetables:5360kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1296 all_unreclaimable? no
2011-01-05T19:43:19.467+01:00 n22 kernel: lowmem_reserve[]: 0 0 8369 8369
2011-01-05T19:43:19.467+01:00 n22 kernel: HighMem free:174760kB min:512kB low:1636kB high:2764kB active_anon:504936kB inactive_anon:168404kB 
active_file:96312kB inactive_file:123652kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1071256kB mlocked:0kB dirty:40kB writeback:0kB 
mapped:111032kB shmem:74924kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
2011-01-05T19:43:19.467+01:00 n22 kernel: lowmem_reserve[]: 0 0 0 0
2011-01-05T19:43:19.467+01:00 n22 kernel: DMA: 1*4kB 1*8kB 0*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3500kB
2011-01-05T19:43:19.467+01:00 n22 kernel: Normal: 1*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2756kB
2011-01-05T19:43:19.467+01:00 n22 kernel: HighMem: 16840*4kB 9685*8kB 1730*16kB 64*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 174760kB
2011-01-05T19:43:19.467+01:00 n22 kernel: 204435 total pagecache pages
2011-01-05T19:43:19.467+01:00 n22 kernel: 0 pages in swap cache
2011-01-05T19:43:19.467+01:00 n22 kernel: Swap cache stats: add 0, delete 0, find 0/0
2011-01-05T19:43:19.467+01:00 n22 kernel: Free swap  = 2003364kB
2011-01-05T19:43:19.468+01:00 n22 kernel: Total swap = 2003364kB
2011-01-05T19:43:19.468+01:00 n22 kernel: 498160 pages RAM
2011-01-05T19:43:19.468+01:00 n22 kernel: 270850 pages HighMem
2011-01-05T19:43:19.468+01:00 n22 kernel: 6064 pages reserved
2011-01-05T19:43:19.468+01:00 n22 kernel: 296131 pages shared
2011-01-05T19:43:19.468+01:00 n22 kernel: 275823 pages non-shared
2011-01-05T19:43:19.468+01:00 n22 kernel: kmemleak: Cannot allocate a kmemleak_object structure
2011-01-05T19:43:19.468+01:00 n22 kernel: Pid: 26241, comm: mke2fs Not tainted 2.6.37 #1
2011-01-05T19:43:19.468+01:00 n22 kernel: Call Trace:
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1260b2b>] ? printk+0x18/0x1d
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10b0288>] create_object+0x228/0x240
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10b01dd>] ? create_object+0x17d/0x240
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c102ff7f>] ? wake_up_process+0xf/0x20
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1254307>] kmemleak_alloc+0x27/0x50
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10adc07>] kmem_cache_alloc+0x87/0xd0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108732e>] mempool_alloc_slab+0xe/0x10
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1087471>] mempool_alloc+0x41/0xf0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1087471>] ? mempool_alloc+0x41/0xf0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<f90ab023>] alloc_tio+0x23/0x50 [dm_mod]
2011-01-05T19:43:19.468+01:00 n22 kernel: [<f90ac7b4>] __split_and_process_bio+0x244/0x6f0 [dm_mod]
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c106099b>] ? __module_text_address+0xb/0x50
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10609e8>] ? is_module_text_address+0x8/0x10
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1049e67>] ? __kernel_text_address+0x47/0x70
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c100676e>] ? print_context_stack+0x4e/0xb0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10054f7>] ? dump_trace+0x87/0xe0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<f90acd16>] dm_request+0xb6/0x150 [dm_mod]
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c112cd0f>] generic_make_request+0x28f/0x380
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10adc07>] ? kmem_cache_alloc+0x87/0xd0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c112ce6a>] submit_bio+0x6a/0x100
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d8b5c>] ? bio_alloc_bioset+0x3c/0xb0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d3c33>] submit_bh+0xe3/0x120
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d67b9>] __block_write_full_page+0x229/0x3a0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d91e0>] ? blkdev_get_block+0x0/0xd0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d6a1a>] block_write_full_page_endio+0xea/0x100
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d91e0>] ? blkdev_get_block+0x0/0xd0
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d6a42>] block_write_full_page+0x12/0x20
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d5fa0>] ? end_buffer_async_write+0x0/0x140
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10da0af>] blkdev_writepage+0xf/0x20
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108b70b>] __writepage+0xb/0x30
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108be58>] write_cache_pages+0x158/0x330
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108b700>] ? __writepage+0x0/0x30
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10da0a0>] ? blkdev_writepage+0x0/0x20
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108c04f>] generic_writepages+0x1f/0x30
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108c077>] do_writepages+0x17/0x30
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c1085909>] __filemap_fdatawrite_range+0x59/0x70
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c108596f>] filemap_write_and_wait_range+0x4f/0x90
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d23cc>] vfs_fsync_range+0x4c/0x90
2011-01-05T19:43:19.468+01:00 n22 kernel: [<c10d24c2>] vfs_fsync+0x22/0x30
2011-01-05T19:43:19.469+01:00 n22 kernel: [<c10d24fa>] do_fsync+0x2a/0x50
2011-01-05T19:43:19.469+01:00 n22 kernel: [<c10d254d>] sys_fsync+0xd/0x10
2011-01-05T19:43:19.469+01:00 n22 kernel: [<c1002e93>] sysenter_do_call+0x12/0x22
2011-01-05T19:43:19.469+01:00 n22 kernel: kmemleak: Kernel memory leak detector disabled
2011-01-05T19:43:19.469+01:00 n22 kernel: kmemleak: Automatic memory scanning thread ended

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

