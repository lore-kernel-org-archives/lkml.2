Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab0JZKen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:34:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41364 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab0JZKej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:34:39 -0400
Subject: [linux-2.6.36-git7: Power7] LTP Memory CGROUP Controller
	functional test creates Backtrace, OOMKill & rcu_sched_state detected stall
	jiffies
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        ltp-list <ltp-list@lists.sf.net>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary="=-og1HV1sqX18JjUauS4s2"
Organization: IBM
Date: Tue, 26 Oct 2010 16:03:56 +0530
Message-Id: <1288089237.5010.9.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-og1HV1sqX18JjUauS4s2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

If you run LTP Memory CGROUP Controller functional test on
linux-2.6.36-git7, the following Backtrace, OOMKill & rcu_sched_state
detected stall jiffies are created. The machine is not reachable
thereafter. Ways to reproduce this problem:

1) Build and boot kernel 2.6.36-git7 on Power7 machine with attached
config file,
2) Fetch, build and install LTP:
	git clone git://ltp.git.sourceforge.net/gitroot/ltp/ltp
	cd ltp
	./configure
	make
	make install
3) Create a LTP runtest file /opt/ltp/runtest/memcg_function_test with
the following entry:
memcg_function          memcg_function_test.sh
<<EOF>>
	cd /opt/ltp
	./runltp -f memcg_function_test

Regards--
Subrata

Memory Cgroup Controller Function test results:
==========================================================
memcg_test_1 invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0,
oom_score_adj=0
memcg_test_1 cpuset=/ mems_allowed=0
Call Trace:
[c00000002065b200] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000002065b2b0] [c000000000156d8c] .dump_header+0xac/0x220
[c00000002065b390] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000002065b470] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000002065b520] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000002065b610] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000002065b760] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000002065b810] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c00000002065b900] [c00000000017dc4c] .__get_user_pages+0x1bc/0x500
[c00000002065ba00] [c000000000180b2c] .__mlock_vma_pages_range+0xdc/0x240
[c00000002065bb50] [c0000000001814b8] .mlock_vma_pages_range+0xb8/0xc0
[c00000002065bbe0] [c000000000184af8] .mmap_region+0x358/0x5c0
[c00000002065bcf0] [c0000000001851f4] .SyS_mmap_pgoff+0x94/0x1a0
[c00000002065bdb0] [c00000000000cb54] .sys_mmap+0x74/0x90
[c00000002065be30] [c000000000008564] syscall_exit+0x0/0x40
Task in /0 killed as a result of limit of /0
memory: usage 0kB, limit 0kB, failcnt 2548
memory+swap: usage 0kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   3
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   3
CPU    6: hi:    6, btch:   1 usd:   4
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   0
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   1
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   5
CPU   15: hi:    6, btch:   1 usd:   3
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   0
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   1
CPU   20: hi:    6, btch:   1 usd:   5
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   5
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:390 inactive_anon:1073 isolated_anon:0
 active_file:1694 inactive_file:1438 isolated_file:0
 unevictable:0 dirty:23 writeback:0 unstable:0
 free:54998 slab_reclaimable:580 slab_unreclaimable:2929
 mapped:236 shmem:1 pagetables:174 bounce:0
Node 0 DMA free:3519872kB min:8128kB low:10112kB high:12160kB active_anon:24960kB inactive_anon:68672kB active_file:108416kB inactive_file:92032kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:1472kB writeback:0kB mapped:15104kB shmem:64kB slab_reclaimable:37120kB slab_unreclaimable:187456kB kernel_stack:4112kB pagetables:11136kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 162*64kB 91*128kB 480*256kB 433*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3520512kB
4258 total pagecache pages
1143 pages in swap cache
Swap cache stats: add 64700, delete 63557, find 39392/46116
Free swap  = 3974720kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3183 pages shared
6337 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[16827]     0 16827       61       25   8       0             0 memcg_test_1
[16828]     0 16828       60       24   0       0             0 memcg_test_1
Memory cgroup out of memory: Kill process 16827 (memcg_test_1) score 1000 or sacrifice child
Killed process 16827 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16828 (memcg_test_1) score 1000 or sacrifice child
Killed process 16828 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16829 (memcg_test_1) score 1000 or sacrifice child
Killed process 16829 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16830 (memcg_test_1) score 1000 or sacrifice child
Killed process 16830 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16831 (memcg_test_1) score 1000 or sacrifice child
Killed process 16831 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16832 (memcg_test_1) score 1000 or sacrifice child
Killed process 16832 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16833 (memcg_test_1) score 1000 or sacrifice child
Killed process 16833 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16834 (memcg_test_1) score 1000 or sacrifice child
Killed process 16834 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16835 (memcg_test_1) score 1000 or sacrifice child
Killed process 16835 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16836 (memcg_test_1) score 1000 or sacrifice child
Killed process 16836 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16837 (memcg_test_1) score 1000 or sacrifice child
Killed process 16837 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16838 (memcg_test_1) score 1000 or sacrifice child
Killed process 16838 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16839 (memcg_test_1) score 1000 or sacrifice child
Killed process 16839 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16840 (memcg_test_1) score 1000 or sacrifice child
Killed process 16840 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16841 (memcg_test_1) score 1000 or sacrifice child
Killed process 16841 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16842 (memcg_test_1) score 1000 or sacrifice child
Killed process 16842 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16843 (memcg_test_1) score 1000 or sacrifice child
Killed process 16843 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16844 (memcg_test_1) score 1000 or sacrifice child
Killed process 16844 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16845 (memcg_test_1) score 1000 or sacrifice child
Killed process 16845 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16846 (memcg_test_1) score 1000 or sacrifice child
Killed process 16846 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16847 (memcg_test_1) score 1000 or sacrifice child
Killed process 16847 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16848 (memcg_test_1) score 1000 or sacrifice child
Killed process 16848 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16849 (memcg_test_1) score 1000 or sacrifice child
Killed process 16849 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16850 (memcg_test_1) score 1000 or sacrifice child
Killed process 16850 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16851 (memcg_test_1) score 1000 or sacrifice child
Killed process 16851 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16852 (memcg_test_1) score 1000 or sacrifice child
Killed process 16852 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16853 (memcg_test_1) score 1000 or sacrifice child
Killed process 16853 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16854 (memcg_test_1) score 1000 or sacrifice child
Killed process 16854 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16855 (memcg_test_1) score 1000 or sacrifice child
Killed process 16855 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16856 (memcg_test_1) score 1000 or sacrifice child
Killed process 16856 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16857 (memcg_test_1) score 1000 or sacrifice child
Killed process 16857 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16858 (memcg_test_1) score 1000 or sacrifice child
Killed process 16858 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16859 (memcg_test_1) score 1000 or sacrifice child
Killed process 16859 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16860 (memcg_test_1) score 1000 or sacrifice child
Killed process 16860 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16861 (memcg_test_1) score 1000 or sacrifice child
Killed process 16861 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16862 (memcg_test_1) score 1000 or sacrifice child
Killed process 16862 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
Memory cgroup out of memory: Kill process 16863 (memcg_test_1) score 1000 or sacrifice child
Killed process 16863 (memcg_test_1) total-vm:3904kB, anon-rss:576kB, file-rss:1024kB
oom_kill_process: 36 callbacks suppressed
swapoff invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
swapoff cpuset=/ mems_allowed=0
Call Trace:
[c00000005f49b560] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000005f49b610] [c000000000156d8c] .dump_header+0xac/0x220
[c00000005f49b6f0] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000005f49b7d0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000005f49b880] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000005f49b970] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000005f49bac0] [c0000000001b88f4] .mem_cgroup_try_charge_swapin+0xc4/0x130
[c00000005f49bb60] [c000000000193bf0] .unuse_mm+0x340/0x520
[c00000005f49bca0] [c0000000001941ec] .SyS_swapoff+0x41c/0xcd0
[c00000005f49be30] [c000000000008564] syscall_exit+0x0/0x40
Task in /0 killed as a result of limit of /0
memory: usage 40960kB, limit 40960kB, failcnt 72
memory+swap: usage 105152kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   1
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   3
CPU    9: hi:    6, btch:   1 usd:   1
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   3
CPU   12: hi:    6, btch:   1 usd:   1
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   1
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   3
CPU   17: hi:    6, btch:   1 usd:   5
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   5
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   5
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:648 inactive_anon:1686 isolated_anon:0
 active_file:1697 inactive_file:1439 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:54033 slab_reclaimable:580 slab_unreclaimable:2921
 mapped:235 shmem:7 pagetables:179 bounce:0
