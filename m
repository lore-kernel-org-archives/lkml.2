Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0J0TNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:13:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55019 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751403Ab0J0TNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:13:05 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/vO3ZWNcPvm6kSQwODv+lgHOSrrNEzBUbwsImwDt
	YR7i8rt7gwcDJN
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak disabled itself in 2.6.36
Date: Wed, 27 Oct 2010 21:12:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010272112.59520.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm unsure whether this happens due to a 
$> sudo su -c "echo clear > /sys/kernel/debug/kmemleak"
or while regular scanning, but anyway seems not to be normal, or ?

2010-10-27T20:42:21.697+02:00 n22 kernel: flush-254:0: page allocation failure. order:0, mode:0x0
2010-10-27T20:42:21.697+02:00 n22 kernel: Pid: 15475, comm: flush-254:0 Not tainted 2.6.36 #2
2010-10-27T20:42:21.697+02:00 n22 kernel: Call Trace:
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c124a580>] ? printk+0x18/0x20
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c107edd4>] __alloc_pages_nodemask+0x514/0x570
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c100653e>] ? print_context_stack+0x4e/0xb0
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c109fd34>] cache_alloc_refill+0x2b4/0x4e0
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c109fa6c>] kmem_cache_alloc+0xbc/0xd0
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c10a3853>] create_object+0x23/0x240
2010-10-27T20:42:21.697+02:00 n22 kernel: [<c123e297>] kmemleak_alloc+0x27/0x50
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c109fa37>] kmem_cache_alloc+0x87/0xd0
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c107ae9e>] mempool_alloc_slab+0xe/0x10
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c107afe1>] mempool_alloc+0x41/0xf0
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c109fa37>] ? kmem_cache_alloc+0x87/0xd0
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10cbbc8>] bio_alloc_bioset+0x28/0xb0
2010-10-27T20:42:21.698+02:00 n22 kernel: [<f9bca09b>] clone_bio+0x3b/0x90 [dm_mod]
2010-10-27T20:42:21.698+02:00 n22 kernel: [<f9bcb985>] __split_and_process_bio+0x1f5/0x710 [dm_mod]
2010-10-27T20:42:21.698+02:00 n22 kernel: [<f9bcbf5c>] dm_request+0xbc/0x1c0 [dm_mod]
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c111e15e>] generic_make_request+0x18e/0x340
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c1080d52>] ? pagevec_lookup_tag+0x22/0x30
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c107f76a>] ? write_cache_pages+0xaa/0x330
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c111e37c>] submit_bio+0x6c/0x100
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c1104329>] ? ext2_get_inode+0xc9/0x140
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10cfab0>] ? mpage_end_io_read+0x0/0x70
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10cf32c>] mpage_bio_submit+0x1c/0x30
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10cfb6d>] mpage_writepages+0x4d/0x70
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c1104ac0>] ? ext2_get_block+0x0/0x850
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c110402d>] ext2_writepages+0xd/0x10
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c107fa37>] do_writepages+0x17/0x30
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c1320>] writeback_single_inode+0x80/0x240
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c1904>] writeback_sb_inodes+0xb4/0x160
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c1e84>] writeback_inodes_wb+0x84/0x120
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c20eb>] wb_writeback+0x1cb/0x210
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c124b4ee>] ? schedule_timeout+0x10e/0x1e0
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c2197>] wb_do_writeback+0x67/0x140
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c22e1>] bdi_writeback_thread+0x71/0x130
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c10c2270>] ? bdi_writeback_thread+0x0/0x130
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c104b0f4>] kthread+0x74/0x80
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c104b080>] ? kthread+0x0/0x80
2010-10-27T20:42:21.698+02:00 n22 kernel: [<c100327e>] kernel_thread_helper+0x6/0x18
2010-10-27T20:42:21.698+02:00 n22 kernel: Mem-Info:
2010-10-27T20:42:21.698+02:00 n22 kernel: DMA per-cpu:
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    0: hi:    0, btch:   1 usd:   0
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    1: hi:    0, btch:   1 usd:   0
2010-10-27T20:42:21.698+02:00 n22 kernel: Normal per-cpu:
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd:  44
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd:  30
2010-10-27T20:42:21.698+02:00 n22 kernel: HighMem per-cpu:
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd:  94
2010-10-27T20:42:21.698+02:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd:   0
2010-10-27T20:42:21.698+02:00 n22 kernel: active_anon:106111 inactive_anon:52216 isolated_anon:0
2010-10-27T20:42:21.698+02:00 n22 kernel: active_file:73442 inactive_file:179093 isolated_file:0
2010-10-27T20:42:21.698+02:00 n22 kernel: unevictable:0 dirty:52878 writeback:7857 unstable:0
2010-10-27T20:42:21.698+02:00 n22 kernel: free:4401 slab_reclaimable:34207 slab_unreclaimable:37304
2010-10-27T20:42:21.698+02:00 n22 kernel: mapped:16039 shmem:25688 pagetables:1201 bounce:0
2010-10-27T20:42:21.698+02:00 n22 kernel: DMA free:3492kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:4kB active_file:1184kB 
inactive_file:6632kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15860kB mlocked:0kB dirty:988kB writeback:1932kB mapped:0kB shmem:4kB 
slab_reclaimable:2224kB slab_unreclaimable:2400kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
2010-10-27T20:42:21.698+02:00 n22 kernel: lowmem_reserve[]: 0 865 1911 1911
2010-10-27T20:42:21.698+02:00 n22 kernel: Normal free:2676kB min:3728kB low:4660kB high:5592kB active_anon:74128kB inactive_anon:86076kB 
active_file:208592kB inactive_file:208780kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:47320kB writeback:10400kB 
mapped:1952kB shmem:6288kB slab_reclaimable:134604kB slab_unreclaimable:146816kB kernel_stack:2184kB pagetables:4804kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-10-27T20:42:21.698+02:00 n22 kernel: lowmem_reserve[]: 0 0 8369 8369
2010-10-27T20:42:21.698+02:00 n22 kernel: HighMem free:11436kB min:512kB low:1636kB high:2764kB active_anon:350316kB inactive_anon:122784kB 
active_file:83992kB inactive_file:500960kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1071256kB mlocked:0kB dirty:163204kB 
writeback:19096kB mapped:62204kB shmem:96460kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB 
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-10-27T20:42:21.699+02:00 n22 kernel: lowmem_reserve[]: 0 0 0 0
2010-10-27T20:42:21.699+02:00 n22 kernel: DMA: 0*4kB 0*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3504kB
2010-10-27T20:42:21.699+02:00 n22 kernel: Normal: 29*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2676kB
2010-10-27T20:42:21.699+02:00 n22 kernel: HighMem: 1781*4kB 255*8kB 56*16kB 33*32kB 3*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
11436kB
2010-10-27T20:42:21.699+02:00 n22 kernel: 278252 total pagecache pages
2010-10-27T20:42:21.699+02:00 n22 kernel: 0 pages in swap cache
2010-10-27T20:42:21.699+02:00 n22 kernel: Swap cache stats: add 0, delete 0, find 0/0
2010-10-27T20:42:21.699+02:00 n22 kernel: Free swap  = 2003364kB
2010-10-27T20:42:21.699+02:00 n22 kernel: Total swap = 2003364kB
2010-10-27T20:42:21.699+02:00 n22 kernel: 498175 pages RAM
2010-10-27T20:42:21.699+02:00 n22 kernel: 270850 pages HighMem
2010-10-27T20:42:21.699+02:00 n22 kernel: 6041 pages reserved
2010-10-27T20:42:21.699+02:00 n22 kernel: 339892 pages shared
2010-10-27T20:42:21.699+02:00 n22 kernel: 261411 pages non-shared
2010-10-27T20:42:21.699+02:00 n22 kernel: kmemleak: Cannot allocate a kmemleak_object structure
2010-10-27T20:42:21.699+02:00 n22 kernel: Pid: 15475, comm: flush-254:0 Not tainted 2.6.36 #2
2010-10-27T20:42:21.699+02:00 n22 kernel: Call Trace:
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c124a580>] ? printk+0x18/0x20
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10a3a58>] create_object+0x228/0x240
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c123e297>] kmemleak_alloc+0x27/0x50
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c109fa37>] kmem_cache_alloc+0x87/0xd0
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c107ae9e>] mempool_alloc_slab+0xe/0x10
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c107afe1>] mempool_alloc+0x41/0xf0
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c109fa37>] ? kmem_cache_alloc+0x87/0xd0
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10cbbc8>] bio_alloc_bioset+0x28/0xb0
2010-10-27T20:42:21.699+02:00 n22 kernel: [<f9bca09b>] clone_bio+0x3b/0x90 [dm_mod]
2010-10-27T20:42:21.699+02:00 n22 kernel: [<f9bcb985>] __split_and_process_bio+0x1f5/0x710 [dm_mod]
2010-10-27T20:42:21.699+02:00 n22 kernel: [<f9bcbf5c>] dm_request+0xbc/0x1c0 [dm_mod]
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c111e15e>] generic_make_request+0x18e/0x340
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c1080d52>] ? pagevec_lookup_tag+0x22/0x30
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c107f76a>] ? write_cache_pages+0xaa/0x330
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c111e37c>] submit_bio+0x6c/0x100
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c1104329>] ? ext2_get_inode+0xc9/0x140
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10cfab0>] ? mpage_end_io_read+0x0/0x70
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10cf32c>] mpage_bio_submit+0x1c/0x30
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10cfb6d>] mpage_writepages+0x4d/0x70
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c1104ac0>] ? ext2_get_block+0x0/0x850
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c110402d>] ext2_writepages+0xd/0x10
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c107fa37>] do_writepages+0x17/0x30
2010-10-27T20:42:21.699+02:00 n22 kernel: [<c10c1320>] writeback_single_inode+0x80/0x240
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c1904>] writeback_sb_inodes+0xb4/0x160
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c1e84>] writeback_inodes_wb+0x84/0x120
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c20eb>] wb_writeback+0x1cb/0x210
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c124b4ee>] ? schedule_timeout+0x10e/0x1e0
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c2197>] wb_do_writeback+0x67/0x140
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c22e1>] bdi_writeback_thread+0x71/0x130
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c10c2270>] ? bdi_writeback_thread+0x0/0x130
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c104b0f4>] kthread+0x74/0x80
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c104b080>] ? kthread+0x0/0x80
2010-10-27T20:42:21.700+02:00 n22 kernel: [<c100327e>] kernel_thread_helper+0x6/0x18
2010-10-27T20:42:21.700+02:00 n22 kernel: kmemleak: Kernel memory leak detector disabled
2010-10-27T20:42:21.700+02:00 n22 kernel: kmemleak: Automatic memory scanning thread ended

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

