Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2ATAIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:08:12 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:49171 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2ATAIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:08:06 -0500
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Fri, 20 Jan 2012 01:08:00 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [kmemleak report 1/2] kernel 3.1.6, x86_64: mm, xfs ?, vfs ?
Message-ID: <20120120000800.GA24762@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
 <20120115223701.GA3937@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120115223701.GA3937@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.1.6 + cherry-picked “kmemleak: Handle percpu memory allocation” as
suggested by Catalin Marinas, I get no significant changes to kmemleak reports,
and e.g. following /proc/meminfo snapshots.  I wonder, is such a huge slab
memory normal?  Is there anything else suspicious?


------------------------------------------------------------------------
uptime  (  h:mm )             1:10               1:15               1:19
------------------------------------------------------------------------
loadavg ( 1m 5m )    ( 0.17 0.10 )      ( 2.24 0.99 )      ( 0.39 0.70 )
------------------------------------------------------------------------
MemTotal:             3 982 248 kB       3 982 248 kB       3 982 248 kB
MemFree:              2 838 392 kB       2 185 060 kB       2 248 388 kB
Buffers:                  7 876 kB           7 876 kB           7 876 kB
Cached:                 422 112 kB         538 832 kB         548 840 kB
SwapCached:                   0 kB               0 kB               0 kB
Active:                 499 296 kB         658 180 kB         590 760 kB
Inactive:               356 892 kB         384 456 kB         391 592 kB
Active(anon):           427 152 kB         496 876 kB         426 636 kB
Inactive(anon):           7 876 kB           7 876 kB           7 876 kB
Active(file):            72 144 kB         161 304 kB         164 124 kB
Inactive(file):         349 016 kB         376 580 kB         383 716 kB
Unevictable:                144 kB             144 kB             144 kB
Mlocked:                    144 kB             144 kB             144 kB
SwapTotal:            8 031 468 kB       8 031 468 kB       8 031 468 kB
SwapFree:             8 031 468 kB       8 031 468 kB       8 031 468 kB
Dirty:                    1 432 kB          13 576 kB             100 kB
Writeback:                    0 kB               0 kB               0 kB
AnonPages:              426 052 kB         495 880 kB         425 680 kB
Mapped:                  44 912 kB          46 876 kB          45 044 kB
Shmem:                    8 776 kB           8 776 kB           8 776 kB
Slab:                   132 452 kB         535 940 kB         533 292 kB
SReclaimable:            29 444 kB         233 648 kB         234 280 kB
SUnreclaim:             103 008 kB         302 292 kB         299 012 kB
KernelStack:              2 096 kB           2 088 kB           2 072 kB
PageTables:              13 320 kB          13 324 kB          12 876 kB
NFS_Unstable:                 0 kB               0 kB               0 kB
Bounce:                       0 kB               0 kB               0 kB
WritebackTmp:                 0 kB               0 kB               0 kB
CommitLimit:         10 022 592 kB      10 022 592 kB      10 022 592 kB
Committed_AS:           680 572 kB         754 868 kB         679 516 kB
VmallocTotal:    34 359 738 367 kB  34 359 738 367 kB  34 359 738 367 kB
VmallocUsed:            137 204 kB         137 204 kB         137 204 kB
VmallocChunk:    34 359 465 068 kB  34 359 465 068 kB  34 359 465 068 kB
AnonHugePages:           75 776 kB          75 776 kB          75 776 kB
HugePages_Total:              0                  0                  0   
HugePages_Free:               0                  0                  0   
HugePages_Rsvd:               0                  0                  0   
HugePages_Surp:               0                  0                  0   
Hugepagesize:             2 048 kB           2 048 kB           2 048 kB
DirectMap4k:              2 428 kB           2 428 kB           2 428 kB
DirectMap2M:          4 116 480 kB       4 116 480 kB       4 116 480 kB
------------------------------------------------------------------------


