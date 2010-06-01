Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0FAGH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:07:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49692 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0FAGH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RRllHoyo9ZXgrG6UaLOBcs6ZG+jc1S73zpmaOWGGwuC30BbpdGDTjmfn76hLYNjMAS
         ZuYst9GeHrO9B7ZoxMmKxvivUbVob2eFTtLZlENk2dWEem+SoeuhdRysHVyW3l9EvME8
         eui4DA0CmQjrkgnLdWcGJSQza05svlmc/48Yg=
Message-ID: <4C04A304.6070405@gmail.com>
Date: Tue, 01 Jun 2010 11:34:52 +0530
From: senthilkumaar2021 <senthilkumaar2021@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: netfilter@vger.kernel.org
Subject: squid -kernel 2.6.34
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have running squid 2.7stable6 as tproxy in *bridge mode* and the 
network traffic is around 100MBps.
The operating system is fedora 8 and the kernel is  2.6.34 ,my hardware 
configuration as follows CPU greater than 2GHZ and 8 GB Ram .Squid works 
fine for about 20-25 hours suddenly traffic not get passed through squid 
but squid is running fine.
The iptables version is iptables v1.4.8
Ebtables version is ebtables v2.0.9-1 (June 2009)

Please provide me a suggestions in solving the issue

In the dmesg we can find following errors

possible SYN flooding on port 80. Sending cookies.
swapper: page allocation failure. order:0, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34 #1
Call Trace:
 <IRQ>  [<ffffffff8109e763>] ? __alloc_pages_nodemask+0x530/0x59c
 [<ffffffffa01d0fcc>] ? br_nf_pre_routing_finish+0x0/0x2d6 [bridge]
 [<ffffffffa01d0fcc>] ? br_nf_pre_routing_finish+0x0/0x2d6 [bridge]
 [<ffffffff810c6824>] ? new_slab+0xa8/0x251
 [<ffffffff810c7e20>] ? __slab_alloc+0x1c4/0x3d4
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff81286e1e>] ? nf_iterate+0x40/0x9f
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff810c80b0>] ? kmem_cache_alloc_node+0x80/0x100
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff81261713>] ? __netdev_alloc_skb+0x29/0x43
 [<ffffffffa011ca1b>] ? e1000_alloc_rx_buffers+0x72/0x21b [e1000e]
 [<ffffffffa011c5fa>] ? e1000_clean_rx_irq+0x2bf/0x300 [e1000e]
 [<ffffffffa011b3bd>] ? e1000_clean+0x6e/0x21c [e1000e]
 [<ffffffff81030ec3>] ? enqueue_task_fair+0x239/0x24d
 [<ffffffff8126a42f>] ? net_rx_action+0xa9/0x17a
 [<ffffffff8103d64b>] ? __do_softirq+0xc5/0x17a
 [<ffffffff8100380c>] ? call_softirq+0x1c/0x28
 [<ffffffff81004da0>] ? do_softirq+0x31/0x65
 [<ffffffff8103d544>] ? irq_exit+0x36/0x78
 [<ffffffff81004420>] ? do_IRQ+0xa7/0xbd
 [<ffffffff812f1d93>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff81017b0b>] ? lapic_next_event+0x0/0x1c
 [<ffffffff811c4fe2>] ? acpi_idle_enter_bm+0x248/0x273
 [<ffffffff811c4fd8>] ? acpi_idle_enter_bm+0x23e/0x273
 [<ffffffff81244c84>] ? cpuidle_idle_call+0x83/0xdb
 [<ffffffff81001a2e>] ? cpu_idle+0x9a/0xbd
 [<ffffffff812ec48f>] ? start_secondary+0x1f5/0x1f9
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 176
CPU    1: hi:  186, btch:  31 usd: 166
CPU    2: hi:  186, btch:  31 usd:  22
CPU    3: hi:  186, btch:  31 usd: 137
CPU    4: hi:  186, btch:  31 usd: 174
CPU    5: hi:  186, btch:  31 usd: 164
CPU    6: hi:  186, btch:  31 usd:  24
CPU    7: hi:  186, btch:  31 usd:   6
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd: 183
CPU    2: hi:  186, btch:  31 usd: 148
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd: 175
CPU    6: hi:  186, btch:  31 usd:  76
CPU    7: hi:  186, btch:  31 usd:  56
active_anon:1244610 inactive_anon:223750 isolated_anon:0
 active_file:166512 inactive_file:222491 isolated_file:65
 unevictable:0 dirty:184444 writeback:346 unstable:0
 free:11564 slab_reclaimable:69448 slab_unreclaimable:77207
 mapped:406 shmem:1 pagetables:3570 bounce:0
