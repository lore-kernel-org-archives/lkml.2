Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0HWG2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:28:01 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.164]:31185 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751327Ab0HWG16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:27:58 -0400
Message-ID: <4C7214DD.30500@superonline.com>
Date: Mon, 23 Aug 2010 09:27:41 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
References: <4C677A49.4030904@superonline.com> <20100820115449.5FF1.A69D9226@jp.fujitsu.com> <20100823091948.6029.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100823091948.6029.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -7.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 23/08/10 03:22 AM, KOSAKI Motohiro wrote:
> 
> sorry, my last mail has some mistake.
> 

No problem. I did the tests again according to your new instructions,
and I am appending the results.

Regards,

M. Vefa Bicakci

> 1. Please let me know your machine & test script
>

% ./your-fills-up-the-tmpfs-script   (i.e. run your script)

> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1258780 kB
Buffers:           30820 kB
Cached:          1693836 kB
SwapCached:            0 kB
Active:          1670344 kB
Inactive:         137960 kB
Active(anon):    1633940 kB
Inactive(anon):    26224 kB
Active(file):      36404 kB
Inactive(file):   111736 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         437684 kB
LowTotal:         877852 kB
LowFree:          821096 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                28 kB
Writeback:             0 kB
AnonPages:         83676 kB
Mapped:            44220 kB
Shmem:           1576520 kB
Slab:              17136 kB
SReclaimable:       9480 kB
SUnreclaim:         7656 kB
KernelStack:        1832 kB
PageTables:         2440 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1892636 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      92764 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       24568 kB
DirectMap4M:      884736 kB


> % cat /proc/vmstat

nr_free_pages 314850
nr_inactive_anon 6480
nr_active_anon 408485
nr_inactive_file 27935
nr_active_file 9101
nr_unevictable 8
nr_mlock 8
nr_anon_pages 20919
nr_mapped 11055
nr_file_pages 431089
nr_dirty 8
nr_writeback 0
nr_slab_reclaimable 2370
nr_slab_unreclaimable 1914
nr_page_table_pages 610
nr_kernel_stack 229
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 394054
pgpgin 150719
pgpgout 5312
pswpin 0
pswpout 0
pgalloc_dma 2
pgalloc_normal 116354
pgalloc_high 2637682
pgalloc_movable 0
pgfree 3069531
pgactivate 2339016
pgdeactivate 160
pgfault 699155
pgmajfault 1082
pgrefill_dma 0
pgrefill_normal 0
pgrefill_high 160
pgrefill_movable 0
pgsteal_dma 0
pgsteal_normal 0
pgsteal_high 29
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 0
pgscan_direct_high 32
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 0
kswapd_steal 0
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
kswapd_skip_congestion_wait 0
pageoutrun 0
allocstall 1
pgrotated 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 7832
unevictable_pgs_scanned 0
unevictable_pgs_rescued 7046
unevictable_pgs_mlocked 8562
unevictable_pgs_munlocked 8554
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

> % cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     2614
        min      16
        low      20
        high     24
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 2614
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 865, 3022, 3022)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     202722
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 202722
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5792
    nr_active_file 1970
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7761
    nr_dirty     7
    nr_writeback 0
    nr_slab_reclaimable 2370
    nr_slab_unreclaimable 1912
    nr_page_table_pages 0
    nr_kernel_stack 229
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 0, 17259, 17259)
  pagesets
    cpu: 0
              count: 155
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 173
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 272
 recent_file_scanned: 1385
 anon_ratio:          7
Node 0, zone  HighMem
  pages free     109607
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 109607
    nr_inactive_anon 6482
    nr_active_anon 408478
    nr_inactive_file 22146
    nr_active_file 7131
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20919
    nr_mapped    11054
    nr_file_pages 423333
    nr_dirty     2
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 610
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     394056
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 107
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 129
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 1259857
 recent_anon_scanned: 2522124
 recent_file_rotated: 1269
 recent_file_scanned: 5591
 anon_ratio:          16

> % df

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda15            10317828   7309436   2484276  75% /
tmpfs                  1552240         8   1552232   1% /lib/init/rw
udev                   1549148       220   1548928   1% /dev
tmpfs                  1552240         4   1552236   1% /dev/shm
tmpfs                  1552240   1552240         0 100% /tmp

