Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1ATGWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:22:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55573 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1ATGWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:22:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 Jan 2011 15:16:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: ksm/thp/memcg bug
Message-Id: <20110120151640.15e53cb5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1250922468.82535.1295503009407.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
References: <1449034445.82533.1295502930584.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<1250922468.82535.1295503009407.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 00:56:49 -0500 (EST)
CAI Qian <caiqian@redhat.com> wrote:

> Fixed the wrong email address for linux-mm.
> 
> ----- Original Message -----
> > When running LTP ksm03 test [1], kernel is dead.
> > 
> > # ksm03 -u 128
> > 
> > WARNING: at kernel/res_counter.c:71
> > res_counter_uncharge_locked+0x37/0x40()
> > Hardware name: QSSC-S4R
> > Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
> > freq_table mperf ipv6 dm_mirror dm_region_hash dm_log bnx2 pcspkr
> > i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
> > edac_core shpchp sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod
> > crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last
> > unloaded: microcode]
> > Pid: 278, comm: ksmd Tainted: G W 2.6.38-rc1 #1
> > Call Trace:
> > [<ffffffff81061f8f>] ? warn_slowpath_common+0x7f/0xc0
> > [<ffffffff81061fea>] ? warn_slowpath_null+0x1a/0x20
> > [<ffffffff810b4fb7>] ? res_counter_uncharge_locked+0x37/0x40
> > [<ffffffff810b5004>] ? res_counter_uncharge+0x44/0x70
> > [<ffffffff8114db15>] ? __mem_cgroup_uncharge_common+0x265/0x2c0
> > [<ffffffff8114dbbf>] ? mem_cgroup_uncharge_page+0x2f/0x40
> > [<ffffffff81126a2d>] ? page_remove_rmap+0x3d/0xb0
> > [<ffffffff8113d88f>] ? try_to_merge_with_ksm_page+0x53f/0x5e0
> > [<ffffffff8113e4f8>] ? ksm_scan_thread+0x5f8/0xd10
> > [<ffffffff810836e0>] ? autoremove_wake_function+0x0/0x40
> > [<ffffffff8113df00>] ? ksm_scan_thread+0x0/0xd10
> > [<ffffffff81083046>] ? kthread+0x96/0xa0
> > [<ffffffff8100cdc4>] ? kernel_thread_helper+0x4/0x10
> > [<ffffffff81082fb0>] ? kthread+0x0/0xa0
> > [<ffffffff8100cdc0>] ? kernel_thread_helper+0x0/0x10
> > ---[ end trace f600950ce87dbdf9 ]---
> > BUG: unable to handle kernel paging request at ffffc900171d3090
> > IP: [<ffffffff8114a92e>]
> > mem_cgroup_get_reclaim_stat_from_page+0x4e/0x80
> > PGD 87f419067 PUD c7f419067 PMD 85e8bd067 PTE 0
> > Oops: 0000 [#1] SMP
> > last sysfs file: /sys/kernel/mm/ksm/run
> > CPU 0
> > Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq
> > freq_table mperf ipv6 dm_mirror dm_region_hash dm_log bnx2 pcspkr
> > i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma i7core_edac
> > edac_core shpchp sg igb dca ext4 mbcache jbd2 sr_mod cdrom sd_mod
> > crc_t10dif pata_acpi ata_generic ata_piix megaraid_sas dm_mod [last
> > unloaded: microcode]
> > 
> > Pid: 7297, comm: ksm03 Tainted: G W 2.6.38-rc1 #1 QSSC-S4R/QSSC-S4R
> > RIP: 0010:[<ffffffff8114a92e>] [<ffffffff8114a92e>]
> > mem_cgroup_get_reclaim_stat_from_page+0x4e/0x80
> > RSP: 0018:ffff88105da05b58 EFLAGS: 00010002
> > RAX: 0000000000000002 RBX: ffff88047ffd9e00 RCX: 0000000000000000
> > RDX: ffffc900171d3000 RSI: ffffea000eb84c00 RDI: 0000000000434a80
> > RBP: ffff88105da05b58 R08: ffff8804620ba3c8 R09: 0000000000000040
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000001 R14: 0000000000000490 R15: ffff880078211c00
> > FS: 00007fd0f1214700(0000) GS:ffff880078200000(0000)
> > knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: ffffc900171d3090 CR3: 000000085d872000 CR4: 00000000000006f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process ksm03 (pid: 7297, threadinfo ffff88105da04000, task
> > ffff88105ea82100)
> > Stack:
> > ffff88105da05b88 ffffffff81104b1d ffff88105da05b88 ffffea000eb84c00
> > ffff88047ffd9e00 000000000000000a ffff88105da05bd8 ffffffff8110562e
> > 0000000200000000 0000000100000001 ffff88105da05bc8 ffffea000eb84ca8
> > Call Trace:
> > [<ffffffff81104b1d>] update_page_reclaim_stat+0x2d/0x70
> > [<ffffffff8110562e>] ____pagevec_lru_add+0xee/0x190
> > [<ffffffff81105728>] __lru_cache_add+0x58/0x70
> > [<ffffffff8110576d>] lru_cache_add_lru+0x2d/0x50
> > [<ffffffff81127a5d>] page_add_new_anon_rmap+0x9d/0xf0
> > [<ffffffff8111cc44>] do_wp_page+0x294/0x910
> > [<ffffffff8111ec1d>] handle_pte_fault+0x2ad/0xb20
> > [<ffffffff8111f641>] handle_mm_fault+0x1b1/0x320
> > [<ffffffff8113c854>] break_ksm+0x74/0xa0
> > [<ffffffff8113dd7d>] run_store+0x19d/0x320
> > [<ffffffff812275c7>] kobj_attr_store+0x17/0x20
> > [<ffffffff811be67f>] sysfs_write_file+0xef/0x170
> > [<ffffffff81153fd8>] vfs_write+0xc8/0x190
> > [<ffffffff811541a1>] sys_write+0x51/0x90
> > [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
> > Code: c0 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 48 8b 50 08 48 8b 40 10
> > 48 85 d2 48 8b 00 74 e2 48 89 c1 48 c1 e8 34 48 c1 e9 36 83 e0 03 <48>
> > 8b 94 ca 90 00 00 00 48 89 c1 48 c1 e0 08 48 c1 e1 04 48 29
> > RIP [<ffffffff8114a92e>]
> > mem_cgroup_get_reclaim_stat_from_page+0x4e/0x80
> > RSP <ffff88105da05b58>
> > CR2: ffffc900171d3090
> > ---[ end trace f600950ce87dbdfa ]---
> > 
> > [1]
> > http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/kernel/mem/ksm/ksm03.c
> 
Thank you for reporting.

Hmm..I saw this kind of error for the 1st time.
Because this happens at __pagevec_lru_add(), It's not clear what kind of 
page was added to LRU. So, I don't think there are races between ksm/memcg, now.

I know there are some patches queued in -mm, which has some fixes for thp/memcg.
It includes fixes for THP/mem_cgroup which doesn't clear USED bit in page_cgroup
cleanly. Could you show your .config ?

Thanks,
-Kame


