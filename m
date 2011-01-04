Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1ADHlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:41:13 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:38786 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1ADHlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:41:12 -0500
MIME-Version: 1.0
From: ShiYong LI <a22381@motorola.com>
Date: Tue, 4 Jan 2011 15:40:17 +0800
Message-ID: <AANLkTikbEEUUoZ-+f7EGLrOQ+2n0+EaZXNSEH39bNFiY@mail.gmail.com>
Subject: Kernel 2.6.35.7 Oops caused by might_sleep() on ARMv7
To: linux-kernel@vger.kernel.org
Cc: TAO HU <taohu@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting kernel run on OMAP4430 chip (ARMv7, dual core), and got an
unexpected Oops caused by might_sleep() function. While that happened,
I was performing system test which almost consumed all system memory.

Based on Oops log below, might_sleep() threw out an unexpected warning
in page fault exception triggered by short of memory while calling
system call (by SWI exception). This should be a normal scenario, but,
kernel doesn't seem to handle it fine.  Any thoughts ?

Oops log:

<6>[35377.073242] request_suspend_state: wakeup (0->0) at
32812699437166 (2010-12-29 19:08:41.273678467 UTC)
<6>[35379.468200] input: sensors as /devices/virtual/input/input9
<6>[35380.344421] usb_ether_get_stats
<6>[35380.362335] usb_ether_get_stats
<6>[35380.399444] usb_ether_get_stats
<6>[35380.417022] usb_ether_get_stats
<6>[35380.618469] usb_ether_get_stats
<3>[35391.279327] init: untracked pid 25171 exited
<4>[35393.306610] events/0: page allocation failure. order:1, mode:0x20
<4>[35393.313140] [<c004b7a0>] (unwind_backtrace+0x0/0xf0) from
[<c00f2df8>] (__alloc_pages_nodemask+0x568/0x6e8)
<4>[35393.323455] [<c00f2df8>] (__alloc_pages_nodemask+0x568/0x6e8)
from [<c0117a64>] (cache_grow.clone.0+0xac/0x3e8)
<4>[35393.334167] [<c0117a64>] (cache_grow.clone.0+0xac/0x3e8) from
[<c011a0a0>] (__kmalloc_track_caller+0x3f4/0x6cc)
<4>[35393.344848] [<c011a0a0>] (__kmalloc_track_caller+0x3f4/0x6cc)
from [<c0373264>] (__alloc_skb+0x50/0xe0)
<4>[35393.354827] [<c0373264>] (__alloc_skb+0x50/0xe0) from
[<bf030020>] (st_int_recv+0x370/0x48c [st_drv])
<4>[35393.364593] [<bf030020>] (st_int_recv+0x370/0x48c [st_drv]) from
[<bf02f018>] (st_tty_receive+0x18/0x20 [st_drv])
<4>[35393.375488] [<bf02f018>] (st_tty_receive+0x18/0x20 [st_drv])
from [<c0240ae0>] (flush_to_ldisc+0xe0/0x180)
<4>[35393.385711] [<c0240ae0>] (flush_to_ldisc+0xe0/0x180) from
[<c00a4cac>] (worker_thread+0x1e4/0x278)
<4>[35393.395202] [<c00a4cac>] (worker_thread+0x1e4/0x278) from
[<c00a8ab0>] (kthread+0x78/0x80)
<4>[35393.403961] [<c00a8ab0>] (kthread+0x78/0x80) from [<c00462cc>]
(kernel_thread_exit+0x0/0x8)
<4>[35393.412811] Mem-info:
<4>[35393.415222] Normal per-cpu:
<4>[35393.418182] CPU    0: hi:  186, btch:  31 usd:   5
<4>[35393.423248] CPU    1: hi:  186, btch:  31 usd:  91
<4>[35393.428314] active_anon:15917 inactive_anon:15771 isolated_anon:1
<4>[35393.428314]  active_file:5235 inactive_file:7587 isolated_file:0
<4>[35393.428344]  unevictable:50762 dirty:56 writeback:0 unstable:0
<4>[35393.428344]  free:1037 slab_reclaimable:1224 slab_unreclaimable:3021
<4>[35393.428344]  mapped:12461 shmem:93 pagetables:3545 bounce:0
<4>[35393.459930] Normal free:4148kB min:2848kB low:3560kB high:4272kB
active_anon:63668kB inactive_anon:63084kB active_file:20940kB
inactive_file:30348kB unevictable:203048kB isolated(anon):4kB
isolated(file):0kB present:508000kB mlocked:0kB dirty:224kB
writeback:0kB mapped:49844kB shmem:372kB slab_reclaimable:4896kB
slab_unreclaimable:12084kB kernel_stack:3664kB pagetables:14180kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32
all_unreclaimable? no
<4>[35393.502685] lowmem_reserve[]: 0 0 0
<4>[35393.506378] Normal: 1037*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4148kB
<4>[35393.517517] 63672 total pagecache pages
<4>[35393.521545] 0 pages in swap cache
<4>[35393.525054] Swap cache stats: add 0, delete 0, find 0/0
<4>[35393.530578] Free swap  = 0kB
<4>[35393.533630] Total swap = 0kB
<4>[35393.555419] 128000 pages of RAM
<4>[35393.558746] 1790 free pages
<4>[35393.561676] 17305 reserved pages
<4>[35393.565093] 4254 slab pages
<4>[35393.568054] 127057 pages shared
<4>[35393.571350] 0 pages swap cached
<3>[35393.596527] (stc): Can't allocate mem for new packet
<3>[35398.317199] hci_cmd_task: hci0 command tx timeout
<3>[35403.916595] BUG: sleeping function called from invalid context
at /Volumes/data/hudson/workspace/integrated_device-cdma-solana-eng_main-dev_linux_continuous/platform/kernel/omap4/arch/arm/mm/fault.c:295
<3>[35403.935455] in_atomic(): 0, irqs_disabled(): 128, pid: 25390,
name: Thread-9
<4>[35403.942901] [<c004b7a0>] (unwind_backtrace+0x0/0xf0) from
[<c007eb24>] (__might_sleep+0x11c/0x148)
<4>[35403.952301] [<c007eb24>] (__might_sleep+0x11c/0x148) from
[<c004eccc>] (do_page_fault+0xa8/0x2e8)
<4>[35403.961608] [<c004eccc>] (do_page_fault+0xa8/0x2e8) from
[<c0044488>] (do_DataAbort+0x34/0xa8)
<4>[35403.970642] [<c0044488>] (do_DataAbort+0x34/0xa8) from
[<c0044bec>] (__dabt_svc+0x4c/0x60)
<4>[35403.979309] Exception stack(0xd1b79f68 to 0xd1b79fb0)
<4>[35403.984588] 9f60:                   4624d868 00020241 00000180
4847ba4c 00000241 00228e58
<4>[35403.993164] 9f80: 00000180 00000005 20000010 43c66d8c 43c66d74
46251a60 ad12e228 d1b79fb0
<4>[35404.001739] 9fa0: afd0da0c c0045228 60000093 ffffffff
<4>[35404.007019] [<c0044bec>] (__dabt_svc+0x4c/0x60) from
[<c0045228>] (vector_swi+0x28/0x88)

--
Thanks & Best Regards
Shiyong