Node 0 DMA free:15880kB min:64kB low:80kB high:96kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15768kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3510 8055 8055
Node 0 DMA32 free:23820kB min:15220kB low:19024kB high:22828kB 
active_anon:1935192kB inactive_anon:387664kB active_file:354332kB 
inactive_file:492488kB unevictable:0kB isolated(anon):0kB 
isolated(file):132kB present:3594804kB mlocked:0kB dirty:395960kB 
writeback:1016kB mapped:104kB shmem:0kB slab_reclaimable:222852kB 
slab_unreclaimable:138272kB kernel_stack:0kB pagetables:4564kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 4544 4544
Node 0 Normal free:6556kB min:19708kB low:24632kB high:29560kB 
active_anon:3043248kB inactive_anon:507336kB active_file:311716kB 
inactive_file:397476kB unevictable:0kB isolated(anon):0kB 
isolated(file):128kB present:4654076kB mlocked:0kB dirty:341816kB 
writeback:368kB mapped:1520kB shmem:4kB slab_reclaimable:54940kB 
slab_unreclaimable:170540kB kernel_stack:2152kB pagetables:9716kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 
1*1024kB 1*2048kB 3*4096kB = 15880kB
Node 0 DMA32: 5742*4kB 29*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 23200kB
Node 0 Normal: 1639*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 6556kB
399649 total pagecache pages
10594 pages in swap cache
Swap cache stats: add 62784, delete 52190, find 19949/24904
Free swap  = 20897812kB
Total swap = 20972852kB
swapper: page allocation failure. order:0, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34 #1
Call Trace:
 <IRQ>  [<ffffffff8109e763>] ? __alloc_pages_nodemask+0x530/0x59c
 [<ffffffffa01d0fcc>] ? br_nf_pre_routing_finish+0x0/0x2d6 [bridge]
 [<ffffffffa01d0fcc>] ? br_nf_pre_routing_finish+0x0/0x2d6 [bridge]
 [<ffffffff810c6824>] ? new_slab+0xa8/0x251
 [<ffffffff810c7e20>] ? __slab_alloc+0x1c4/0x3d4
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff810c80b0>] ? kmem_cache_alloc_node+0x80/0x100
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff81261713>] ? __netdev_alloc_skb+0x29/0x43
 [<ffffffffa011ca1b>] ? e1000_alloc_rx_buffers+0x72/0x21b [e1000e]
 [<ffffffffa011c5fa>] ? e1000_clean_rx_irq+0x2bf/0x300 [e1000e]
 [<ffffffffa011b3bd>] ? e1000_clean+0x6e/0x21c [e1000e]
 [<ffffffff8126a42f>] ? net_rx_action+0xa9/0x17a
 [<ffffffff8103d64b>] ? __do_softirq+0xc5/0x17a
 [<ffffffff8100380c>] ? call_softirq+0x1c/0x28
 [<ffffffff81004da0>] ? do_softirq+0x31/0x65
 [<ffffffff8103d544>] ? irq_exit+0x36/0x78
 [<ffffffff81004420>] ? do_IRQ+0xa7/0xbd
 [<ffffffff812f1d93>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff81017b0b>] ? lapic_next_event+0x0/0x1c
 [<ffffffff811c4fe2>] ? acpi_idle_enter_bm+0x248/0x273
 [<ffffffff811c4fd8>] ? acpi_idle_enter_bm+0x23e/0x273
 [<ffffffff81244c84>] ? cpuidle_idle_call+0x83/0xdb
 [<ffffffff81001a2e>] ? cpu_idle+0x9a/0xbd
 [<ffffffff812ec48f>] ? start_secondary+0x1f5/0x1f9
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 176
CPU    1: hi:  186, btch:  31 usd: 166
CPU    2: hi:  186, btch:  31 usd:  22
CPU    3: hi:  186, btch:  31 usd: 137
CPU    4: hi:  186, btch:  31 usd: 174
CPU    5: hi:  186, btch:  31 usd: 164
CPU    6: hi:  186, btch:  31 usd:  24
CPU    7: hi:  186, btch:  31 usd:   6
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd: 183
CPU    2: hi:  186, btch:  31 usd: 148
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd: 175
CPU    6: hi:  186, btch:  31 usd:  76
CPU    7: hi:  186, btch:  31 usd:  56
active_anon:1244610 inactive_anon:223750 isolated_anon:0
 active_file:166512 inactive_file:222491 isolated_file:65
 unevictable:0 dirty:184444 writeback:346 unstable:0
 free:11564 slab_reclaimable:69448 slab_unreclaimable:77207
 mapped:406 shmem:1 pagetables:3570 bounce:0
