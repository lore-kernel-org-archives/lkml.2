Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1CEIZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:25:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35281 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1CEIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ABFMXuxSZY7Y3d+CJatEhy9SrbEVgVabr8jJIvqTb6n5vm7s7JEKdO85PX7dm2cs9U
         PRleVAYOANDKM1FkYX7V5GjMHApSQ27GbcuBg0NIR1a1LlkWeH/gGrmSd8Bj797C8mdp
         OoJ45Q9dH7NxIIV4uz0o5OJaXkXK8q3GWIKvA=
MIME-Version: 1.0
Date: Sat, 5 Mar 2011 00:25:02 -0800
Message-ID: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com>
Subject: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure what this is or where I should post this:

basically turned the machine on, loaded gnome-mplayer(music starts)
then thunderbird, gwibber,llirc then started watching a movie on
hulu..in the process I was adding
audit rules to my SELinux policy(/usr/sbin/semodule -i somename) then
all hell broke loose:

/semodule" subj=justin:staff_r:staff_sudo_t:s0 key=(null)
[  339.786270] plugin-containe: page allocation failure. order:2, mode:0x4020
[  339.786275] Pid: 2572, comm: plugin-containe Not tainted
2.6.38-rc7-00143-gd1b152c #7
[  339.786278] Call Trace:
[  339.786280]  <IRQ>  [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
[  339.786302]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.786306]  [<ffffffff810f67cf>] ? new_slab+0x7b/0x1c6
[  339.786310]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.786314]  [<ffffffff810f6dd6>] ? T.925+0x163/0x29c
[  339.786318]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.786322]  [<ffffffff810f895a>] ? __kmalloc_track_caller+0xfe/0x190
[  339.786327]  [<ffffffff81380600>] ? __alloc_skb+0x6c/0x126
[  339.786331]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.786338]  [<ffffffffa01c553e>] ? ath_rx_tasklet+0x8bc/0x163b [ath9k]
[  339.786345]  [<ffffffffa01c4335>] ? ath9k_tasklet+0xa3/0x143 [ath9k]
[  339.786350]  [<ffffffff81066081>] ? tasklet_action+0x7b/0xfb
[  339.786353]  [<ffffffff81067253>] ? __do_softirq+0xc7/0x1a4
[  339.786358]  [<ffffffff8102e15c>] ? call_softirq+0x1c/0x28
[  339.786361]  [<ffffffff8102f635>] ? do_softirq+0x41/0x7e
[  339.786364]  [<ffffffff810670ea>] ? irq_exit+0x36/0x78
[  339.786368]  [<ffffffff8102ed0e>] ? do_IRQ+0x98/0xaf
[  339.786372]  [<ffffffff814473d3>] ? ret_from_intr+0x0/0x15
[  339.786374]  <EOI>  [<ffffffff8102d384>] ? sysret_audit+0x16/0x20
[  339.786379] Mem-Info:
[  339.786381] DMA per-cpu:
[  339.786383] CPU    0: hi:    0, btch:   1 usd:   0
[  339.786386] CPU    1: hi:    0, btch:   1 usd:   0
[  339.786388] DMA32 per-cpu:
[  339.786390] CPU    0: hi:  186, btch:  31 usd:   0
[  339.786392] CPU    1: hi:  186, btch:  31 usd:  30
[  339.786398] active_anon:88538 inactive_anon:88629 isolated_anon:96
[  339.786399]  active_file:19394 inactive_file:18955 isolated_file:0
[  339.786401]  unevictable:10 dirty:3018 writeback:1035 unstable:0
[  339.786402]  free:2022 slab_reclaimable:4588 slab_unreclaimable:22662
[  339.786404]  mapped:21900 shmem:1676 pagetables:3959 bounce:0
[  339.786411] DMA free:3948kB min:60kB low:72kB high:88kB
active_anon:5016kB inactive_anon:5176kB active_file:56kB
inactive_file:1020kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15684kB mlocked:0kB dirty:0kB writeback:0kB
mapped:240kB shmem:0kB slab_reclaimable:40kB slab_unreclaimable:196kB
kernel_stack:0kB pagetables:456kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  339.786419] lowmem_reserve[]: 0 978 978 978
[  339.786428] DMA32 free:4140kB min:3972kB low:4964kB high:5956kB
active_anon:349136kB inactive_anon:349340kB active_file:77520kB
inactive_file:74800kB unevictable:40kB isolated(anon):384kB
isolated(file):0kB present:1002436kB mlocked:40kB dirty:12072kB
writeback:4140kB mapped:87360kB shmem:6704kB slab_reclaimable:18312kB
slab_unreclaimable:90452kB kernel_stack:2256kB pagetables:15380kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[  339.786436] lowmem_reserve[]: 0 0 0 0
[  339.786440] DMA: 5*4kB 1*8kB 1*16kB 0*32kB 1*64kB 2*128kB 2*256kB
2*512kB 0*1024kB 1*2048kB 0*4096kB = 3948kB
[  339.786451] DMA32: 871*4kB 16*8kB 13*16kB 4*32kB 3*64kB 0*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4140kB
[  339.786461] 40904 total pagecache pages
[  339.786463] 876 pages in swap cache
[  339.786465] Swap cache stats: add 2272, delete 1396, find 37/43
[  339.786467] Free swap  = 381732kB
[  339.786469] Total swap = 390620kB
[  339.787008] 258163 pages RAM
[  339.787008] 6166 pages reserved
[  339.787008] 137254 pages shared
[  339.787008] 207478 pages non-shared
[  339.787008] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[  339.787008]   cache: kmalloc-8192, object size: 8192, buffer size:
8264, default order: 3, min order: 2
[  339.787008]   kmalloc-8192 debugging increased min order, use
slub_debug=O to disable.
[  339.787008]   node 0: slabs: 181, objs: 543, free: 0
[  339.790575] skbuff alloc of size 3904 failed
[  339.823775] swapper: page allocation failure. order:2, mode:0x4020
[  339.823781] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00143-gd1b152c #7
[  339.823783] Call Trace:
[  339.823786]  <IRQ>  [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
[  339.823811]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.823815]  [<ffffffff810f67cf>] ? new_slab+0x7b/0x1c6
[  339.823819]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.823823]  [<ffffffff810f6dd6>] ? T.925+0x163/0x29c
[  339.823827]  [<ffffffff810c4ecc>] ? mempool_destroy+0xf/0x17
[  339.823832]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
[  339.823836]  [<ffffffff810f895a>] ? __kmalloc_track_caller+0xfe/0x190


full dmesg is here:
http://fpaste.org/wkjq/

let me know if I need to supply any info

-- 
Justin P. Mattock
