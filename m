Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2AOWih (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 17:38:37 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:49379 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2AOWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 17:38:36 -0500
X-manitu-Original-Sender-IP: 86.32.213.40
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sun, 15 Jan 2012 23:38:32 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: linux-kernel@vger.kernel.org
Subject: [kmemleak report 2/2] kernel 3.1.6, x86_64: pm, acpi-cpufreq ?
Message-ID: <20120115223832.GB3937@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
References: <20120115222932.GA24330@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120115222932.GA24330@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After every suspend-to-RAM-resume-cycle I get kmemleak reports similar to this example:

unreferenced object 0xffff880125fe3f00 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209841 (age 22926.421s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 ff 91 26 01 88 ff ff  ...........&....
    00 00 00 00 00 00 00 00 c0 33 c2 0c 01 88 ff ff  .........3......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6208>] sysfs_create_dir+0x78/0xb0
    [<ffffffff81317c2d>] kobject_add_internal+0xbd/0x250
    [<ffffffff813180a3>] kobject_init_and_add+0x63/0x90
    [<ffffffff81523ada>] cpufreq_add_dev_interface+0x3a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a8349>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff81084d3b>] __cpu_notify+0x1b/0x30
    [<ffffffff81084d60>] cpu_notify+0x10/0x20
    [<ffffffff81682409>] _cpu_up+0xc0/0xe9
unreferenced object 0xffff88010cc23920 (size 32):
  comm "pm-suspend", pid 8464, jiffies 4502209841 (age 22926.421s)
  hex dump (first 32 bytes):
    73 74 61 74 73 00 ff ff d0 c5 97 25 01 88 ff ff  stats......%....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131ad2>] __kmalloc+0x102/0x190
    [<ffffffff81106dec>] kstrdup+0x3c/0x70
    [<ffffffff811a5aec>] sysfs_new_dirent+0x10c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
unreferenced object 0xffff88010cd75a50 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209841 (age 22926.605s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 3f fe 25 01 88 ff ff  .........?.%....
    00 00 00 00 00 00 00 00 20 39 c2 0c 01 88 ff ff  ........ 9......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
unreferenced object 0xffff88010cd75aa0 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209841 (age 22926.605s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 50 5a d7 0c 01 88 ff ff  ........PZ......
    b0 54 d7 0c 01 88 ff ff 3c 9e 82 81 ff ff ff ff  .T......<.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff88010cd754b0 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209841 (age 22926.605s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 50 5a d7 0c 01 88 ff ff  ........PZ......
    00 00 00 00 00 00 00 00 48 9e 82 81 ff ff ff ff  ........H.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff880120dcef40 (size 32):
  comm "pm-suspend", pid 8464, jiffies 4502209883 (age 22926.746s)
  hex dump (first 32 bytes):
    63 70 75 66 72 65 71 00 00 00 00 00 00 00 00 79  cpufreq........y
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131ad2>] __kmalloc+0x102/0x190
    [<ffffffff81106dec>] kstrdup+0x3c/0x70
    [<ffffffff811a5aec>] sysfs_new_dirent+0x10c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6208>] sysfs_create_dir+0x78/0xb0
    [<ffffffff81317c2d>] kobject_add_internal+0xbd/0x250
    [<ffffffff813180a3>] kobject_init_and_add+0x63/0x90
    [<ffffffff81523ada>] cpufreq_add_dev_interface+0x3a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a8349>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff81084d3b>] __cpu_notify+0x1b/0x30
    [<ffffffff81084d60>] cpu_notify+0x10/0x20
unreferenced object 0xffff880035d292d0 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209883 (age 22926.746s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 fe 91 26 01 88 ff ff  ...........&....
    00 00 00 00 00 00 00 00 40 ef dc 20 01 88 ff ff  ........@.. ....
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6208>] sysfs_create_dir+0x78/0xb0
    [<ffffffff81317c2d>] kobject_add_internal+0xbd/0x250
    [<ffffffff813180a3>] kobject_init_and_add+0x63/0x90
    [<ffffffff81523ada>] cpufreq_add_dev_interface+0x3a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a8349>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff81084d3b>] __cpu_notify+0x1b/0x30
    [<ffffffff81084d60>] cpu_notify+0x10/0x20
    [<ffffffff81682409>] _cpu_up+0xc0/0xe9
unreferenced object 0xffff880120dceea0 (size 32):
  comm "pm-suspend", pid 8464, jiffies 4502209884 (age 22926.745s)
  hex dump (first 32 bytes):
    73 74 61 74 73 00 ff ff 50 ca 97 25 01 88 ff ff  stats...P..%....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131ad2>] __kmalloc+0x102/0x190
    [<ffffffff81106dec>] kstrdup+0x3c/0x70
    [<ffffffff811a5aec>] sysfs_new_dirent+0x10c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