Node 0 DMA free:3458112kB min:8128kB low:10112kB high:12160kB active_anon:41472kB inactive_anon:107904kB active_file:108608kB inactive_file:92096kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:0kB writeback:0kB mapped:15040kB shmem:448kB slab_reclaimable:37120kB slab_unreclaimable:186944kB kernel_stack:4000kB pagetables:11456kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 123*64kB 83*128kB 246*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3457600kB
4504 total pagecache pages
1321 pages in swap cache
Swap cache stats: add 66495, delete 65174, find 39409/46134
Free swap  = -170496kB
Total swap = 0kB
65536 pages RAM
1556 pages reserved
3229 pages shared
7268 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[16897]     0 16897     1614       27   9       0             0 sleep
[16914]     0 16914     1643       65   0       0             0 memcg_test_4.sh
[16916]     0 16916     1660      346  11       0             0 memcg_test_4
[16920]     0 16920     1620       40   8       0             0 swapoff
Memory cgroup out of memory: Kill process 16916 (memcg_test_4) score 1000 or sacrifice child
Killed process 16916 (memcg_test_4) total-vm:106240kB, anon-rss:20800kB, file-rss:1344kB
swapoff invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
swapoff cpuset=/ mems_allowed=0
Call Trace:
[c00000005f49b560] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000005f49b610] [c000000000156d8c] .dump_header+0xac/0x220
[c00000005f49b6f0] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000005f49b7d0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000005f49b880] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000005f49b970] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000005f49bac0] [c0000000001b88f4] .mem_cgroup_try_charge_swapin+0xc4/0x130
[c00000005f49bb60] [c000000000193bf0] .unuse_mm+0x340/0x520
[c00000005f49bca0] [c0000000001941ec] .SyS_swapoff+0x41c/0xcd0
[c00000005f49be30] [c000000000008564] syscall_exit+0x0/0x40
Task in /0 killed as a result of limit of /0
memory: usage 40960kB, limit 40960kB, failcnt 78
memory+swap: usage 105152kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   1
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   3
CPU    9: hi:    6, btch:   1 usd:   1
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   3
CPU   12: hi:    6, btch:   1 usd:   1
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   1
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   3
CPU   17: hi:    6, btch:   1 usd:   5
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   5
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   5
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:648 inactive_anon:1686 isolated_anon:0
 active_file:1697 inactive_file:1439 isolated_file:0
 unevictable:0 dirty:0 writeback:0 unstable:0
 free:54033 slab_reclaimable:580 slab_unreclaimable:2921
 mapped:235 shmem:7 pagetables:179 bounce:0
Node 0 DMA free:3458112kB min:8128kB low:10112kB high:12160kB active_anon:41472kB inactive_anon:107904kB active_file:108608kB inactive_file:92096kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:0kB writeback:0kB mapped:15040kB shmem:448kB slab_reclaimable:37120kB slab_unreclaimable:186944kB kernel_stack:4000kB pagetables:11456kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 123*64kB 83*128kB 246*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3457600kB
4504 total pagecache pages
1321 pages in swap cache
Swap cache stats: add 66495, delete 65174, find 39409/46134
Free swap  = -170496kB
Total swap = 0kB
65536 pages RAM
1556 pages reserved
3229 pages shared
7268 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[16897]     0 16897     1614       27   9       0             0 sleep
[16914]     0 16914     1643       65  10       0             0 memcg_test_4.sh
[16920]     0 16920     1620       40   8       0             0 swapoff
Memory cgroup out of memory: Kill process 16920 (swapoff) score 1000 or sacrifice child
Killed process 16920 (swapoff) total-vm:103680kB, anon-rss:640kB, file-rss:1920kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c00000007a86f480] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000007a86f530] [c000000000156d8c] .dump_header+0xac/0x220
[c00000007a86f610] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000007a86f6f0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000007a86f7a0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000007a86f890] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000007a86f9e0] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000007a86fa90] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c00000007a86fb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c00000007a86fe30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /11 killed as a result of limit of /11
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   3
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   0
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   1
CPU   11: hi:    6, btch:   1 usd:   0
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   5
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   2
CPU   17: hi:    6, btch:   1 usd:   5
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   5
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:441 inactive_anon:1392 isolated_anon:0
 active_file:1719 inactive_file:1441 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:54632 slab_reclaimable:580 slab_unreclaimable:2924
 mapped:231 shmem:16 pagetables:176 bounce:0