Node 0 DMA free:15880kB min:64kB low:80kB high:96kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15768kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3510 8055 8055
Node 0 DMA32 free:23820kB min:15220kB low:19024kB high:22828kB 
active_anon:1935192kB inactive_anon:387664kB active_file:354332kB 
inactive_file:492488kB unevictable:0kB isolated(anon):0kB 
isolated(file):132kB present:3594804kB mlocked:0kB dirty:395960kB 
writeback:1016kB mapped:104kB shmem:0kB slab_reclaimable:222852kB 
slab_unreclaimable:138272kB kernel_stack:0kB pagetables:4564kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 4544 4544
Node 0 Normal free:6556kB min:19708kB low:24632kB high:29560kB 
active_anon:3043248kB inactive_anon:507336kB active_file:311716kB 
inactive_file:397476kB unevictable:0kB isolated(anon):0kB 
isolated(file):128kB present:4654076kB mlocked:0kB dirty:341816kB 
writeback:368kB mapped:1520kB shmem:4kB slab_reclaimable:54940kB 
slab_unreclaimable:170540kB kernel_stack:2152kB pagetables:9716kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 
1*1024kB 1*2048kB 3*4096kB = 15880kB
Node 0 DMA32: 5742*4kB 29*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 23200kB
Node 0 Normal: 1639*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 6556kB
399649 total pagecache pages
10594 pages in swap cache
Swap cache stats: add 62784, delete 52190, find 19949/24904
Free swap  = 20897812kB
Total swap = 20972852kB
2097150 pages RAM
48252 pages reserved
386835 pages shared
1650423 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-256, object size: 256, buffer size: 256, default order: 
1, min order: 0
  node 0: slabs: 1955, objs: 50752, free: 0
swapper: page allocation failure. order:0, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.34 #1
Call Trace:
 <IRQ>  [<ffffffff8109e763>] ? __alloc_pages_nodemask+0x530/0x59c
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff810c6824>] ? new_slab+0xa8/0x251
 [<ffffffff810c7e20>] ? __slab_alloc+0x1c4/0x3d4
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff810c80b0>] ? kmem_cache_alloc_node+0x80/0x100
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
 [<ffffffff812a521b>] ? tcp_delack_timer+0x0/0x1b9
 [<ffffffff812a23a9>] ? tcp_send_ack+0x28/0xcd
 [<ffffffff812a5381>] ? tcp_delack_timer+0x166/0x1b9
 [<ffffffff810442a9>] ? run_timer_softirq+0x1bb/0x252
 [<ffffffff8103d64b>] ? __do_softirq+0xc5/0x17a
 [<ffffffff8100380c>] ? call_softirq+0x1c/0x28
 [<ffffffff81004da0>] ? do_softirq+0x31/0x65
 [<ffffffff8103d544>] ? irq_exit+0x36/0x78
swapper: page allocation failure. order:0, mode:0x4020
 [<ffffffff81004420>] ? do_IRQ+0xa7/0xbd
 [<ffffffff812f1d93>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff81017b0b>] ? lapic_next_event+0x0/0x1c
