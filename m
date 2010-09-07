Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0IGBfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 21:35:08 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.168]:35050 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755502Ab0IGBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 21:35:03 -0400
Message-ID: <4C8596B1.6010005@superonline.com>
Date: Mon, 06 Sep 2010 21:34:41 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Important news regarding the two different patches
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <20100906090528.C8A9.A69D9226@jp.fujitsu.com> <4C84D02A.7070508@superonline.com> <201009062043.37819.rjw@sisk.pl>
In-Reply-To: <201009062043.37819.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -26.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/10 02:43 PM, Rafael J. Wysocki wrote:
> On Monday, September 06, 2010, M. Vefa Bicakci wrote:
>> [snip]
>>
>> Patch 1:
>> 	http://lkml.org/lkml/2010/9/5/86
>>
>> Patch 2:
>> 	http://kerneltrap.org/mailarchive/linux-kernel/2010/9/4/4615426
>>
>> The first of these was prepared by Minchan Kim, and it fixes
>> the issue; i.e. no hangs during hibernation with a full tmpfs.
> 
> We've already agreed that this patch should be applied.
> 
>> However, the second patch, prepared by Rafael Wysocki, does *not*
>> fix the problem. I still experience hangs with a full tmpfs upon
>> hibernation.
> 
> So we still manage to trigger OOM with this approach.
> 
>> As always, I am willing to test newer patches and help in debugging
>> this issue.
> 
> What happens if you apply them both at the same time?

Hello,

When I apply both of the patches, then I don't get any hangs with
hibernation. However, I do get another problem, which I am not sure
is related or not. I should note that I haven't experienced this
with only the vmscan.c patch, but maybe I haven't repeated my test
enough times.

One test consists of an automated run of 7 hibernate/thaw cycles. 

Here's what I got in dmesg in two of the iterations in one test.
Sorry for the long e-mail and the long lines.