Node 0 DMA free:3496448kB min:8128kB low:10112kB high:12160kB active_anon:28224kB inactive_anon:89088kB active_file:110016kB inactive_file:92224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:14784kB shmem:1024kB slab_reclaimable:37120kB slab_unreclaimable:187136kB kernel_stack:3968kB pagetables:11264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 143*64kB 90*128kB 388*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3496128kB
4182 total pagecache pages
1024 pages in swap cache
Swap cache stats: add 66504, delete 65480, find 39419/46147
Free swap  = 4008640kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3166 pages shared
6677 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17264]     0 17264       62       33   2       0             0 memcg_process
Memory cgroup out of memory: Kill process 17264 (memcg_process) score 1000 or sacrifice child
Killed process 17264 (memcg_process) total-vm:3968kB, anon-rss:640kB, file-rss:1472kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000eee4b130] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c0000000eee4b1e0] [c000000000156d8c] .dump_header+0xac/0x220
[c0000000eee4b2c0] [c000000000157488] .oom_kill_process+0x108/0x260
[c0000000eee4b3a0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000eee4b450] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000eee4b540] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c0000000eee4b690] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000eee4b740] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c0000000eee4b7f0] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c0000000eee4b910] [c00000000016be90] .shmem_fault+0x60/0xa0
[c0000000eee4b990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c0000000eee4ba90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c0000000eee4bb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000eee4be30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /12 killed as a result of limit of /12
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   0
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   3
CPU   14: hi:    6, btch:   1 usd:   5
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   3
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   0
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:434 inactive_anon:1392 isolated_anon:0
 active_file:1720 inactive_file:1441 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:54630 slab_reclaimable:580 slab_unreclaimable:2924
 mapped:231 shmem:16 pagetables:172 bounce:0
Node 0 DMA free:3496320kB min:8128kB low:10112kB high:12160kB active_anon:27776kB inactive_anon:89088kB active_file:110080kB inactive_file:92224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:14784kB shmem:1024kB slab_reclaimable:37120kB slab_unreclaimable:187136kB kernel_stack:3952kB pagetables:11008kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 141*64kB 84*128kB 390*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3495744kB
4183 total pagecache pages
1024 pages in swap cache
Swap cache stats: add 66504, delete 65480, find 39419/46147
Free swap  = 4008640kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3177 pages shared
6676 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17280]     0 17280       62       34  16       0             0 memcg_process
Memory cgroup out of memory: Kill process 17280 (memcg_process) score 1000 or sacrifice child
Killed process 17280 (memcg_process) total-vm:3968kB, anon-rss:640kB, file-rss:1536kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000079ab0c0] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c0000000079ab170] [c000000000156d8c] .dump_header+0xac/0x220
[c0000000079ab250] [c000000000157488] .oom_kill_process+0x108/0x260
[c0000000079ab330] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000079ab3e0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000079ab4d0] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c0000000079ab620] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000079ab6d0] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c0000000079ab780] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c0000000079ab8a0] [c00000000016be90] .shmem_fault+0x60/0xa0
[c0000000079ab920] [c00000000038a0a4] .shm_fault+0x34/0x50
[c0000000079ab990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c0000000079aba90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c0000000079abb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000079abe30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /13 killed as a result of limit of /13
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   3
CPU   14: hi:    6, btch:   1 usd:   0
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   1
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   2
CPU   21: hi:    6, btch:   1 usd:   0
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:434 inactive_anon:1392 isolated_anon:0
 active_file:1720 inactive_file:1441 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:54622 slab_reclaimable:580 slab_unreclaimable:2924
 mapped:231 shmem:16 pagetables:176 bounce:0
Node 0 DMA free:3495808kB min:8128kB low:10112kB high:12160kB active_anon:27776kB inactive_anon:89088kB active_file:110080kB inactive_file:92224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:14784kB shmem:1024kB slab_reclaimable:37120kB slab_unreclaimable:187136kB kernel_stack:3952kB pagetables:11264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 142*64kB 82*128kB 389*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3495296kB
4183 total pagecache pages
1024 pages in swap cache
Swap cache stats: add 66504, delete 65480, find 39419/46147
Free swap  = 4008640kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3178 pages shared
6685 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17296]     0 17296       62       33  13       0             0 memcg_process
Memory cgroup out of memory: Kill process 17296 (memcg_process) score 1000 or sacrifice child
Killed process 17296 (memcg_process) total-vm:3968kB, anon-rss:576kB, file-rss:1536kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c00000007d46b200] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000007d46b2b0] [c000000000156d8c] .dump_header+0xac/0x220
[c00000007d46b390] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000007d46b470] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000007d46b520] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000007d46b610] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000007d46b760] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000007d46b810] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c00000007d46b900] [c00000000017dc4c] .__get_user_pages+0x1bc/0x500
[c00000007d46ba00] [c000000000180b2c] .__mlock_vma_pages_range+0xdc/0x240
[c00000007d46bb50] [c0000000001814b8] .mlock_vma_pages_range+0xb8/0xc0
[c00000007d46bbe0] [c000000000184af8] .mmap_region+0x358/0x5c0
[c00000007d46bcf0] [c0000000001851f4] .SyS_mmap_pgoff+0x94/0x1a0
[c00000007d46bdb0] [c00000000000cb54] .sys_mmap+0x74/0x90
[c00000007d46be30] [c000000000008564] syscall_exit+0x0/0x40
Task in /14 killed as a result of limit of /14
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   3
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   0
CPU   14: hi:    6, btch:   1 usd:   3
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   3
CPU   17: hi:    6, btch:   1 usd:   2
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   0
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:443 inactive_anon:1394 isolated_anon:0
 active_file:1721 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:54625 slab_reclaimable:580 slab_unreclaimable:2924
 mapped:231 shmem:18 pagetables:176 bounce:0
Node 0 DMA free:3496000kB min:8128kB low:10112kB high:12160kB active_anon:28352kB inactive_anon:89216kB active_file:110144kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:14784kB shmem:1152kB slab_reclaimable:37120kB slab_unreclaimable:187136kB kernel_stack:3936kB pagetables:11264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 143*64kB 84*128kB 390*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3495872kB
4185 total pagecache pages
1024 pages in swap cache
Swap cache stats: add 66504, delete 65480, find 39419/46147
Free swap  = 4008640kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3174 pages shared
6679 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17312]     0 17312       62       33  16       0             0 memcg_process
Memory cgroup out of memory: Kill process 17312 (memcg_process) score 1000 or sacrifice child
Killed process 17312 (memcg_process) total-vm:3968kB, anon-rss:640kB, file-rss:1472kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000079bf2e0] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c0000000079bf390] [c000000000156d8c] .dump_header+0xac/0x220
[c0000000079bf470] [c000000000157488] .oom_kill_process+0x108/0x260
[c0000000079bf550] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000079bf600] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000079bf6f0] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c0000000079bf840] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000079bf8f0] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c0000000079bf9e0] [c00000000017dc4c] .__get_user_pages+0x1bc/0x500
[c0000000079bfae0] [c000000000180b2c] .__mlock_vma_pages_range+0xdc/0x240
[c0000000079bfc30] [c000000000180e50] .mlock_fixup+0x1c0/0x250
[c0000000079bfcf0] [c0000000001811fc] .do_mlock+0x10c/0x160
[c0000000079bfda0] [c00000000018139c] .SyS_mlock+0xbc/0x120
[c0000000079bfe30] [c000000000008564] syscall_exit+0x0/0x40
Task in /15 killed as a result of limit of /15
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   2
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   2
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   3
CPU   13: hi:    6, btch:   1 usd:   3
CPU   14: hi:    6, btch:   1 usd:   3
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   0
CPU   17: hi:    6, btch:   1 usd:   5
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   5
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:414 inactive_anon:1394 isolated_anon:0
 active_file:1721 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:54657 slab_reclaimable:580 slab_unreclaimable:2924
 mapped:220 shmem:18 pagetables:167 bounce:0
Node 0 DMA free:3498048kB min:8128kB low:10112kB high:12160kB active_anon:26496kB inactive_anon:89216kB active_file:110144kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:14080kB shmem:1152kB slab_reclaimable:37120kB slab_unreclaimable:187136kB kernel_stack:3936kB pagetables:10688kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 154*64kB 84*128kB 391*256kB 434*512kB 306*1024kB 291*2048kB 184*4096kB 96*8192kB 43*16384kB = 3496832kB
4186 total pagecache pages
1024 pages in swap cache
Swap cache stats: add 66504, delete 65480, find 39419/46147
Free swap  = 4008640kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3174 pages shared
6663 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17325]     0 17325       62       33  12       0             0 memcg_process
Memory cgroup out of memory: Kill process 17325 (memcg_process) score 1000 or sacrifice child
Killed process 17325 (memcg_process) total-vm:3968kB, anon-rss:640kB, file-rss:1472kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c00000005f4a7480] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000005f4a7530] [c000000000156d8c] .dump_header+0xac/0x220
[c00000005f4a7610] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000005f4a76f0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000005f4a77a0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000005f4a7890] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000005f4a79e0] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000005f4a7a90] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c00000005f4a7b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c00000005f4a7e30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /16 killed as a result of limit of /16
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   1
CPU    4: hi:    6, btch:   1 usd:   5
CPU    5: hi:    6, btch:   1 usd:   0
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   3
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   3
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   4
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:634 inactive_anon:765 isolated_anon:0
 active_file:1711 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:8 writeback:0 unstable:0
 free:55076 slab_reclaimable:578 slab_unreclaimable:2924
 mapped:236 shmem:38 pagetables:180 bounce:0
