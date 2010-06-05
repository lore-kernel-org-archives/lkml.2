Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab0FEAqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:46:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab0FEAqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KyJGfJkILtJ8QQ6w+CX8eSaFA3nqlTndrGSviUq+5PMZifizbIBh+JIXeB64MjRdpc
         xDHPuaPzfxxc6Ie0bHXSRKLUskcsddXFyXVZv0d8/kcUmo8uyZUo8f8ef2uT/q4bsY9l
         QfkF1lIZcV+hNujJePM6ySfNRxi0baWlRrpI4=
MIME-Version: 1.0
Date: Sat, 5 Jun 2010 10:46:03 +1000
Message-ID: <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
Subject: 2.6.35-rc1 system oom, many processes killed but memory not free
From: andrew hendry <andrew.hendry@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I left a 2.6.35-rc1 system, ubuntu 10.4/64 building randconfigs in a
ramdisk overnight.
/dev/ram0              9842848   5141780   4201068  56% /media/ramdisk

After about 3 hours oom killer started killing nearly all the
processes, but the memory is still not released. Could ramdisk cause
this? How can I find out what is still using all the memory?

cat /proc/meminfo
MemTotal:        8187304 kB
MemFree:          231976 kB
Buffers:             424 kB
Cached:            19728 kB
SwapCached:        51144 kB
Active:            14056 kB
Inactive:          72592 kB
Active(anon):      12900 kB
Inactive(anon):    53940 kB
Active(file):       1156 kB
Inactive(file):    18652 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1986556 kB
SwapFree:        1504676 kB
Dirty:                 0 kB
Writeback:         19720 kB
AnonPages:         32884 kB
Mapped:             4760 kB
Shmem:                 4 kB
Slab:              51652 kB
SReclaimable:      28816 kB
SUnreclaim:        22836 kB
KernelStack:        2880 kB
PageTables:        18484 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6080208 kB
Committed_AS:    1133944 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      350936 kB
VmallocChunk:   34359369212 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        7616 kB
DirectMap2M:     8372224 kB

 Active / Total Objects (% used)    : 152645 / 170934 (89.3%)
 Active / Total Slabs (% used)      : 3918 / 3918 (100.0%)
 Active / Total Caches (% used)     : 68 / 88 (77.3%)
 Active / Total Size (% used)       : 43995.40K / 49940.66K (88.1%)
 Minimum / Average / Maximum Object : 0.01K / 0.29K / 16.12K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 39063  35168  90%    0.55K   1347       29     21552K radix_tree_node
 17296  17114  98%    0.17K    376       46      3008K vm_area_struct
  2706   1173  43%    0.96K     82       33      2624K ext4_inode_cache
   385    377  97%    5.62K     77        5      2464K task_struct
   300    299  99%    8.00K     75        4      2400K kmalloc-8192
  8820   8265  93%    0.19K    210       42      1680K kmalloc-192
  8400   4063  48%    0.19K    200       42      1600K dentry
  2268   1624  71%    0.58K     84       27      1344K inode_cache
 13617  13617 100%    0.08K    267       51      1068K sysfs_dir_cache
  1024    937  91%    1.00K     32       32      1024K kmalloc-1024
 14592   9444  64%    0.06K    228       64       912K kmalloc-64
   400    372  93%    2.00K     25       16       800K kmalloc-2048
   375    326  86%    2.06K     25       15       800K sighand_cache
  1000    989  98%    0.79K     25       40       800K shmem_inode_cache
   152    140  92%    4.00K     19        8       608K kmalloc-4096
   714    711  99%    0.75K     17       42       544K RAW
  7280   7280 100%    0.07K    130       56       520K Acpi-ParseExt