=== 8< ===
[  166.512085] PM: Hibernation mode set to 'reboot'
[  166.516503] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  166.517654] PM: Basic memory bitmaps created
[  166.518781] PM: Syncing filesystems ... done.
[  166.546308] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  166.559596] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  166.571649] PM: Preallocating image memory... 
[  185.712457] iwl3945: page allocation failure. order:0, mode:0xd0
[  185.714564] Pid: 1225, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
[  185.715741] Call Trace:
[  185.716853]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
[  185.718126]  [<f8a562c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
[  185.719379]  [<c03f0516>] ? schedule+0x356/0x730
[  185.720556]  [<f8a56d50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
[  185.721914]  [<f8a56dbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
[  185.723929]  [<c014b167>] ? worker_thread+0x117/0x1f0
[  185.725745]  [<f8a56d80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
[  185.727097]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
[  185.728468]  [<c014b050>] ? worker_thread+0x0/0x1f0
[  185.730235]  [<c014e854>] ? kthread+0x74/0x80
[  185.731601]  [<c014e7e0>] ? kthread+0x0/0x80
[  185.732919]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
[  185.734851] Mem-Info:
[  185.736144] DMA per-cpu:
[  185.737439] CPU    0: hi:    0, btch:   1 usd:   0
[  185.738635] CPU    1: hi:    0, btch:   1 usd:   0
[  185.740296] Normal per-cpu:
[  185.741560] CPU    0: hi:  186, btch:  31 usd: 173
[  185.742752] CPU    1: hi:  186, btch:  31 usd:  49
[  185.744092] HighMem per-cpu:
[  185.745897] CPU    0: hi:  186, btch:  31 usd: 159
[  185.747239] CPU    1: hi:  186, btch:  31 usd: 170
[  185.748547] active_anon:136410 inactive_anon:34149 isolated_anon:0
[  185.748549]  active_file:689 inactive_file:344 isolated_file:0
[  185.748550]  unevictable:0 dirty:0 writeback:392 unstable:0
[  185.748551]  free:1928 slab_reclaimable:933 slab_unreclaimable:1680
[  185.748552]  mapped:952 shmem:168120 pagetables:304 bounce:0
[  185.755444] DMA free:3516kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  185.759708] lowmem_reserve[]: 0 865 3022 3022
[  185.761135] Normal free:3444kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:52kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:3732kB slab_unreclaimable:6712kB kernel_stack:1480kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:96 all_unreclaimable? no
[  185.765935] lowmem_reserve[]: 0 0 17259 17259
[  185.767626] HighMem free:628kB min:512kB low:2836kB high:5160kB active_anon:545256kB inactive_anon:136444kB active_file:2704kB inactive_file:1376kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2209236kB mlocked:0kB dirty:0kB writeback:1416kB mapped:3804kB shmem:671948kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:1216kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[  185.773232] lowmem_reserve[]: 0 0 0 0
[  185.775142] DMA: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3516kB
[  185.777152] Normal: 1*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3444kB
[  185.779420] HighMem: 151*4kB 14*8kB 6*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 876kB
[  185.781487] 170219 total pagecache pages
[  185.783662] 1273 pages in swap cache
[  185.785764] Swap cache stats: add 295103, delete 293899, find 177724/191474
[  185.787782] Free swap  = 8072684kB
[  185.789940] Total swap = 8385376kB
[  185.802225] 783968 pages RAM
[  185.804258] 556658 pages HighMem
[  185.806241] 7853 pages reserved
[  185.808263] 14784 pages shared
[  185.810237] 764178 pages non-shared
[  185.812216] iwl3945 0000:05:00.0: Failed to allocate SKB buffer with GFP_KERNEL. Only 5 free buffers remaining.
[  185.871861] iwl3945: page allocation failure. order:0, mode:0xd0
[  185.873847] Pid: 1225, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
[  185.876345] Call Trace:
[  185.878416]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
[  185.880493]  [<f8a562c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
[  185.882558]  [<f8a56d50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
[  185.884651]  [<f8a56dbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
[  185.886753]  [<c014b167>] ? worker_thread+0x117/0x1f0
[  185.888831]  [<f8a56d80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
[  185.890856]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
[  185.892984]  [<c014b050>] ? worker_thread+0x0/0x1f0
[  185.895116]  [<c014e854>] ? kthread+0x74/0x80
[  185.897249]  [<c014e7e0>] ? kthread+0x0/0x80
[  185.899367]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
[  185.901465] Mem-Info:
[  185.903580] DMA per-cpu:
[  185.905697] CPU    0: hi:    0, btch:   1 usd:   0
[  185.907801] CPU    1: hi:    0, btch:   1 usd:   0
[  185.909915] Normal per-cpu:
[  185.912014] CPU    0: hi:  186, btch:  31 usd: 184
[  185.914144] CPU    1: hi:  186, btch:  31 usd:  71
[  185.916228] HighMem per-cpu:
[  185.918285] CPU    0: hi:  186, btch:  31 usd: 164
[  185.920370] CPU    1: hi:  186, btch:  31 usd: 156
[  185.922390] active_anon:134202 inactive_anon:33609 isolated_anon:0
[  185.922391]  active_file:689 inactive_file:344 isolated_file:0
[  185.922393]  unevictable:0 dirty:0 writeback:409 unstable:0
[  185.922394]  free:1897 slab_reclaimable:933 slab_unreclaimable:1678
[  185.922395]  mapped:952 shmem:165367 pagetables:304 bounce:0
[  185.931250] DMA free:3516kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  185.936496] lowmem_reserve[]: 0 865 3022 3022
[  185.938184] Normal free:3568kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:52kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:3732kB slab_unreclaimable:6772kB kernel_stack:1480kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  185.943403] lowmem_reserve[]: 0 0 17259 17259
[  185.945089] HighMem free:1000kB min:512kB low:2836kB high:5160kB active_anon:536552kB inactive_anon:134300kB active_file:2704kB inactive_file:1376kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2209236kB mlocked:0kB dirty:0kB writeback:1620kB mapped:3804kB shmem:660876kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:1216kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  185.950324] lowmem_reserve[]: 0 0 0 0
[  185.952105] DMA: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3516kB
[  185.953979] Normal: 20*4kB 4*8kB 2*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3568kB
[  185.955929] HighMem: 176*4kB 23*8kB 3*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1000kB
[  185.957877] 167673 total pagecache pages
[  185.959787] 1391 pages in swap cache
[  185.961686] Swap cache stats: add 297661, delete 296270, find 177724/191474
[  185.963640] Free swap  = 8062924kB
[  185.965591] Total swap = 8385376kB
[  185.975363] 783968 pages RAM
[  185.977245] 556658 pages HighMem
[  185.979082] 7853 pages reserved
[  185.980889] 14760 pages shared
[  185.982676] 764093 pages non-shared
[  185.984478] iwl3945 0000:05:00.0: Failed to allocate SKB buffer with GFP_KERNEL. Only 4 free buffers remaining.
...
...
[  245.712056] usb usb3: __pm_runtime_suspend() from workqueue!
[  245.712088] usb usb3: __pm_runtime_suspend() returns 0!
[  245.712093] usb usb5: __pm_runtime_suspend() from workqueue!
[  245.712114] usb usb5: __pm_runtime_suspend() returns 0!
[  245.712119] usb usb1: __pm_runtime_suspend() from workqueue!
[  245.712165] usb usb1: __pm_runtime_suspend() returns 0!
[  265.583404] PM: Hibernation mode set to 'reboot'
[  265.584286] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  265.584291] PM: Basic memory bitmaps created
[  265.584292] PM: Syncing filesystems ... done.
[  265.630328] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  265.644327] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  265.657301] PM: Preallocating image memory... 
[  277.545121] iwl3945: page allocation failure. order:0, mode:0xd0
[  277.547985] Pid: 1144, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
[  277.547988] Call Trace:
[  277.548001]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
[  277.548015]  [<f897d2c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
[  277.548019]  [<c03f0516>] ? schedule+0x356/0x730
[  277.548024]  [<f897dd50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
[  277.548029]  [<f897ddbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
[  277.548033]  [<c014b167>] ? worker_thread+0x117/0x1f0
[  277.548038]  [<f897dd80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
[  277.548042]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
[  277.548045]  [<c014b050>] ? worker_thread+0x0/0x1f0
[  277.548048]  [<c014e854>] ? kthread+0x74/0x80
[  277.548050]  [<c014e7e0>] ? kthread+0x0/0x80
[  277.548054]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
[  277.548056] Mem-Info:
[  277.548059] DMA per-cpu:
[  277.548061] CPU    0: hi:    0, btch:   1 usd:   0
[  277.548063] CPU    1: hi:    0, btch:   1 usd:   0
[  277.548065] Normal per-cpu:
[  277.548067] CPU    0: hi:  186, btch:  31 usd: 158
[  277.548069] CPU    1: hi:  186, btch:  31 usd:  81
[  277.548070] HighMem per-cpu:
[  277.548072] CPU    0: hi:  186, btch:  31 usd: 194
[  277.548074] CPU    1: hi:  186, btch:  31 usd: 185
[  277.548079] active_anon:132061 inactive_anon:33051 isolated_anon:0
[  277.548080]  active_file:890 inactive_file:320 isolated_file:0
[  277.548081]  unevictable:0 dirty:0 writeback:282 unstable:0
[  277.548082]  free:1884 slab_reclaimable:880 slab_unreclaimable:1633
[  277.548084]  mapped:991 shmem:164563 pagetables:306 bounce:0
[  277.548090] DMA free:3520kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  277.548094] lowmem_reserve[]: 0 865 3022 3022
[  277.548102] Normal free:3608kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:76kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:3520kB slab_unreclaimable:6524kB kernel_stack:1480kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:122 all_unreclaimable? no
[  277.548106] lowmem_reserve[]: 0 0 17259 17259
[  277.548114] HighMem free:408kB min:512kB low:2836kB high:5160kB active_anon:528244kB inactive_anon:132204kB active_file:3560kB inactive_file:1204kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2209236kB mlocked:0kB dirty:0kB writeback:1128kB mapped:3960kB shmem:658252kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:1224kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4384 all_unreclaimable? no
[  277.548118] lowmem_reserve[]: 0 0 0 0
[  277.548121] DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
[  277.548129] Normal: 0*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3608kB
[  277.548136] HighMem: 100*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 408kB
[  277.548143] 166232 total pagecache pages
[  277.548145] 460 pages in swap cache
[  277.548147] Swap cache stats: add 947081, delete 946621, find 437341/491917
[  277.548148] Free swap  = 2665828kB
[  277.548150] Total swap = 2996084kB
[  277.560847] 783968 pages RAM
[  277.560849] 556658 pages HighMem
[  277.560851] 7853 pages reserved
[  277.560852] 14928 pages shared
[  277.560854] 764721 pages non-shared
[  277.560860] iwl3945 0000:05:00.0: Failed to allocate SKB buffer with GFP_KERNEL. Only 8 free buffers remaining.
[  277.560897] iwl3945: page allocation failure. order:0, mode:0xd0
[  277.560901] Pid: 1144, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
[  277.560903] Call Trace:
[  277.560912]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
[  277.560925]  [<f897d2c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
[  277.560930]  [<c014b815>] ? __queue_work+0x25/0x40
[  277.560933]  [<c014b908>] ? queue_work_on+0x38/0x60
[  277.560937]  [<f897dd50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
[  277.560942]  [<f897ddbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
[  277.560945]  [<c014b167>] ? worker_thread+0x117/0x1f0
[  277.560949]  [<f897dd80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
[  277.560953]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
[  277.560956]  [<c014b050>] ? worker_thread+0x0/0x1f0
[  277.560959]  [<c014e854>] ? kthread+0x74/0x80
[  277.560962]  [<c014e7e0>] ? kthread+0x0/0x80
[  277.560966]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
[  277.560968] Mem-Info:
[  277.560970] DMA per-cpu:
[  277.560972] CPU    0: hi:    0, btch:   1 usd:   0
[  277.560975] CPU    1: hi:    0, btch:   1 usd:   0
[  277.560976] Normal per-cpu:
[  277.560978] CPU    0: hi:  186, btch:  31 usd: 159
[  277.560980] CPU    1: hi:  186, btch:  31 usd:  81
[  277.560982] HighMem per-cpu:
[  277.560984] CPU    0: hi:  186, btch:  31 usd: 194
[  277.560986] CPU    1: hi:  186, btch:  31 usd: 185
[  277.560991] active_anon:132061 inactive_anon:33051 isolated_anon:0
[  277.560992]  active_file:890 inactive_file:320 isolated_file:0
[  277.560994]  unevictable:0 dirty:0 writeback:168 unstable:0
[  277.560995]  free:1884 slab_reclaimable:880 slab_unreclaimable:1633
[  277.560996]  mapped:991 shmem:164563 pagetables:306 bounce:0
[  277.561003] DMA free:3520kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[  277.561007] lowmem_reserve[]: 0 865 3022 3022
[  277.561014] Normal free:3608kB min:3728kB low:4660kB high:5592kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:76kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:0kB slab_reclaimable:3520kB slab_unreclaimable:6524kB kernel_stack:1480kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:122 all_unreclaimable? no
[  277.561019] lowmem_reserve[]: 0 0 17259 17259
[  277.561027] HighMem free:408kB min:512kB low:2836kB high:5160kB active_anon:528244kB inactive_anon:132204kB active_file:3560kB inactive_file:1204kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2209236kB mlocked:0kB dirty:0kB writeback:672kB mapped:3960kB shmem:658252kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:1224kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:4384 all_unreclaimable? no
[  277.561031] lowmem_reserve[]: 0 0 0 0
[  277.561034] DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
[  277.561042] Normal: 0*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3608kB
[  277.561049] HighMem: 100*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 408kB
[  277.561057] 166232 total pagecache pages
[  277.561059] 460 pages in swap cache
[  277.561061] Swap cache stats: add 947081, delete 946621, find 437341/491917
[  277.561063] Free swap  = 2665828kB
[  277.561065] Total swap = 2996084kB
[  277.573331] 783968 pages RAM
[  277.573333] 556658 pages HighMem
[  277.573334] 7853 pages reserved
[  277.573335] 14928 pages shared
[  277.573336] 764720 pages non-shared
[  277.573341] iwl3945 0000:05:00.0: Failed to allocate SKB buffer with GFP_KERNEL. Only 8 free buffers remaining.
=== >8 ===