Pid: 0, comm: swapper Not tainted 2.6.34 #1
Call Trace:
 <IRQ>  [<ffffffff811c4fe2>] ? acpi_idle_enter_bm+0x248/0x273
 [<ffffffff811c4fd8>] ? acpi_idle_enter_bm+0x23e/0x273
 [<ffffffff8109e763>] ? __alloc_pages_nodemask+0x530/0x59c
 [<ffffffff81244c84>] ? cpuidle_idle_call+0x83/0xdb
 [<ffffffffa011b241>] ? e1000_intr_msi+0xea/0xf4 [e1000e]
 [<ffffffff810c6824>] ? new_slab+0xa8/0x251
 [<ffffffff81001a2e>] ? cpu_idle+0x9a/0xbd
 [<ffffffff812ec48f>] ? start_secondary+0x1f5/0x1f9
 [<ffffffff810c7e20>] ? __slab_alloc+0x1c4/0x3d4
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 176
CPU    1: hi:  186, btch:  31 usd: 167
CPU    2: hi:  186, btch:  31 usd:  22
CPU    3: hi:  186, btch:  31 usd: 137
CPU    4: hi:  186, btch:  31 usd: 174
CPU    5: hi:  186, btch:  31 usd: 164
CPU    6: hi:  186, btch:  31 usd:  24
CPU    7: hi:  186, btch:  31 usd:   6
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd: 183
CPU    2: hi:  186, btch:  31 usd: 148
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd: 175
CPU    6: hi:  186, btch:  31 usd:  76
CPU    7: hi:  186, btch:  31 usd:  56
active_anon:1244610 inactive_anon:223750 isolated_anon:0
 active_file:166512 inactive_file:222491 isolated_file:65
 unevictable:0 dirty:184444 writeback:346 unstable:0
 free:11564 slab_reclaimable:69448 slab_unreclaimable:77207
 mapped:406 shmem:1 pagetables:3570 bounce:0
Node 0 DMA free:15880kB min:64kB low:80kB high:96kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15768kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3510 8055 8055
Node 0 DMA32 free:23820kB min:15220kB low:19024kB high:22828kB 
active_anon:1935192kB inactive_anon:387664kB active_file:354332kB 
inactive_file:492488kB unevictable:0kB isolated(anon):0kB 
isolated(file):132kB present:3594804kB mlocked:0kB dirty:395960kB 
writeback:1016kB mapped:104kB shmem:0kB slab_reclaimable:222852kB 
slab_unreclaimable:138272kB kernel_stack:0kB pagetables:4564kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 4544 4544
Node 0 Normal free:6556kB min:19708kB low:24632kB high:29560kB 
active_anon:3043248kB inactive_anon:507336kB active_file:311716kB 
inactive_file:397476kB unevictable:0kB isolated(anon):0kB 
isolated(file):128kB present:4654076kB mlocked:0kB dirty:341816kB 
writeback:368kB mapped:1520kB shmem:4kB slab_reclaimable:54940kB 
slab_unreclaimable:170540kB kernel_stack:2152kB pagetables:9716kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 
1*1024kB 1*2048kB 3*4096kB = 15880kB
Node 0 DMA32: 5742*4kB  [<ffffffff81004420>] ? do_IRQ+0xa7/0xbd
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
29*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 23200kB
Node 0 Normal: 1639*4kB  [<ffffffff810c80b0>] ? 
kmem_cache_alloc_node+0x80/0x100
 [<ffffffff81261329>] ? __alloc_skb+0x3c/0x158