Node 0 DMA free:3524864kB min:8128kB low:10112kB high:12160kB active_anon:40576kB inactive_anon:48960kB active_file:109504kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:512kB writeback:0kB mapped:15104kB shmem:2432kB slab_reclaimable:36992kB slab_unreclaimable:187136kB kernel_stack:3936kB pagetables:11520kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 163*64kB 84*128kB 302*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3524288kB
3171 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1556 pages reserved
3242 pages shared
6288 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17342]     0 17342       62       33  17       0             0 memcg_process
Memory cgroup out of memory: Kill process 17342 (memcg_process) score 1000 or sacrifice child
Killed process 17342 (memcg_process) total-vm:3968kB, anon-rss:640kB, file-rss:1472kB
Adding 4095936k swap on /dev/sda6.  Priority:-1 extents:1 across:4095936k 
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c00000007a863130] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000007a8631e0] [c000000000156d8c] .dump_header+0xac/0x220
[c00000007a8632c0] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000007a8633a0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000007a863450] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000007a863540] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000007a863690] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000007a863740] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c00000007a8637f0] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c00000007a863910] [c00000000016be90] .shmem_fault+0x60/0xa0
[c00000007a863990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c00000007a863a90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c00000007a863b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c00000007a863e30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /17 killed as a result of limit of /17
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   0
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   4
CPU   14: hi:    6, btch:   1 usd:   3
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   3
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   2
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:575 inactive_anon:765 isolated_anon:0
 active_file:1712 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:12 writeback:0 unstable:0
 free:55149 slab_reclaimable:578 slab_unreclaimable:2924
 mapped:231 shmem:38 pagetables:168 bounce:0
Node 0 DMA free:3529536kB min:8128kB low:10112kB high:12160kB active_anon:36800kB inactive_anon:48960kB active_file:109568kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:768kB writeback:0kB mapped:14784kB shmem:2432kB slab_reclaimable:36992kB slab_unreclaimable:187136kB kernel_stack:3920kB pagetables:10752kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 168*64kB 94*128kB 311*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3528192kB
3172 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1556 pages reserved
3156 pages shared
6217 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17358]     0 17358       62       33  16       0             0 memcg_process
Memory cgroup out of memory: Kill process 17358 (memcg_process) score 1000 or sacrifice child
Killed process 17358 (memcg_process) total-vm:3968kB, anon-rss:576kB, file-rss:1536kB
Adding 4095936k swap on /dev/sda6.  Priority:-1 extents:1 across:4095936k 
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000206130c0] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c000000020613170] [c000000000156d8c] .dump_header+0xac/0x220
[c000000020613250] [c000000000157488] .oom_kill_process+0x108/0x260
[c000000020613330] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000206133e0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000206134d0] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c000000020613620] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000206136d0] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c000000020613780] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c0000000206138a0] [c00000000016be90] .shmem_fault+0x60/0xa0
[c000000020613920] [c00000000038a0a4] .shm_fault+0x34/0x50
[c000000020613990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c000000020613a90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c000000020613b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c000000020613e30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /18 killed as a result of limit of /18
memory: usage 64kB, limit 64kB, failcnt 8
memory+swap: usage 64kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   2
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   3
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   1
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   1
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   1
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:571 inactive_anon:765 isolated_anon:0
 active_file:1712 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:12 writeback:0 unstable:0
 free:55133 slab_reclaimable:578 slab_unreclaimable:2924
 mapped:231 shmem:38 pagetables:175 bounce:0
Node 0 DMA free:3528512kB min:8128kB low:10112kB high:12160kB active_anon:36544kB inactive_anon:48960kB active_file:109568kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:768kB writeback:0kB mapped:14784kB shmem:2432kB slab_reclaimable:36992kB slab_unreclaimable:187136kB kernel_stack:3920kB pagetables:11200kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 167*64kB 95*128kB 312*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3528512kB
3172 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1556 pages reserved
3160 pages shared
6210 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17375]     0 17375       62       33   0       0             0 memcg_process
Memory cgroup out of memory: Kill process 17375 (memcg_process) score 1000 or sacrifice child
Killed process 17375 (memcg_process) total-vm:3968kB, anon-rss:576kB, file-rss:1536kB
Adding 4095936k swap on /dev/sda6.  Priority:-1 extents:1 across:4095936k 
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000f9887480] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c0000000f9887530] [c000000000156d8c] .dump_header+0xac/0x220
[c0000000f9887610] [c000000000157488] .oom_kill_process+0x108/0x260
[c0000000f98876f0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000f98877a0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000f9887890] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c0000000f98879e0] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000f9887a90] [c00000000017d854] .handle_mm_fault+0x8f4/0xb30
[c0000000f9887b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000f9887e30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /19 killed as a result of limit of /19
memory: usage 0kB, limit 0kB, failcnt 7
memory+swap: usage 0kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   4
CPU    4: hi:    6, btch:   1 usd:   2
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   5
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   2
CPU   15: hi:    6, btch:   1 usd:   5
CPU   16: hi:    6, btch:   1 usd:   3
CPU   17: hi:    6, btch:   1 usd:   4
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   0
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   0
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:585 inactive_anon:767 isolated_anon:0
 active_file:1713 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:12 writeback:0 unstable:0
 free:55128 slab_reclaimable:578 slab_unreclaimable:2924
 mapped:231 shmem:40 pagetables:176 bounce:0
Node 0 DMA free:3528192kB min:8128kB low:10112kB high:12160kB active_anon:37440kB inactive_anon:49088kB active_file:109632kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:768kB writeback:0kB mapped:14784kB shmem:2560kB slab_reclaimable:36992kB slab_unreclaimable:187136kB kernel_stack:3904kB pagetables:11264kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 166*64kB 95*128kB 312*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3528448kB
3175 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 4095936kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3153 pages shared
6205 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17391]     0 17391       61       32  16       0             0 memcg_process
Memory cgroup out of memory: Kill process 17391 (memcg_process) score 1000 or sacrifice child
Killed process 17391 (memcg_process) total-vm:3904kB, anon-rss:576kB, file-rss:1472kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c00000003fdd3130] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c00000003fdd31e0] [c000000000156d8c] .dump_header+0xac/0x220
[c00000003fdd32c0] [c000000000157488] .oom_kill_process+0x108/0x260
[c00000003fdd33a0] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c00000003fdd3450] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c00000003fdd3540] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c00000003fdd3690] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c00000003fdd3740] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c00000003fdd37f0] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c00000003fdd3910] [c00000000016be90] .shmem_fault+0x60/0xa0
[c00000003fdd3990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c00000003fdd3a90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c00000003fdd3b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c00000003fdd3e30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /20 killed as a result of limit of /20
memory: usage 0kB, limit 0kB, failcnt 7
memory+swap: usage 0kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   2
CPU    5: hi:    6, btch:   1 usd:   3
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   3
CPU    9: hi:    6, btch:   1 usd:   5
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   5
CPU   14: hi:    6, btch:   1 usd:   5
CPU   15: hi:    6, btch:   1 usd:   0
CPU   16: hi:    6, btch:   1 usd:   5
CPU   17: hi:    6, btch:   1 usd:   2
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   0
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   5
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:574 inactive_anon:767 isolated_anon:0
 active_file:1713 inactive_file:1440 isolated_file:0
 unevictable:0 dirty:12 writeback:0 unstable:0
 free:55136 slab_reclaimable:578 slab_unreclaimable:2924
 mapped:231 shmem:40 pagetables:171 bounce:0
Node 0 DMA free:3528704kB min:8128kB low:10112kB high:12160kB active_anon:36736kB inactive_anon:49088kB active_file:109632kB inactive_file:92160kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:768kB writeback:0kB mapped:14784kB shmem:2560kB slab_reclaimable:36992kB slab_unreclaimable:187136kB kernel_stack:3904kB pagetables:10944kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 156*64kB 95*128kB 312*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3527808kB
3175 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 4095936kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3153 pages shared
6223 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17404]     0 17404       61       32   8       0             0 memcg_process
Memory cgroup out of memory: Kill process 17404 (memcg_process) score 1000 or sacrifice child
Killed process 17404 (memcg_process) total-vm:3904kB, anon-rss:576kB, file-rss:1472kB
memcg_process invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0, oom_score_adj=0
memcg_process cpuset=/ mems_allowed=0
Call Trace:
[c0000000079db0c0] [c000000000014c64] .show_stack+0x74/0x1c0 (unreliable)
[c0000000079db170] [c000000000156d8c] .dump_header+0xac/0x220
[c0000000079db250] [c000000000157488] .oom_kill_process+0x108/0x260
[c0000000079db330] [c000000000157ca4] .mem_cgroup_out_of_memory+0xb4/0xf0
[c0000000079db3e0] [c0000000001b7ab0] .mem_cgroup_handle_oom+0x220/0x230
[c0000000079db4d0] [c0000000001b814c] .__mem_cgroup_try_charge+0x68c/0x6b0
[c0000000079db620] [c0000000001b8a60] .mem_cgroup_charge_common+0x60/0xb0
[c0000000079db6d0] [c0000000001b8c3c] .mem_cgroup_cache_charge+0x18c/0x1f0
[c0000000079db780] [c00000000016ba74] .shmem_getpage+0x974/0xd30
[c0000000079db8a0] [c00000000016be90] .shmem_fault+0x60/0xa0
[c0000000079db920] [c00000000038a0a4] .shm_fault+0x34/0x50
[c0000000079db990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c0000000079dba90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c0000000079dbb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000079dbe30] [c00000000000522c] handle_page_fault+0x20/0x74
Task in /21 killed as a result of limit of /21
memory: usage 0kB, limit 0kB, failcnt 7
memory+swap: usage 0kB, limit 9007199254740991kB, failcnt 0
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   5
CPU    6: hi:    6, btch:   1 usd:   5
CPU    7: hi:    6, btch:   1 usd:   5
CPU    8: hi:    6, btch:   1 usd:   5
CPU    9: hi:    6, btch:   1 usd:   3
CPU   10: hi:    6, btch:   1 usd:   5
CPU   11: hi:    6, btch:   1 usd:   5
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   3
CPU   14: hi:    6, btch:   1 usd:   5
CPU   15: hi:    6, btch:   1 usd:   4
CPU   16: hi:    6, btch:   1 usd:   0
CPU   17: hi:    6, btch:   1 usd:   5
CPU   18: hi:    6, btch:   1 usd:   5
CPU   19: hi:    6, btch:   1 usd:   5
CPU   20: hi:    6, btch:   1 usd:   4
CPU   21: hi:    6, btch:   1 usd:   5
CPU   22: hi:    6, btch:   1 usd:   5
CPU   23: hi:    6, btch:   1 usd:   5
active_anon:586 inactive_anon:767 isolated_anon:0
 active_file:1713 inactive_file:1441 isolated_file:0
 unevictable:0 dirty:12 writeback:0 unstable:0
 free:55111 slab_reclaimable:578 slab_unreclaimable:2925
 mapped:231 shmem:40 pagetables:175 bounce:0
