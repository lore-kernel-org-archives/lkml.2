Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2H1KvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 06:51:05 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:43788 "HELO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752316Ab2H1KvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 06:51:00 -0400
Message-ID: <503CA1A2.90104@mellanox.com>
Date: Tue, 28 Aug 2012 13:46:58 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Or Gerlitz <ogerlitz@mellanox.com>, Shachar Raindel <raindel@mellanox.com>
Subject: Kernel 3.6-rc3 BUG at mm/slab.c:2629
Content-Type: multipart/mixed;
	boundary="------------060602020909040501060602"
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------060602020909040501060602
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I believe I have encountered a bug in kernel 3.6-rc3. It starts with the
assertion in mm/slab.c:2629 failing, and then the system hangs. I can
reproduce this bug by running a large compilation (compiling the kernel
for instance).

Here's what I see in netconsole:
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:2629!
> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC

I'm attaching netconsole logs I got with kernel 3.6-rc1, which contain a
little more details after the crash, but for some reason netconsole
didn't capture the full stack trace of the assertion. I caught a glimpse
at the console and I saw RIP was at cache_alloc_refill.

I'd be happy to provide further information or perform testing to help
solve this issue.

Regards,
Haggai Eran

--------------060602020909040501060602
Content-Type: text/plain; charset="windows-1252";
	name="bug-3.6-rc1-mm-slab-c-2629.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="bug-3.6-rc1-mm-slab-c-2629.txt"