------------------------------------------------------------------------
uptime  (  h:mm )             1:31               5:09              18:10
------------------------------------------------------------------------
loadavg ( 1m 5m )    ( 0.16 0.14 )      ( 0.02 0.06 )      ( 0.07 0.11 )
------------------------------------------------------------------------
MemTotal:             3 982 248 kB       3 982 248 kB       3 982 248 kB
MemFree:              2 229 492 kB       2 063 376 kB         967 200 kB
Buffers:                  7 876 kB           7 876 kB           7 692 kB
Cached:                 560 564 kB         639 444 kB       1 130 700 kB
SwapCached:                   0 kB               0 kB               8 kB
Active:                 592 056 kB         619 736 kB         785 640 kB
Inactive:               402 704 kB         478 516 kB         945 624 kB
Active(anon):           427 376 kB         451 760 kB         568 340 kB
Inactive(anon):           7 876 kB           9 396 kB          43 148 kB
Active(file):           164 680 kB         167 976 kB         217 300 kB
Inactive(file):         394 828 kB         469 120 kB         902 476 kB
Unevictable:                144 kB              76 kB              76 kB
Mlocked:                    144 kB              76 kB              76 kB
SwapTotal:            8 031 468 kB       8 031 468 kB       8 031 468 kB
SwapFree:             8 031 468 kB       8 031 468 kB       8 031 448 kB
Dirty:                      276 kB               0 kB               0 kB
Writeback:                    0 kB               0 kB               0 kB
AnonPages:              426 324 kB         451 032 kB         593 020 kB
Mapped:                  45 068 kB          46 680 kB          57 056 kB
Shmem:                    8 776 kB          10 224 kB          18 616 kB
Slab:                   539 756 kB         599 832 kB       1 015 676 kB
SReclaimable:           236 808 kB         254 164 kB         375 908 kB
SUnreclaim:             302 948 kB         345 668 kB         639 768 kB
KernelStack:              2 056 kB           2 016 kB           2 104 kB
PageTables:              12 880 kB          13 112 kB          13 732 kB
NFS_Unstable:                 0 kB               0 kB               0 kB
Bounce:                       0 kB               0 kB               0 kB
WritebackTmp:                 0 kB               0 kB               0 kB
CommitLimit:         10 022 592 kB      10 022 592 kB      10 022 592 kB
Committed_AS:           679 012 kB         705 104 kB         856 188 kB
VmallocTotal:    34 359 738 367 kB  34 359 738 367 kB  34 359 738 367 kB
VmallocUsed:            137 204 kB         137 204 kB         137 268 kB
VmallocChunk:    34 359 465 068 kB  34 359 465 068 kB  34 359 465 068 kB
AnonHugePages:           75 776 kB          96 256 kB         221 184 kB
HugePages_Total:              0                  0                  0   
HugePages_Free:               0                  0                  0   
HugePages_Rsvd:               0                  0                  0   
HugePages_Surp:               0                  0                  0   
Hugepagesize:             2 048 kB           2 048 kB           2 048 kB
DirectMap4k:              2 428 kB           2 428 kB          74 108 kB
DirectMap2M:          4 116 480 kB       4 116 480 kB       4 044 800 kB
------------------------------------------------------------------------