Node 0 DMA free:3527104kB min:8128kB low:10112kB high:12160kB active_anon:37504kB inactive_anon:49088kB active_file:109632kB inactive_file:92224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4190720kB mlocked:0kB dirty:768kB writeback:0kB mapped:14784kB shmem:2560kB slab_reclaimable:36992kB slab_unreclaimable:187200kB kernel_stack:3904kB pagetables:11200kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 148*64kB 90*128kB 312*256kB 439*512kB 312*1024kB 297*2048kB 187*4096kB 98*8192kB 43*16384kB = 3526656kB
3176 total pagecache pages
0 pages in swap cache
Swap cache stats: add 66844, delete 66844, find 39419/46147
Free swap  = 4095936kB
Total swap = 4095936kB
65536 pages RAM
1556 pages reserved
3154 pages shared
6240 pages non-shared
[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
[17417]     0 17417       61       32  12       0             0 memcg_process
Memory cgroup out of memory: Kill process 17417 (memcg_process) score 1000 or sacrifice child
Killed process 17417 (memcg_process) total-vm:3904kB, anon-rss:576kB, file-rss:1472kB
-- 0:conmux-control -- time-stamp -- Oct/26/10  0:05:55 --
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:01:02 --
INFO: rcu_sched_state detected stall on CPU 8 (t=6000 jiffies)
INFO: task rcu_torture_fak:88 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcu_torture_f D 0000000000000000     0    88      2 0x00008000
Call Trace:
[c0000000fcab3690] [c0000000fcab3740] 0xc0000000fcab3740 (unreliable)
[c0000000fcab3860] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000fcab38f0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000fcab3a60] [c0000000006ec0d4] .schedule_timeout+0x234/0x330
[c0000000fcab3bb0] [c0000000006ebce4] .wait_for_common+0x154/0x1b0
[c0000000fcab3c80] [c00000000011c800] .synchronize_sched+0x60/0x80
[c0000000fcab3d70] [c000000000117bc0] .synchronize_rcu+0x10/0x30
[c0000000fcab3de0] [c000000000118ed8] .rcu_torture_fakewriter+0xc8/0x190
[c0000000fcab3e90] [c0000000000b6b0c] .kthread+0xbc/0xd0
[c0000000fcab3f90] [c000000000032164] .kernel_thread+0x54/0x70
no locks held by rcu_torture_fak/88.
INFO: task rcu_torture_fak:89 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcu_torture_f D 0000000000000000     0    89      2 0x00008000
Call Trace:
[c0000000fcab7690] [c0000000fcab7740] 0xc0000000fcab7740 (unreliable)
[c0000000fcab7860] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000fcab78f0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000fcab7a60] [c0000000006ec0d4] .schedule_timeout+0x234/0x330
[c0000000fcab7bb0] [c0000000006ebce4] .wait_for_common+0x154/0x1b0
[c0000000fcab7c80] [c00000000011c800] .synchronize_sched+0x60/0x80
[c0000000fcab7d70] [c000000000117bc0] .synchronize_rcu+0x10/0x30
[c0000000fcab7de0] [c000000000118ed8] .rcu_torture_fakewriter+0xc8/0x190
[c0000000fcab7e90] [c0000000000b6b0c] .kthread+0xbc/0xd0
[c0000000fcab7f90] [c000000000032164] .kernel_thread+0x54/0x70
no locks held by rcu_torture_fak/89.
INFO: task rcu_torture_fak:90 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcu_torture_f D 0000000000000000     0    90      2 0x00008000
Call Trace:
[c0000000fcabb690] [c0000000fcabb740] 0xc0000000fcabb740 (unreliable)
[c0000000fcabb860] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000fcabb8f0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000fcabba60] [c0000000006ec0d4] .schedule_timeout+0x234/0x330
[c0000000fcabbbb0] [c0000000006ebce4] .wait_for_common+0x154/0x1b0
[c0000000fcabbc80] [c00000000011c800] .synchronize_sched+0x60/0x80
[c0000000fcabbd70] [c000000000117bc0] .synchronize_rcu+0x10/0x30
[c0000000fcabbde0] [c000000000118ed8] .rcu_torture_fakewriter+0xc8/0x190
[c0000000fcabbe90] [c0000000000b6b0c] .kthread+0xbc/0xd0
[c0000000fcabbf90] [c000000000032164] .kernel_thread+0x54/0x70
no locks held by rcu_torture_fak/90.
INFO: task rcu_torture_fak:91 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcu_torture_f D 0000000000000000     0    91      2 0x00008000
Call Trace:
[c0000000fcabf690] [c0000000fcabf740] 0xc0000000fcabf740 (unreliable)
[c0000000fcabf860] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000fcabf8f0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000fcabfa60] [c0000000006ec0d4] .schedule_timeout+0x234/0x330
[c0000000fcabfbb0] [c0000000006ebce4] .wait_for_common+0x154/0x1b0
[c0000000fcabfc80] [c00000000011c800] .synchronize_sched+0x60/0x80
[c0000000fcabfd70] [c000000000117bc0] .synchronize_rcu+0x10/0x30
[c0000000fcabfde0] [c000000000118ed8] .rcu_torture_fakewriter+0xc8/0x190
[c0000000fcabfe90] [c0000000000b6b0c] .kthread+0xbc/0xd0
[c0000000fcabff90] [c000000000032164] .kernel_thread+0x54/0x70
no locks held by rcu_torture_fak/91.
INFO: task kjournald:571 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D 0000000000000000     0   571      2 0x00008000
Call Trace:
[c0000000093c3550] [c0000000093c3600] 0xc0000000093c3600 (unreliable)
[c0000000093c3720] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000093c37b0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000093c3920] [c0000000006eba00] .io_schedule+0x90/0x110
[c0000000093c39b0] [c0000000001f7c98] .sync_buffer+0x68/0x80
[c0000000093c3a20] [c0000000006ec4d4] .__wait_on_bit+0xb4/0x130
[c0000000093c3ad0] [c0000000006ec5c0] .out_of_line_wait_on_bit+0x70/0x90
[c0000000093c3bb0] [c0000000001f7ae0] .__wait_on_buffer+0x30/0x50
[c0000000093c3c30] [c0000000002c8aec] .journal_commit_transaction+0x82c/0x1670
[c0000000093c3db0] [c0000000002cd6bc] .kjournald+0x10c/0x2e0
[c0000000093c3e90] [c0000000000b6b0c] .kthread+0xbc/0xd0
[c0000000093c3f90] [c000000000032164] .kernel_thread+0x54/0x70
no locks held by kjournald/571.
INFO: task master:1451 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
master        D 00000fffa4b92434     0  1451      1 0x00008080
Call Trace:
[c000000006d2b430] [c000000006d2b4e0] 0xc000000006d2b4e0 (unreliable)
[c000000006d2b600] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c000000006d2b690] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c000000006d2b800] [c0000000006eba00] .io_schedule+0x90/0x110
[c000000006d2b890] [c0000000001537d4] .sync_page+0x74/0xa0
[c000000006d2b910] [c0000000006ec2d4] .__wait_on_bit_lock+0xd4/0x190
[c000000006d2b9d0] [c000000000153714] .__lock_page+0x54/0x70
[c000000006d2ba90] [c00000000017da74] .handle_mm_fault+0xb14/0xb30
[c000000006d2bb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c000000006d2be30] [c00000000000522c] handle_page_fault+0x20/0x74
1 lock held by master/1451:
 #0:  (&mm->mmap_sem){......}, at: [<c0000000006f1b1c>] .do_page_fault+0x1dc/0x780
