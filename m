Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3AGNtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:49:22 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44445 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3AGNtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:49:21 -0500
MIME-Version: 1.0
In-Reply-To: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
Date: Mon, 7 Jan 2013 21:49:20 +0800
Message-ID: <CAEH94LhFLz2MSK125wJ1MiE6rf7KOS2bixy0zp8R9cP6uDAJtw@mail.gmail.com>
Subject: Re: [PATCH RESEND v1 00/16] vfs: hot data tracking
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com,
        dave@jikos.cz, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com, zwu.kernel@gmail.com,
        wuzhy@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

any comments? Some graphs are generated based on the following benchmark data.

1. fs_mark test
https://github.com/wuzhy/perf_report/commit/8dbc7a00d280d7d7e625e336aac57391fa3e422c

2. ffsb test
1.) large_file_create
https://github.com/wuzhy/perf_report/commit/1582cf3fed06d32ffd93dbe109572a2a2fe2990f

2.) large_file_read
https://github.com/wuzhy/perf_report/commit/3b8a13c02c4b86de349e59215d8dbcdf88c5821c

3.) random_write
https://github.com/wuzhy/perf_report/commit/d4fc2aaa0626d40f72a4a06f8c5b5a10d5a949c3

4.) random_read
https://github.com/wuzhy/perf_report/commit/7e010b4fe193c6cf49c8c946be301ed3d3ac9eae

5.) mail_server
https://github.com/wuzhy/perf_report/commit/225f2b51ae3baab774e7cda6009d3745ec742d18

