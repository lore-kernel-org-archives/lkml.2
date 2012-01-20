Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab2ATEmW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 19 Jan 2012 23:42:22 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:57959 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2ATEmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 23:42:16 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "=?koi8-r?B?UmFqa3VtYXIgTWFub2hhcmFu?=" <rmanohar@qca.qualcomm.com>
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 20 Jan 2012 08:42:12 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f18f0a4c42917.06465691@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I read the roaming script. I need to get the scan results and then 
issue 
 > "roam" in loop between all the APs I can access, right? Will try just 
to 
 > collect some new testing data.
 > 
 > Thanks for the patch - looks like it works fine so far.

Got a fresh trace... No idea how it happened, to be honest. 

First, I got a few surprisingly non-lethal 

Jan 18 11:39:16 401a0bf1 kernel: [401292.709527] ath: Failed to stop TX 
DMA, queues=0x005!
Jan 18 11:39:16 401a0bf1 kernel: [401292.726868] ath: Failed to stop TX 
DMA, queues=0x005!

Jan 19 04:19:28 401a0bf1 kernel: [452270.295826] ath: Failed to stop TX 
DMA, queues=0x005!
Jan 19 04:19:28 401a0bf1 kernel: [452270.313079] ath: Failed to stop TX 
DMA, queues=0x005!

On Jan 19, I sshed quite a few gigabytes over cpio/ssh

Got memory allocation warnings, log sample in the end of message. WiFi 
driver is mentioned in the stack, but looks mostly harmless.

Then I suspended (succesfully) and when I got home I checked my email 
succesfully using WiFi.

Then I did my standard mistake (closing the lid without stopping 
screensaver: after some time I get a GL screensaver with DPMS-Off state 
which is bad for i915 for some reason). 

I got failed GPU hangcheck at

Jan 19 23:41:39 401a0bf1 kernel: [49726.973809] 
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
and in two seconds X server was gone (I was asleep by that time)

Then..

Jan 20 06:37:41 401a0bf1 kernel: [74665.029637] ath: Timeout while waiting 
for nf to load: AR_PHY_AGC_CONTROL=0x40d22
Jan 20 06:37:41 401a0bf1 kernel: [74665.362365] ath: Failed to stop TX 
DMA, queues=0x005!
Jan 20 06:37:41 401a0bf1 kernel: [74665.371028] ------------[ cut here ]--
----------
Jan 20 06:37:41 401a0bf1 kernel: [74665.371038] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()                 

It continued to log-spam for an hour, then I shut it down.

Log in the very end of the message

The same warnings got repeated again and again, network was down. Didn't 
have time to check whether reloading module would help, though. 