Jun  5 04:51:58 jaunty kernel: [25913.310588] firefox-bin invoked
oom-killer: gfp_mask=0xd0, order=1, oom_adj=0
Jun  5 04:51:58 jaunty kernel: [25913.310591] firefox-bin cpuset=/
mems_allowed=0
Jun  5 04:51:58 jaunty kernel: [25913.310594] Pid: 13275, comm:
firefox-bin Not tainted 2.6.35-rc1+ #3
Jun  5 04:51:58 jaunty kernel: [25913.310595] Call Trace:
Jun  5 04:51:58 jaunty kernel: [25913.310603]  [<ffffffff810ec772>]
dump_header+0x72/0x1c0
Jun  5 04:51:58 jaunty kernel: [25913.310608]  [<ffffffff8151e5dc>] ?
_raw_spin_unlock_irqrestore+0x2c/0x50
Jun  5 04:51:58 jaunty kernel: [25913.310612]  [<ffffffff8127e39f>] ?
___ratelimit+0x9f/0x110
Jun  5 04:51:58 jaunty kernel: [25913.310615]  [<ffffffff810ec941>]
oom_kill_process+0x81/0x180
Jun  5 04:51:58 jaunty kernel: [25913.310619]  [<ffffffff810ece98>]
__out_of_memory+0x58/0xd0
Jun  5 04:51:58 jaunty kernel: [25913.310622]  [<ffffffff810ecf97>]
out_of_memory+0x87/0x1d0
Jun  5 04:51:58 jaunty kernel: [25913.310625]  [<ffffffff810f08d4>]
__alloc_pages_nodemask+0x714/0x730
Jun  5 04:51:58 jaunty kernel: [25913.310629]  [<ffffffff8152208e>] ?
add_preempt_count+0xe/0xd0
Jun  5 04:51:58 jaunty kernel: [25913.310634]  [<ffffffff81121f09>]
alloc_pages_current+0x99/0x100
Jun  5 04:51:58 jaunty kernel: [25913.310637]  [<ffffffff810ef81e>]
__get_free_pages+0xe/0x50
Jun  5 04:51:58 jaunty kernel: [25913.310642]  [<ffffffff81058974>]
copy_process+0xe4/0x1130
Jun  5 04:51:58 jaunty kernel: [25913.310645]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 04:51:58 jaunty kernel: [25913.310649]  [<ffffffff8152204d>] ?
sub_preempt_count+0x9d/0xd0
Jun  5 04:51:58 jaunty kernel: [25913.310652]  [<ffffffff8151e58a>] ?
_raw_spin_unlock+0x1a/0x40
Jun  5 04:51:58 jaunty kernel: [25913.310656]  [<ffffffff811081d3>] ?
handle_mm_fault+0x623/0xab0
Jun  5 04:51:58 jaunty kernel: [25913.310659]  [<ffffffff81059a54>]
do_fork+0x94/0x450
Jun  5 04:51:58 jaunty kernel: [25913.310662]  [<ffffffff81521d3a>] ?
do_page_fault+0x15a/0x3d0
Jun  5 04:51:58 jaunty kernel: [25913.310667]  [<ffffffff810137a8>]
sys_clone+0x28/0x30
Jun  5 04:51:58 jaunty kernel: [25913.310670]  [<ffffffff8100b413>]
stub_clone+0x13/0x20
Jun  5 04:51:58 jaunty kernel: [25913.310673]  [<ffffffff8100b0f2>] ?
system_call_fastpath+0x16/0x1b
Jun  5 04:51:58 jaunty kernel: [25913.310676] Mem-Info:
Jun  5 04:51:58 jaunty kernel: [25913.310678] Node 0 DMA per-cpu:
Jun  5 04:51:58 jaunty kernel: [25913.310680] CPU    0: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310682] CPU    1: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310684] CPU    2: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310686] CPU    3: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310688] CPU    4: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310690] CPU    5: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310692] CPU    6: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310694] CPU    7: hi:    0,
btch:   1 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310696] Node 0 DMA32 per-cpu:
Jun  5 04:51:58 jaunty kernel: [25913.310699] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310701] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310702] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310704] CPU    3: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310706] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310708] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310710] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310712] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310713] Node 0 Normal per-cpu:
Jun  5 04:51:58 jaunty kernel: [25913.310716] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310717] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310719] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310721] CPU    3: hi:  186,
btch:  31 usd:  20
Jun  5 04:51:58 jaunty kernel: [25913.310723] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310725] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310727] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310729] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 04:51:58 jaunty kernel: [25913.310732] active_anon:39101
inactive_anon:23724 isolated_anon:128
Jun  5 04:51:58 jaunty kernel: [25913.310733]  active_file:32
inactive_file:68 isolated_file:32
Jun  5 04:51:58 jaunty kernel: [25913.310734]  unevictable:4 dirty:11
writeback:21 unstable:0
Jun  5 04:51:58 jaunty kernel: [25913.310735]  free:90150
slab_reclaimable:8434 slab_unreclaimable:6106
Jun  5 04:51:58 jaunty kernel: [25913.310736]  mapped:92 shmem:19
pagetables:6622 bounce:0
Jun  5 04:51:58 jaunty kernel: [25913.310737] Node 0 DMA free:15812kB
min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15696kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 04:51:58 jaunty kernel: [25913.310746] lowmem_reserve[]: 0 2991 8041 8041
Jun  5 04:51:58 jaunty kernel: [25913.310751] Node 0 DMA32
free:205968kB min:4264kB low:5328kB high:6396kB active_anon:0kB
inactive_anon:404kB active_file:20kB inactive_file:0kB unevictable:0kB
isolated(anon):256kB isolated(file):128kB present:3063456kB
mlocked:0kB dirty:24kB writeback:40kB mapped:132kB shmem:0kB
slab_reclaimable:5248kB slab_unreclaimable:372kB kernel_stack:112kB
pagetables:688kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
Jun  5 04:51:58 jaunty kernel: [25913.310758] lowmem_reserve[]: 0 0 5050 5050
Jun  5 04:51:58 jaunty kernel: [25913.310763] Node 0 Normal
free:138820kB min:7200kB low:9000kB high:10800kB active_anon:156428kB
inactive_anon
:94492kB active_file:108kB inactive_file:280kB unevictable:16kB
isolated(anon):256kB isolated(file):0kB present:5171200kB mlocked:16kB
dirty:20kB writeback:44kB mapped:236kB shmem:76kB
slab_reclaimable:28488kB slab_unreclaimable:24036kB
kernel_stack:3056kB pagetables:25800kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 04:51:58 jaunty kernel: [25913.310771] lowmem_reserve[]: 0 0 0 0
Jun  5 04:51:58 jaunty kernel: [25913.310775] Node 0 DMA: 1*4kB 0*8kB
0*16kB 2*32kB 2*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15812kB
Jun  5 04:51:58 jaunty kernel: [25913.310786] Node 0 DMA32: 50966*4kB
81*8kB 3*16kB 2*32kB 1*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB
0*4096kB = 206224kB
Jun  5 04:51:58 jaunty kernel: [25913.310796] Node 0 Normal: 33997*4kB
25*8kB 6*16kB 3*32kB 0*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB
0*4096kB = 139452kB
Jun  5 04:51:58 jaunty kernel: [25913.310807] 19073 total pagecache pages
Jun  5 04:51:58 jaunty kernel: [25913.310808] 18904 pages in swap cache
Jun  5 04:51:58 jaunty kernel: [25913.310810] Swap cache stats: add
64440380, delete 64421476, find 5022143/13127219
Jun  5 04:51:58 jaunty kernel: [25913.310812] Free swap  = 0kB
Jun  5 04:51:58 jaunty kernel: [25913.310814] Total swap = 1986556kB
Jun  5 04:51:58 jaunty kernel: [25913.325717] 2097136 pages RAM
Jun  5 04:51:58 jaunty kernel: [25913.325719] 50310 pages reserved
Jun  5 04:51:58 jaunty kernel: [25913.325720] 322 pages shared
Jun  5 04:51:58 jaunty kernel: [25913.325721] 1955500 pages non-shared
Jun  5 04:51:58 jaunty kernel: [25913.325724] Out of memory: kill
process 1446 (gnome-session) score 168483 or a child
Jun  5 04:51:58 jaunty kernel: [25913.325727] Killed process 1477
(ibus-daemon) vsz:64288kB, anon-rss:420kB, file-rss:0kB
Jun  5 05:12:29 jaunty kernel: [27142.499997] collect2 invoked
oom-killer: gfp_mask=0xd0, order=1, oom_adj=0
Jun  5 05:12:29 jaunty kernel: [27142.500000] collect2 cpuset=/ mems_allowed=0
Jun  5 05:12:29 jaunty kernel: [27142.500003] Pid: 8067, comm:
collect2 Not tainted 2.6.35-rc1+ #3
Jun  5 05:12:29 jaunty kernel: [27142.500005] Call Trace:
Jun  5 05:12:29 jaunty kernel: [27142.500012]  [<ffffffff810ec772>]
dump_header+0x72/0x1c0
Jun  5 05:12:29 jaunty kernel: [27142.500017]  [<ffffffff8151e5dc>] ?
_raw_spin_unlock_irqrestore+0x2c/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500020]  [<ffffffff8127e39f>] ?
___ratelimit+0x9f/0x110
Jun  5 05:12:29 jaunty kernel: [27142.500023]  [<ffffffff810ec941>]
oom_kill_process+0x81/0x180
Jun  5 05:12:29 jaunty kernel: [27142.500026]  [<ffffffff810ece98>]
__out_of_memory+0x58/0xd0
Jun  5 05:12:29 jaunty kernel: [27142.500028]  [<ffffffff810ecf97>]
out_of_memory+0x87/0x1d0
Jun  5 05:12:29 jaunty kernel: [27142.500031]  [<ffffffff810f08d4>]
__alloc_pages_nodemask+0x714/0x730
Jun  5 05:12:29 jaunty kernel: [27142.500036]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500039]  [<ffffffff81121f09>]
alloc_pages_current+0x99/0x100
Jun  5 05:12:29 jaunty kernel: [27142.500042]  [<ffffffff810ef81e>]
__get_free_pages+0xe/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500045]  [<ffffffff81058974>]
copy_process+0xe4/0x1130
Jun  5 05:12:29 jaunty kernel: [27142.500048]  [<ffffffff81107d75>] ?
handle_mm_fault+0x1c5/0xab0
Jun  5 05:12:29 jaunty kernel: [27142.500051]  [<ffffffff81059a54>]
do_fork+0x94/0x450
Jun  5 05:12:29 jaunty kernel: [27142.500053]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500056]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500058]  [<ffffffff8152204d>] ?
sub_preempt_count+0x9d/0xd0
Jun  5 05:12:29 jaunty kernel: [27142.500061]  [<ffffffff81521d3a>] ?
do_page_fault+0x15a/0x3d0
Jun  5 05:12:29 jaunty kernel: [27142.500064]  [<ffffffff810137d5>]
sys_vfork+0x25/0x30
Jun  5 05:12:29 jaunty kernel: [27142.500068]  [<ffffffff8100b453>]
stub_vfork+0x13/0x20
Jun  5 05:12:29 jaunty kernel: [27142.500070]  [<ffffffff8100b0f2>] ?
system_call_fastpath+0x16/0x1b
Jun  5 05:12:29 jaunty kernel: [27142.500072] Mem-Info:
Jun  5 05:12:29 jaunty kernel: [27142.500074] Node 0 DMA per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500076] CPU    0: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500077] CPU    1: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500079] CPU    2: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500080] CPU    3: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500081] CPU    4: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500083] CPU    5: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500084] CPU    6: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500086] CPU    7: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500087] Node 0 DMA32 per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500089] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500090] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500091] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500093] CPU    3: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500094] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500096] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500097] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500098] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500100] Node 0 Normal per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500101] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500103] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500104] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500106] CPU    3: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500107] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500108] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500110] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500111] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500115] active_anon:25887
inactive_anon:5496 isolated_anon:32
Jun  5 05:12:29 jaunty kernel: [27142.500115]  active_file:0
inactive_file:0 isolated_file:61
Jun  5 05:12:29 jaunty kernel: [27142.500116]  unevictable:4 dirty:60
writeback:0 unstable:0
Jun  5 05:12:29 jaunty kernel: [27142.500117]  free:117962
slab_reclaimable:8356 slab_unreclaimable:6052
Jun  5 05:12:29 jaunty kernel: [27142.500117]  mapped:1 shmem:37
pagetables:6226 bounce:0
Jun  5 05:12:29 jaunty kernel: [27142.500119] Node 0 DMA free:15812kB
min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15696kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500126] lowmem_reserve[]: 0 2991 8041 8041
Jun  5 05:12:29 jaunty kernel: [27142.500129] Node 0 DMA32
free:200664kB min:4264kB low:5328kB high:6396kB active_anon:120kB
inactive_anon:32kB active_file:4kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:3063456kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:5060kB
slab_unreclaimable:244kB kernel_stack:240kB pagetables:672kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500136] lowmem_reserve[]: 0 0 5050 5050
Jun  5 05:12:29 jaunty kernel: [27142.500139] Node 0 Normal
free:255372kB min:7200kB low:9000kB high:10800kB active_anon:103428kB
inactive_anon:21952kB active_file:0kB inactive_file:0kB
unevictable:16kB isolated(anon):128kB isolated(file):244kB
present:5171200kB mlocked:16kB dirty:240kB writeback:0kB mapped:4kB
shmem:148kB slab_reclaimable:28364kB slab_unreclaimable:23948kB
kernel_stack:3008kB pagetables:24232kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500147] lowmem_reserve[]: 0 0 0 0
Jun  5 05:12:29 jaunty kernel: [27142.500150] Node 0 DMA: 1*4kB 0*8kB
0*16kB 2*32kB 2*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15812kB
Jun  5 05:12:29 jaunty kernel: [27142.500157] Node 0 DMA32: 49660*4kB
14*8kB 4*16kB 6*32kB 1*64kB 2*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB
0*4096kB = 200864kB
Jun  5 05:12:29 jaunty kernel: [27142.500165] Node 0 Normal: 63050*4kB
5*8kB 5*16kB 9*32kB 1*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB
0*4096kB = 255744kB
Jun  5 05:12:29 jaunty kernel: [27142.500172] 81 total pagecache pages
Jun  5 05:12:29 jaunty kernel: [27142.500173] 107 pages in swap cache
Jun  5 05:12:29 jaunty kernel: [27142.500175] Swap cache stats: add
64583476, delete 64583369, find 5037944/13158563
Jun  5 05:12:29 jaunty kernel: [27142.500176] Free swap  = 4kB
Jun  5 05:12:29 jaunty kernel: [27142.500177] Total swap = 1986556kB
Jun  5 05:12:29 jaunty kernel: [27142.515738] 2097136 pages RAM
Jun  5 05:12:29 jaunty kernel: [27142.515740] 50310 pages reserved
Jun  5 05:12:29 jaunty kernel: [27142.515742] 322 pages shared
Jun  5 05:12:29 jaunty kernel: [27142.515743] 1928184 pages non-shared
Jun  5 05:12:29 jaunty kernel: [27142.515746] Out of memory: kill
process 1446 (gnome-session) score 164464 or a child
Jun  5 05:12:29 jaunty kernel: [27142.515750] Killed process 1481
(ssh-agent) vsz:11976kB, anon-rss:28kB, file-rss:0kB
Jun  5 05:12:29 jaunty kernel: [27142.534292] collect2 invoked
oom-killer: gfp_mask=0xd0, order=1, oom_adj=0
Jun  5 05:12:29 jaunty kernel: [27142.534296] collect2 cpuset=/ mems_allowed=0
Jun  5 05:12:29 jaunty kernel: [27142.534299] Pid: 8067, comm:
collect2 Not tainted 2.6.35-rc1+ #3
Jun  5 05:12:29 jaunty kernel: [27142.534301] Call Trace:
Jun  5 05:12:29 jaunty kernel: [27142.500012]  [<ffffffff810ec772>]
dump_header+0x72/0x1c0
Jun  5 05:12:29 jaunty kernel: [27142.500017]  [<ffffffff8151e5dc>] ?
_raw_spin_unlock_irqrestore+0x2c/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500020]  [<ffffffff8127e39f>] ?
___ratelimit+0x9f/0x110
Jun  5 05:12:29 jaunty kernel: [27142.500023]  [<ffffffff810ec941>]
oom_kill_process+0x81/0x180
Jun  5 05:12:29 jaunty kernel: [27142.500026]  [<ffffffff810ece98>]
__out_of_memory+0x58/0xd0
Jun  5 05:12:29 jaunty kernel: [27142.500028]  [<ffffffff810ecf97>]
out_of_memory+0x87/0x1d0
Jun  5 05:12:29 jaunty kernel: [27142.500031]  [<ffffffff810f08d4>]
__alloc_pages_nodemask+0x714/0x730
Jun  5 05:12:29 jaunty kernel: [27142.500036]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500039]  [<ffffffff81121f09>]
alloc_pages_current+0x99/0x100
Jun  5 05:12:29 jaunty kernel: [27142.500042]  [<ffffffff810ef81e>]
__get_free_pages+0xe/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500045]  [<ffffffff81058974>]
copy_process+0xe4/0x1130
Jun  5 05:12:29 jaunty kernel: [27142.500048]  [<ffffffff81107d75>] ?
handle_mm_fault+0x1c5/0xab0
Jun  5 05:12:29 jaunty kernel: [27142.500051]  [<ffffffff81059a54>]
do_fork+0x94/0x450
Jun  5 05:12:29 jaunty kernel: [27142.500053]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500056]  [<ffffffff81048161>] ?
get_parent_ip+0x11/0x50
Jun  5 05:12:29 jaunty kernel: [27142.500058]  [<ffffffff8152204d>] ?
sub_preempt_count+0x9d/0xd0
Jun  5 05:12:29 jaunty kernel: [27142.500061]  [<ffffffff81521d3a>] ?
do_page_fault+0x15a/0x3d0
Jun  5 05:12:29 jaunty kernel: [27142.500064]  [<ffffffff810137d5>]
sys_vfork+0x25/0x30
Jun  5 05:12:29 jaunty kernel: [27142.500068]  [<ffffffff8100b453>]
stub_vfork+0x13/0x20
Jun  5 05:12:29 jaunty kernel: [27142.500070]  [<ffffffff8100b0f2>] ?
system_call_fastpath+0x16/0x1b
Jun  5 05:12:29 jaunty kernel: [27142.500072] Mem-Info:
Jun  5 05:12:29 jaunty kernel: [27142.500074] Node 0 DMA per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500076] CPU    0: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500077] CPU    1: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500079] CPU    2: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500080] CPU    3: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500081] CPU    4: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500083] CPU    5: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500084] CPU    6: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500086] CPU    7: hi:    0,
btch:   1 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500087] Node 0 DMA32 per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500089] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500090] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500091] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500093] CPU    3: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500094] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500096] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500097] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500098] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500100] Node 0 Normal per-cpu:
Jun  5 05:12:29 jaunty kernel: [27142.500101] CPU    0: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500103] CPU    1: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500104] CPU    2: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500106] CPU    3: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500107] CPU    4: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500108] CPU    5: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500110] CPU    6: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500111] CPU    7: hi:  186,
btch:  31 usd:   0
Jun  5 05:12:29 jaunty kernel: [27142.500115] active_anon:25887
inactive_anon:5496 isolated_anon:32
Jun  5 05:12:29 jaunty kernel: [27142.500115]  active_file:0
inactive_file:0 isolated_file:61
Jun  5 05:12:29 jaunty kernel: [27142.500116]  unevictable:4 dirty:60
writeback:0 unstable:0
Jun  5 05:12:29 jaunty kernel: [27142.500117]  free:117962
slab_reclaimable:8356 slab_unreclaimable:6052
Jun  5 05:12:29 jaunty kernel: [27142.500117]  mapped:1 shmem:37
pagetables:6226 bounce:0
Jun  5 05:12:29 jaunty kernel: [27142.500119] Node 0 DMA free:15812kB
min:20kB low:24kB high:28kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15696kB mlocked:0kB dirty:0kB writeback:0kB
mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500126] lowmem_reserve[]: 0 2991 8041 8041
Jun  5 05:12:29 jaunty kernel: [27142.500129] Node 0 DMA32
free:200664kB min:4264kB low:5328kB high:6396kB active_anon:120kB
inactive_anon:32kB active_file:4kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:3063456kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:5060kB
slab_unreclaimable:244kB kernel_stack:240kB pagetables:672kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500136] lowmem_reserve[]: 0 0 5050 5050
Jun  5 05:12:29 jaunty kernel: [27142.500139] Node 0 Normal
free:255372kB min:7200kB low:9000kB high:10800kB active_anon:103428kB
inactive_anon:21952kB active_file:0kB inactive_file:0kB
unevictable:16kB isolated(anon):128kB isolated(file):244kB
present:5171200kB mlocked:16kB dirty:240kB writeback:0kB mapped:4kB
shmem:148kB slab_reclaimable:28364kB slab_unreclaimable:23948kB
kernel_stack:3008kB pagetables:24232kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun  5 05:12:29 jaunty kernel: [27142.500147] lowmem_reserve[]: 0 0 0 0
Jun  5 05:12:29 jaunty kernel: [27142.500150] Node 0 DMA: 1*4kB 0*8kB
0*16kB 2*32kB 2*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15812kB
Jun  5 05:12:29 jaunty kernel: [27142.500157] Node 0 DMA32: 49660*4kB
14*8kB 4*16kB 6*32kB 1*64kB 2*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB
0*4096kB = 200864kB
Jun  5 05:12:29 jaunty kernel: [27142.500165] Node 0 Normal: 63050*4kB
5*8kB 5*16kB 9*32kB 1*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB
0*4096kB = 255744kB
Jun  5 05:12:29 jaunty kernel: [27142.500172] 81 total pagecache pages
Jun  5 05:12:29 jaunty kernel: [27142.500173] 107 pages in swap cache
Jun  5 05:12:29 jaunty kernel: [27142.500175] Swap cache stats: add
64583476, delete 64583369, find 5037944/13158563
Jun  5 05:12:29 jaunty kernel: [27142.500176] Free swap  = 4kB
Jun  5 05:12:29 jaunty kernel: [27142.500177] Total swap = 1986556kB
Jun  5 05:12:29 jaunty kernel: [27142.515738] 2097136 pages RAM
Jun  5 05:12:29 jaunty kernel: [27142.515740] 50310 pages reserved
Jun  5 05:12:29 jaunty kernel: [27142.515742] 322 pages shared
Jun  5 05:12:29 jaunty kernel: [27142.515743] 1928184 pages non-shared
Jun  5 05:12:29 jaunty kernel: [27142.515746] Out of memory: kill
process 1446 (gnome-session) score 164464 or a child
Jun  5 05:12:29 jaunty kernel: [27142.515750] Killed process 1481
(ssh-agent) vsz:11976kB, anon-rss:28kB, file-rss:0kB
Jun  5 05:12:29 jaunty kernel: [27142.534292] collect2 invoked
oom-killer: gfp_mask=0xd0, order=1, oom_adj=0
Jun  5 05:12:29 jaunty kernel: [27142.534296] collect2 cpuset=/ mems_allowed=0
Jun  5 05:12:29 jaunty kernel: [27142.534299] Pid: 8067, comm:
collect2 Not tainted 2.6.35-rc1+ #3

....

It continued killing off 420 processes but the free memory didnt increase.