INFO: task abrtd:1462 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
abrtd         D 00000fff8d8873c0     0  1462      1 0x00008080
Call Trace:
[c0000000fb7a2b40] [c0000000fb7a2bf0] 0xc0000000fb7a2bf0 (unreliable)
[c0000000fb7a2d10] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000fb7a2da0] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000fb7a2f10] [c0000000006eba00] .io_schedule+0x90/0x110
[c0000000fb7a2fa0] [c0000000001537d4] .sync_page+0x74/0xa0
[c0000000fb7a3020] [c0000000006ec2d4] .__wait_on_bit_lock+0xd4/0x190
[c0000000fb7a30e0] [c000000000153714] .__lock_page+0x54/0x70
[c0000000fb7a31a0] [c0000000001539f8] .find_lock_page+0xb8/0xe0
[c0000000fb7a3240] [c000000000154514] .filemap_fault+0x1e4/0x490
[c0000000fb7a3310] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c0000000fb7a3410] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c0000000fb7a3500] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000fb7a37b0] [c00000000000522c] handle_page_fault+0x20/0x74
--- Exception: 301 at .__strncpy_from_user+0x14/0x3c
    LR = .getname+0x114/0x260
[c0000000fb7a3aa0] [c0000000001ced70] .getname+0xe0/0x260 (unreliable)
[c0000000fb7a3b40] [c0000000001d1b10] .user_path_at+0x30/0xb0
[c0000000fb7a3c90] [c0000000001c5824] .vfs_fstatat+0x44/0xb0
[c0000000fb7a3d30] [c0000000001c5ac4] .SyS_newstat+0x24/0x50
[c0000000fb7a3e30] [c000000000008564] syscall_exit+0x0/0x40
1 lock held by abrtd/1462:
 #0:  (&mm->mmap_sem){......}, at: [<c0000000006f1b1c>] .do_page_fault+0x1dc/0x780
INFO: task crond:1470 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
crond         D 00000000550575a8     0  1470      1 0x00008080
Call Trace:
[c0000000070031c0] [c000000007003270] 0xc000000007003270 (unreliable)
[c000000007003390] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c000000007003420] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c000000007003590] [c0000000006eba00] .io_schedule+0x90/0x110
[c000000007003620] [c0000000001537d4] .sync_page+0x74/0xa0
[c0000000070036a0] [c0000000006ec2d4] .__wait_on_bit_lock+0xd4/0x190
[c000000007003760] [c000000000153714] .__lock_page+0x54/0x70
[c000000007003820] [c0000000001539f8] .find_lock_page+0xb8/0xe0
[c0000000070038c0] [c000000000154514] .filemap_fault+0x1e4/0x490
[c000000007003990] [c00000000017a4ac] .__do_fault+0xac/0x6d0
[c000000007003a90] [c00000000017d0ac] .handle_mm_fault+0x14c/0xb30
[c000000007003b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c000000007003e30] [c00000000000522c] handle_page_fault+0x20/0x74
1 lock held by crond/1470:
 #0:  (&mm->mmap_sem){......}, at: [<c0000000006f1b1c>] .do_page_fault+0x1dc/0x780
INFO: task memcg_process_s:17690 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
memcg_process D 0000000010000ac8     0 17690  17665 0x00008080
Call Trace:
[c0000000079ae800] [c0000000079ae8b0] 0xc0000000079ae8b0 (unreliable)
[c0000000079ae9d0] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c0000000079aea60] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c0000000079aebd0] [c0000000006eba00] .io_schedule+0x90/0x110
[c0000000079aec60] [c0000000003df57c] .get_request_wait+0x15c/0x230
[c0000000079aed70] [c0000000003df9f0] .__make_request+0x90/0x680
[c0000000079aee30] [c0000000003dd400] .generic_make_request+0x340/0x520
[c0000000079aef40] [c0000000003dd674] .submit_bio+0x94/0x130
[c0000000079af010] [c00000000018feb0] .swap_writepage+0xb0/0x130
[c0000000079af0a0] [c00000000016652c] .pageout+0x1bc/0x420
[c0000000079af180] [c00000000016777c] .shrink_page_list+0x38c/0x640
[c0000000079af2b0] [c000000000167e60] .shrink_inactive_list+0x130/0x4d0
[c0000000079af3c0] [c0000000001688e0] .shrink_zone+0x300/0x500
[c0000000079af4e0] [c000000000169da0] .do_try_to_free_pages+0x110/0x4e0
[c0000000079af5d0] [c00000000016a4ec] .try_to_free_pages+0xbc/0x1a0
[c0000000079af6e0] [c00000000015d820] .__alloc_pages_nodemask+0x540/0x940
[c0000000079af860] [c00000000019eb68] .alloc_page_vma+0x98/0x1d0
[c0000000079af900] [c000000000190480] .read_swap_cache_async+0x160/0x1e0
[c0000000079af9d0] [c000000000190594] .swapin_readahead+0x94/0xe0
[c0000000079afa90] [c00000000017d5c4] .handle_mm_fault+0x664/0xb30
[c0000000079afb80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c0000000079afe30] [c00000000000522c] handle_page_fault+0x20/0x74
1 lock held by memcg_process_s/17690:
 #0:  (&mm->mmap_sem){......}, at: [<c0000000006f1b1c>] .do_page_fault+0x1dc/0x780
