Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1GNMlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 08:41:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54425 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab1GNMlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 08:41:46 -0400
MIME-Version: 1.0
Date: Thu, 14 Jul 2011 14:41:45 +0200
Message-ID: <CADdPHGupJ-MTDGYTEuygvHzZvaaWBuBxhnqxuxTo+PVW9yTNeg@mail.gmail.com>
Subject: 2.6.38.8 page allocation failure, (probably ixgbe)
From: Stefan Majer <stefan.majer@gmail.com>
To: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during a fairly large datatransfer over 2 10GB links to a local ext4 fs i got:

[117933.102057] rbd: page allocation failure. order:2, mode:0x4020
[117933.102097] rbd: page allocation failure. order:2, mode:0x4020
[117933.102100] Pid: 9946, comm: rbd Tainted: P
2.6.38.8-1.fits.4.el6.x86_64 #1
[117933.102102] Call Trace:
[117933.102104]  <IRQ>  [<ffffffff81108cf7>] ?
__alloc_pages_nodemask+0x6f7/0x8a0
[117933.102117]  [<ffffffff81146cd2>] ? kmalloc_large_node+0x62/0xb0
[117933.102120]  [<ffffffff8114becb>] ? __kmalloc_node_track_caller+0x15b/0x1d0
[117933.102125]  [<ffffffff814b073d>] ? ip_rcv+0x23d/0x310
[117933.102130]  [<ffffffff81466ff4>] ? __netdev_alloc_skb+0x24/0x50
[117933.102133]  [<ffffffff81466793>] ? __alloc_skb+0x83/0x170
[117933.102136]  [<ffffffff81466ff4>] ? __netdev_alloc_skb+0x24/0x50
[117933.102147]  [<ffffffffa01431b7>] ?
ixgbe_alloc_rx_buffers+0x2b7/0x370 [ixgbe]
[117933.102151]  [<ffffffff814748b0>] ? napi_skb_finish+0x50/0x70
[117933.102157]  [<ffffffffa01455a8>] ? ixgbe_clean_rx_irq+0x818/0x880 [ixgbe]
[117933.102162]  [<ffffffffa01476df>] ?
ixgbe_clean_rxtx_many+0x10f/0x220 [ixgbe]
[117933.102166]  [<ffffffff81474f22>] ? net_rx_action+0x102/0x2a0
[117933.102170]  [<ffffffff8106b765>] ? __do_softirq+0xb5/0x210
[117933.102174]  [<ffffffff810c7ca4>] ? handle_IRQ_event+0x54/0x180
[117933.102177]  [<ffffffff8106b7dd>] ? __do_softirq+0x12d/0x210
[117933.102184]  [<ffffffff8100cf3c>] ? call_softirq+0x1c/0x30
[117933.102186]  [<ffffffff8100e975>] ? do_softirq+0x65/0xa0
[117933.102189]  [<ffffffff8106b625>] ? irq_exit+0x95/0xa0
[117933.102193]  [<ffffffff8154a2f6>] ? do_IRQ+0x66/0xe0
[117933.102196]  [<ffffffff81542ad3>] ? ret_from_intr+0x0/0x15
[117933.102199]  <EOI>  [<ffffffff8110ee69>] ? __remove_mapping+0x99/0x140
[117933.102205]  [<ffffffff8110ee5e>] ? __remove_mapping+0x8e/0x140
[117933.102208]  [<ffffffff8111018b>] ? shrink_page_list+0x2db/0x5c0
[117933.102212]  [<ffffffff81110a82>] ? shrink_inactive_list+0x172/0x460
[117933.102215]  [<ffffffff814266e0>] ? clone_endio+0x0/0xd0
[117933.102218]  [<ffffffff81111473>] ? shrink_zone+0x3d3/0x530
[117933.102223]  [<ffffffff81091101>] ? ktime_get_ts+0xb1/0xf0
[117933.102226]  [<ffffffff8111168f>] ? do_try_to_free_pages+0xbf/0x450
[117933.102230]  [<ffffffff81111c64>] ? try_to_free_pages+0x84/0x100
[117933.102233]  [<ffffffff81108ad3>] ? __alloc_pages_nodemask+0x4d3/0x8a0
[117933.102237]  [<ffffffff8112e1bd>] ? page_add_new_anon_rmap+0x7d/0xd0
[117933.102240]  [<ffffffff81140f4a>] ? alloc_pages_vma+0x9a/0x150
[117933.102244]  [<ffffffff8112494b>] ? handle_pte_fault+0x74b/0xb30
[117933.102247]  [<ffffffff81124e78>] ? handle_mm_fault+0x148/0x270
[117933.102250]  [<ffffffff81124e78>] ? handle_mm_fault+0x148/0x270
[117933.102253]  [<ffffffff815460fb>] ? do_page_fault+0x14b/0x490
[117933.102255]  [<ffffffff81105774>] ? free_one_page+0x184/0x3e0
[117933.102258]  [<ffffffff81542d95>] ? page_fault+0x25/0x30
[117933.102260]  [<ffffffff81542d95>] ? page_fault+0x25/0x30
[117933.102264]  [<ffffffff812a77bd>] ? copy_user_generic_string+0x2d/0x40
[117933.102267]  [<ffffffff81469260>] ? memcpy_toiovec+0x80/0xa0
[117933.102271]  [<ffffffff8146a24f>] ? skb_copy_datagram_iovec+0x5f/0x2b0
[117933.102274]  [<ffffffff814c0662>] ? tcp_recvmsg+0xb62/0xd20
[117933.102279]  [<ffffffff814e287f>] ? inet_recvmsg+0x4f/0x80
[117933.102284]  [<ffffffff8145cd5d>] ? sock_recvmsg+0xfd/0x130
[117933.102287]  [<ffffffff81124682>] ? handle_pte_fault+0x482/0xb30
[117933.102290]  [<ffffffff81120e34>] ? __pte_alloc+0xa4/0xf0
[117933.102293]  [<ffffffff8145d61e>] ? sys_recvfrom+0xee/0x170
[117933.102297]  [<ffffffff8116b34d>] ? poll_select_set_timeout+0x8d/0xa0
[117933.102303]  [<ffffffff8100c002>] ? system_call_fastpath+0x16/0x1b
[117933.102304] Mem-Info:
[117933.102306] Node 0 DMA per-cpu:
[117933.102308] CPU    0: hi:    0, btch:   1 usd:   0
[117933.102310] CPU    1: hi:    0, btch:   1 usd:   0
[117933.102312] CPU    2: hi:    0, btch:   1 usd:   0
[117933.102314] CPU    3: hi:    0, btch:   1 usd:   0
[117933.102315] CPU    4: hi:    0, btch:   1 usd:   0
[117933.102317] CPU    5: hi:    0, btch:   1 usd:   0
[117933.102319] CPU    6: hi:    0, btch:   1 usd:   0
[117933.102321] CPU    7: hi:    0, btch:   1 usd:   0
[117933.102322] Node 0 DMA32 per-cpu:
[117933.102324] CPU    0: hi:  186, btch:  31 usd: 168
[117933.102326] CPU    1: hi:  186, btch:  31 usd: 182
[117933.102328] CPU    2: hi:  186, btch:  31 usd: 182
[117933.102330] CPU    3: hi:  186, btch:  31 usd:  53
[117933.102331] CPU    4: hi:  186, btch:  31 usd: 112
[117933.102333] CPU    5: hi:  186, btch:  31 usd: 175
[117933.102335] CPU    6: hi:  186, btch:  31 usd:  23
[117933.102337] CPU    7: hi:  186, btch:  31 usd:  14
[117933.102338] Node 0 Normal per-cpu:
[117933.102340] CPU    0: hi:  186, btch:  31 usd: 156
[117933.102342] CPU    1: hi:  186, btch:  31 usd: 174
[117933.102343] CPU    2: hi:  186, btch:  31 usd: 159
[117933.102345] CPU    3: hi:  186, btch:  31 usd:  39
[117933.102347] CPU    4: hi:  186, btch:  31 usd: 167
[117933.102349] CPU    5: hi:  186, btch:  31 usd: 182
[117933.102351] CPU    6: hi:  186, btch:  31 usd: 162
[117933.102353] CPU    7: hi:  186, btch:  31 usd: 174
[117933.102357] active_anon:235354 inactive_anon:44 isolated_anon:0
[117933.102358]  active_file:188649 inactive_file:5224606 isolated_file:32
[117933.102359]  unevictable:57420 dirty:1751301 writeback:0 unstable:0
[117933.102360]  free:87732 slab_reclaimable:158690 slab_unreclaimable:24613
[117933.102361]  mapped:2914 shmem:48 pagetables:11791 bounce:0
[117933.102364] Node 0 DMA free:15852kB min:164kB low:204kB high:244kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15660kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[117933.102373] lowmem_reserve[]: 0 2991 24201 24201
[117933.102375] Node 0 DMA32 free:96868kB min:32380kB low:40472kB
high:48568kB active_anon:100348kB inactive_anon:0kB
active_file:50560kB inactive_file:2381876kB unevictable:3616kB
isolated(anon):0kB isolated(file):0kB present:3063392kB mlocked:0kB
dirty:874064kB writeback:0kB mapped:24kB shmem:0kB
slab_reclaimable:136656kB slab_unreclaimable:48788kB
kernel_stack:40776kB pagetables:4408kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[117933.102385] lowmem_reserve[]: 0 0 21210 21210
[117933.102387] Node 0 Normal free:238952kB min:229592kB low:286988kB
high:344388kB active_anon:841068kB inactive_anon:176kB
active_file:704036kB inactive_file:18515396kB unevictable:226064kB
isolated(anon):0kB isolated(file):128kB present:21719040kB mlocked:0kB
dirty:6131140kB writeback:0kB mapped:11632kB shmem:192kB
slab_reclaimable:498104kB slab_unreclaimable:49664kB
kernel_stack:3680kB pagetables:42756kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:64 all_unreclaimable? no
[117933.102397] lowmem_reserve[]: 0 0 0 0
[117933.102399] Node 0 DMA: 1*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15852kB
[117933.102406] Node 0 DMA32: 3084*4kB 1253*8kB 762*16kB 1539*32kB
143*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 97048kB
[117933.102412] Node 0 Normal: 56218*4kB 196*8kB 304*16kB 142*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 239944kB
[117933.102421] 5470384 total pagecache pages
[117933.102422] 0 pages in swap cache
[117933.102424] Swap cache stats: add 0, delete 0, find 0/0
[117933.102425] Free swap  = 0kB
[117933.102426] Total swap = 0kB


any hints how to nail this down are welcome.

Greetings

-- 
Stefan Majer
