Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0HVQ3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 12:29:04 -0400
Received: from t03.superonline.com ([92.45.6.174]:5464 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751856Ab0HVQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 12:28:55 -0400
Message-ID: <4C715027.9060602@superonline.com>
Date: Sun, 22 Aug 2010 19:28:23 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
References: <4C677A49.4030904@superonline.com> <20100820115449.5FF1.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100820115449.5FF1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> I've tested hibernation case for a while. but I have no luck. I couldn't
> reproduce your issue. Very sorry. Can you please help our debugging? 
> If possible, I hope to run following three test.

First of all, thanks a lot for spending time on this regression
I have been experiencing. I really appreciate it.

Sorry to hear that you weren't able to reproduce the issue. Well the
good (or bad?) news is that I am able to reproduce it with 2.6.35.3
with your patches applied.

I should note that after applying your patches and trying a hibernation
with a full tmpfs, a printk prints extra information on the screen just
before the hibernation process hangs. The last time I ran it, it printed:

=== 8< ===
shrink_all_memory: req: 342067 reclaimed: 27062 free: 340221
=== >8 ===

A piece of information that may be relevant or irrelevant is that my
swap space is on a dm-crypt volume.

Appended are the results of the tests you asked me to carry out.
If you'd like, I can send in private a tarball containing this
information in separate files.

Once again, thanks a lot for helping out.

M. Vefa Bicakci

> 
> 1. Please let me know your machine & test script

Please note that I filled up the tmpfs filesystem between step 1
and step 2.

> 
> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         2817616 kB
Buffers:           31156 kB
Cached:           142124 kB
SwapCached:            0 kB
Active:           116464 kB
Inactive:         137424 kB
Active(anon):      80852 kB
Inactive(anon):    24820 kB
Active(file):      35612 kB
Inactive(file):   112604 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:        1994008 kB
LowTotal:         877852 kB
LowFree:          823608 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:               116 kB
Writeback:             0 kB
AnonPages:         80636 kB
Mapped:            43768 kB
Shmem:             25068 kB
Slab:              15120 kB
SReclaimable:       7516 kB
SUnreclaim:         7604 kB
KernelStack:        1856 kB
PageTables:         2420 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:     337784 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      94312 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB


> % cat /proc/vmstat

nr_free_pages 704435
nr_inactive_anon 6199
nr_active_anon 20213
nr_inactive_file 28153
nr_active_file 8904
nr_unevictable 8
nr_mlock 8
nr_anon_pages 20159
nr_mapped 10943
nr_file_pages 43317
nr_dirty 2
nr_writeback 0
nr_slab_reclaimable 1879
nr_slab_unreclaimable 1900
nr_page_table_pages 605
nr_kernel_stack 232
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 6261
pgpgin 150947
pgpgout 3984
pswpin 0
pswpout 0
pgalloc_dma 2
pgalloc_normal 55622
pgalloc_high 219709
pgalloc_movable 0
pgfree 980252
pgactivate 12703
pgdeactivate 0
pgfault 584903
pgmajfault 1077
pgrefill_dma 0
pgrefill_normal 0
pgrefill_high 0
pgrefill_movable 0
pgsteal_dma 0
pgsteal_normal 0
pgsteal_high 0
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 0
pgscan_direct_high 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 0
kswapd_steal 0
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 0
kswapd_high_wmark_hit_quickly 0
kswapd_skip_congestion_wait 0
pageoutrun 0
allocstall 0
pgrotated 0
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 7828
unevictable_pgs_scanned 0
unevictable_pgs_rescued 7042
unevictable_pgs_mlocked 8558
unevictable_pgs_munlocked 8550
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
  prev_priority:     12
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     203226
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 203226
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 5727
    nr_active_file 2143
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 7869
    nr_dirty     9
    nr_writeback 0
    nr_slab_reclaimable 1880
    nr_slab_unreclaimable 1898
    nr_page_table_pages 0
    nr_kernel_stack 232
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
              count: 127
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 61
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 2330
 recent_file_scanned: 11064
 anon_ratio:          8
Node 0, zone  HighMem
  pages free     498378
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 498378
    nr_inactive_anon 6283
    nr_active_anon 20225
    nr_inactive_file 22446
    nr_active_file 6830
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20171
    nr_mapped    10962
    nr_file_pages 35621
    nr_dirty     1
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 605
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     6345
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 155
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 154
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 140735
 recent_anon_scanned: 188078
 recent_file_rotated: 9673
 recent_file_scanned: 43796
 anon_ratio:          11

> % df

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda15            10317828   7308360   2485352  75% /
tmpfs                  1552240         8   1552232   1% /lib/init/rw
udev                   1549148       220   1548928   1% /dev
tmpfs                  1552240         4   1552236   1% /dev/shm
tmpfs                  1552240        32   1552208   1% /tmp

> % cat your-fills-up-the-tmpfs-script

#!/bin/bash

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

> # ./script.sh # Fill up the tmpfs

> % df # My extra step (I modified the script to fill only 1400MB.)

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda15            10317828   7308408   2485304  75% /
tmpfs                  1552240         8   1552232   1% /lib/init/rw
udev                   1549148       220   1548928   1% /dev
tmpfs                  1552240         4   1552236   1% /dev/shm
tmpfs                  1552240   1435036    117204  93% /tmp

> 
> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1339564 kB
Buffers:           42824 kB
Cached:          1595432 kB
SwapCached:            0 kB
Active:          1557540 kB
Inactive:         161944 kB
Active(anon):    1515072 kB
Inactive(anon):    25144 kB
Active(file):      42468 kB
Inactive(file):   136800 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         538992 kB
LowTotal:         877852 kB
LowFree:          800572 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                20 kB
Writeback:             0 kB
AnonPages:         81256 kB
Mapped:            44032 kB
Shmem:           1458992 kB
Slab:              26312 kB
SReclaimable:      18632 kB
SUnreclaim:         7680 kB
KernelStack:        1816 kB
PageTables:         2424 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1772060 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      94312 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB

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
  prev_priority:     12
  start_pfn:         16
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 0
 recent_file_scanned: 0
 anon_ratio:          30
Node 0, zone   Normal
  pages free     197498
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 197498
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 7293
    nr_active_file 3466
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 10758
    nr_dirty     4
    nr_writeback 0
    nr_slab_reclaimable 4658
    nr_slab_unreclaimable 1918
    nr_page_table_pages 0
    nr_kernel_stack 227
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
              count: 157
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 81
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 3652
 recent_file_scanned: 15280
 anon_ratio:          9
Node 0, zone  HighMem
  pages free     134717
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 134717
    nr_inactive_anon 6261
    nr_active_anon 378769
    nr_inactive_file 26907
    nr_active_file 7152
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20315
    nr_mapped    11007
    nr_file_pages 398782
    nr_dirty     2
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 606
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     364723
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 136
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 182
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 912909
 recent_anon_scanned: 1757064
 recent_file_rotated: 10006
 recent_file_scanned: 48952
 anon_ratio:          14

> # echo 1 > /proc/sys/vm/shrink_all_memory

> # tail /var/log/messages

[  472.454344] shrink_all_memory start
[  472.454731] shrink_all_memory: req:1 reclaimed:29 free:334891

> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1339556 kB
Buffers:           42864 kB
Cached:          1595252 kB
SwapCached:            0 kB
Active:          1557108 kB
Inactive:         162296 kB
Active(anon):    1514628 kB
Inactive(anon):    25540 kB
Active(file):      42480 kB
Inactive(file):   136756 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         538992 kB
LowTotal:         877852 kB
LowFree:          800564 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                24 kB
Writeback:             0 kB
AnonPages:         81324 kB
Mapped:            44048 kB
Shmem:           1458884 kB
Slab:              26312 kB
SReclaimable:      18632 kB
SUnreclaim:         7680 kB
KernelStack:        1824 kB
PageTables:         2424 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1771928 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      94312 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB


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
  pages free     197527
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 197527
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 7304
    nr_active_file 3466
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 10770
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 4657
    nr_slab_unreclaimable 1918
    nr_page_table_pages 0
    nr_kernel_stack 228
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
              count: 157
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 67
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 456
 recent_file_scanned: 1918
 anon_ratio:          9
Node 0, zone  HighMem
  pages free     134779
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 134779
    nr_inactive_anon 6389
    nr_active_anon 378650
    nr_inactive_file 26887
    nr_active_file 7154
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20331
    nr_mapped    11014
    nr_file_pages 398764
    nr_dirty     2
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 606
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     364723
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 144
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 115
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 117656
 recent_anon_scanned: 228960
 recent_file_rotated: 1252
 recent_file_scanned: 6163
 anon_ratio:          14

> 
> 
> 3. reset zone_reclaim_stat and rerun shrink_all_memory
> 
> # echo 1 > /proc/sys/vm/reset_reclaim_stat
> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1339316 kB
Buffers:           42924 kB
Cached:          1595344 kB
SwapCached:            0 kB
Active:          1557224 kB
Inactive:         162344 kB
Active(anon):    1514632 kB
Inactive(anon):    25532 kB
Active(file):      42592 kB
Inactive(file):   136812 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         538868 kB
LowTotal:         877852 kB
LowFree:          800448 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                28 kB
Writeback:             0 kB
AnonPages:         81328 kB
Mapped:            44056 kB
Shmem:           1458868 kB
Slab:              26312 kB
SReclaimable:      18636 kB
SUnreclaim:         7676 kB
KernelStack:        1816 kB
PageTables:         2424 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1771932 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      94312 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB

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
  pages free     197498
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 197498
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 7317
    nr_active_file 3467
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 10783
    nr_dirty     7
    nr_writeback 0
    nr_slab_reclaimable 4659
    nr_slab_unreclaimable 1917
    nr_page_table_pages 0
    nr_kernel_stack 227
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
              count: 151
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 80
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
 recent_file_scanned: 4
 anon_ratio:          14
Node 0, zone  HighMem
  pages free     134717
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 134717
    nr_inactive_anon 6387
    nr_active_anon 378651
    nr_inactive_file 26887
    nr_active_file 7181
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20369
    nr_mapped    11017
    nr_file_pages 398789
    nr_dirty     1
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 606
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     364721
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 155
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 150
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     10
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 3636
 recent_anon_scanned: 11656
 recent_file_rotated: 0
 recent_file_scanned: 1
 anon_ratio:          40

> # echo 1 > /proc/sys/vm/shrink_all_memory
> # tail /var/log/messages

[  627.410562] shrink_all_memory start
[  627.410889] shrink_all_memory: req:1 reclaimed:32 free:334798

> % cat /proc/meminfo

MemTotal:        3104484 kB
MemFree:         1339184 kB
Buffers:           43048 kB
Cached:          1595396 kB
SwapCached:            0 kB
Active:          1556584 kB
Inactive:         163144 kB
Active(anon):    1513976 kB
Inactive(anon):    26336 kB
Active(file):      42608 kB
Inactive(file):   136808 kB
Unevictable:          32 kB
Mlocked:              32 kB
HighTotal:       2226632 kB
HighFree:         538744 kB
LowTotal:         877852 kB
LowFree:          800440 kB
SwapTotal:       1999540 kB
SwapFree:        1999540 kB
Dirty:                 8 kB
Writeback:             0 kB
AnonPages:         81340 kB
Mapped:            44104 kB
Shmem:           1459032 kB
Slab:              26316 kB
SReclaimable:      18640 kB
SUnreclaim:         7676 kB
KernelStack:        1824 kB
PageTables:         2424 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3551780 kB
Committed_AS:    1772116 kB
VmallocTotal:     122880 kB
VmallocUsed:       16308 kB
VmallocChunk:      94312 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB

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
  pages free     197496
        min      932
        low      1165
        high     1398
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 197496
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 7344
    nr_active_file 3471
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 10814
    nr_dirty     27
    nr_writeback 0
    nr_slab_reclaimable 4660
    nr_slab_unreclaimable 1917
    nr_page_table_pages 0
    nr_kernel_stack 228
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
              count: 116
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 61
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         4096
  inactive_ratio:    1
 recent_anon_rotated: 0
 recent_anon_scanned: 0
 recent_file_rotated: 5
 recent_file_scanned: 39
 anon_ratio:          6
Node 0, zone  HighMem
  pages free     133632
        min      128
        low      709
        high     1290
        scanned  0
        spanned  556658
        present  552309
    nr_free_pages 133632
    nr_inactive_anon 7700
    nr_active_anon 378501
    nr_inactive_file 26857
    nr_active_file 7181
    nr_unevictable 8
    nr_mlock     8
    nr_anon_pages 20335
    nr_mapped    11025
    nr_file_pages 399912
    nr_dirty     1
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 606
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     365874
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 90
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 164
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     9
  start_pfn:         227326
  inactive_ratio:    4
 recent_anon_rotated: 7752
 recent_anon_scanned: 27187
 recent_file_rotated: 0
 recent_file_scanned: 42
 anon_ratio:          3

