Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2DIQTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:19:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46403 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756878Ab2DIQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:19:32 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19X959NL29X/7dFvv/9LflnyK3wOI1IrD6arbzqBA
	G90xXkJICoRMe4
From: Sven Joachim <svenjoac@gmx.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<8762d9v10x.fsf@turtle.gmx.de> <4F8306ED.7080405@redhat.com>
Date: Mon, 09 Apr 2012 18:19:28 +0200
In-Reply-To: <4F8306ED.7080405@redhat.com> (Rik van Riel's message of "Mon, 09
	Apr 2012 11:57:33 -0400")
Message-ID: <87398cev3j.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

On 2012-04-09 17:57 +0200, Rik van Riel wrote:

> On 04/09/2012 03:04 AM, Sven Joachim wrote:
>
>> While I did not experience any crashes or instabilities (yet?), I'm also
>> seeing memory leaks.  On a system started this morning, with hardly
>> anything running:
>
>> where I would expect no more than 50 MB used, 400 MB are actually in use:
>>
>> ,----
>> | $ free
>> |              total       used       free     shared    buffers     cached
>> | Mem:       3348400    1849712    1498688          0     328960    1119180
>> | -/+ buffers/cache:     401572    2946828
>> | Swap:      3719040          0    3719040
>> `----
>
> Do you see any big memory users in /proc/meminfo or in
> /proc/slabinfo?

Attaching these files, since I can't really make anything out of the
latter.  Note that I started a few memory hogs (X, Firefox, Emacs with
Gnus), so overall memory footprint has grown to 768 MB.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=meminfo

MemTotal:        3348400 kB
MemFree:          195560 kB
Buffers:          292688 kB
Cached:          2079648 kB
SwapCached:            0 kB
Active:          1443900 kB
Inactive:        1241544 kB
Active(anon):     219388 kB
Inactive(anon):    94668 kB
Active(file):    1224512 kB
Inactive(file):  1146876 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       3719040 kB
SwapFree:        3719040 kB
Dirty:                52 kB
Writeback:             0 kB
AnonPages:        313108 kB
Mapped:            70348 kB
Shmem:               948 kB
Slab:             407688 kB
SReclaimable:     393984 kB
SUnreclaim:        13704 kB
KernelStack:        1088 kB
PageTables:         2496 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5393240 kB
Committed_AS:     790452 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      316040 kB
VmallocChunk:   34359370299 kB
DirectMap4k:      232380 kB
DirectMap2M:     3174400 kB

--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=slabinfo

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fib6_nodes             5     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache          4     12    320   12    1 : tunables   54   27    8 : slabdata      1      1      0
RAWv6                  5      8   1024    4    1 : tunables   54   27    8 : slabdata      2      2      0
UDPLITEv6              0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
tw_sock_TCPv6          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                  0      0   1792    2    1 : tunables   24   12    8 : slabdata      0      0      0
ext4_groupinfo_2k     27     28    136   28    1 : tunables  120   60    8 : slabdata      1      1      0
ext4_groupinfo_4k   1160   1176    136   28    1 : tunables  120   60    8 : slabdata     42     42      0
uhci_urb_priv          0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
flow_cache             0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_sense_cache      22     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_cmd_cache        22     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
sd_ext_cdb             2    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
cfq_io_cq             43    148    104   37    1 : tunables  120   60    8 : slabdata      4      4      0
cfq_queue             44    119    232   17    1 : tunables  120   60    8 : slabdata      7      7      0
mqueue_inode_cache      1      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
jbd2_transaction_s     27     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
jbd2_inode         17996  19019     48   77    1 : tunables  120   60    8 : slabdata    247    247      0
jbd2_journal_handle     24    144     24  144    1 : tunables  120   60    8 : slabdata      1      1      0
jbd2_journal_head     54    340    112   34    1 : tunables  120   60    8 : slabdata     10     10      0
jbd2_revoke_table_s     10    202     16  202    1 : tunables  120   60    8 : slabdata      1      1      0
jbd2_revoke_record_s      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_inode_cache  283945 284168    840    4    1 : tunables   54   27    8 : slabdata  71042  71042      0
ext4_xattr             0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_free_data         0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_allocation_context      0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_prealloc_space     18     74    104   37    1 : tunables  120   60    8 : slabdata      2      2      0
ext4_system_zone       0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_io_end            0      0   1128    3    1 : tunables   24   12    8 : slabdata      0      0      0
ext4_io_page           0      0     16  202    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                 0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fanotify_response_event      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_mark          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_private_data      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_inode_mark     16     28    136   28    1 : tunables  120   60    8 : slabdata      1      1      0
dnotify_mark           0      0    136   28    1 : tunables  120   60    8 : slabdata      0      0      0
dnotify_struct         0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
dio                    0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
fasync_cache           5     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
posix_timers_cache      0      0    144   27    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              9     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
UNIX                 175    175    768    5    1 : tunables   54   27    8 : slabdata     35     35      0
UDP-Lite               0      0    832    9    2 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket       10    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache       15     40    192   20    1 : tunables  120   60    8 : slabdata      2      2      0
secpath_cache          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_trie            8     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_alias           9     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache          31     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
PING                   0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
RAW                    3      9    832    9    2 : tunables   54   27    8 : slabdata      1      1      0
UDP                   18     18    832    9    2 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCP            0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                   10     15   1600    5    2 : tunables   24   12    8 : slabdata      3      3      0
eventpoll_pwq         94    212     72   53    1 : tunables  120   60    8 : slabdata      4      4      0
eventpoll_epi         94    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0
sgpool-128             2      2   4096    1    1 : tunables   24   12    8 : slabdata      2      2      0
sgpool-64              2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-32              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-8              15     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_data_buffer       0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue           2      4   1688    4    2 : tunables   24   12    8 : slabdata      1      1      0
blkdev_requests       22     22    344   11    1 : tunables   54   27    8 : slabdata      2      2      0
blkdev_ioc            43    160     96   40    1 : tunables  120   60    8 : slabdata      4      4      0
fsnotify_event_holder      0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
fsnotify_event         1     34    112   34    1 : tunables  120   60    8 : slabdata      1      1      0
bio-0                 32     40    192   20    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-256             2      2   4096    1    1 : tunables   24   12    8 : slabdata      2      2      0
biovec-128             0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
biovec-64              0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
biovec-16              0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
sock_inode_cache     224    224    576    7    1 : tunables   54   27    8 : slabdata     32     32      0
skbuff_fclone_cache      0      8    448    8    1 : tunables   54   27    8 : slabdata      0      1      0
skbuff_head_cache    156    180    256   15    1 : tunables  120   60    8 : slabdata     12     12      0
file_lock_cache       34     40    192   20    1 : tunables  120   60    8 : slabdata      2      2      0
shmem_inode_cache   1364   1573    592   13    2 : tunables   54   27    8 : slabdata    121    121    135
Acpi-Operand        1432   1484     72   53    1 : tunables  120   60    8 : slabdata     28     28      0
Acpi-ParseExt          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     48   77    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       691    736     40   92    1 : tunables  120   60    8 : slabdata      8      8      0
task_delay_info      169    306    112   34    1 : tunables  120   60    8 : slabdata      9      9      0
taskstats              2     12    328   12    1 : tunables   54   27    8 : slabdata      1      1      0
proc_inode_cache    1188   1188    592    6    1 : tunables   54   27    8 : slabdata    198    198      0
sigqueue              48     48    160   24    1 : tunables  120   60    8 : slabdata      2      2      0
bdev_cache            11     15    768    5    1 : tunables   54   27    8 : slabdata      3      3      0
sysfs_dir_cache     6770   6800    112   34    1 : tunables  120   60    8 : slabdata    200    200      0
mnt_cache             30     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
filp                2362   3285    256   15    1 : tunables  120   60    8 : slabdata    219    219     60
inode_cache          651    651    528    7    1 : tunables   54   27    8 : slabdata     93     93      0
dentry            232248 238440    192   20    1 : tunables  120   60    8 : slabdata  11922  11922      0
names_cache            5      5   4096    1    1 : tunables   24   12    8 : slabdata      5      5      0
key_jar                1     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
buffer_head       376815 406556    104   37    1 : tunables  120   60    8 : slabdata  10988  10988      0
nsproxy                1     77     48   77    1 : tunables  120   60    8 : slabdata      1      1      0
vm_area_struct      4348   4600    168   23    1 : tunables  120   60    8 : slabdata    200    200     60
mm_struct             76     76    896    4    1 : tunables   54   27    8 : slabdata     19     19      0
fs_cache              84    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
files_cache           84    132    704   11    2 : tunables   54   27    8 : slabdata     12     12      0
signal_cache         125    140   1024    4    1 : tunables   54   27    8 : slabdata     35     35      0
sighand_cache        117    126   2112    3    2 : tunables   24   12    8 : slabdata     42     42      0
task_xstate          112    112    512    8    1 : tunables   54   27    8 : slabdata     14     14      0
task_struct          155    155   1472    5    2 : tunables   24   12    8 : slabdata     31     31      0
cred_jar             373    640    192   20    1 : tunables  120   60    8 : slabdata     32     32      0
anon_vma_chain      3520   5005     48   77    1 : tunables  120   60    8 : slabdata     65     65      0
anon_vma            2502   2950     64   59    1 : tunables  120   60    8 : slabdata     50     50      0
pid                  175    240    128   30    1 : tunables  120   60    8 : slabdata      8      8      0
radix_tree_node    28764  29099    560    7    1 : tunables   54   27    8 : slabdata   4157   4157      0
idr_layer_cache      327    357    544    7    1 : tunables   54   27    8 : slabdata     51     51      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            1      1 524288    1  128 : tunables    1    1    0 : slabdata      1      1      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            3      3 131072    1   32 : tunables    8    4    0 : slabdata      3      3      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             5      5  65536    1   16 : tunables    8    4    0 : slabdata      5      5      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             9      9  32768    1    8 : tunables    8    4    0 : slabdata      9      9      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             7      7  16384    1    4 : tunables    8    4    0 : slabdata      7      7      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             23     23   8192    1    2 : tunables    8    4    0 : slabdata     23     23      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            210    210   4096    1    1 : tunables   24   12    8 : slabdata    210    210      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            276    276   2048    2    1 : tunables   24   12    8 : slabdata    138    138      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            920    920   1024    4    1 : tunables   54   27    8 : slabdata    230    230      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             608    608    512    8    1 : tunables   54   27    8 : slabdata     76     76      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             620    795    256   15    1 : tunables  120   60    8 : slabdata     53     53      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
size-192            1545   1960    192   20    1 : tunables  120   60    8 : slabdata     98     98      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             8307  13924     64   59    1 : tunables  120   60    8 : slabdata    236    236      0
size-32(DMA)           0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
size-128            3820   3840    128   30    1 : tunables  120   60    8 : slabdata    128    128      0
size-32             5625   5936     32  112    1 : tunables  120   60    8 : slabdata     53     53      0
kmem_cache           153    160    192   20    1 : tunables  120   60    8 : slabdata      8      8      0

--=-=-=--