INFO: task memcg_process_s:17692 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
memcg_process D 0000000010000ac8     0 17692  17665 0x00008080
Call Trace:
[c00000007d402800] [c00000007d4028b0] 0xc00000007d4028b0 (unreliable)
[c00000007d4029d0] [c000000000015c50] .__switch_to+0xe0/0x1a0
[c00000007d402a60] [c0000000006eb1f4] .schedule+0x3f4/0xb70
[c00000007d402bd0] [c0000000006eba00] .io_schedule+0x90/0x110
[c00000007d402c60] [c0000000003df57c] .get_request_wait+0x15c/0x230
[c00000007d402d70] [c0000000003df9f0] .__make_request+0x90/0x680
[c00000007d402e30] [c0000000003dd400] .generic_make_request+0x340/0x520
[c00000007d402f40] [c0000000003dd674] .submit_bio+0x94/0x130
[c00000007d403010] [c00000000018feb0] .swap_writepage+0xb0/0x130
[c00000007d4030a0] [c00000000016652c] .pageout+0x1bc/0x420
[c00000007d403180] [c00000000016777c] .shrink_page_list+0x38c/0x640
[c00000007d4032b0] [c000000000167e60] .shrink_inactive_list+0x130/0x4d0
[c00000007d4033c0] [c0000000001688e0] .shrink_zone+0x300/0x500
[c00000007d4034e0] [c000000000169da0] .do_try_to_free_pages+0x110/0x4e0
[c00000007d4035d0] [c00000000016a4ec] .try_to_free_pages+0xbc/0x1a0
[c00000007d4036e0] [c00000000015d820] .__alloc_pages_nodemask+0x540/0x940
[c00000007d403860] [c00000000019eb68] .alloc_page_vma+0x98/0x1d0
[c00000007d403900] [c000000000190480] .read_swap_cache_async+0x160/0x1e0
[c00000007d4039d0] [c000000000190594] .swapin_readahead+0x94/0xe0
[c00000007d403a90] [c00000000017d5c4] .handle_mm_fault+0x664/0xb30
[c00000007d403b80] [c0000000006f1c84] .do_page_fault+0x344/0x780
[c00000007d403e30] [c00000000000522c] handle_page_fault+0x20/0x74
1 lock held by memcg_process_s/17692:
 #0:  (&mm->mmap_sem){......}, at: [<c0000000006f1b1c>] .do_page_fault+0x1dc/0x780
