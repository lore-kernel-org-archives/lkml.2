Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674Ab1IILEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:04:36 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:37353 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab1IILEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:04:31 -0400
Message-ID: <4E69F2B5.7090007@t-online.de>
Date: Fri, 09 Sep 2011 13:04:21 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.20) Gecko/20110804 SUSE/3.1.12 Thunderbird/3.1.12
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org
Subject: [BUG] page table and page allocation problems in 3.1.0-rc5-main+
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: E2REfcZQZh6hhQu9vqq1P694ZkYpHGIzNs7hEsEiQSqe6u0jvwJ+AYLqPDjwVclwNj
X-TOI-MSGID: b28e0540-edc4-4e79-ac43-ad1fd29f79d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris!

hardware
=======
Aopen i915GMm-hfs, 1.86GHz Pentium M (Dothan), 2GB RAM

software:
=======
openSuSE 11.4

kernel, 3.1.0-rc5-main+ (kernel 3.0.4 seems to be ok)

X.Org X Server 1.11.0
Release Date: 2011-08-26
[    74.225] X Protocol Version 11, Revision 0
[    74.225] Build Operating System: Linux 3.0.4-main i686
[    74.225] Current Operating System: Linux golem 3.1.0-rc5-main+ #15 PREEMPT Thu Sep 8 15:45:51 CEST 2011 i686
[    74.225] Kernel command line: root=/dev/sdb5 acpi_enforce_resources=lax drm.debug=0 5
[    74.225] Build Date: 08 September 2011  04:40:24PM


dmesg
=====

[54760.775797] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[54760.776010] render error detected, EIR: 0x00000010
[54760.776010] page table error
[54760.776010]   PGTBL_ER: 0x00000010
[54760.776010] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
[54760.776010] render error detected, EIR: 0x00000010
[54760.776010] page table error
[54760.776010]   PGTBL_ER: 0x00000010

i915_error_state
=============

cat /sys/kernel/debug/dri/0/i915_error_state does not work and tells we are out of memory:

cat: /sys/kernel/debug/dri/0/i915_error_state: Nicht genügend Hauptspeicher verfügbar

dmesg again
==========

After a failed read of i915_error_state dmesg has additional information:

[65622.108515] cat: page allocation failure: order:8, mode:0xd0
[65622.108521] Pid: 27871, comm: cat Not tainted 3.1.0-rc5-main+ #15
[65622.108524] Call Trace:
[65622.108536]  [<c043291e>] ? printk+0xf/0x11
[65622.108544]  [<c0170c67>] warn_alloc_failed+0xb0/0xc2
[65622.108549]  [<c0172cc3>] __alloc_pages_nodemask+0x47e/0x4a8
[65622.108558]  [<c018ed57>] cache_alloc_refill+0x25b/0x411
[65622.108564]  [<c018ef89>] __kmalloc+0x7c/0xc5
[65622.108569]  [<c01a86de>] seq_read+0x1be/0x31b
[65622.108575]  [<c019129e>] ? rw_verify_area+0xc4/0xe7
[65622.108580]  [<c019165c>] vfs_read+0x8a/0x11e
[65622.108584]  [<c01a8520>] ? seq_lseek+0x134/0x134
[65622.108589]  [<c019172b>] sys_read+0x3b/0x60
[65622.108595]  [<c0438f8c>] sysenter_do_call+0x12/0x32
[65622.108599] Mem-Info:
[65622.108601] DMA per-cpu:
[65622.108604] CPU    0: hi:    0, btch:   1 usd:   0
[65622.108606] Normal per-cpu:
[65622.108609] CPU    0: hi:  186, btch:  31 usd:   0
[65622.108612] HighMem per-cpu:
[65622.108614] CPU    0: hi:  186, btch:  31 usd:   0
[65622.108620] active_anon:70036 inactive_anon:39146 isolated_anon:0
[65622.108622]  active_file:144252 inactive_file:145043 isolated_file:0
[65622.108623]  unevictable:0 dirty:4 writeback:80 unstable:0
[65622.108625]  free:71350 slab_reclaimable:34317 slab_unreclaimable:6780
[65622.108626]  mapped:22764 shmem:28737 pagetables:1231 bounce:0
[65622.108635] DMA free:5240kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:144kB slab_unreclaimable:12kB 
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[65622.108642] lowmem_reserve[]: 0 865 2008 2008
[65622.108655] Normal free:232876kB min:3728kB low:4660kB high:5592kB active_anon:15320kB inactive_anon:17680kB active_file:221016kB inactive_file:216960kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:16kB writeback:0kB mapped:4808kB shmem:12836kB 
slab_reclaimable:137124kB slab_unreclaimable:27108kB kernel_stack:2368kB pagetables:204kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[65622.108663] lowmem_reserve[]: 0 0 9143 9143
[65622.108675] HighMem free:47284kB min:512kB low:1740kB high:2972kB active_anon:264824kB inactive_anon:138904kB active_file:355992kB inactive_file:363212kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1170376kB mlocked:0kB dirty:0kB writeback:320kB mapped:86248kB shmem:102112kB 
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:4720kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[65622.108682] lowmem_reserve[]: 0 0 0 0
[65622.108689] DMA: 26*4kB 22*8kB 24*16kB 21*32kB 19*64kB 11*128kB 3*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 5240kB
[65622.108705] Normal: 17087*4kB 6900*8kB 1877*16kB 830*32kB 380*64kB 152*128kB 33*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 232876kB
[65622.108722] HighMem: 917*4kB 578*8kB 859*16kB 395*32kB 133*64kB 24*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 47284kB
[65622.108738] 321480 total pagecache pages
[65622.108740] 3448 pages in swap cache
[65622.108743] Swap cache stats: add 23966, delete 20518, find 4198/4697
[65622.108746] Free swap  = 5146764kB
[65622.108748] Total swap = 5164888kB
[65622.137455] 522208 pages RAM
[65622.137459] 294898 pages HighMem
[65622.137462] 7053 pages reserved
[65622.137464] 321488 pages shared
[65622.137466] 250040 pages non-shared

cu,
  knut