/proc/slabinfo  at uptime 29:32
--------------
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
uhci_urb_priv          0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
SCTPv6                 1      3   1344    3    1 : tunables   24   12    8 : slabdata      1      1      0
SCTP                   0      0   1152    7    2 : tunables   24   12    8 : slabdata      0      0      0
sctp_chunk             0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
sctp_bind_bucket       0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm6_tunnel_spi       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
fib6_nodes             5     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache          4     12    320   12    1 : tunables   54   27    8 : slabdata      1      1      0
ndisc_cache            1     12    320   12    1 : tunables   54   27    8 : slabdata      1      1      0
RAWv6                  7      8   1024    4    1 : tunables   54   27    8 : slabdata      2      2      0
UDPLITEv6              0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
tw_sock_TCPv6          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                  0      0   1792    2    1 : tunables   24   12    8 : slabdata      0      0      0
xt_hashlimit           0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
nf_conntrack_expect      0      0    240   16    1 : tunables  120   60    8 : slabdata      0      0      0
nf_conntrack_ffffffff81a9fa00      1     13    296   13    1 : tunables   54   27    8 : slabdata      1      1      0
flow_cache             0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_sense_cache       6     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_cmd_cache         6     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
sd_ext_cdb             2    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
cfq_io_context        70    150    128   30    1 : tunables  120   60    8 : slabdata      5      5      0
cfq_queue             62    136    232   17    1 : tunables  120   60    8 : slabdata      8      8      0
mqueue_inode_cache      1      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
xfs_buf            33849  33876    320   12    1 : tunables   54   27    8 : slabdata   2823   2823      0
fstrm_item             0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_mru_cache_elem      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_ili             4924   4968    216   18    1 : tunables  120   60    8 : slabdata    276    276      0
xfs_inode         195797 195824    960    4    1 : tunables   54   27    8 : slabdata  48956  48956      0
xfs_efi_item           0      0    400   10    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_efd_item           0      0    400   10    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_buf_item           2     17    224   17    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_log_item_desc      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_trans              0      0    280   14    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_ifork             22     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_dabuf              0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_da_state           0      0    488    8    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_btree_cur        477    494    208   19    1 : tunables  120   60    8 : slabdata     26     26      0
xfs_bmap_free_item      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_log_ticket        17     76    200   19    1 : tunables  120   60    8 : slabdata      4      4      0
xfs_ioend             32     34    112   34    1 : tunables  120   60    8 : slabdata      1      1      0
udf_inode_cache        0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
isofs_inode_cache      0      0    584    7    1 : tunables   54   27    8 : slabdata      0      0      0
fat_inode_cache        6     12    648    6    1 : tunables   54   27    8 : slabdata      2      2      0
fat_cache              0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
hugetlbfs_inode_cache      1      7    552    7    1 : tunables   54   27    8 : slabdata      1      1      0
squashfs_inode_cache      0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
jbd2_inode             0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_handle      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_head      0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_table      0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_record      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle         0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
journal_head           0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_table           0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_record          0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_inode_cache       0      0    848    4    1 : tunables   54   27    8 : slabdata      0      0      0
ext4_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_free_data         0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_allocation_context      0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_prealloc_space      0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_system_zone       0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_io_end            0      0   1128    3    1 : tunables   24   12    8 : slabdata      0      0      0
ext4_io_page           0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
ext2_inode_cache       0      0    728    5    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache       0      0    752    5    1 : tunables   54   27    8 : slabdata      0      0      0
ext3_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
dlm_rsb                0      0    296   13    1 : tunables   54   27    8 : slabdata      0      0      0
dlm_lkb                0      0    488    8    1 : tunables   54   27    8 : slabdata      0      0      0
configfs_dir_cache      1     44     88   44    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fanotify_response_event      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_mark          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_private_data      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_inode_mark    143    196    136   28    1 : tunables  120   60    8 : slabdata      7      7      0
dnotify_mark           0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
dnotify_struct         0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
khugepaged_mm_slot     49    184     40   92    1 : tunables  120   60    8 : slabdata      2      2      0
ksm_mm_slot            0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_stable_node        0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ksm_rmap_item          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    176   22    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              8     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
kvm_async_pf           0      0    144   27    1 : tunables  120   60    8 : slabdata      0      0      0
kvm_vcpu               0      0  14208    1    4 : tunables    8    4    0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    176   22    1 : tunables  120   60    8 : slabdata      0      0      0
pte_list_desc          0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
UNIX                  99    115    768    5    1 : tunables   54   27    8 : slabdata     23     23      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    832    9    2 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket        8    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache       27     40    192   20    1 : tunables  120   60    8 : slabdata      2      2      0
secpath_cache          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_trie            9     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_alias          10     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache          24     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
arp_cache              2     12    320   12    1 : tunables   54   27    8 : slabdata      1      1      0
PING                   0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
RAW                    5      5    768    5    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                    1      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
tw_sock_TCP            0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    9     15   1600    5    2 : tunables   24   12    8 : slabdata      3      3      0
eventpoll_pwq          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
sgpool-128             2      2   4096    1    1 : tunables   24   12    8 : slabdata      2      2      0
sgpool-64              2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-32              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-8               2     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_data_buffer       0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_integrity       0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue         106    108   1720    4    2 : tunables   24   12    8 : slabdata     27     27      0
blkdev_requests        8     22    352   11    1 : tunables   54   27    8 : slabdata      2      2      0
blkdev_ioc            70    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
fsnotify_event_holder      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_event         1     32    120   32    1 : tunables  120   60    8 : slabdata      1      1      0
bio-0               2258   2360    192   20    1 : tunables  120   60    8 : slabdata    118    118      0
biovec-256             2      2   4096    1    1 : tunables   24   12    8 : slabdata      2      2      0
biovec-128             0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
biovec-64              0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
biovec-16              0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
bip-256                2      2   4224    1    2 : tunables    8    4    0 : slabdata      2      2      0
bip-128                0      0   2176    3    2 : tunables   24   12    8 : slabdata      0      0      0
bip-64                 0      0   1152    7    2 : tunables   24   12    8 : slabdata      0      0      0
bip-16                 0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
bip-4                  0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
bip-1                  0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
sock_inode_cache     142    168    640    6    1 : tunables   54   27    8 : slabdata     28     28      0
skbuff_fclone_cache      0      0    512    7    1 : tunables   54   27    8 : slabdata      0      0      0
skbuff_head_cache    501    570    256   15    1 : tunables  120   60    8 : slabdata     38     38     60
file_lock_cache        1     22    176   22    1 : tunables  120   60    8 : slabdata      1      1      0
shmem_inode_cache   2712   2754    616    6    1 : tunables   54   27    8 : slabdata    459    459      0
Acpi-Operand        4252   4399     72   53    1 : tunables  120   60    8 : slabdata     83     83      0
Acpi-ParseExt          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace      1736   1840     40   92    1 : tunables  120   60    8 : slabdata     20     20      0
task_delay_info      260    442    112   34    1 : tunables  120   60    8 : slabdata     13     13      0
taskstats              1     12    328   12    1 : tunables   54   27    8 : slabdata      1      1      0
proc_inode_cache    1836   1884    600    6    1 : tunables   54   27    8 : slabdata    314    314      0
sigqueue               0      0    160   24    1 : tunables  120   60    8 : slabdata      0      0      0
bdev_cache           132    140    768    5    1 : tunables   54   27    8 : slabdata     28     28      0
sysfs_dir_cache    22556  22656     80   48    1 : tunables  120   60    8 : slabdata    472    472      0
mnt_cache             56     90    256   15    1 : tunables  120   60    8 : slabdata      6      6      0
filp                3333   4100    192   20    1 : tunables  120   60    8 : slabdata    205    205      0
inode_cache         4606   4641    536    7    1 : tunables   54   27    8 : slabdata    663    663      0
dentry             68218  68380    192   20    1 : tunables  120   60    8 : slabdata   3419   3419      0
names_cache            3      3   4096    1    1 : tunables   24   12    8 : slabdata      3      3      0
key_jar                0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
buffer_head       1127461 1127686    104   37    1 : tunables  120   60    8 : slabdata  30478  30478      0
nsproxy                1     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
vm_area_struct     10857  11193    184   21    1 : tunables  120   60    8 : slabdata    533    533      0
mm_struct            127    164    896    4    1 : tunables   54   27    8 : slabdata     41     41      0
fs_cache             130    295     64   59    1 : tunables  120   60    8 : slabdata      5      5      0
files_cache          130    198    704   11    2 : tunables   54   27    8 : slabdata     18     18      0
signal_cache         237    301   1088    7    2 : tunables   24   12    8 : slabdata     43     43      0
sighand_cache        237    267   2112    3    2 : tunables   24   12    8 : slabdata     89     89      0
task_xstate          150    208    512    8    1 : tunables   54   27    8 : slabdata     26     26      0
task_struct          259    300   1728    4    2 : tunables   24   12    8 : slabdata     75     75      0
cred_jar             480    800    192   20    1 : tunables  120   60    8 : slabdata     40     40      0
anon_vma_chain      6143   6622     48   77    1 : tunables  120   60    8 : slabdata     86     86      0
anon_vma            3672   4012     64   59    1 : tunables  120   60    8 : slabdata     68     68      0
pid                  268    450    128   30    1 : tunables  120   60    8 : slabdata     15     15      0
shared_policy_node      0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
numa_policy            0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
kmemleak_scan_area   4519   4816     32  112    1 : tunables  120   60    8 : slabdata     43     43      0
kmemleak_object   1618747 1662156    320   12    1 : tunables   54   27    8 : slabdata 138513 138513    128
radix_tree_node    23667  23688    560    7    1 : tunables   54   27    8 : slabdata   3384   3384      0
idr_layer_cache      344    378    544    7    1 : tunables   54   27    8 : slabdata     54     54      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           1      1 2097152    1  512 : tunables    1    1    0 : slabdata      1      1      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           1      1 1048576    1  256 : tunables    1    1    0 : slabdata      1      1      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            1      1 524288    1  128 : tunables    1    1    0 : slabdata      1      1      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536            38     38  65536    1   16 : tunables    8    4    0 : slabdata     38     38      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             2      2  32768    1    8 : tunables    8    4    0 : slabdata      2      2      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            13     13  16384    1    4 : tunables    8    4    0 : slabdata     13     13      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             15     15   8192    1    2 : tunables    8    4    0 : slabdata     15     15      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            427    427   4096    1    1 : tunables   24   12    8 : slabdata    427    427      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            795    836   2048    2    1 : tunables   24   12    8 : slabdata    418    418      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024           2004   2080   1024    4    1 : tunables   54   27    8 : slabdata    520    520      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512           23674  23728    512    8    1 : tunables   54   27    8 : slabdata   2966   2966     10
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256            1140   1260    256   15    1 : tunables  120   60    8 : slabdata     84     84      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
size-192            4746   5180    192   20    1 : tunables  120   60    8 : slabdata    259    259      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-64            17024  26137     64   59    1 : tunables  120   60    8 : slabdata    443    443      0
size-32(DMA)           0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
size-128           23791  25320    128   30    1 : tunables  120   60    8 : slabdata    844    844      0
size-32            18784  19152     32  112    1 : tunables  120   60    8 : slabdata    171    171      0
kmem_cache           213    240    192   20    1 : tunables  120   60    8 : slabdata     12     12      0