Jan 19 16:52:28 401a0bf1 kernel: [29856.739064] ssh: page allocation 
failure: order:1, mode:0x4020
Jan 19 16:52:28 401a0bf1 kernel: [29856.739069] Pid: 1657, comm: ssh Not 
tainted 3.2.0 #1
Jan 19 16:52:28 401a0bf1 kernel: [29856.739071] Call Trace:
Jan 19 16:52:28 401a0bf1 kernel: [29856.739081]  
[warn_alloc_failed+0xeb/0x130] warn_alloc_failed+0xeb/0x130
Jan 19 16:52:28 401a0bf1 kernel: [29856.739081]  [<ffffffff810c3fab>] 
warn_alloc_failed+0xeb/0x130
Jan 19 16:52:28 401a0bf1 kernel: [29856.739085]  
[__alloc_pages_nodemask+0x487/0x6f0] __alloc_pages_nodemask+0x487/0x6f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739085]  [<ffffffff810c6237>] 
__alloc_pages_nodemask+0x487/0x6f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739091]  [new_slab+0x218/0x250] 
new_slab+0x218/0x250
Jan 19 16:52:28 401a0bf1 kernel: [29856.739091]  [<ffffffff810f8718>] 
new_slab+0x218/0x250
Jan 19 16:52:28 401a0bf1 kernel: [29856.739095]  
[__slab_alloc.clone.64+0x1f2/0x290] __slab_alloc.clone.64+0x1f2/0x290
Jan 19 16:52:28 401a0bf1 kernel: [29856.739095]  [<ffffffff810f9ff2>] 
__slab_alloc.clone.64+0x1f2/0x290
Jan 19 16:52:28 401a0bf1 kernel: [29856.739099]  
[pskb_expand_head+0x93/0x300] ? pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739099]  [<ffffffff812adae3>] ? 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739104]  
[led_trigger_event+0x23/0x80] ? led_trigger_event+0x23/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.739104]  [<ffffffff812920e3>] ? 
led_trigger_event+0x23/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.739130]  
[mac80211:ieee80211_led_tx+0x42/0x50] ? ieee80211_led_tx+0x42/0x50 
[mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739130]  [<ffffffffa054d572>] ? 
ieee80211_led_tx+0x42/0x50 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739132]  
[pskb_expand_head+0x93/0x300] ? pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739132]  [<ffffffff812adae3>] ? 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739134]  [__kmalloc+0x164/0x180] 
__kmalloc+0x164/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.739134]  [<ffffffff810fa364>] 
__kmalloc+0x164/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.739137]  
[pskb_expand_head+0x93/0x300] pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739137]  [<ffffffff812adae3>] 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739143]  
[mac80211:ieee80211_skb_resize.clone.28+0x44/0xc0] 
ieee80211_skb_resize.clone.28+0x44/0xc0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739143]  [<ffffffffa0547c24>] 
ieee80211_skb_resize.clone.28+0x44/0xc0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739150]  
[mac80211:ieee80211_subif_start_xmit+0x23c/0x7e0] 
ieee80211_subif_start_xmit+0x23c/0x7e0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739150]  [<ffffffffa054958c>] 
ieee80211_subif_start_xmit+0x23c/0x7e0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.739154]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.739154]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.739158]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 19 16:52:28 401a0bf1 kernel: [29856.739158]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 19 16:52:28 401a0bf1 kernel: [29856.739163]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739163]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739166]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739166]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739171]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739171]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.739174]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739174]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739177]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.739177]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.739179]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.739179]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.739182]  
[ip_queue_xmit+0x15a/0x400] ip_queue_xmit+0x15a/0x400
Jan 19 16:52:28 401a0bf1 kernel: [29856.739182]  [<ffffffff812eef5a>] 
ip_queue_xmit+0x15a/0x400
Jan 19 16:52:28 401a0bf1 kernel: [29856.739186]  
[tcp_transmit_skb+0x3de/0x8f0] tcp_transmit_skb+0x3de/0x8f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739186]  [<ffffffff81305a7e>] 
tcp_transmit_skb+0x3de/0x8f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739189]  
[tcp_write_xmit+0x1d2/0x9d0] tcp_write_xmit+0x1d2/0x9d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739189]  [<ffffffff813066a2>] 
tcp_write_xmit+0x1d2/0x9d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739192]  [ksize+0x17/0xc0] ? 
ksize+0x17/0xc0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739192]  [<ffffffff810f8d47>] ? 
ksize+0x17/0xc0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739194]  [tcp_push_one+0x2b/0x30] 
tcp_push_one+0x2b/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.739194]  [<ffffffff81306ecb>] 
tcp_push_one+0x2b/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.739199]  [tcp_sendmsg+0xcde/0xdd0] 
tcp_sendmsg+0xcde/0xdd0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739199]  [<ffffffff812f8aee>] 
tcp_sendmsg+0xcde/0xdd0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739203]  
[try_to_wake_up+0xce/0x270] ? try_to_wake_up+0xce/0x270
Jan 19 16:52:28 401a0bf1 kernel: [29856.739203]  [<ffffffff8104364e>] ? 
try_to_wake_up+0xce/0x270
Jan 19 16:52:28 401a0bf1 kernel: [29856.739208]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739208]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739212]  
[sock_aio_write+0x15b/0x170] sock_aio_write+0x15b/0x170
Jan 19 16:52:28 401a0bf1 kernel: [29856.739212]  [<ffffffff812a27cb>] 
sock_aio_write+0x15b/0x170
Jan 19 16:52:28 401a0bf1 kernel: [29856.739217]  
[do_sync_write+0xda/0x120] do_sync_write+0xda/0x120
Jan 19 16:52:28 401a0bf1 kernel: [29856.739217]  [<ffffffff811051ba>] 
do_sync_write+0xda/0x120
Jan 19 16:52:28 401a0bf1 kernel: [29856.739221]  
[handle_mm_fault+0x162/0x260] ? handle_mm_fault+0x162/0x260
Jan 19 16:52:28 401a0bf1 kernel: [29856.739221]  [<ffffffff810de432>] ? 
handle_mm_fault+0x162/0x260
Jan 19 16:52:28 401a0bf1 kernel: [29856.739227]  
[security_file_permission+0x27/0xb0] ? security_file_permission+0x27/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739227]  [<ffffffff81187cc7>] ? 
security_file_permission+0x27/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739230]  [vfs_write+0x16a/0x180] 
vfs_write+0x16a/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.739230]  [<ffffffff81105b2a>] 
vfs_write+0x16a/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.739233]  [sys_write+0x4c/0x90] 
sys_write+0x4c/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.739233]  [<ffffffff81105d9c>] 
sys_write+0x4c/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.739239]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 19 16:52:28 401a0bf1 kernel: [29856.739239]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 19 16:52:28 401a0bf1 kernel: [29856.739241] Mem-Info:
Jan 19 16:52:28 401a0bf1 kernel: [29856.739243] DMA per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.739245] CPU    0: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739247] CPU    1: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739249] CPU    2: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739251] CPU    3: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739252] DMA32 per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.739254] CPU    0: hi:  186, btch:  
31 usd: 114
Jan 19 16:52:28 401a0bf1 kernel: [29856.739256] CPU    1: hi:  186, btch:  
31 usd: 102
Jan 19 16:52:28 401a0bf1 kernel: [29856.739258] CPU    2: hi:  186, btch:  
31 usd: 149
Jan 19 16:52:28 401a0bf1 kernel: [29856.739260] CPU    3: hi:  186, btch:  
31 usd:  75
Jan 19 16:52:28 401a0bf1 kernel: [29856.739262] Normal per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.739264] CPU    0: hi:  186, btch:  
31 usd: 108
Jan 19 16:52:28 401a0bf1 kernel: [29856.739265] CPU    1: hi:  186, btch:  
31 usd: 175
Jan 19 16:52:28 401a0bf1 kernel: [29856.739268] CPU    2: hi:  186, btch:  
31 usd: 104
Jan 19 16:52:28 401a0bf1 kernel: [29856.739269] CPU    3: hi:  186, btch:  
31 usd:  52
Jan 19 16:52:28 401a0bf1 kernel: [29856.739273] active_anon:433335 
inactive_anon:153961 isolated_anon:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739274]  active_file:166130 
inactive_file:140108 isolated_file:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739275]  unevictable:0 dirty:87 
writeback:0 unstable:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739276]  free:13588 
slab_reclaimable:20726 slab_unreclaimable:7912
Jan 19 16:52:28 401a0bf1 kernel: [29856.739277]  mapped:20503 shmem:33840 
pagetables:5073 bounce:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739283] DMA free:15168kB min:28kB 
low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB 
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:15640kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:496kB slab_unreclaimable:200kB kernel_stack:8kB 
pagetables:24kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Jan 19 16:52:28 401a0bf1 kernel: [29856.739288] lowmem_reserve[]: 0 2653 
3787 3787
Jan 19 16:52:28 401a0bf1 kernel: [29856.739296] DMA32 free:36224kB 
min:5504kB low:6880kB high:8256kB active_anon:1202436kB 
inactive_anon:426920kB active_file:521536kB inactive_file:442340kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2716812kB 
mlocked:0kB dirty:228kB writeback:0kB mapped:31508kB shmem:105520kB 
slab_reclaimable:45348kB slab_unreclaimable:12832kB kernel_stack:1344kB 
pagetables:9700kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:189 all_unreclaimable? no
Jan 19 16:52:28 401a0bf1 kernel: [29856.739301] lowmem_reserve[]: 0 0 1134 
1134
Jan 19 16:52:28 401a0bf1 kernel: [29856.739308] Normal free:2960kB 
min:2352kB low:2940kB high:3528kB active_anon:530904kB 
inactive_anon:188924kB active_file:142984kB inactive_file:118092kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1161216kB 
mlocked:0kB dirty:120kB writeback:0kB mapped:50504kB shmem:29840kB 
slab_reclaimable:37060kB slab_unreclaimable:18616kB kernel_stack:2472kB 
pagetables:10568kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:43 all_unreclaimable? no
Jan 19 16:52:28 401a0bf1 kernel: [29856.739313] lowmem_reserve[]: 0 0 0 0
Jan 19 16:52:28 401a0bf1 kernel: [29856.739316] DMA: 4*4kB 5*8kB 6*16kB 
6*32kB 1*64kB 1*128kB 1*256kB 0*512kB 2*1024kB 2*2048kB 2*4096kB = 15128kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.739324] DMA32: 8823*4kB 3*8kB 
5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
36132kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.739331] Normal: 640*4kB 0*8kB 
1*16kB 6*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
2960kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.739338] 352585 total pagecache 
pages
Jan 19 16:52:28 401a0bf1 kernel: [29856.739340] 12471 pages in swap cache
Jan 19 16:52:28 401a0bf1 kernel: [29856.739342] Swap cache stats: add 
105397, delete 92926, find 133772/141462
Jan 19 16:52:28 401a0bf1 kernel: [29856.739343] Free swap  = 6207460kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.739345] Total swap = 6297444kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.754077] 1015792 pages RAM
Jan 19 16:52:28 401a0bf1 kernel: [29856.754080] 56932 pages reserved
Jan 19 16:52:28 401a0bf1 kernel: [29856.754081] 436740 pages shared
Jan 19 16:52:28 401a0bf1 kernel: [29856.754081] 604363 pages non-shared
Jan 19 16:52:28 401a0bf1 kernel: [29856.754085] SLUB: Unable to allocate 
memory on node -1 (gfp=0x20)
Jan 19 16:52:28 401a0bf1 kernel: [29856.754087]   cache: kmalloc-8192, 
object size: 8192, buffer size: 8192, default order: 3, min order: 1
Jan 19 16:52:28 401a0bf1 kernel: [29856.754090]   node 0: slabs: 27, objs: 
99, free: 0
Jan 19 16:52:28 401a0bf1 kernel: [29856.754175] ieee80211 phy3: failed to 
reallocate TX buffer
Jan 19 16:52:28 401a0bf1 kernel: [29856.847514] screen: page allocation 
failure: order:1, mode:0x4020
Jan 19 16:52:28 401a0bf1 kernel: [29856.847520] Pid: 18660, comm: screen 
Not tainted 3.2.0 #1
Jan 19 16:52:28 401a0bf1 kernel: [29856.847522] Call Trace:
Jan 19 16:52:28 401a0bf1 kernel: [29856.847524]  <IRQ>  
[warn_alloc_failed+0xeb/0x130] warn_alloc_failed+0xeb/0x130
Jan 19 16:52:28 401a0bf1 kernel: [29856.847524]  <IRQ>  
[<ffffffff810c3fab>] warn_alloc_failed+0xeb/0x130
Jan 19 16:52:28 401a0bf1 kernel: [29856.847537]  
[__alloc_pages_nodemask+0x487/0x6f0] __alloc_pages_nodemask+0x487/0x6f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847537]  [<ffffffff810c6237>] 
__alloc_pages_nodemask+0x487/0x6f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847543]  [new_slab+0x218/0x250] 
new_slab+0x218/0x250
Jan 19 16:52:28 401a0bf1 kernel: [29856.847543]  [<ffffffff810f8718>] 
new_slab+0x218/0x250
Jan 19 16:52:28 401a0bf1 kernel: [29856.847547]  
[__slab_alloc.clone.64+0x1f2/0x290] __slab_alloc.clone.64+0x1f2/0x290
Jan 19 16:52:28 401a0bf1 kernel: [29856.847547]  [<ffffffff810f9ff2>] 
__slab_alloc.clone.64+0x1f2/0x290
Jan 19 16:52:28 401a0bf1 kernel: [29856.847552]  
[pskb_expand_head+0x93/0x300] ? pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847552]  [<ffffffff812adae3>] ? 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847557]  
[led_trigger_event+0x23/0x80] ? led_trigger_event+0x23/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.847557]  [<ffffffff812920e3>] ? 
led_trigger_event+0x23/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.847582]  
[mac80211:ieee80211_led_tx+0x42/0x50] ? ieee80211_led_tx+0x42/0x50 
[mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847582]  [<ffffffffa054d572>] ? 
ieee80211_led_tx+0x42/0x50 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847585]  
[pskb_expand_head+0x93/0x300] ? pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847585]  [<ffffffff812adae3>] ? 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847588]  [__kmalloc+0x164/0x180] 
__kmalloc+0x164/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.847588]  [<ffffffff810fa364>] 
__kmalloc+0x164/0x180
Jan 19 16:52:28 401a0bf1 kernel: [29856.847590]  
[pskb_expand_head+0x93/0x300] pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847590]  [<ffffffff812adae3>] 
pskb_expand_head+0x93/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847597]  
[mac80211:ieee80211_skb_resize.clone.28+0x44/0xc0] 
ieee80211_skb_resize.clone.28+0x44/0xc0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847597]  [<ffffffffa0547c24>] 
ieee80211_skb_resize.clone.28+0x44/0xc0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847604]  
[mac80211:ieee80211_subif_start_xmit+0x23c/0x7e0] 
ieee80211_subif_start_xmit+0x23c/0x7e0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847604]  [<ffffffffa054958c>] 
ieee80211_subif_start_xmit+0x23c/0x7e0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847609]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847609]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847613]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 19 16:52:28 401a0bf1 kernel: [29856.847613]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 19 16:52:28 401a0bf1 kernel: [29856.847619]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847619]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847621]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847621]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847626]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847626]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 19 16:52:28 401a0bf1 kernel: [29856.847629]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847629]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847632]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847632]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847635]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.847635]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.847638]  
[ip_queue_xmit+0x15a/0x400] ip_queue_xmit+0x15a/0x400
Jan 19 16:52:28 401a0bf1 kernel: [29856.847638]  [<ffffffff812eef5a>] 
ip_queue_xmit+0x15a/0x400
Jan 19 16:52:28 401a0bf1 kernel: [29856.847642]  
[tcp_transmit_skb+0x3de/0x8f0] tcp_transmit_skb+0x3de/0x8f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847642]  [<ffffffff81305a7e>] 
tcp_transmit_skb+0x3de/0x8f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847645]  
[tcp_write_xmit+0x1d2/0x9d0] tcp_write_xmit+0x1d2/0x9d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847645]  [<ffffffff813066a2>] 
tcp_write_xmit+0x1d2/0x9d0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847648]  
[__tcp_push_pending_frames+0x21/0x90] __tcp_push_pending_frames+0x21/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.847648]  [<ffffffff81306ef1>] 
__tcp_push_pending_frames+0x21/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.847651]  
[tcp_rcv_established+0x4b6/0x840] tcp_rcv_established+0x4b6/0x840
Jan 19 16:52:28 401a0bf1 kernel: [29856.847651]  [<ffffffff81303ab6>] 
tcp_rcv_established+0x4b6/0x840
Jan 19 16:52:28 401a0bf1 kernel: [29856.847655]  
[tcp_v4_do_rcv+0x257/0x460] tcp_v4_do_rcv+0x257/0x460
Jan 19 16:52:28 401a0bf1 kernel: [29856.847655]  [<ffffffff8130b137>] 
tcp_v4_do_rcv+0x257/0x460
Jan 19 16:52:28 401a0bf1 kernel: [29856.847660]  
[security_sock_rcv_skb+0x11/0x20] ? security_sock_rcv_skb+0x11/0x20
Jan 19 16:52:28 401a0bf1 kernel: [29856.847660]  [<ffffffff811871a1>] ? 
security_sock_rcv_skb+0x11/0x20
Jan 19 16:52:28 401a0bf1 kernel: [29856.847663]  [tcp_v4_rcv+0x656/0x900] 
tcp_v4_rcv+0x656/0x900
Jan 19 16:52:28 401a0bf1 kernel: [29856.847663]  [<ffffffff8130d5d6>] 
tcp_v4_rcv+0x656/0x900
Jan 19 16:52:28 401a0bf1 kernel: [29856.847666]  
[ip_route_input_common+0xbec/0xe10] ? ip_route_input_common+0xbec/0xe10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847666]  [<ffffffff812e7d7c>] ? 
ip_route_input_common+0xbec/0xe10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847671]  
[neigh_direct_output+0xc/0x10] ? neigh_direct_output+0xc/0x10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847671]  [<ffffffff812c27ac>] ? 
neigh_direct_output+0xc/0x10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847674]  
[ip_local_deliver_finish+0xdd/0x280] ip_local_deliver_finish+0xdd/0x280
Jan 19 16:52:28 401a0bf1 kernel: [29856.847674]  [<ffffffff812e9dbd>] 
ip_local_deliver_finish+0xdd/0x280
Jan 19 16:52:28 401a0bf1 kernel: [29856.847677]  
[ip_local_deliver+0x80/0x90] ip_local_deliver+0x80/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.847677]  [<ffffffff812ea120>] 
ip_local_deliver+0x80/0x90
Jan 19 16:52:28 401a0bf1 kernel: [29856.847679]  
[ip_rcv_finish+0x135/0x3a0] ip_rcv_finish+0x135/0x3a0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847679]  [<ffffffff812e9a75>] 
ip_rcv_finish+0x135/0x3a0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847682]  [ip_rcv+0x224/0x2f0] 
ip_rcv+0x224/0x2f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847682]  [<ffffffff812ea354>] 
ip_rcv+0x224/0x2f0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847687]  [<ffffffffa069de65>] ? 
packet_rcv_spkt+0x45/0x198 [af_packet]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847691]  
[__netif_receive_skb+0x4d6/0x580] __netif_receive_skb+0x4d6/0x580
Jan 19 16:52:28 401a0bf1 kernel: [29856.847691]  [<ffffffff812b87c6>] 
__netif_receive_skb+0x4d6/0x580
Jan 19 16:52:28 401a0bf1 kernel: [29856.847695]  
[netif_receive_skb+0x58/0x80] netif_receive_skb+0x58/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.847695]  [<ffffffff812b88c8>] 
netif_receive_skb+0x58/0x80
Jan 19 16:52:28 401a0bf1 kernel: [29856.847701]  
[mac80211:ieee80211_deliver_skb.clone.25+0xa8/0x210] 
ieee80211_deliver_skb.clone.25+0xa8/0x210 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847701]  [<ffffffffa05436a8>] 
ieee80211_deliver_skb.clone.25+0xa8/0x210 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847707]  
[mac80211:ieee80211_rx_handlers+0xc9a/0x1b50] 
ieee80211_rx_handlers+0xc9a/0x1b50 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847707]  [<ffffffffa05446fa>] 
ieee80211_rx_handlers+0xc9a/0x1b50 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847710]  [__kfree_skb+0x19/0xa0] ? 
__kfree_skb+0x19/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847710]  [<ffffffff812ac2f9>] ? 
__kfree_skb+0x19/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847713]  [consume_skb+0x19/0x40] ? 
consume_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847713]  [<ffffffff812ac399>] ? 
consume_skb+0x19/0x40
Jan 19 16:52:28 401a0bf1 kernel: [29856.847720]  
[mac80211:ieee80211_prepare_and_rx_handle+0x2bd/0x900] 
ieee80211_prepare_and_rx_handle+0x2bd/0x900 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847720]  [<ffffffffa054586d>] 
ieee80211_prepare_and_rx_handle+0x2bd/0x900 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847727]  
[mac80211:ieee80211_rx+0x30b/0x9a0] ieee80211_rx+0x30b/0x9a0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847727]  [<ffffffffa05461bb>] 
ieee80211_rx+0x30b/0x9a0 [mac80211]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847734]  [<ffffffffa06c01d7>] 
ath_rx_tasklet+0xcf7/0x1e30 [ath9k]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847739]  
[swiotlb_map_page+0x0/0x100] ? swiotlb_map_sg+0x10/0x10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847739]  [<ffffffff811e10d0>] ? 
swiotlb_map_sg+0x10/0x10
Jan 19 16:52:28 401a0bf1 kernel: [29856.847744]  [<ffffffffa06bcf3f>] 
ath9k_tasklet+0xff/0x1c0 [ath9k]
Jan 19 16:52:28 401a0bf1 kernel: [29856.847748]  
[tasklet_action+0x64/0xe0] tasklet_action+0x64/0xe0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847748]  [<ffffffff81052a74>] 
tasklet_action+0x64/0xe0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847751]  [__do_softirq+0x98/0x120] 
__do_softirq+0x98/0x120
Jan 19 16:52:28 401a0bf1 kernel: [29856.847751]  [<ffffffff81052d98>] 
__do_softirq+0x98/0x120
Jan 19 16:52:28 401a0bf1 kernel: [29856.847755]  
[ack_apic_level+0x71/0x1e0] ? ack_apic_level+0x71/0x1e0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847755]  [<ffffffff810296e1>] ? 
ack_apic_level+0x71/0x1e0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847761]  [call_softirq+0x1c/0x30] 
call_softirq+0x1c/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.847761]  [<ffffffff8135efec>] 
call_softirq+0x1c/0x30
Jan 19 16:52:28 401a0bf1 kernel: [29856.847765]  [do_softirq+0x65/0xa0] 
do_softirq+0x65/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847765]  [<ffffffff8100d815>] 
do_softirq+0x65/0xa0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847768]  [irq_exit+0x8e/0xb0] 
irq_exit+0x8e/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847768]  [<ffffffff8105308e>] 
irq_exit+0x8e/0xb0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847770]  [do_IRQ+0x61/0xe0] 
do_IRQ+0x61/0xe0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847770]  [<ffffffff8100d441>] 
do_IRQ+0x61/0xe0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847773]  [ret_from_intr+0x0/0x15] 
common_interrupt+0x6e/0x6e
Jan 19 16:52:28 401a0bf1 kernel: [29856.847773]  [<ffffffff8135c62e>] 
common_interrupt+0x6e/0x6e
Jan 19 16:52:28 401a0bf1 kernel: [29856.847776]  <EOI> Mem-Info:
Jan 19 16:52:28 401a0bf1 kernel: [29856.847779] DMA per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.847781] CPU    0: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847783] CPU    1: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847785] CPU    2: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847786] CPU    3: hi:    0, btch:   
1 usd:   0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847788] DMA32 per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.847789] CPU    0: hi:  186, btch:  
31 usd: 169
Jan 19 16:52:28 401a0bf1 kernel: [29856.847791] CPU    1: hi:  186, btch:  
31 usd:  38
Jan 19 16:52:28 401a0bf1 kernel: [29856.847793] CPU    2: hi:  186, btch:  
31 usd:  53
Jan 19 16:52:28 401a0bf1 kernel: [29856.847795] CPU    3: hi:  186, btch:  
31 usd: 150
Jan 19 16:52:28 401a0bf1 kernel: [29856.847796] Normal per-cpu:
Jan 19 16:52:28 401a0bf1 kernel: [29856.847798] CPU    0: hi:  186, btch:  
31 usd: 172
Jan 19 16:52:28 401a0bf1 kernel: [29856.847800] CPU    1: hi:  186, btch:  
31 usd:  85
Jan 19 16:52:28 401a0bf1 kernel: [29856.847801] CPU    2: hi:  186, btch:  
31 usd:  20
Jan 19 16:52:28 401a0bf1 kernel: [29856.847804] CPU    3: hi:  186, btch:  
31 usd:  97
Jan 19 16:52:28 401a0bf1 kernel: [29856.847808] active_anon:454825 
inactive_anon:152014 isolated_anon:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847809]  active_file:146979 
inactive_file:142073 isolated_file:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847810]  unevictable:0 dirty:87 
writeback:0 unstable:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847811]  free:11207 
slab_reclaimable:20726 slab_unreclaimable:7860
Jan 19 16:52:28 401a0bf1 kernel: [29856.847812]  mapped:20393 shmem:33840 
pagetables:5174 bounce:0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847818] DMA free:15168kB min:28kB 
low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:0kB 
inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB 
present:15640kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:496kB slab_unreclaimable:152kB kernel_stack:56kB 
pagetables:24kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes
Jan 19 16:52:28 401a0bf1 kernel: [29856.847823] lowmem_reserve[]: 0 2653 
3787 3787
Jan 19 16:52:28 401a0bf1 kernel: [29856.847830] DMA32 free:26764kB 
min:5504kB low:6880kB high:8256kB active_anon:1270664kB 
inactive_anon:420880kB active_file:463632kB inactive_file:447692kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2716812kB 
mlocked:0kB dirty:228kB writeback:0kB mapped:31068kB shmem:105520kB 
slab_reclaimable:45348kB slab_unreclaimable:12672kB kernel_stack:1344kB 
pagetables:9920kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:0 all_unreclaimable? no
Jan 19 16:52:28 401a0bf1 kernel: [29856.847836] lowmem_reserve[]: 0 0 1134 
1134
Jan 19 16:52:28 401a0bf1 kernel: [29856.847843] Normal free:2896kB 
min:2352kB low:2940kB high:3528kB active_anon:548636kB 
inactive_anon:187176kB active_file:124284kB inactive_file:120600kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1161216kB 
mlocked:0kB dirty:120kB writeback:0kB mapped:50504kB shmem:29840kB 
slab_reclaimable:37060kB slab_unreclaimable:18616kB kernel_stack:2472kB 
pagetables:10752kB unstable:0kB bounce:0kB writeback_tmp:0kB 
pages_scanned:240 all_unreclaimable? no
Jan 19 16:52:28 401a0bf1 kernel: [29856.847848] lowmem_reserve[]: 0 0 0 0
Jan 19 16:52:28 401a0bf1 kernel: [29856.847851] DMA: 4*4kB 8*8kB 5*16kB 
7*32kB 1*64kB 1*128kB 1*256kB 0*512kB 2*1024kB 2*2048kB 2*4096kB = 15168kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.847859] DMA32: 6457*4kB 3*8kB 
5*16kB 9*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
26668kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.847866] Normal: 624*4kB 0*8kB 
1*16kB 6*32kB 1*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
2896kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.847873] 334392 total pagecache 
pages
Jan 19 16:52:28 401a0bf1 kernel: [29856.847875] 11509 pages in swap cache
Jan 19 16:52:28 401a0bf1 kernel: [29856.847876] Swap cache stats: add 
105411, delete 93902, find 133781/141475
Jan 19 16:52:28 401a0bf1 kernel: [29856.847878] Free swap  = 6207496kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.847879] Total swap = 6297444kB
Jan 19 16:52:28 401a0bf1 kernel: [29856.863600] 1015792 pages RAM
Jan 19 16:52:28 401a0bf1 kernel: [29856.863603] 56932 pages reserved
Jan 19 16:52:28 401a0bf1 kernel: [29856.863605] 417956 pages shared
Jan 19 16:52:28 401a0bf1 kernel: [29856.863606] 626945 pages non-shared