> % cat your-fills-up-the-tmpfs-script

#!/bin/bash

rm -vf /tmp/tmp
dd if=/dev/zero of=/tmp/tmp bs=1024k count=1600
shred -vn1 /tmp/tmp

exit 0 ### removed when testing hibernation

read -p "Press enter to hibernate..."

echo -n reboot > /sys/power/disk
echo -n disk > /sys/power/state

echo "Exit code: $?"

rm -vf /tmp/tmp


>
> 2. call shrink_all_memory() forcely and show result
>

% ./your-fills-up-the-tmpfs-script

> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1259400 kB
Buffers:           30836 kB
Cached:          1693572 kB
SwapCached:            0 kB
Active:          1670356 kB
Inactive:         137708 kB
Active(anon):    1633948 kB
Inactive(anon):    25944 kB
Active(file):      36408 kB
Inactive(file):   111764 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         438056 kB
LowTotal:         877852 kB
LowFree:          821344 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                36 kB
Writeback:             0 kB
AnonPages:         83684 kB
Mapped:            44236 kB
Shmem:           1576240 kB
Slab:              17136 kB
SReclaimable:       9480 kB
SUnreclaim:         7656 kB
KernelStack:        1832 kB
PageTables:         2440 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1892412 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      92764 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       24568 kB
DirectMap4M:      884736 kB

> % cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     2614
        min      16
        low      20
        high     24
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 2614
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 865, 3022, 3022)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     202691
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 202691
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5796
    nr_active_file 1970
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7765
    nr_dirty     7
    nr_writeback 0
    nr_slab_reclaimable 2370
    nr_slab_unreclaimable 1912
    nr_page_table_pages 0
    nr_kernel_stack 229
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 0, 17259, 17259)
  pagesets
    cpu: 0
              count: 161
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 170
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 272
 recent_file_scanned: 1389
 anon_ratio:          7
Node 0, zone  HighMem
  pages free     109514
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 109514
    nr_inactive_anon 6484
    nr_active_anon 408487
    nr_inactive_file 22148
    nr_active_file 7132
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20921
    nr_mapped    11058
    nr_file_pages 423338
    nr_dirty     3
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 610
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     394058
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 167
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 156
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 1650360
 recent_anon_scanned: 3304957
 recent_file_rotated: 1270
 recent_file_scanned: 5595
 anon_ratio:          16

> # echo 1 > /proc/sys/vm/shrink_all_memory

> # tail /var/log/messages

[  439.165652] shrink_all_memory start
[  439.165960] shrink_all_memory: req:1 reclaimed:32 free:313765

> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1259516 kB
Buffers:           30852 kB
Cached:          1693672 kB
SwapCached:            0 kB
Active:          1669728 kB
Inactive:         138456 kB
Active(anon):    1633320 kB
Inactive(anon):    26800 kB
Active(file):      36408 kB
Inactive(file):   111656 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         438180 kB
LowTotal:         877852 kB
LowFree:          821336 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                40 kB
Writeback:             0 kB
AnonPages:         83696 kB
Mapped:            44236 kB
Shmem:           1576460 kB
Slab:              17140 kB
SReclaimable:       9484 kB
SUnreclaim:         7656 kB
KernelStack:        1840 kB
PageTables:         2440 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1892540 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      92764 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       24568 kB
DirectMap4M:      884736 kB

> % cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     2614
        min      16
        low      20
        high     24
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 2614
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 865, 3022, 3022)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     202720
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 202720
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5798
    nr_active_file 1970
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7767
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 2371
    nr_slab_unreclaimable 1912
    nr_page_table_pages 0
    nr_kernel_stack 230
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 0, 17259, 17259)
  pagesets
    cpu: 0
              count: 139
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 165
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 272
 recent_file_scanned: 1391
 anon_ratio:          7
Node 0, zone  HighMem
  pages free     109576
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 109576
    nr_inactive_anon 6642
    nr_active_anon 408330
    nr_inactive_file 22118
    nr_active_file 7132
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20924
    nr_mapped    11058
    nr_file_pages 423306
    nr_dirty     3
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 610
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     394056
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 158
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 133
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 103467
 recent_anon_scanned: 207085
 recent_file_rotated: 1270
 recent_file_scanned: 5629
 anon_ratio:          16