On Thu, Dec 20, 2012 at 10:43 PM,  <zwu.kernel@gmail.com> wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> HI, guys,
>
>   This patchset has been done scalability or performance tests
> by fs_mark, ffsb and compilebench.
>   I have done the perf testing on Linux 3.7.0-rc8+ with Intel(R) Core(TM)
> i7-3770 CPU @ 3.40GHz with 8 CPUs, 16G ram and 260G disk.
>
>   Any comments or ideas are appreciated, thanks.
>
> NOTE:
>
>   The patchset can be obtained via my kernel dev git on github:
> git://github.com/wuzhy/kernel.git hot_tracking
>   If you're interested, you can also review them via
> https://github.com/wuzhy/kernel/commits/hot_tracking
>
>   For more info, please check hot_tracking.txt in Documentation
>
> Below is the perf testing report:
>
> 1. fs_mark test
>
> w/o: without hot tracking
> w/ : with hot tracking
>
>   Count     Size      FSUse%               Files/sec                     App Overhead
>
>                     w/o    w/           w/o          w/                   w/o        w/
>
>   800000     1       2      3          13756.4     32144.9              5350627    5436291
>  1600000     1       4      5           1163.4      1799.3             20848119   21708216
>  2400000     1       6      6           1360.8      1252.5              6798705    8715322
>  3200000     1       8      8           1600.1      1196.3              5751129    6013792
>  4000000     1       9      9           1071.4      1191.2             17204725   26786369
>  4800000     1      10     10           1483.5      1447.9             19555541    8383046
>  5600000     1      11     11           1457.9      1699.5              5783588   10074681
>  6400000     1      12     13           1658.8      1628.5              6992697    6185551
>  7200000     1      14     14           1662.4      1857.1              5796793   13772592
>  8000000     1      15     15           2930.0      2653.8             12431682    6152573
>  8800000     1      16     17           1630.8      1665.0              7666719   13682765
>  9600000     1      18     18           1530.3      1583.9              5823644   10171644
> 10400000     1      19     19           1437.9      1798.6             20935224    6048083
> 11200000     1      20     20           1529.0      1550.6              6647450    6003151
> 12000000     1      21     22           1558.6      1501.8             12539509   18144939
> 12800000     1      23     23           1644.2      1432.1              7074419   28101975
> 13600000     1      24     24           1753.6      1650.2              7164297   20888972
> 14400000     1      25     25           2750.0      1483.9             12756692    7441225
> 15200000     1      27     27           1551.1      1514.3              5741066    8250443
> 16000000     1      28     28           1610.8      1635.9             72193860    8545285
> 16800000     1      29     29           1646.7      1907.7              8945856   11703513
> 17600000     1      30     31           1496.6      2722.3              5858961    8989393
> 18400000     1      32     32           1457.7      1565.7             10914475   26504660
> 19200000     1      33     33           1437.6      1518.7              6708975  213303618
> 20000000     1      34     34           1825.4      1521.1              5722086   12490907
> 20800000     1      36     35           1718.4      1611.5              5873290   17942534
> 21600000     1      37     37           2152.6      1536.9            113050627    8717940
> 22400000     1      38     38           2443.7      1788.2              7398122   19834765
> 23200000     1      39     39           1518.5      1587.6              5770959   10134882
> 24000000     1      41     41           1536.8      2164.0              5751248    7214626
> 24800000     1      42     42           1576.6      2939.4              7390314    6070271
> 25600000     1      43     43           1707.4      1535.9             11075939    6052896
> 26400000     1      44     44           1522.5      1563.1             10142987   22549898
> 27200000     1      46     46           1827.4      1608.5             11613016   24828125
> 28000000     1      47     47           3420.5      1741.9              8059985   16599156
> 28800000     1      48     48           1815.5      1944.4              7847931    9043277
> 29600000     1      50     49           1650.0      1596.6              5636323    7929164
> 30400000     1      51     51           1683.7      1573.3              5766323   19369146
> 31200000     1      52     52           1610.1      1669.8              9256111    9899107
> 32000000     1      53     53           1645.2      3081.0              7855010    6057257
> 32800000     1      54     55           1835.3      3122.0              6899141    6143875
> 33600000     1      56     56           1916.8      1734.8             10271967    6049509
> 34400000     1      57     57           3119.2      1630.8             11503274   13975417
> 35200000     1      58     58           1629.2      1695.7              6827225    6214248
> 36000000     1      60     60           1636.5      1695.4             38077664   16211067
> 36800000     1      61     61           1665.2      2069.1             19948817    9358494
> 37600000     1      62     62           1734.5      1931.5             26487196    8954836
> 38400000     1      63     63           1625.8      1654.0              6649289    9131844
> 39200000     1      65     65           1778.4      1663.3             11653376    7144960
> 40000000     1      66     66           1851.0      1935.6              8164470   11288753
> 40800000     1      67     67           3171.0      3431.6             12358380    6072820
> 41600000     1      69     69           1714.3      1954.3             13765035    9364495
> 42400000     1      70     70           1591.0      1681.8             18733304    7407689
> 43200000     1      71     71           1537.2      1642.8             19534908    6163018
> 44000000     1      72     72           1630.3      1641.2             23479883   10967509
> 44800000     1      74     74           1877.5      1651.9              8174965    9484587
> 45600000     1      75     75           3322.4      1653.6             14740938    7497831
> 46400000     1      76     76           1706.9      1840.6             10348550   23296562
> 47200000     1      77     78           1837.7      2515.3             13917543   14683192
> 48000000     1      79     79           1642.6      2368.6             14365759    6080942
> 48800000     1      80     80           1827.1      1655.2              9234312    7412406
> 49600000     1      81     81           1631.0      1858.7              7543970   18610881
> 50400000     1      82     82           1560.5      1865.0             21374219    6598771
>
>
> From the above table, when the same count files with same size are created, how FS is full is
> basically same.
>
> 2. FFSB test
>                               w/o hot tracking         w/ hot tracking           ratio
>                                        v1                     v2               (v2-v1)/v1
> large_file_create
>         1 thread
>            - Trans/sec              28918.75               29014.48               +0.33%
>            - Throughput             113MB/sec              113MB/sec              +0.0%
>            - %CPU                     4.8%                    5.1%                +6.3%
>            - Trans/%CPU             602473.96              568911.37              -5.6%
>         8 threads
>            - Trans/sec              28480.37               28541.25               +0.2%
>            - Throughput             111MB/sec              111MB/sec              +0.0%
>            - %CPU                     5.6%                    5.9%                +5.4%
>            - Trans/%CPU             508578.04               483750                -4.9%
>         32 threads
>            - Trans/sec              25011.86               26992.32               +7.9%
>            - Throughput             97.7MB/sec             105MB/sec              +7.5%
>            - %CPU                     6.2%                    7.1%                +14.8%
>            - Trans/%CPU             403417.10              380173.52              -5.8%
>
> large_file_seq_read
>         1 thread
>            - Trans/sec              35303.23               34838.02               -1.3%
>            - Throughput             138MB/sec              136MB/sec              -1.4%
>            - %CPU                     5.4%                    5.4%                +0.0%
>            - Trans/%CPU             653763.52              645148.52              -1.3%
>         8 threads
>            - Trans/sec              11902.82               11205.22               -5.9%
>            - Throughput             46.5MB/sec             43.8MB/sec             -5.8%
>            - %CPU                     2.1%                    2.0%                -4.8%
>            - Trans/%CPU             566800.95                560261               -1.2%
>         32 threads
>            - Trans/sec               5068.48                5316.36               +4.9%
>            - Throughput             19.8MB/sec             20.8MB/sec             +5.1%
>            - %CPU                     0.9%                    1.0%                +11.1%
>            - Trans/%CPU             563164.45                531636               -5.6%
>
> random_write
>         1 thread
>            - Trans/sec                729.01                 738.89               +1.4%
>            - Throughput             99.7MB/sec              101MB/sec             +1.3%
>            - %CPU                     0.1%                    0.1%                +0.0%
>            - Trans/%CPU               72901                  73889                +1.4%
>         8 threads
>            - Trans/sec               714.56                  714.57               +0.0%
>            - Throughput            97.7MB/sec               97.7MB/sec            +0.0%
>            - %CPU                     0.2%                    0.2%                +0.0%
>            - Trans/%CPU               35728                  35728.5              +0.0%
>         32 threads
>            - Trans/sec               698.62                  692.59               -0.9%
>            - Throughput            95.5MB/sec               94.7MB/sec            -0.8%
>            - %CPU                     0.2%                    0.2%                +0.0%
>            - Trans/%CPU               34931                 34629.5               -0.9%
>
> random_read
>         1 thread
>            - Trans/sec               225.49                 227.03                +0.7%
>            - Throughput             902KB/sec               908KB/sec             +0.7%
>            - %CPU                     1.1%                    1.1%                +0.0%
>            - Trans/%CPU             20499.10                20639.10              +0.7%
>         8 threads
>            - Trans/sec               106.72                  105.76               -0.9%
>            - Throughput             427KB/sec               423KB/sec             -0.9%
>            - %CPU                     0.5%                    0.5%                +0.0%
>            - Trans/%CPU              2134.4                  2115.2               -0.9%
>         32 threads
>            - Trans/sec               107.44                  108.26               +0.8%
>            - Throughput             430KB/sec               433KB/sec             +0.7%
>            - %CPU                     0.5%                    0.5%                +0.0%
>            - Trans/%CPU              2148.8                  2165.2               +0.8%
>
> mail_server
>         1 thread
>            - Trans/sec               681.67                  732.66               +7.5%
>            - Throughput [read]      1.77MB/sec              1.99MB/sec            +12.4%
>            - Throughput [write]     858KB/sec               887KB/sec             +3.4%
>            - %CPU                     0.6%                    0.6%                +0.0%
>            - Trans/%CPU             11361.17                 12211                +7.5%
>         8 threads
>            - Trans/sec               630.48                  597.08               -5.3%
>            - Throughput [read]      1.64MB/sec             1.54MB/sec             -6.1%
>            - Throughput [write]     814KB/sec              784KB/sec              -3.7%
>            - %CPU                     0.6%                    0.5%                -16.7%
>            - Trans/%CPU               10508                 11941.6               +13.6%
>         32 threads
>            - Trans/sec               598.68                 566.05                -5.5%
>            - Throughput [read]      1.53MB/sec             1.5MB/sec              -2.0%
>            - Throughput [write]     804KB/sec              705KB/sec              -12.3%
>            - %CPU                     0.7%                    0.6%                -14.2%
>            - Trans/%CPU              8552.57                9434.17               +10.3%
>
> 3. Compilebench test
>
>                         w/o hot tracking        w/ hot tracking            ratio
>                                v1                     v2                 (v2-v1)/v1
> intial create              114.81 MB/s             118.32 MB/s             +3.1%
> create                     11.98 MB/s              12.26 MB/s              +2.3%
> patch                      3.61 MB/s               3.66 MB/s               +1.4%
> compile                    46.40 MB/s              48.07 MB/s              +3.6%
> clean                      126.33 MB/s             128.75 MB/s             +1.9%
> read tree                  9.93 MB/s               9.71 MB/s               -2.2%
> read compiled tree         17.19 MB/s              17.52 MB/s              +1.9%
> delete tree                12.23 seconds           11.13 seconds           -9.0%
> delete compiled tree       12.98 seconds           16.05 seconds           +26.7%
> stat tree                  7.03 seconds            5.51 seconds            -21.6%
> stat compiled tree         12.19 seconds           9.06 seconds            -25.7%
>
> Changelog:
>
>  - Solved 64 bits inode number issue. [David Sterba]
>  - Embed struct hot_type in struct file_system_type [Darrick J. Wong]
>  - Cleanup Some issues [David Sterba]
>  - Use a static hot debugfs root [Greg KH]
>  - Rewritten debugfs support based on seq_file operation. [Dave Chinner]
>  - Refactored workqueue support. [Dave Chinner]
>  - Turn some Micro into be tunable   [Zhiyong, Zheng Liu]
>        TIME_TO_KICK, and HEAT_UPDATE_DELAY
>  - Introduce hot func registering framework [Zhiyong]
>  - Remove global variable for hot tracking [Zhiyong]
>  - Add xfs hot tracking support [Dave Chinner]
>  - Add ext4 hot tracking support [Zheng Liu]
>  - Cleanedup a lot of other issues [Dave Chinner]
>  - Added memory shrinker [Dave Chinner]
>  - Converted to one workqueue to update map info periodically [Dave Chinner]
>  - Cleanedup a lot of other issues [Dave Chinner]
>  - Reduce new files and put all in fs/hot_tracking.[ch] [Dave Chinner]
>  - Add btrfs hot tracking support [Zhiyong]
>  - The first three patches can probably just be flattened into one.
>                                         [Marco Stornelli , Dave Chinner]
>
> Zhi Yong Wu (16):
>   vfs: introduce some data structures
>   vfs: add init and cleanup functions
>   vfs: add I/O frequency update function
>   vfs: add two map arrays
>   vfs: add hooks to enable hot tracking
>   vfs: add temp calculation function
>   vfs: add map info update function
>   vfs: add aging function
>   vfs: add one work queue
>   vfs: add FS hot type support
>   vfs: register one shrinker
>   vfs: add one ioctl interface
>   vfs: add debugfs support
>   proc: add two hot_track proc files
>   btrfs: add hot tracking support
>   vfs: add documentation
>
>  Documentation/filesystems/00-INDEX         |    2 +
>  Documentation/filesystems/hot_tracking.txt |  255 ++++++
>  fs/Makefile                                |    2 +-
>  fs/btrfs/ctree.h                           |    1 +
>  fs/btrfs/super.c                           |   22 +-
>  fs/compat_ioctl.c                          |    5 +
>  fs/dcache.c                                |    2 +
>  fs/direct-io.c                             |    6 +
>  fs/hot_tracking.c                          | 1345 ++++++++++++++++++++++++++++
>  fs/hot_tracking.h                          |   52 ++
>  fs/ioctl.c                                 |   74 ++
>  include/linux/fs.h                         |    5 +
>  include/linux/hot_tracking.h               |  152 ++++
>  kernel/sysctl.c                            |   14 +
>  mm/filemap.c                               |    6 +
>  mm/page-writeback.c                        |   12 +
>  mm/readahead.c                             |    7 +
>  17 files changed, 1960 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/filesystems/hot_tracking.txt
>  create mode 100644 fs/hot_tracking.c
>  create mode 100644 fs/hot_tracking.h
>  create mode 100644 include/linux/hot_tracking.h
>
> --
> 1.7.6.5
>



-- 
Regards,

Zhi Yong Wu