INFO: rcu_sched_state detected stall on CPU 8 (t=24030 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:06:01 --
INFO: rcu_sched_state detected stall on CPU 8 (t=42060 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:09:02 --
INFO: rcu_sched_state detected stall on CPU 8 (t=60090 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:12:02 --
INFO: rcu_sched_state detected stall on CPU 8 (t=78120 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:15:02 --
INFO: rcu_sched_state detected stall on CPU 8 (t=96150 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:18:03 --
INFO: rcu_sched_state detected stall on CPU 8 (t=114180 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:21:03 --
INFO: rcu_sched_state detected stall on CPU 8 (t=132210 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:24:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=150240 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:27:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=168270 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:30:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=186300 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:33:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=204330 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:36:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=222360 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:39:04 --
INFO: rcu_sched_state detected stall on CPU 8 (t=240390 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:42:06 --
INFO: rcu_sched_state detected stall on CPU 8 (t=258420 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:45:06 --
INFO: rcu_sched_state detected stall on CPU 8 (t=276450 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:48:06 --
INFO: rcu_sched_state detected stall on CPU 8 (t=294480 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:51:06 --
INFO: rcu_sched_state detected stall on CPU 8 (t=312510 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  1:54:06 --
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:04:14 --
INFO: rcu_sched_state detected stall on CPU 0 (t=6000 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:06:13 --
INFO: rcu_sched_state detected stall on CPU 0 (t=24030 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:09:13 --
INFO: rcu_sched_state detected stall on CPU 0 (t=42060 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:12:14 --
INFO: rcu_sched_state detected stall on CPU 0 (t=60090 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:15:15 --
INFO: rcu_sched_state detected stall on CPU 0 (t=78120 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:18:15 --
INFO: rcu_sched_state detected stall on CPU 0 (t=96150 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:21:15 --
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:25:53 --
INFO: rcu_sched_state detected stall on CPU 20 (t=6000 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:27:53 --
INFO: rcu_sched_state detected stall on CPU 20 (t=24030 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:30:53 --
INFO: rcu_sched_state detected stall on CPU 20 (t=42060 jiffies)
-- 0:conmux-control -- time-stamp -- Oct/26/10  2:33:53 --
INFO: rcu_sched_state detected stall on CPU 20 (t=60090 jiffies)
==========================================================


--=-og1HV1sqX18JjUauS4s2
Content-Disposition: attachment; filename=linux-2.6.36-git7-config-power7
Content-Type: text/plain; name=linux-2.6.36-git7-config-power7; charset=UTF-8
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.36-git7
# Tue Oct 26 01:18:30 2010
#
CONFIG_PPC64=y

#
# Processor support
#
CONFIG_PPC_BOOK3S_64=y
# CONFIG_PPC_BOOK3E_64 is not set
CONFIG_PPC_BOOK3S=y
CONFIG_POWER4_ONLY=y
CONFIG_POWER4=y
# CONFIG_TUNE_CELL is not set
CONFIG_PPC_FPU=y
CONFIG_ALTIVEC=y
CONFIG_VSX=y
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_64=y
CONFIG_PPC_MM_SLICES=y
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_PPC_HAVE_PMU_SUPPORT=y
CONFIG_PPC_PERF_CTRS=y
CONFIG_SMP=y
CONFIG_NR_CPUS=1024
CONFIG_64BIT=y
CONFIG_WORD_SIZE=64
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_MMU=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_IRQ_PER_CPU=y
CONFIG_NR_IRQS=512
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_ARCH_HAS_ILOG2_U64=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_PPC_UDBG_16550=y
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_DEFAULT_UIMAGE is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
# CONFIG_PPC_OF_PLATFORM_PCI is not set
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_HAVE_GENERIC_HARDIRQS is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=19
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_SYSCALL_WRAPPERS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y
CONFIG_PPC_MSI_BITMAP=y

#
# Platform support
#
CONFIG_PPC_PSERIES=y
CONFIG_PPC_SPLPAR=y
CONFIG_EEH=y
CONFIG_PSERIES_MSI=y
CONFIG_SCANLOG=y
CONFIG_LPARCFG=y
CONFIG_PPC_SMLPAR=y
CONFIG_CMM=y
CONFIG_DTL=y
# CONFIG_PPC_ISERIES is not set
# CONFIG_PPC_PMAC is not set
# CONFIG_PPC_MAPLE is not set
CONFIG_PPC_PASEMI=y

#
# PA Semi PWRficient options
#
CONFIG_PPC_PASEMI_IOMMU=y
# CONFIG_PPC_PASEMI_IOMMU_DMA_FORCE is not set
CONFIG_PPC_PASEMI_MDIO=m
# CONFIG_PPC_PS3 is not set
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PPC_IBM_CELL_BLADE is not set
# CONFIG_PPC_CELLEB is not set
# CONFIG_PPC_CELL_QPACE is not set
# CONFIG_PQ2ADS is not set
CONFIG_KVM_GUEST=y
CONFIG_PPC_NATIVE=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
# CONFIG_UDBG_RTAS_CONSOLE is not set
CONFIG_XICS=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_MPIC_WEIRD is not set
CONFIG_PPC_I8259=y
# CONFIG_U3_DART is not set
CONFIG_PPC_RTAS=y
CONFIG_RTAS_ERROR_LOGGING=y
CONFIG_PPC_RTAS_DAEMON=y
CONFIG_RTAS_PROC=y
CONFIG_RTAS_FLASH=y
# CONFIG_MMIO_NVRAM is not set
# CONFIG_MPIC_U3_HT_IRQS is not set
CONFIG_MPIC_BROKEN_REGREAD=y
CONFIG_IBMVIO=y
CONFIG_IBMEBUS=y
# CONFIG_PPC_MPC106 is not set
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_INDIRECT_IO is not set
# CONFIG_GENERIC_IOMAP is not set
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPU Frequency drivers
#
CONFIG_PPC_PASEMI_CPUFREQ=y
# CONFIG_FSL_ULI1575 is not set
CONFIG_SIMPLE_GPIO=y

#
# Kernel options
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HUGETLB_PAGE_SIZE_VARIABLE=y
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_PHYP_DUMP is not set
CONFIG_IRQ_ALL_CPUS=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=8
CONFIG_MAX_ACTIVE_REGIONS=256
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SYS_SUPPORTS_HUGETLBFS=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_PPC_HAS_HASH_64K=y
# CONFIG_PPC_4K_PAGES is not set
CONFIG_PPC_64K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=9
CONFIG_PPC_SUBPAGE_PROT=y
CONFIG_SCHED_SMT=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
# CONFIG_PM_OPP is not set
# CONFIG_SECCOMP is not set
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
# CONFIG_PPC_INDIRECT_PCI is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_IOV=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_ELECTRA_CF=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_HOTPLUG_PCI_RPA=y
CONFIG_HOTPLUG_PCI_RPA_DLPAR=y
# CONFIG_HAS_RAPIDIO is not set
CONFIG_RELOCATABLE=y
CONFIG_PAGE_OFFSET=0xc000000000000000
CONFIG_KERNEL_START=0xc000000000000000
CONFIG_PHYSICAL_START=0x00000000
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=m
# CONFIG_PHONET_PIPECTRLR is not set
CONFIG_IEEE802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_RPS=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_MSCAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SJA1000_OF_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_PLX_PCI is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_PHYSMAP_OF=m
CONFIG_MTD_PCI=m
# CONFIG_MTD_PCMCIA is not set
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_PASEMI=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_NAND_FSL_ELBC is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_DTC=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_GPIO=y
CONFIG_OF_I2C=m
CONFIG_OF_MDIO=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_ISL29003=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_BE2ISCSI=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_IBMVSCSI=y
CONFIG_SCSI_IBMVFC=m
CONFIG_SCSI_IBMVFC_TRACE=y
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
# CONFIG_PCMCIA_FDOMAIN is not set
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_OF_PLATFORM=m
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_WINDFARM is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set
CONFIG_MII=m
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM63XX_PHY is not set
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_ETHOC=m
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_HP100 is not set
CONFIG_IBMVETH=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
# CONFIG_KS8851_MLL is not set
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGBVF=m
CONFIG_NS83820=m
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_CNIC=m
# CONFIG_XILINX_LL_TEMAC is not set
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=m
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4_DEPENDS=y
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4VF_DEPENDS=y
# CONFIG_CHELSIO_T4VF is not set
CONFIG_EHEA=y
CONFIG_ENIC=m
CONFIG_IXGBE=m
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_IXGB=m
CONFIG_S2IO=m
CONFIG_VXGE=m
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_PASEMI_MAC=m
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
# CONFIG_QLCNIC is not set
CONFIG_QLGE=m
# CONFIG_BNA is not set
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_BE2NET=m
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS_THINFIRM=m
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
# CONFIG_ATH9K_HTC is not set
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
# CONFIG_CARL9170 is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWM=m
# CONFIG_IWM_DEBUG is not set
# CONFIG_IWM_TRACING is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=m
# CONFIG_HERMES_PRISM is not set
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
# CONFIG_ORINOCO_USB is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI_PCI=y
# CONFIG_RT2800PCI is not set
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_WL1251=m
CONFIG_WL1251_SDIO=m
CONFIG_WL12XX=m
# CONFIG_WL1271 is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
# CONFIG_WIMAX_IWMC3200_SDIO is not set
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_WAN=y
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m

#
# CAIF transport drivers
#
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=m
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
# CONFIG_TOUCHSCREEN_QT602240 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_ADXL34X is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_XILINX_XPS_PS2=m
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_ICOM=m
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_OF_PLATFORM=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_GRLIB_GAISLER_APBUART is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_CONSOLE=y
CONFIG_HVC_RTAS=y
# CONFIG_HVC_UDBG is not set
CONFIG_VIRTIO_CONSOLE=m
CONFIG_HVCS=m
CONFIG_IBM_BSR=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_PASEMI=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PASEMI=m
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_ARCH_REQUIRE_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_XILINX=y
# CONFIG_GPIO_SCH is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_MAX17040=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ALIM7101_WDT=m
CONFIG_WATCHDOG_RTAS=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_UCB1400_CORE=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_WM8400=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
# CONFIG_VIDEO_V4L1_COMPAT is not set
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_IR_CORE=m
CONFIG_VIDEO_IR=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_LIRC_CODEC=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_W9966 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
# CONFIG_VIDEO_CX18_ALSA is not set
CONFIG_VIDEO_SAA7164=m
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_RJ54N1 is not set
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV772X=m
# CONFIG_SOC_CAMERA_OV9640 is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
# CONFIG_USB_GSPCA_BENQ is not set
CONFIG_USB_GSPCA_CONEX=m
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=m
# CONFIG_USB_GSPCA_PAC7302 is not set
CONFIG_USB_GSPCA_PAC7311=m
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STV0680 is not set
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_TLG2300 is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_AZ6027 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
# CONFIG_SMS_SIANO_MDTV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m
# CONFIG_DVB_FIREDTV is not set

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=m

#
# Supported Mantis Adapters
#
# CONFIG_MANTIS_CORE is not set

#
# Supported nGene Adapters
#
# CONFIG_DVB_NGENE is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_TTM=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_KMS=y
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
CONFIG_FB_MACMODES=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_OF=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=m
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
# CONFIG_SND_ES1968_INPUT is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=2
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
# CONFIG_SND_MAESTRO3_INPUT is not set
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_PPC=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_PCMCIA=y
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EGALAX is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_PYRA is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_HCD_PPC_OF=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
CONFIG_USB_OHCI_HCD_PPC_OF_LE=y
CONFIG_USB_OHCI_HCD_PPC_OF=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SAMBA is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_OF=m
# CONFIG_MMC_SDHCI_OF_ESDHC is not set
# CONFIG_MMC_SDHCI_OF_HLWD is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_EHCA=m
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
# CONFIG_INFINIBAND_CXGB4 is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_PASEMI=m
CONFIG_EDAC_CPC925=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_GENERIC=y
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_TIMB_DMA is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_TM6000 is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_OTUS is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192SU is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTL8192E is not set
# CONFIG_TRANZPORT is not set
# CONFIG_POHMELFS is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_DEBUG is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_UDL is not set
# CONFIG_VME_BUS is not set
# CONFIG_IIO is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_STATS=y
# CONFIG_WLAGS49_H2 is not set
# CONFIG_WLAGS49_H25 is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_ST_BT is not set
# CONFIG_FB_XGI is not set
# CONFIG_LIRC_STAGING is not set
# CONFIG_EASYCAP is not set
# CONFIG_SOLO6X10 is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_BKL=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
# CONFIG_KGDB_KDB is not set
CONFIG_PPC_DISABLE_WERROR=y
CONFIG_PRINT_STACK_DEPTH=64
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HCALL_STATS=y
CONFIG_PPC_EMULATED_STATS=y
# CONFIG_CODE_PATCHING_SELFTEST is not set
# CONFIG_FTR_FIXUP_SELFTEST is not set
CONFIG_MSI_BITMAP_SELFTEST=y
CONFIG_XMON=y
# CONFIG_XMON_DEFAULT is not set
CONFIG_XMON_DISASSEMBLY=y
CONFIG_DEBUGGER=y
# CONFIG_VIRQ_DEBUG is not set
CONFIG_BOOTX_TEXT=y
# CONFIG_PPC_EARLY_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_KEYS_COMPAT=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
# CONFIG_PPC_CLOCK is not set
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM_BOOK3S_64 is not set
CONFIG_VHOST_NET=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y

--=-og1HV1sqX18JjUauS4s2--

