Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0FGNEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0FGNEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:04:46 -0400
Date: Mon, 7 Jun 2010 09:04:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: linux-kernel@vger.kernel.org
Subject: lockup when disabling CPUs
Message-ID: <Pine.LNX.4.64.1006070853130.8695@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On a computer with 2 quad-core Barcelona Opterons, I experienced a lockup 
in sync_page after disabling 7 cores in 
/sys/devices/system/cpu/cpu$i/online . Reenabling the cores didn't resolve 
it. The lockup resolved automatically after several minutes and the 
machine continues to run.

The kernel is 2.6.34. I use ext2 filesystem on a SCSI disk on Fusion MPT 
SCSI controller (there is also md-raid0 loaded, but it wasn't mounted at 
the time of the lockup).

Mikulas

CPU 1 is now offline
CPU 2 is now offline
CPU 3 is now offline
CPU 4 is now offline
CPU 5 is now offline
CPU 6 is now offline
CPU 7 is now offline
SMP alternatives: switching to UP code
SysRq : Show Blocked State
  task                        PC stack   pid father
flush-8:0     D 0000000000000000     0  3492      2 0x00000000
 ffff88023f0d78a0 0000000000000046 ffff88023f0d6000 ffff88023f0d7fd8
 ffff88023f0d6000 ffff88023f0d7fd8 ffff88023f0d6000 ffff88023f0d7fd8
 ffff88023f0d6000 ffff88023e67a050 0000000000012dc0 ffff88023f0d7fd8
Call Trace:
 [<ffffffff81173f61>] ? cfq_may_queue+0x51/0xe0
 [<ffffffff812e74fd>] ? io_schedule+0x4d/0x70
 [<ffffffff81166b62>] ? get_request_wait+0x132/0x1d0
 [<ffffffff8105eca0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff81166c94>] ? __make_request+0x94/0x4d0
 [<ffffffff81164c31>] ? generic_make_request+0x351/0x4b0
 [<ffffffff810a4a12>] ? mempool_alloc+0x62/0x140
 [<ffffffff81164de0>] ? submit_bio+0x50/0xc0
 [<ffffffff8110dff9>] ? submit_bh+0x109/0x150
 [<ffffffff8110fd9f>] ? __block_write_full_page+0x1cf/0x390
 [<ffffffff810a4094>] ? find_get_pages_tag+0x54/0x160
 [<ffffffff81110310>] ? end_buffer_async_write+0x0/0x200
 [<ffffffff81114220>] ? blkdev_get_block+0x0/0x70
 [<ffffffff810aa35a>] ? __writepage+0xa/0x40
 [<ffffffff810aa879>] ? write_cache_pages+0x1a9/0x370
 [<ffffffff810aa350>] ? __writepage+0x0/0x40
 [<ffffffff81107b57>] ? writeback_single_inode+0xf7/0x380
 [<ffffffff81108968>] ? writeback_inodes_wb+0x3b8/0x600
 [<ffffffff81108cd6>] ? wb_writeback+0x126/0x200
 [<ffffffff81109061>] ? wb_do_writeback+0x1e1/0x1f0
 [<ffffffff811090d2>] ? bdi_writeback_task+0x62/0xa0
 [<ffffffff810ba9c0>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff810baa3e>] ? bdi_start_fn+0x7e/0xf0
 [<ffffffff810ba9c0>] ? bdi_start_fn+0x0/0xf0
 [<ffffffff8105e716>] ? kthread+0x96/0xb0
 [<ffffffff810032d4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8105e680>] ? kthread+0x0/0xb0
 [<ffffffff810032d0>] ? kernel_thread_helper+0x0/0x10
aptitude      D 0000000000000000     0  3497   3493 0x00000000
 ffff88023f163d08 0000000000000082 ffff88023f162000 ffff88023f163fd8
 ffff88023f162000 ffff88023f163fd8 ffff88023f162000 ffff88023f163fd8
 ffff88023f162000 ffff88023f28e050 0000000000012dc0 ffff88023f163fd8
Call Trace:
 [<ffffffff810a2340>] ? sync_page+0x0/0x70
 [<ffffffff812e74fd>] ? io_schedule+0x4d/0x70
 [<ffffffff810a2375>] ? sync_page+0x35/0x70
 [<ffffffff812e7bb0>] ? __wait_on_bit+0x50/0x80
 [<ffffffff810a251c>] ? wait_on_page_bit+0x6c/0x80
 [<ffffffff8105ecd0>] ? wake_bit_function+0x0/0x30
 [<ffffffff810ac5da>] ? pagevec_lookup_tag+0x1a/0x30
 [<ffffffff810a2813>] ? filemap_fdatawait_range+0xd3/0x150
 [<ffffffff810a2977>] ? filemap_write_and_wait_range+0x67/0x70
 [<ffffffff8110c8cb>] ? vfs_fsync_range+0x8b/0xe0
 [<ffffffff810c7d6e>] ? sys_msync+0x16e/0x1f0
 [<ffffffff810025ab>] ? system_call_fastpath+0x16/0x1b

Module                  Size  Used by
powernow_k8            11650  1
cpufreq_userspace       1992  0
cpufreq_stats           3881  0
cpufreq_powersave        902  0
cpufreq_ondemand        8021  0
freq_table              2427  3 powernow_k8,cpufreq_stats,cpufreq_ondemand
cpufreq_conservative     9196  0
raid0                   6141  2
md_mod                 90752  1 raid0
lm85                   20425  0
hwmon_vid               2628  1 lm85
ide_cd_mod             26768  0
cdrom                  34286  1 ide_cd_mod
ehci_hcd               36915  0
ohci_hcd               21868  0
serverworks             4132  0
i2c_piix4               8520  0
sata_svw                4430  0
k10temp                 2795  0
hwmon                   1385  2 lm85,k10temp
ide_core               88296  2 ide_cd_mod,serverworks
i2c_core               17422  2 lm85,i2c_piix4
libata                154751  1 sata_svw
rtc_cmos                8766  0
rtc_core               13548  1 rtc_cmos
usbcore               138235  3 ehci_hcd,ohci_hcd
floppy                 55194  0
nls_base                6777  1 usbcore
rtc_lib                 1881  1 rtc_core
thermal                11930  0
button                  4778  0
processor              28143  1 powernow_k8
unix                   23684  30