sda{5,10,27,28} are loop-AES encrypted XFS with external log sections, all other
sda?* are plain XFS filesystems, sda21 holds the root filesystem:

grep -v ' 0 0$' /proc/diskstats  at uptime 33:29
-------------------------------
   8       0 sda 78559 137798 2304012 839844 122404 329314 5415104 41936431 0 1792183 42774787
   8       1 sda1 2 0 10 215 0 0 0 0 0 215 215
   8       5 sda5 702 2725 22812 3938 1956 1545 25085 55352 0 14700 59287
   8       6 sda6 132 56 1504 2601 27 189 1728 93 0 2557 2692
   8       7 sda7 2024 0 12836 37383 5705 398 40073 1199296 0 204469 1236622
   8       8 sda8 161 64 6848 3142 336 0 4473 6467 0 9231 9609
   8       9 sda9 117 0 5295 2918 333 0 4425 6662 0 9508 9580
   8      10 sda10 30201 110000 1001752 371689 35943 206068 1779679 4314002 0 687767 4684952
   8      11 sda11 30 0 240 2446 0 0 0 0 0 2446 2446
   8      12 sda12 30 0 240 2634 0 0 0 0 0 2634 2634
   8      13 sda13 30 0 240 1515 0 0 0 0 0 1515 1515
   8      14 sda14 30 24 216 1674 0 0 0 0 0 1674 1674
   8      15 sda15 30 24 216 1747 0 0 0 0 0 1747 1747
 259       0 sda16 30 24 216 990 0 0 0 0 0 990 990
 259       1 sda17 118 72 5264 1914 333 0 4425 7353 0 9195 9267
 259       2 sda18 7471 13 67451 27781 3694 847 92920 779570 0 98405 807309
 259       3 sda19 119 0 5297 2036 333 0 4425 5495 0 7479 7531
 259       4 sda20 119 0 5297 2281 333 0 4425 5830 0 8066 8111
 259       5 sda21 32166 9664 1086313 300171 58412 16246 2528731 34872785 0 837964 35172340
 259       6 sda22 119 0 5297 1472 333 0 4425 6611 0 8024 8083
 259       7 sda23 119 0 5297 2421 333 0 4425 4507 0 6862 6928
 259       8 sda24 119 0 5297 2798 333 0 4425 3830 0 6574 6628
 259       9 sda25 120 0 8879 2505 333 0 4425 4240 0 6639 6744
 259      10 sda26 239 0 4671 2258 333 0 4425 3363 0 5595 5621
 259      11 sda27 1465 3757 32271 40084 13156 103665 898494 654351 0 194811 694408
 259      12 sda28 2818 11375 19869 20860 156 356 4096 6195 0 18305 27054


/proc/fs/xfs/stat  at uptime 33:30
-----------------
extent_alloc 20042 9731586 24081 8905389
abt 0 0 0 0
blk_map 7846005 3450635 22643 764025 31534 11319696 0
bmbt 0 0 0 0
dir 392978 7204 6864 109586
trans 3999 98083 5310
ig 0 163392 0 197512 0 1728 16951
log 5978 106974 0 21522 5538
push_ail 107392 0 763672 4764 111288 600 157853 0 0 332
xstrat 18648 0
rw 529172 9692797
attr 54338 0 0 2
icluster 54468 19446 77469
vnodes 4294962708 0 0 0 4588 4588 4588 0
buf 1895380 34995 1878532 10182 99893 0 0 29894 33620
abtb2 45639 598402 16541 16774 0 0 137693 28338 1142 1023 37 34 37 34 885281
abtc2 66542 877795 30257 30480 0 0 8884 6406 4030 8434 295 282 295 282 1481487
bmbt2 26237 295473 13600 12499 6 4 5972 6195 6056 5972 467 432 473 436 302002
ibt2 21482 185410 8 0 0 0 31190 248 5 0 0 0 0 0 157
xpc 293832939520 2035179692 7828060813
debug 0


Thanks.
-- 
Roland Eggner