unreferenced object 0xffff880125fe3410 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209884 (age 22926.934s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 d0 92 d2 35 00 88 ff ff  ...........5....
    00 00 00 00 00 00 00 00 a0 ee dc 20 01 88 ff ff  ........... ....
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
unreferenced object 0xffff880125fe3dc0 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209884 (age 22926.934s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 34 fe 25 01 88 ff ff  .........4.%....
    10 3e fe 25 01 88 ff ff 3c 9e 82 81 ff ff ff ff  .>.%....<.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff880125fe3e10 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209884 (age 22926.934s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 10 34 fe 25 01 88 ff ff  .........4.%....
    00 00 00 00 00 00 00 00 48 9e 82 81 ff ff ff ff  ........H.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff880104d1a460 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209927 (age 22927.076s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 80 fc 91 26 01 88 ff ff  ...........&....
    00 00 00 00 00 00 00 00 20 9b dc 23 01 88 ff ff  ........ ..#....
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6208>] sysfs_create_dir+0x78/0xb0
    [<ffffffff81317c2d>] kobject_add_internal+0xbd/0x250
    [<ffffffff813180a3>] kobject_init_and_add+0x63/0x90
    [<ffffffff81523ada>] cpufreq_add_dev_interface+0x3a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a8349>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff81084d3b>] __cpu_notify+0x1b/0x30
    [<ffffffff81084d60>] cpu_notify+0x10/0x20
    [<ffffffff81682409>] _cpu_up+0xc0/0xe9
unreferenced object 0xffff88010cc23960 (size 32):
  comm "pm-suspend", pid 8464, jiffies 4502209927 (age 22927.076s)
  hex dump (first 32 bytes):
    73 74 61 74 73 00 ff ff 00 00 00 00 01 00 00 00  stats...........
    40 9e dc 23 01 88 ff ff 04 00 00 00 00 00 00 00  @..#............
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131ad2>] __kmalloc+0x102/0x190
    [<ffffffff81106dec>] kstrdup+0x3c/0x70
    [<ffffffff811a5aec>] sysfs_new_dirent+0x10c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
unreferenced object 0xffff880125ba7b90 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209927 (age 22927.076s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 60 a4 d1 04 01 88 ff ff  ........`.......
    00 00 00 00 00 00 00 00 60 39 c2 0c 01 88 ff ff  ........`9......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a60cd>] create_dir+0x3d/0xe0
    [<ffffffff811a6187>] sysfs_create_subdir+0x17/0x20
    [<ffffffff811a7cf9>] internal_create_group+0x59/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
unreferenced object 0xffff880125ba7f50 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209927 (age 22927.262s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 90 7b ba 25 01 88 ff ff  .........{.%....
    f0 7a ba 25 01 88 ff ff 3c 9e 82 81 ff ff ff ff  .z.%....<.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff880125ba7af0 (size 80):
  comm "pm-suspend", pid 8464, jiffies 4502209927 (age 22927.262s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 90 7b ba 25 01 88 ff ff  .........{.%....
    00 00 00 00 00 00 00 00 48 9e 82 81 ff ff ff ff  ........H.......
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131c32>] kmem_cache_alloc+0xd2/0x150
    [<ffffffff811a5a1c>] sysfs_new_dirent+0x3c/0x120
    [<ffffffff811a5117>] sysfs_add_file_mode+0x37/0xb0
    [<ffffffff811a7d6e>] internal_create_group+0xce/0x1b0
    [<ffffffff811a7e7e>] sysfs_create_group+0xe/0x10
    [<ffffffff81524eed>] cpufreq_stat_notifier_policy+0xdd/0x290
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a85f3>] __blocking_notifier_call_chain+0x53/0x80
    [<ffffffff810a8631>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81522ae1>] __cpufreq_set_policy+0xc1/0x170
    [<ffffffff81523d2a>] cpufreq_add_dev_interface+0x28a/0x2e0
    [<ffffffff815240dd>] cpufreq_add_dev+0x35d/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
unreferenced object 0xffff8801258c9400 (size 1024):
  comm "pm-suspend", pid 16264, jiffies 4524280281 (age 857.106s)
  hex dump (first 32 bytes):
    6b 0a 00 00 00 00 00 00 a8 61 00 00 00 00 00 00  k........a......
    0a 00 00 00 00 00 00 00 0a 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8113bf7d>] create_object+0x10d/0x290
    [<ffffffff81673101>] kmemleak_alloc+0x21/0x50
    [<ffffffff81131ad2>] __kmalloc+0x102/0x190
    [<ffffffff8138b288>] acpi_processor_register_performance+0x27e/0x3d8
    [<ffffffff8152798d>] acpi_cpufreq_cpu_init+0xcd/0x4d0
    [<ffffffff81523f47>] cpufreq_add_dev+0x1c7/0x4a0
    [<ffffffff81684bf2>] cpufreq_cpu_callback+0x6a/0x78
    [<ffffffff810a829c>] notifier_call_chain+0x4c/0x70
    [<ffffffff810a8349>] __raw_notifier_call_chain+0x9/0x10
    [<ffffffff81084d3b>] __cpu_notify+0x1b/0x30
    [<ffffffff81084d60>] cpu_notify+0x10/0x20
    [<ffffffff81682409>] _cpu_up+0xc0/0xe9
    [<ffffffff81671f75>] enable_nonboot_cpus+0x95/0xc0
    [<ffffffff810c05b1>] suspend_devices_and_enter+0x161/0x250
    [<ffffffff810c07c5>] enter_state+0x125/0x150
    [<ffffffff810bfc86>] state_store+0xc6/0x100


uname -r -m -p
--------------
3.1.6-grsecurity.roland.0 x86_64 Intel(R) Core(TM) i7 CPU M 620 @ 2.67GHz 


grep -Ee acpi\|cpufreq modules.builtin
--------------------------------------
kernel/drivers/acpi/ac.ko
kernel/drivers/acpi/button.ko
kernel/drivers/acpi/fan.ko
kernel/drivers/acpi/video.ko
kernel/drivers/acpi/pci_slot.ko
kernel/drivers/acpi/processor.ko
kernel/drivers/acpi/container.ko
kernel/drivers/acpi/thermal.ko
kernel/drivers/acpi/battery.ko
kernel/drivers/cpufreq/cpufreq_stats.ko
kernel/drivers/cpufreq/cpufreq_performance.ko
kernel/drivers/cpufreq/cpufreq_powersave.ko
kernel/drivers/cpufreq/cpufreq_userspace.ko
kernel/drivers/cpufreq/cpufreq_ondemand.ko
kernel/drivers/cpufreq/cpufreq_conservative.ko
kernel/drivers/cpufreq/freq_table.ko
kernel/drivers/cpufreq/acpi-cpufreq.ko
kernel/drivers/cpufreq/mperf.ko


lspci -k -nn -v
---------------
00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0044] (rev 02)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge [0604]: Intel Corporation Core Processor PCI Express x16 Root Port [8086:0045] (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: d0000000-e30fffff
	Capabilities: [88] Subsystem: Dell Device [1028:040c]
	Capabilities: [80] Power Management version 3
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [a0] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel
	Kernel driver in use: pcieport

00:19.0 Ethernet controller [0200]: Intel Corporation 82577LM Gigabit Network Connection [8086:10ea] (rev 05)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at e8200000 (32-bit, non-prefetchable) [size=128K]
	Memory at e8280000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at 7040 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [e0] PCI Advanced Features
	Kernel driver in use: e1000e

00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at e8270000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at e8260000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: e6e00000-e81fffff
	Prefetchable memory behind bridge: 00000000e8500000-00000000e86fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Dell Device [1028:040c]
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.2 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 3 [8086:3b46] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
	I/O behind bridge: 00002000-00003fff
	Memory behind bridge: e3100000-e59fffff
	Prefetchable memory behind bridge: 00000000ec000000-00000000efffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Dell Device [1028:040c]
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1c.3 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 [8086:3b48] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=0a, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: e5a00000-e6dfffff
	Prefetchable memory behind bridge: 00000000e8300000-00000000e84fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Dell Device [1028:040c]
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: pcieport

00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, medium devsel, latency 0, IRQ 17
	Memory at e8250000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev a5) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Capabilities: [50] Subsystem: Dell Device [1028:040c]

00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller [8086:3b07] (rev 05)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=10 <?>

00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller [8086:3b2f] (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 41
	I/O ports at 7090 [size=8]
	I/O ports at 7080 [size=4]
	I/O ports at 7070 [size=8]
	I/O ports at 7060 [size=4]
	I/O ports at 7020 [size=32]
	Memory at e8240000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 05)
	Subsystem: Dell Device [1028:040c]
	Flags: medium devsel, IRQ 18
	Memory at e8230000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 7000 [size=32]
	Kernel driver in use: i801_smbus

00:1f.6 Signal processing controller [1180]: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem [8086:3b32] (rev 05)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at e8220000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-

01:00.0 VGA compatible controller [0300]: nVidia Corporation GT216 [Quadro FX 880M] [10de:0a3c] (rev a2) (prog-if 00 [VGA controller])
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at e2000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at e0000000 (64-bit, prefetchable) [size=32M]
	I/O ports at 6000 [size=128]
	Expansion ROM at e3000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting <?>
	Capabilities: [600] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
	Kernel driver in use: nouveau

01:00.1 Audio device [0403]: nVidia Corporation High Definition Audio Controller [10de:0be2] (rev a1)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at e3080000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [60] Power Management version 3
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Express Endpoint, MSI 00
	Kernel driver in use: snd_hda_intel

03:00.0 CardBus bridge [0607]: Ricoh Co Ltd Device [1180:e476] (rev 02)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at e5940000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
	Memory window 0: ec000000-effff000 (prefetchable)
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002000-000020ff
	16-bit legacy interface ports at 0001

03:00.1 SD Host controller [0805]: Ricoh Co Ltd MMC/SD Host Controller [1180:e822] (rev 03) (prog-if 01)
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at e5930000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00

03:00.4 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd FireWire Host Controller [1180:e832] (rev 03) (prog-if 10 [OHCI])
	Subsystem: Dell Device [1028:040c]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at e5900000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [78] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00

3f:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c62] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0

3f:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0

3f:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0

3f:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0

3f:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0

3f:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 02)
	Subsystem: Intel Corporation Device [8086:8086]
	Flags: bus master, fast devsel, latency 0


-- 
Roland Eggner 