0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 
0*4096kB = 6556kB
399649 total pagecache pages
10594 pages in swap cache
Swap cache stats: add 62784, delete 52190, find 19949/24904
Free swap  = 20897812kB
Total swap = 20972852kB
 [<ffffffff8126f1cb>] ? __neigh_notify+0x26/0xb0
 [<ffffffff81271e59>] ? neigh_timer_handler+0x0/0x25b
 [<ffffffff81272098>] ? neigh_timer_handler+0x23f/0x25b
 [<ffffffff810442a9>] ? run_timer_softirq+0x1bb/0x252
 [<ffffffff81057458>] ? ktime_get+0x5c/0xb9
 [<ffffffff8103d64b>] ? __do_softirq+0xc5/0x17a
 [<ffffffff8100380c>] ? call_softirq+0x1c/0x28
 [<ffffffff81004da0>] ? do_softirq+0x31/0x65
 [<ffffffff8103d544>] ? irq_exit+0x36/0x78
 [<ffffffff81017f72>] ? smp_apic_timer_interrupt+0x87/0x95
 [<ffffffff810032d3>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff81017b0b>] ? lapic_next_event+0x0/0x1c
 [<ffffffff811c4fe2>] ? acpi_idle_enter_bm+0x248/0x273
 [<ffffffff811c4fd8>] ? acpi_idle_enter_bm+0x23e/0x273
 [<ffffffff81244c84>] ? cpuidle_idle_call+0x83/0xdb
 [<ffffffff81001a2e>] ? cpu_idle+0x9a/0xbd
 [<ffffffff812ec48f>] ? start_secondary+0x1f5/0x1f9
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 176
CPU    1: hi:  186, btch:  31 usd: 167
CPU    2: hi:  186, btch:  31 usd:  22
CPU    3: hi:  186, btch:  31 usd: 137
CPU    4: hi:  186, btch:  31 usd: 174
CPU    5: hi:  186, btch:  31 usd: 164
CPU    6: hi:  186, btch:  31 usd:  24
CPU    7: hi:  186, btch:  31 usd:   6
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd: 183
CPU    2: hi:  186, btch:  31 usd: 148
CPU    3: hi:  186, btch:  31 usd: 170
CPU    4: hi:  186, btch:  31 usd: 165
CPU    5: hi:  186, btch:  31 usd: 175
CPU    6: hi:  186, btch:  31 usd:  76
CPU    7: hi:  186, btch:  31 usd:  56
active_anon:1244610 inactive_anon:223750 isolated_anon:0
 active_file:166512 inactive_file:222491 isolated_file:65
 unevictable:0 dirty:184444 writeback:346 unstable:0
 free:11564 slab_reclaimable:69448 slab_unreclaimable:77207
 mapped:406 shmem:1 pagetables:3570 bounce:0
Node 0 DMA free:15880kB min:64kB low:80kB high:96kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15768kB mlocked:0kB 
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB 
slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 3510 8055 8055
Node 0 DMA32 free:23820kB min:15220kB low:19024kB high:22828kB 
active_anon:1935192kB inactive_anon:387664kB active_file:354332kB 
inactive_file:492488kB unevictable:0kB isolated(anon):0kB 
isolated(file):132kB present:3594804kB mlocked:0kB dirty:395960kB 
writeback:1016kB mapped:104kB shmem:0kB slab_reclaimable:222852kB 
slab_unreclaimable:138272kB kernel_stack:0kB pagetables:4564kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? no
lowmem_reserve[]: 0 0 4544 4544
Node 0 Normal free:6556kB min:19708kB low:24632kB high:29560kB 
active_anon:3043248kB inactive_anon:507336kB active_file:311716kB 
inactive_file:397476kB unevictable:0kB isolated(anon):0kB 
isolated(file):128kB present:4654076kB mlocked:0kB dirty:341816kB 
writeback:368kB mapped:1520kB shmem:4kB slab_reclaimable:54940kB 
slab_unreclaimable:170540kB kernel_stack:2152kB pagetables:9716kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 
1*1024kB 1*2048kB 3*4096kB = 15880kB
Node 0 DMA32: 5742*4kB 29*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 23200kB
Node 0 Normal: 1639*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 
0*512kB 0*1024kB 0*2048kB 0*4096kB = 6556kB
399649 total pagecache pages
10594 pages in swap cache
Swap cache stats: add 62784, delete 52190, find 19949/24904
Free swap  = 20897812kB
Total swap = 20972852kB
2097150 pages RAM
48252 pages reserved
386835 pages shared
1650423 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-256, object size: 256, buffer size: 256, default order: 
1, min order: 0
  node 0: slabs: 1955, objs: 50752, free: 4
2097150 pages RAM
48252 pages reserved
386732 pages shared
1650504 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-256, object size: 256, buffer size: 256, default order: 
1, min order: 0
  node 0: slabs: 1980, objs: 51152, free: 0
2097150 pages RAM
48252 pages reserved
386732 pages shared
1650504 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-256, object size: 256, buffer size: 256, default order: 
1, min order: 0
  node 0: slabs: 1980, objs: 51152, free: 88
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.
possible SYN flooding on port 80. Sending cookies.


Regards
senthil