> 3. reset zone_reclaim_stat and rerun shrink_all_memory
>

% ./your-fills-up-the-tmpfs-script

> # echo 1 > /proc/sys/vm/reset_reclaim_stat
> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1260012 kB
Buffers:           30884 kB
Cached:          1693496 kB
SwapCached:            0 kB
Active:          1669736 kB
Inactive:         138316 kB
Active(anon):    1633324 kB
Inactive(anon):    26616 kB
Active(file):      36412 kB
Inactive(file):   111700 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         438304 kB
LowTotal:         877852 kB
LowFree:          821708 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                12 kB
Writeback:             0 kB
AnonPages:         83700 kB
Mapped:            44240 kB
Shmem:           1576272 kB
Slab:              17140 kB
SReclaimable:       9484 kB
SUnreclaim:         7656 kB
KernelStack:        1840 kB
PageTables:         2440 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1892440 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      92764 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       24568 kB
DirectMap4M:      884736 kB

> % cat /proc/zoneinfo


Node 0, zone      DMA
  pages free     2614
        min      16
        low      20
        high     24
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 2614
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 865, 3022, 3022)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     202844
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 202844
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5808
    nr_active_file 1970
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7777
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 2371
    nr_slab_unreclaimable 1912
    nr_page_table_pages 0
    nr_kernel_stack 230
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 0, 17259, 17259)
  pagesets
    cpu: 0
              count: 153
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 39
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 2
 anon_ratio:          12
Node 0, zone  HighMem
  pages free     109607
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 109607
    nr_inactive_anon 6638
    nr_active_anon 408331
    nr_inactive_file 22120
    nr_active_file 7133
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20925
    nr_mapped    11057
    nr_file_pages 423305
    nr_dirty     1
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 610
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     394052
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 157
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 94
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 896
 recent_anon_scanned: 1078
 recent_file_rotated: 0
 recent_file_scanned: 1
 anon_ratio:          20

> # echo 1 > /proc/sys/vm/shrink_all_memory
> # tail /var/log/messages

[  504.609297] shrink_all_memory start
[  504.609537] shrink_all_memory: req:1 reclaimed:31 free:315005

> % cat /proc/meminfo


MemTotal:        3104484 kB
MemFree:         1255796 kB
Buffers:           30788 kB
Cached:          1697944 kB
SwapCached:            0 kB
Active:          1669480 kB
Inactive:         143044 kB
Active(anon):    1633064 kB
Inactive(anon):    31432 kB
Active(file):      36416 kB
Inactive(file):   111612 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         433964 kB
LowTotal:         877852 kB
LowFree:          821832 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                40 kB
Writeback:             0 kB
AnonPages:         83852 kB
Mapped:            44220 kB
Shmem:           1580704 kB
Slab:              17140 kB
SReclaimable:       9484 kB
SUnreclaim:         7656 kB
KernelStack:        1840 kB
PageTables:         2440 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1896832 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      92764 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       24568 kB
DirectMap4M:      884736 kB

> % cat /proc/zoneinfo

Node 0, zone      DMA
  pages free     2614
        min      16
        low      20
        high     24
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 2614
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 865, 3022, 3022)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     202844
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 202844
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5778
    nr_active_file 1971
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7749
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 2371
    nr_slab_unreclaimable 1912
    nr_page_table_pages 0
    nr_kernel_stack 230
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
        protection: (0, 0, 17259, 17259)
  pagesets
    cpu: 0
              count: 102
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 63
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 1
 recent_file_scanned: 38
 anon_ratio:          2
Node 0, zone  HighMem
  pages free     109545
        min      128
        low      709
        high     1290
        scanned  96
        spanned  556658
        present  552309
    nr_free_pages 109545
    nr_inactive_anon 6797
    nr_active_anon 408235
    nr_inactive_file 22122
    nr_active_file 7133
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20925
    nr_mapped    11054
    nr_file_pages 423370
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 610
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     394115
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 137
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 119
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 1358
 recent_anon_scanned: 1730
 recent_file_rotated: 0
 recent_file_scanned: 3
 anon_ratio:          11