Jan 20 06:37:41 401a0bf1 kernel: [74665.371038] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 20 06:37:41 401a0bf1 kernel: [74665.371041] Hardware name: N53Jn
Jan 20 06:37:41 401a0bf1 kernel: [74665.371043] Modules linked in: ath9k 
ath5k xhci_hcd omfs jfs xfs exportfs reiserfs ext2 hfs hfsplus vfat fat 
isofs nls_utf8 udf crc_itu_t cryptd aes_x86_64 aes_generic af_packet 
snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev v4l2_compat_ioctl32 
cdc_phonet phonet bsd_comp ppp_deflate ppp_async crc_ccitt ppp_generic 
slhc cdc_acm rtc_cmos configs kvm_intel kvm ide_cd_mod ide_core pktcdvd 
pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill 8139too mii fuse thermal ac tun usb_storage 
usb_libusual cpufreq_conservative speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf fbcon tileblit font bitblit softcursor i915 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd
Jan 20 06:37:41 401a0bf1 kernel:  crc16 sr_mod cdrom ahci libahci xtkbd 
ohci_hcd uhci_hcd ehci_hcd usbhid hid usbcore usb_common btrfs 
zlib_deflate libcrc32c crc32c ext3 jbd mbcache synaptics_i2c i2c_core 
sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod dm_mod 
unix [last unloaded: xhci_hcd]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371186] Pid: 7032, comm: gw6c Not 
tainted 3.2.0 #1
Jan 20 06:37:41 401a0bf1 kernel: [74665.371190] Call Trace:
Jan 20 06:37:41 401a0bf1 kernel: [74665.371201]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371201]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371207]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 20 06:37:41 401a0bf1 kernel: [74665.371207]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 20 06:37:41 401a0bf1 kernel: [74665.371214]  [<ffffffffa06c6769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371223]  [<ffffffffa06c6896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371239]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371239]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371253]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371253]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371260]  [load_balance+0x9e/0x7d0] 
? load_balance+0x9e/0x7d0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371260]  [<ffffffff8104680e>] ? 
load_balance+0x9e/0x7d0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371273]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371273]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371286]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371286]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371299]  
[mac80211:ieee80211_subif_start_xmit+0x36f/0x7e0] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371299]  [<ffffffffa05496bf>] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:41 401a0bf1 kernel: [74665.371308]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:41 401a0bf1 kernel: [74665.371308]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:41 401a0bf1 kernel: [74665.371314]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:41 401a0bf1 kernel: [74665.371314]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:41 401a0bf1 kernel: [74665.371324]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371324]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371329]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371329]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371336]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 20 06:37:41 401a0bf1 kernel: [74665.371336]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 20 06:37:41 401a0bf1 kernel: [74665.371341]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371341]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 20 06:37:41 401a0bf1 kernel: [74665.371346]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 20 06:37:41 401a0bf1 kernel: [74665.371346]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 20 06:37:41 401a0bf1 kernel: [74665.371351]  [ip_send_skb+0x16/0x50] 
ip_send_skb+0x16/0x50
Jan 20 06:37:41 401a0bf1 kernel: [74665.371351]  [<ffffffff812f00d6>] 
ip_send_skb+0x16/0x50
Jan 20 06:37:41 401a0bf1 kernel: [74665.371358]  
[udp_send_skb+0x108/0x380] udp_send_skb+0x108/0x380
Jan 20 06:37:41 401a0bf1 kernel: [74665.371358]  [<ffffffff81311758>] 
udp_send_skb+0x108/0x380
Jan 20 06:37:41 401a0bf1 kernel: [74665.371364]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 20 06:37:41 401a0bf1 kernel: [74665.371364]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.371371]  [pollwake+0x0/0x60] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371371]  [<ffffffff811179f0>] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371377]  
[ip_generic_getfrag+0x0/0xb0] ? ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371377]  [<ffffffff812ed1b0>] ? 
ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371383]  [udp_sendmsg+0x32a/0x910] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.371383]  [<ffffffff813137da>] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.371391]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371391]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371399]  
[kmem_cache_free+0x15/0x90] ? kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371399]  [<ffffffff810fa7b5>] ? 
kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371406]  [sock_sendmsg+0xea/0x120] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371406]  [<ffffffff812a3b8a>] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371415]  
[tun:tun_chr_aio_read+0x79/0xd0] ? tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371415]  [<ffffffffa0450499>] ? 
tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371423]  [do_sync_read+0xda/0x120] 
? do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371423]  [<ffffffff811052da>] ? 
do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371430]  
[lock_hrtimer_base.clone.35+0x2b/0x60] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.371430]  [<ffffffff8106c6fb>] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.371436]  
[sockfd_lookup_light+0x24/0x90] ? sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371436]  [<ffffffff812a2bb4>] ? 
sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371442]  [sys_sendto+0x104/0x140] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371442]  [<ffffffff812a5c54>] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371451]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.371451]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.371456] ---[ end trace 
d38cf8ad260b1371 ]---
Jan 20 06:37:42 401a0bf1 kernel: [74665.371562] ------------[ cut here ]--
----------
Jan 20 06:37:42 401a0bf1 kernel: [74665.371571] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 20 06:37:42 401a0bf1 kernel: [74665.371575] Hardware name: N53Jn
Jan 20 06:37:42 401a0bf1 kernel: [74665.371577] Modules linked in: ath9k 
ath5k xhci_hcd omfs jfs xfs exportfs reiserfs ext2 hfs hfsplus vfat fat 
isofs nls_utf8 udf crc_itu_t cryptd aes_x86_64 aes_generic af_packet 
snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev v4l2_compat_ioctl32 
cdc_phonet phonet bsd_comp ppp_deflate ppp_async crc_ccitt ppp_generic 
slhc cdc_acm rtc_cmos configs kvm_intel kvm ide_cd_mod ide_core pktcdvd 
pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill 8139too mii fuse thermal ac tun usb_storage 
usb_libusual cpufreq_conservative speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf fbcon tileblit font bitblit softcursor i915 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd
Jan 20 06:37:42 401a0bf1 kernel:  crc16 sr_mod cdrom ahci libahci xtkbd 
ohci_hcd uhci_hcd ehci_hcd usbhid hid usbcore usb_common btrfs 
zlib_deflate libcrc32c crc32c ext3 jbd mbcache synaptics_i2c i2c_core 
sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod dm_mod 
unix [last unloaded: xhci_hcd]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371707] Pid: 7032, comm: gw6c 
Tainted: G        W    3.2.0 #1
Jan 20 06:37:42 401a0bf1 kernel: [74665.371709] Call Trace:
Jan 20 06:37:42 401a0bf1 kernel: [74665.371715]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371715]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371721]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.371721]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.371729]  [<ffffffffa06c6769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371737]  [<ffffffffa06c6896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371750]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371750]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371763]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371763]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371771]  [<ffffffffa06bb7b8>] ? 
ath9k_tx+0xa8/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371779]  
[led_trigger_event+0x23/0x80] ? led_trigger_event+0x23/0x80
Jan 20 06:37:42 401a0bf1 kernel: [74665.371779]  [<ffffffff812920e3>] ? 
led_trigger_event+0x23/0x80
Jan 20 06:37:42 401a0bf1 kernel: [74665.371791]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371791]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371804]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371804]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371817]  
[mac80211:ieee80211_subif_start_xmit+0x36f/0x7e0] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371817]  [<ffffffffa05496bf>] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371824]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.371824]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.371829]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.371829]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.371837]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371837]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371842]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371842]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371848]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.371848]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.371854]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371854]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371859]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.371859]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.371864]  [ip_send_skb+0x16/0x50] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.371864]  [<ffffffff812f00d6>] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.371870]  
[udp_send_skb+0x108/0x380] udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.371870]  [<ffffffff81311758>] 
udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.371874]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.371874]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.371879]  [pollwake+0x0/0x60] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371879]  [<ffffffff811179f0>] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371891]  
[ip_generic_getfrag+0x0/0xb0] ? ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371891]  [<ffffffff812ed1b0>] ? 
ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371897]  [udp_sendmsg+0x32a/0x910] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.371897]  [<ffffffff813137da>] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.371904]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371904]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.371910]  
[kmem_cache_free+0x15/0x90] ? kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371910]  [<ffffffff810fa7b5>] ? 
kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371915]  [sock_sendmsg+0xea/0x120] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371915]  [<ffffffff812a3b8a>] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371924]  
[tun:tun_chr_aio_read+0x79/0xd0] ? tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371924]  [<ffffffffa0450499>] ? 
tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.371930]  [do_sync_read+0xda/0x120] 
? do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371930]  [<ffffffff811052da>] ? 
do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.371936]  
[lock_hrtimer_base.clone.35+0x2b/0x60] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.371936]  [<ffffffff8106c6fb>] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.371941]  
[sockfd_lookup_light+0x24/0x90] ? sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371941]  [<ffffffff812a2bb4>] ? 
sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.371945]  [sys_sendto+0x104/0x140] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371945]  [<ffffffff812a5c54>] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.371950]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.371950]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.371954] ---[ end trace 
d38cf8ad260b1372 ]---
Jan 20 06:37:42 401a0bf1 kernel: [74665.372042] ------------[ cut here ]--
----------
Jan 20 06:37:42 401a0bf1 kernel: [74665.372050] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 20 06:37:42 401a0bf1 kernel: [74665.372054] Hardware name: N53Jn
Jan 20 06:37:42 401a0bf1 kernel: [74665.372056] Modules linked in: ath9k 
ath5k xhci_hcd omfs jfs xfs exportfs reiserfs ext2 hfs hfsplus vfat fat 
isofs nls_utf8 udf crc_itu_t cryptd aes_x86_64 aes_generic af_packet 
snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev v4l2_compat_ioctl32 
cdc_phonet phonet bsd_comp ppp_deflate ppp_async crc_ccitt ppp_generic 
slhc cdc_acm rtc_cmos configs kvm_intel kvm ide_cd_mod ide_core pktcdvd 
pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill 8139too mii fuse thermal ac tun usb_storage 
usb_libusual cpufreq_conservative speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf fbcon tileblit font bitblit softcursor i915 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd
Jan 20 06:37:42 401a0bf1 kernel:  crc16 sr_mod cdrom ahci libahci xtkbd 
ohci_hcd uhci_hcd ehci_hcd usbhid hid usbcore usb_common btrfs 
zlib_deflate libcrc32c crc32c ext3 jbd mbcache synaptics_i2c i2c_core 
sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod dm_mod 
unix [last unloaded: xhci_hcd]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372199] Pid: 7032, comm: gw6c 
Tainted: G        W    3.2.0 #1
Jan 20 06:37:42 401a0bf1 kernel: [74665.372202] Call Trace:
Jan 20 06:37:42 401a0bf1 kernel: [74665.372208]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372208]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372213]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.372213]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.372220]  [<ffffffffa06c6769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372228]  [<ffffffffa06c6896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372241]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372241]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372253]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372253]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372260]  [<ffffffffa06bb7b8>] ? 
ath9k_tx+0xa8/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372267]  
[led_trigger_event+0x23/0x80] ? led_trigger_event+0x23/0x80
Jan 20 06:37:42 401a0bf1 kernel: [74665.372267]  [<ffffffff812920e3>] ? 
led_trigger_event+0x23/0x80
Jan 20 06:37:42 401a0bf1 kernel: [74665.372279]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372279]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372290]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372290]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372301]  
[mac80211:ieee80211_subif_start_xmit+0x36f/0x7e0] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372301]  [<ffffffffa05496bf>] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372308]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.372308]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.372314]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.372314]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.372321]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372321]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372326]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372326]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372331]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.372331]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.372336]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372336]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372341]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.372341]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.372346]  [ip_send_skb+0x16/0x50] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.372346]  [<ffffffff812f00d6>] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.372352]  
[udp_send_skb+0x108/0x380] udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.372352]  [<ffffffff81311758>] 
udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.372357]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.372357]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.372362]  [pollwake+0x0/0x60] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372362]  [<ffffffff811179f0>] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372367]  
[ip_generic_getfrag+0x0/0xb0] ? ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.372367]  [<ffffffff812ed1b0>] ? 
ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.372373]  [udp_sendmsg+0x32a/0x910] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.372373]  [<ffffffff813137da>] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.372379]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372379]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.372385]  [sock_sendmsg+0xea/0x120] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.372385]  [<ffffffff812a3b8a>] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.372393]  
[tun:tun_chr_aio_read+0x79/0xd0] ? tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372393]  [<ffffffffa0450499>] ? 
tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.372399]  [do_sync_read+0xda/0x120] 
? do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.372399]  [<ffffffff811052da>] ? 
do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.372405]  
[lock_hrtimer_base.clone.35+0x2b/0x60] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.372405]  [<ffffffff8106c6fb>] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.372411]  
[sockfd_lookup_light+0x24/0x90] ? sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.372411]  [<ffffffff812a2bb4>] ? 
sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.372416]  [sys_sendto+0x104/0x140] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.372416]  [<ffffffff812a5c54>] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.372423]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.372423]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.372427] ---[ end trace 
d38cf8ad260b1373 ]---
Jan 20 06:37:42 401a0bf1 kernel: [74665.379268] ------------[ cut here ]--
----------
Jan 20 06:37:42 401a0bf1 kernel: [74665.379279] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 20 06:37:42 401a0bf1 kernel: [74665.379283] Hardware name: N53Jn
Jan 20 06:37:42 401a0bf1 kernel: [74665.379285] Modules linked in: ath9k 
ath5k xhci_hcd omfs jfs xfs exportfs reiserfs ext2 hfs hfsplus vfat fat 
isofs nls_utf8 udf crc_itu_t cryptd aes_x86_64 aes_generic af_packet 
snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev v4l2_compat_ioctl32 
cdc_phonet phonet bsd_comp ppp_deflate ppp_async crc_ccitt ppp_generic 
slhc cdc_acm rtc_cmos configs kvm_intel kvm ide_cd_mod ide_core pktcdvd 
pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill 8139too mii fuse thermal ac tun usb_storage 
usb_libusual cpufreq_conservative speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf fbcon tileblit font bitblit softcursor i915 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd
Jan 20 06:37:42 401a0bf1 kernel:  crc16 sr_mod cdrom ahci libahci xtkbd 
ohci_hcd uhci_hcd ehci_hcd usbhid hid usbcore usb_common btrfs 
zlib_deflate libcrc32c crc32c ext3 jbd mbcache synaptics_i2c i2c_core 
sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod dm_mod 
unix [last unloaded: xhci_hcd]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379417] Pid: 16970, comm: 
fusesmb.cache Tainted: G        W    3.2.0 #1
Jan 20 06:37:42 401a0bf1 kernel: [74665.379420] Call Trace:
Jan 20 06:37:42 401a0bf1 kernel: [74665.379428]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379428]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379433]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.379433]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.379440]  [<ffffffffa06c6769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379446]  [<ffffffffa06c6896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379460]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379460]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379472]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379472]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379477]  [load_balance+0x9e/0x7d0] 
? load_balance+0x9e/0x7d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379477]  [<ffffffff8104680e>] ? 
load_balance+0x9e/0x7d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379489]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379489]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379500]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379500]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379511]  
[mac80211:ieee80211_subif_start_xmit+0x36f/0x7e0] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379511]  [<ffffffffa05496bf>] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.379518]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.379518]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.379523]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.379523]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.379530]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379530]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379534]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379534]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379540]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.379540]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.379544]  
[ip_mc_output+0x139/0x250] ip_mc_output+0x139/0x250
Jan 20 06:37:42 401a0bf1 kernel: [74665.379544]  [<ffffffff812ef539>] 
ip_mc_output+0x139/0x250
Jan 20 06:37:42 401a0bf1 kernel: [74665.379549]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.379549]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.379553]  [ip_send_skb+0x16/0x50] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.379553]  [<ffffffff812f00d6>] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.379558]  
[udp_send_skb+0x108/0x380] udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.379558]  [<ffffffff81311758>] 
udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.379562]  
[ip_generic_getfrag+0x0/0xb0] ? ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.379562]  [<ffffffff812ed1b0>] ? 
ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.379567]  [udp_sendmsg+0x32a/0x910] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.379567]  [<ffffffff813137da>] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.379574]  
[__alloc_pages_nodemask+0x114/0x6f0] ? __alloc_pages_nodemask+0x114/0x6f0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379574]  [<ffffffff810c5ec4>] ? 
__alloc_pages_nodemask+0x114/0x6f0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379579]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379579]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.379584]  [sock_sendmsg+0xea/0x120] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.379584]  [<ffffffff812a3b8a>] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.379590]  
[handle_pte_fault+0x408/0xa60] ? handle_pte_fault+0x408/0xa60
Jan 20 06:37:42 401a0bf1 kernel: [74665.379590]  [<ffffffff810dc8e8>] ? 
handle_pte_fault+0x408/0xa60
Jan 20 06:37:42 401a0bf1 kernel: [74665.379597]  
[core_sys_select+0x2e7/0x340] ? core_sys_select+0x2e7/0x340
Jan 20 06:37:42 401a0bf1 kernel: [74665.379597]  [<ffffffff811186e7>] ? 
core_sys_select+0x2e7/0x340
Jan 20 06:37:42 401a0bf1 kernel: [74665.379602]  
[handle_mm_fault+0x162/0x260] ? handle_mm_fault+0x162/0x260
Jan 20 06:37:42 401a0bf1 kernel: [74665.379602]  [<ffffffff810de432>] ? 
handle_mm_fault+0x162/0x260
Jan 20 06:37:42 401a0bf1 kernel: [74665.379607]  
[move_addr_to_kernel+0x69/0x70] ? move_addr_to_kernel+0x69/0x70
Jan 20 06:37:42 401a0bf1 kernel: [74665.379607]  [<ffffffff812a5389>] ? 
move_addr_to_kernel+0x69/0x70
Jan 20 06:37:42 401a0bf1 kernel: [74665.379611]  [sys_sendto+0x104/0x140] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.379611]  [<ffffffff812a5c54>] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.379617]  
[poll_select_copy_remaining+0x101/0x150] ? 
poll_select_copy_remaining+0x101/0x150
Jan 20 06:37:42 401a0bf1 kernel: [74665.379617]  [<ffffffff81117b51>] ? 
poll_select_copy_remaining+0x101/0x150
Jan 20 06:37:42 401a0bf1 kernel: [74665.379624]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.379624]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.379628] ---[ end trace 
d38cf8ad260b1374 ]---
Jan 20 06:37:42 401a0bf1 kernel: [74665.471609] ------------[ cut here ]--
----------
Jan 20 06:37:42 401a0bf1 kernel: [74665.471619] WARNING: at 
drivers/net/wireless/ath/ath9k/rc.c:697 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]()
Jan 20 06:37:42 401a0bf1 kernel: [74665.471623] Hardware name: N53Jn
Jan 20 06:37:42 401a0bf1 kernel: [74665.471625] Modules linked in: ath9k 
ath5k xhci_hcd omfs jfs xfs exportfs reiserfs ext2 hfs hfsplus vfat fat 
isofs nls_utf8 udf crc_itu_t cryptd aes_x86_64 aes_generic af_packet 
snd_pcm_oss snd_mixer_oss cls_cgroup uvcvideo videodev v4l2_compat_ioctl32 
cdc_phonet phonet bsd_comp ppp_deflate ppp_async crc_ccitt ppp_generic 
slhc cdc_acm rtc_cmos configs kvm_intel kvm ide_cd_mod ide_core pktcdvd 
pata_atiixp ipip tunnel4 ftdi_sio usbserial arc4 mac80211 ath9k_common 
ath9k_hw ath cfg80211 rfkill 8139too mii fuse thermal ac tun usb_storage 
usb_libusual cpufreq_conservative speedstep_lib cpufreq_powersave 
cpufreq_performance loop ipv6 snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore 
snd_page_alloc battery power_supply coretemp cpufreq_ondemand acpi_cpufreq 
freq_table processor mperf fbcon tileblit font bitblit softcursor i915 
drm_kms_helper drm intel_agp i2c_algo_bit button intel_gtt agpgart video 
thermal_sys hwmon ext4 jbd
Jan 20 06:37:42 401a0bf1 kernel:  crc16 sr_mod cdrom ahci libahci xtkbd 
ohci_hcd uhci_hcd ehci_hcd usbhid hid usbcore usb_common btrfs 
zlib_deflate libcrc32c crc32c ext3 jbd mbcache synaptics_i2c i2c_core 
sermouse psmouse evdev pcips2 sd_mod crc_t10dif libata scsi_mod dm_mod 
unix [last unloaded: xhci_hcd]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471737] Pid: 7032, comm: gw6c 
Tainted: G        W    3.2.0 #1
Jan 20 06:37:42 401a0bf1 kernel: [74665.471739] Call Trace:
Jan 20 06:37:42 401a0bf1 kernel: [74665.471746]  
[warn_slowpath_common+0x7a/0xb0] warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471746]  [<ffffffff8104c9ba>] 
warn_slowpath_common+0x7a/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471751]  
[warn_slowpath_null+0x15/0x20] warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.471751]  [<ffffffff8104ca05>] 
warn_slowpath_null+0x15/0x20
Jan 20 06:37:42 401a0bf1 kernel: [74665.471757]  [<ffffffffa06c6769>] 
ath_rc_get_highest_rix.clone.18+0x159/0x200 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471763]  [<ffffffffa06c6896>] 
ath_get_rate+0x86/0x480 [ath9k]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471774]  
[mac80211:rate_control_get_rate+0x86/0x160] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471774]  [<ffffffffa053ea26>] 
rate_control_get_rate+0x86/0x160 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471785]  
[mac80211:invoke_tx_handlers+0x7fa/0x1170] invoke_tx_handlers+0x7fa/0x1170 
[mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471785]  [<ffffffffa054849a>] 
invoke_tx_handlers+0x7fa/0x1170 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471798]  
[double_rq_lock+0x2f/0x60] ? double_rq_lock+0x2f/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.471798]  [<ffffffff8103f0df>] ? 
double_rq_lock+0x2f/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.471808]  
[mac80211:ieee80211_tx+0x5b/0xb0] ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471808]  [<ffffffffa0548f6b>] 
ieee80211_tx+0x5b/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471818]  
[mac80211:ieee80211_xmit+0x87/0xb0] ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471818]  [<ffffffffa0549047>] 
ieee80211_xmit+0x87/0xb0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471828]  
[mac80211:ieee80211_subif_start_xmit+0x36f/0x7e0] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471828]  [<ffffffffa05496bf>] 
ieee80211_subif_start_xmit+0x36f/0x7e0 [mac80211]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471834]  [kfree_skb+0x19/0x40] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.471834]  [<ffffffff812ac3d9>] ? 
kfree_skb+0x19/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.471838]  
[dev_hard_start_xmit+0x275/0x620] dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.471838]  [<ffffffff812ba605>] 
dev_hard_start_xmit+0x275/0x620
Jan 20 06:37:42 401a0bf1 kernel: [74665.471844]  
[sch_direct_xmit+0xe7/0x1b0] sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471844]  [<ffffffff812d50d7>] 
sch_direct_xmit+0xe7/0x1b0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471848]  
[dev_queue_xmit+0x176/0x5d0] dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471848]  [<ffffffff812bab26>] 
dev_queue_xmit+0x176/0x5d0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471852]  
[ip_finish_output+0x173/0x300] ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.471852]  [<ffffffff812eeba3>] 
ip_finish_output+0x173/0x300
Jan 20 06:37:42 401a0bf1 kernel: [74665.471856]  [ip_output+0x98/0xa0] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471856]  [<ffffffff812ef6e8>] 
ip_output+0x98/0xa0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471860]  [ip_local_out+0x24/0x30] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.471860]  [<ffffffff812eedf4>] 
ip_local_out+0x24/0x30
Jan 20 06:37:42 401a0bf1 kernel: [74665.471864]  [ip_send_skb+0x16/0x50] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.471864]  [<ffffffff812f00d6>] 
ip_send_skb+0x16/0x50
Jan 20 06:37:42 401a0bf1 kernel: [74665.471869]  
[udp_send_skb+0x108/0x380] udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.471869]  [<ffffffff81311758>] 
udp_send_skb+0x108/0x380
Jan 20 06:37:42 401a0bf1 kernel: [74665.471873]  
[ipv4_dst_check+0x39/0x40] ? ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.471873]  [<ffffffff812e6749>] ? 
ipv4_dst_check+0x39/0x40
Jan 20 06:37:42 401a0bf1 kernel: [74665.471878]  [pollwake+0x0/0x60] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471878]  [<ffffffff811179f0>] ? 
__pollwait+0xf0/0xf0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471882]  
[ip_generic_getfrag+0x0/0xb0] ? ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.471882]  [<ffffffff812ed1b0>] ? 
ip_setup_cork+0x140/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.471887]  [udp_sendmsg+0x32a/0x910] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.471887]  [<ffffffff813137da>] 
udp_sendmsg+0x32a/0x910
Jan 20 06:37:42 401a0bf1 kernel: [74665.471892]  [inet_sendmsg+0x5f/0xb0] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471892]  [<ffffffff8131cd7f>] 
inet_sendmsg+0x5f/0xb0
Jan 20 06:37:42 401a0bf1 kernel: [74665.471897]  
[kmem_cache_free+0x15/0x90] ? kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.471897]  [<ffffffff810fa7b5>] ? 
kmem_cache_free+0x15/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.471902]  [sock_sendmsg+0xea/0x120] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.471902]  [<ffffffff812a3b8a>] 
sock_sendmsg+0xea/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.471909]  
[tun:tun_chr_aio_read+0x79/0xd0] ? tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471909]  [<ffffffffa0450499>] ? 
tun_chr_aio_read+0x79/0xd0 [tun]
Jan 20 06:37:42 401a0bf1 kernel: [74665.471914]  [do_sync_read+0xda/0x120] 
? do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.471914]  [<ffffffff811052da>] ? 
do_sync_read+0xda/0x120
Jan 20 06:37:42 401a0bf1 kernel: [74665.471919]  
[lock_hrtimer_base.clone.35+0x2b/0x60] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.471919]  [<ffffffff8106c6fb>] ? 
lock_hrtimer_base.clone.35+0x2b/0x60
Jan 20 06:37:42 401a0bf1 kernel: [74665.471924]  
[sockfd_lookup_light+0x24/0x90] ? sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.471924]  [<ffffffff812a2bb4>] ? 
sockfd_lookup_light+0x24/0x90
Jan 20 06:37:42 401a0bf1 kernel: [74665.471928]  [sys_sendto+0x104/0x140] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.471928]  [<ffffffff812a5c54>] 
sys_sendto+0x104/0x140
Jan 20 06:37:42 401a0bf1 kernel: [74665.471934]  
[system_call_fastpath+0x16/0x1b] system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.471934]  [<ffffffff8135cd92>] 
system_call_fastpath+0x16/0x1b
Jan 20 06:37:42 401a0bf1 kernel: [74665.471937] ---[ end trace 
d38cf8ad260b1375 ]---
Jan 20 06:37:42 401a0bf1 kernel: [74665.570722] ------------[ cut here ]--
----------