2012-Aug-20 12:34:44 -  <IRQ> ------------[ cut here ]------------
2012-Aug-20 12:34:44 - kernel BUG at mm/slab.c:2629!
2012-Aug-20 12:34:44 - invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
2012-Aug-20 12:36:13 - Modules linked in: netconsole configfs nfs3 nfs_acl nfs fscache lockd autofs4 sunrpc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support dcdbas coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel serio_raw pcspkr sg ses enclosure lpc_ich mfd_core mlx4_ib ib_mad ib_core mlx4_en mlx4_core bnx2 ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif aesni_intel ablk_helper cryptd aes_x86_64 aes_generic pata_acpiBUG: spinlock lockup suspected on CPU#8, fixdep/28208
2012-Aug-20 12:36:13 - BUG: spinlock lockup suspected on CPU#0, fixdep/28209
2012-Aug-20 12:36:13 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:13 - Pid: 28209, comm: fixdep Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:13 - Call Trace:
2012-Aug-20 12:36:13 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:13 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:13 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff811878e0>] ? cache_alloc_debugcheck_after+0x140/0x270
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:13 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:13 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:13 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:13 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:13 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:13 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:13 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 12:36:13 - BUG: spinlock lockup suspected on CPU#6, fixdep/28210
2012-Aug-20 12:36:13 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:13 - Pid: 28210, comm: fixdep Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:13 - Call Trace:
2012-Aug-20 12:36:13 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:13 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:13 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:13 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:13 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:13 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:13 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:13 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:13 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:13 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 12:36:13 - BUG: spinlock lockup suspected on CPU#4, cc1/28166
2012-Aug-20 12:36:13 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:13 - Pid: 28166, comm: cc1 Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:13 - Call Trace:
2012-Aug-20 12:36:13 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:13 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:13 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:13 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:13 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:13 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:13 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:13 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:13 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:13 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 12:36:13 - BUG: spinlock lockup suspected on CPU#10, cc1/28140
2012-Aug-20 12:36:13 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:13 - Pid: 28140, comm: cc1 Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:13 - Call Trace:
2012-Aug-20 12:36:13 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:13 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:13 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:13 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:13 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:13 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:13 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:13 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:13 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:13 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 12:36:13 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:13 - Pid: 28208, comm: fixdep Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:13 - Call Trace:
2012-Aug-20 12:36:13 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:13 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:13 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:13 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:13 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:13 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:13 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:13 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:13 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:13 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:13 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:13 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:13 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 12:36:14 - BUG: spinlock lockup suspected on CPU#2, perl/28364
2012-Aug-20 12:36:14 -  lock: 0xffff88100f1536a8, .magic: dead4ead, .owner: fixdep/28201, .owner_cpu: 9
2012-Aug-20 12:36:14 - Pid: 28364, comm: perl Tainted: G      D W    3.6.0-rc1-vanilla #47
2012-Aug-20 12:36:14 - Call Trace:
2012-Aug-20 12:36:14 -  [<ffffffff812aaa08>] spin_dump+0x78/0xc0
2012-Aug-20 12:36:14 -  [<ffffffff812aac63>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 12:36:14 -  [<ffffffff81584849>] _raw_spin_lock+0x49/0x50
2012-Aug-20 12:36:14 -  [<ffffffff8118917d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:14 -  [<ffffffff8118917d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 12:36:14 -  [<ffffffff8104b3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 12:36:14 -  [<ffffffff811a21d9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:14 -  [<ffffffff8118a964>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 12:36:14 -  [<ffffffff811a21d9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 12:36:14 -  [<ffffffff811b33a8>] path_openat+0x48/0x4a0
2012-Aug-20 12:36:14 -  [<ffffffff811add87>] ? getname_flags+0x37/0x100
2012-Aug-20 12:36:14 -  [<ffffffff811b3919>] do_filp_open+0x49/0xa0
2012-Aug-20 12:36:14 -  [<ffffffff8158523b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 12:36:14 -  [<ffffffff811c1985>] ? alloc_fd+0x145/0x250
2012-Aug-20 12:36:14 -  [<ffffffff811a03d8>] do_sys_open+0x108/0x1e0
2012-Aug-20 12:36:14 -  [<ffffffff811a04f1>] sys_open+0x21/0x30
2012-Aug-20 12:36:14 -  [<ffffffff8158e0a9>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:04:24 - ------------[ cut here ]------------
2012-Aug-20 15:04:24 - kernel BUG at mm/slab.c:2629!
2012-Aug-20 15:04:24 - invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
2012-Aug-20 15:05:28 - Modules linked in: netconsole configfs nfs3 nfs_acl nfs fscache lockd autofs4 sunrpc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support dcdbas coretemp hwmon kvm_intel kvm crc32c_intel ghash_clmulni_intel ses enclosure serio_raw sg pcspkr lpc_ich mfd_core mlx4_ib ib_mad ib_core mlx4_en mlx4_core bnx2 ext3 jbd mbcache sr_mod cdrom sd_mod crc_t10dif aesni_intel ablk_helper cryptd aes_x86_64 aes_generic pata_acpiSysRq : Emergency Sync
2012-Aug-20 15:05:29 - INFO: rcu_sched detected stalls on CPUs/tasks:
2012-Aug-20 15:05:29 - 	1: (1 GPs behind) idle=259/140000000000000/0 
2012-Aug-20 15:05:29 - 	3: (1 GPs behind) idle=c2b/140000000000000/0 
2012-Aug-20 15:05:29 - 	9: (1 GPs behind) idle=deb/140000000000000/0 
2012-Aug-20 15:05:29 - 	11: (1 GPs behind) idle=0f9/140000000000000/0 
2012-Aug-20 15:05:29 - 	(detected by 8, t=65002 jiffies)
2012-Aug-20 15:05:29 - Pid: 0, comm: swapper/8 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:29 - Call Trace:
2012-Aug-20 15:05:29 -  <IRQ>  [<ffffffff810fd5e2>] rcu_check_callbacks+0x8e2/0x900
2012-Aug-20 15:05:29 -  [<ffffffff810a08f3>] ? rebalance_domains+0x213/0x320
2012-Aug-20 15:05:29 -  [<ffffffff81069d28>] update_process_times+0x48/0x90
2012-Aug-20 15:05:29 -  [<ffffffff810b9e6e>] tick_sched_timer+0x6e/0xe0
2012-Aug-20 15:05:29 -  [<ffffffff81087cf5>] __run_hrtimer+0x95/0x300
2012-Aug-20 15:05:29 -  [<ffffffff810b9e00>] ? tick_setup_sched_timer+0x100/0x100
2012-Aug-20 15:05:29 -  [<ffffffff81088216>] hrtimer_interrupt+0x106/0x280
2012-Aug-20 15:05:29 -  [<ffffffff815912b9>] smp_apic_timer_interrupt+0x69/0x99
2012-Aug-20 15:05:29 -  [<ffffffff815901af>] apic_timer_interrupt+0x6f/0x80
2012-Aug-20 15:05:29 -  <EOI>  [<ffffffff810202c3>] ? mwait_idle+0xb3/0x390
2012-Aug-20 15:05:29 -  [<ffffffff810202cc>] ? mwait_idle+0xbc/0x390
2012-Aug-20 15:05:29 -  [<ffffffff810202c3>] ? mwait_idle+0xb3/0x390
2012-Aug-20 15:05:29 -  [<ffffffff8101f24f>] cpu_idle+0xef/0x140
2012-Aug-20 15:05:29 -  [<ffffffff8157b7e2>] start_secondary+0x259/0x25b
2012-Aug-20 15:05:53 - BUG: spinlock lockup suspected on CPU#1, cc1/5673
2012-Aug-20 15:05:53 - BUG: spinlock lockup suspected on CPU#11, cc1/5684
2012-Aug-20 15:05:53 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:53 - Pid: 5684, comm: cc1 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:53 - Call Trace:
2012-Aug-20 15:05:53 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:53 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:53 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8104c3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff8118bf84>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff811b48c8>] path_openat+0x48/0x4a0
2012-Aug-20 15:05:53 -  [<ffffffff811af2a7>] ? getname_flags+0x37/0x100
2012-Aug-20 15:05:53 -  [<ffffffff811b4e39>] do_filp_open+0x49/0xa0
2012-Aug-20 15:05:53 -  [<ffffffff8158680b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 15:05:53 -  [<ffffffff811c2ea5>] ? alloc_fd+0x145/0x250
2012-Aug-20 15:05:53 -  [<ffffffff811a19f8>] do_sys_open+0x108/0x1e0
2012-Aug-20 15:05:53 -  [<ffffffff811a1b11>] sys_open+0x21/0x30
2012-Aug-20 15:05:53 -  [<ffffffff8158f669>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:05:53 - BUG: spinlock lockup suspected on CPU#3, cc1/5659
2012-Aug-20 15:05:53 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:53 - Pid: 5659, comm: cc1 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:53 - Call Trace:
2012-Aug-20 15:05:53 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:53 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:53 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8104c3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff8118bf84>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff811b48c8>] path_openat+0x48/0x4a0
2012-Aug-20 15:05:53 -  [<ffffffff811af2a7>] ? getname_flags+0x37/0x100
2012-Aug-20 15:05:53 -  [<ffffffff811b4e39>] do_filp_open+0x49/0xa0
2012-Aug-20 15:05:53 -  [<ffffffff8158680b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 15:05:53 -  [<ffffffff811c2ea5>] ? alloc_fd+0x145/0x250
2012-Aug-20 15:05:53 -  [<ffffffff811a19f8>] do_sys_open+0x108/0x1e0
2012-Aug-20 15:05:53 -  [<ffffffff811a1b11>] sys_open+0x21/0x30
2012-Aug-20 15:05:53 -  [<ffffffff8158f669>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:05:53 - BUG: spinlock lockup suspected on CPU#9, cc1/5697
2012-Aug-20 15:05:53 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:53 - Pid: 5697, comm: cc1 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:53 - Call Trace:
2012-Aug-20 15:05:53 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:53 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:53 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8104c3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff8118bf84>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff811b48c8>] path_openat+0x48/0x4a0
2012-Aug-20 15:05:53 -  [<ffffffff811af2a7>] ? getname_flags+0x37/0x100
2012-Aug-20 15:05:53 -  [<ffffffff811b4e39>] do_filp_open+0x49/0xa0
2012-Aug-20 15:05:53 -  [<ffffffff8158680b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 15:05:53 -  [<ffffffff811c2ea5>] ? alloc_fd+0x145/0x250
2012-Aug-20 15:05:53 -  [<ffffffff811a19f8>] do_sys_open+0x108/0x1e0
2012-Aug-20 15:05:53 -  [<ffffffff811a1b11>] sys_open+0x21/0x30
2012-Aug-20 15:05:53 -  [<ffffffff8158f669>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:05:53 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:53 - Pid: 5673, comm: cc1 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:53 - Call Trace:
2012-Aug-20 15:05:53 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:53 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:53 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff8118a79d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff8118bf84>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 15:05:53 -  [<ffffffff811a37f9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:53 -  [<ffffffff811b48c8>] path_openat+0x48/0x4a0
2012-Aug-20 15:05:53 -  [<ffffffff811af2a7>] ? getname_flags+0x37/0x100
2012-Aug-20 15:05:53 -  [<ffffffff811b4e39>] do_filp_open+0x49/0xa0
2012-Aug-20 15:05:53 -  [<ffffffff8158680b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 15:05:53 -  [<ffffffff811c2ea5>] ? alloc_fd+0x145/0x250
2012-Aug-20 15:05:53 -  [<ffffffff811a19f8>] do_sys_open+0x108/0x1e0
2012-Aug-20 15:05:53 -  [<ffffffff811a1b11>] sys_open+0x21/0x30
2012-Aug-20 15:05:53 -  [<ffffffff8158f669>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:05:54 - BUG: spinlock lockup suspected on CPU#5, cc1/5698
2012-Aug-20 15:05:54 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:54 - Pid: 5698, comm: cc1 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:54 - Call Trace:
2012-Aug-20 15:05:54 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:54 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:54 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:54 -  [<ffffffff8118a79d>] ? cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:54 -  [<ffffffff81188f00>] ? cache_alloc_debugcheck_after+0x140/0x270
2012-Aug-20 15:05:54 -  [<ffffffff8118a79d>] cache_alloc_refill+0xad/0x3b0
2012-Aug-20 15:05:54 -  [<ffffffff8104c3bf>] ? __change_page_attr_set_clr+0x75f/0xbd0
2012-Aug-20 15:05:54 -  [<ffffffff811a37f9>] ? get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:54 -  [<ffffffff8118bf84>] kmem_cache_alloc+0x1d4/0x300
2012-Aug-20 15:05:54 -  [<ffffffff811a37f9>] get_empty_filp+0x79/0x1c0
2012-Aug-20 15:05:54 -  [<ffffffff811b48c8>] path_openat+0x48/0x4a0
2012-Aug-20 15:05:54 -  [<ffffffff811af2a7>] ? getname_flags+0x37/0x100
2012-Aug-20 15:05:54 -  [<ffffffff811b4e39>] do_filp_open+0x49/0xa0
2012-Aug-20 15:05:54 -  [<ffffffff8158680b>] ? _raw_spin_unlock+0x2b/0x50
2012-Aug-20 15:05:54 -  [<ffffffff811c2ea5>] ? alloc_fd+0x145/0x250
2012-Aug-20 15:05:54 -  [<ffffffff811a19f8>] do_sys_open+0x108/0x1e0
2012-Aug-20 15:05:54 -  [<ffffffff811a1b11>] sys_open+0x21/0x30
2012-Aug-20 15:05:54 -  [<ffffffff8158f669>] system_call_fastpath+0x16/0x1b
2012-Aug-20 15:05:54 - BUG: spinlock lockup suspected on CPU#2, kworker/2:0/14
2012-Aug-20 15:05:54 -  lock: 0xffff88080f843bb8, .magic: dead4ead, .owner: cc1/5665, .owner_cpu: 8
2012-Aug-20 15:05:54 - Pid: 14, comm: kworker/2:0 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:05:54 - Call Trace:
2012-Aug-20 15:05:54 -  [<ffffffff812abfb8>] spin_dump+0x78/0xc0
2012-Aug-20 15:05:54 -  [<ffffffff812ac213>] do_raw_spin_lock+0x133/0x140
2012-Aug-20 15:05:54 -  [<ffffffff81585e19>] _raw_spin_lock+0x49/0x50
2012-Aug-20 15:05:54 -  [<ffffffff811897c4>] ? __drain_alien_cache+0x64/0xa0
2012-Aug-20 15:05:54 -  [<ffffffff811897c4>] __drain_alien_cache+0x64/0xa0
2012-Aug-20 15:05:54 -  [<ffffffff8118c24c>] cache_reap+0x19c/0x2a0
2012-Aug-20 15:05:54 -  [<ffffffff8107a9fa>] process_one_work+0x20a/0x610
2012-Aug-20 15:05:54 -  [<ffffffff8107a990>] ? process_one_work+0x1a0/0x610
2012-Aug-20 15:05:54 -  [<ffffffff8118c0b0>] ? kmem_cache_alloc+0x300/0x300
2012-Aug-20 15:05:54 -  [<ffffffff8107bb0e>] worker_thread+0x15e/0x460
2012-Aug-20 15:05:54 -  [<ffffffff81082f60>] ? wake_up_bit+0x40/0x40
2012-Aug-20 15:05:54 -  [<ffffffff8107b9b0>] ? manage_workers+0x290/0x290
2012-Aug-20 15:05:54 -  [<ffffffff8108274e>] kthread+0xbe/0xd0
2012-Aug-20 15:05:54 -  [<ffffffff81590844>] kernel_thread_helper+0x4/0x10
2012-Aug-20 15:05:54 -  [<ffffffff81586b30>] ? retint_restore_args+0x13/0x13
2012-Aug-20 15:05:54 -  [<ffffffff81082690>] ? __init_kthread_worker+0x70/0x70
2012-Aug-20 15:05:54 -  [<ffffffff81590840>] ? gs_change+0x13/0x13
2012-Aug-20 15:08:44 - INFO: rcu_sched detected stalls on CPUs/tasks:
2012-Aug-20 15:08:44 - 	1: (1 GPs behind) idle=259/140000000000000/0 
2012-Aug-20 15:08:44 - 	3: (1 GPs behind) idle=c2b/140000000000000/0 
2012-Aug-20 15:08:44 - 	9: (1 GPs behind) idle=deb/140000000000000/0 
2012-Aug-20 15:08:44 - 	11: (1 GPs behind) idle=0f9/140000000000000/0 
2012-Aug-20 15:08:44 - 	(detected by 0, t=260007 jiffies)
2012-Aug-20 15:08:44 - Pid: 0, comm: swapper/0 Tainted: G      D W    3.6.0-rc2-vanilla #53
2012-Aug-20 15:08:44 - Call Trace:
2012-Aug-20 15:08:44 -  <IRQ>  [<ffffffff810fd5e2>] rcu_check_callbacks+0x8e2/0x900
2012-Aug-20 15:08:44 -  [<ffffffff810a08f3>] ? rebalance_domains+0x213/0x320
2012-Aug-20 15:08:44 -  [<ffffffff81069d28>] update_process_times+0x48/0x90
2012-Aug-20 15:08:44 -  [<ffffffff810b9e6e>] tick_sched_timer+0x6e/0xe0
2012-Aug-20 15:08:44 -  [<ffffffff81087cf5>] __run_hrtimer+0x95/0x300
2012-Aug-20 15:08:44 -  [<ffffffff810b9e00>] ? tick_setup_sched_timer+0x100/0x100
2012-Aug-20 15:08:44 -  [<ffffffff81088216>] hrtimer_interrupt+0x106/0x280
2012-Aug-20 15:08:44 -  [<ffffffff815912b9>] smp_apic_timer_interrupt+0x69/0x99
2012-Aug-20 15:08:44 -  [<ffffffff815901af>] apic_timer_interrupt+0x6f/0x80
2012-Aug-20 15:08:44 -  <EOI>  [<ffffffff810202c3>] ? mwait_idle+0xb3/0x390
2012-Aug-20 15:08:44 -  [<ffffffff810202cc>] ? mwait_idle+0xbc/0x390
2012-Aug-20 15:08:44 -  [<ffffffff810202c3>] ? mwait_idle+0xb3/0x390
2012-Aug-20 15:08:44 -  [<ffffffff8101f24f>] cpu_idle+0xef/0x140
2012-Aug-20 15:08:44 -  [<ffffffff8156808f>] rest_init+0xff/0x180
2012-Aug-20 15:08:44 -  [<ffffffff81567f90>] ? csum_partial_copy_generic+0x170/0x170
2012-Aug-20 15:08:44 -  [<ffffffff81b1af28>] start_kernel+0x3f8/0x405
2012-Aug-20 15:08:44 -  [<ffffffff81b1a94e>] ? kernel_init+0x329/0x329
2012-Aug-20 15:08:44 -  [<ffffffff81b1a356>] x86_64_start_reservations+0x131/0x136
2012-Aug-20 15:08:44 -  [<ffffffff81b1a45e>] x86_64_start_kernel+0x103/0x112
2012-Aug-20 15:09:09 - SysRq : Emergency Sync
2012-Aug-20 15:09:10 - SysRq : Emergency Remount R/O
2012-Aug-20 15:09:12 - SysRq : Resetting

--------------060602020909040501060602--
