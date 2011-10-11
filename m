Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1JKPgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:36:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38401 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1JKPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:36:12 -0400
Message-ID: <4E94624E.9080502@gmail.com>
Date: Tue, 11 Oct 2011 08:35:42 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: 3.1.0-rc9-00020-g3ee72ca gives INFO: possible circular locking dependency
 detected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with 3.1.0-rc9-00020-g3ee72c I am getting:

[ 4420.437736] =======================================================
[ 4420.437741] [ INFO: possible circular locking dependency detected ]
[ 4420.437744] 3.1.0-rc9-00020-g3ee72ca #1
[ 4420.437746] -------------------------------------------------------
[ 4420.437748] qemu-kvm/3764 is trying to acquire lock:
[ 4420.437751] (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81050f81>] 
get_online_cpus+0x2e/0x42
[ 4420.437761]
[ 4420.437762] but task is already holding lock:
[ 4420.437764] (&sp->mutex){+.+...}, at: [<ffffffff810708d4>] 
__synchronize_srcu+0x27/0x8b
[ 4420.437771]
[ 4420.437772] which lock already depends on the new lock.
[ 4420.437773]
[ 4420.437775]
[ 4420.437776] the existing dependency chain (in reverse order) is:
[ 4420.437778]
[ 4420.437779] -> #3 (&sp->mutex){+.+...}:
[ 4420.437783] [<ffffffff8107f241>] lock_acquire+0xbf/0x103
[ 4420.437789] [<ffffffff814ae13b>] __mutex_lock_common+0x4c/0x340
[ 4420.437795] [<ffffffff814ae502>] mutex_lock_nested+0x2f/0x36
[ 4420.437799] [<ffffffff810708d4>] __synchronize_srcu+0x27/0x8b
[ 4420.437802] [<ffffffff81070964>] synchronize_srcu+0x15/0x17
[ 4420.437806] [<ffffffff81070fb2>] srcu_notifier_chain_unregister+0x5b/0x69
[ 4420.437811] [<ffffffff813a5169>] cpufreq_unregister_notifier+0x22/0x3c
[ 4420.437816] [<ffffffff813a550a>] cpufreq_governor_userspace+0x155/0x2c6
[ 4420.437820] [<ffffffff813a3ce7>] __cpufreq_governor+0x8b/0xc8
[ 4420.437824] [<ffffffff813a3eb7>] __cpufreq_set_policy+0x193/0x21e
[ 4420.437828] [<ffffffff813a4a23>] store_scaling_governor+0x17c/0x1c2
[ 4420.437831] [<ffffffff813a3bd4>] store+0x5b/0x7e
[ 4420.437835] [<ffffffff8117e1c6>] sysfs_write_file+0x108/0x144
[ 4420.437840] [<ffffffff81120ec2>] vfs_write+0xac/0xf3
[ 4420.437846] [<ffffffff811210b1>] sys_write+0x4a/0x6e
[ 4420.437849] [<ffffffff814b63c2>] system_call_fastpath+0x16/0x1b
[ 4420.437854]
[ 4420.437855] -> #2 (userspace_mutex){+.+...}:
[ 4420.437859] [<ffffffff8107f241>] lock_acquire+0xbf/0x103
[ 4420.437863] [<ffffffff814ae13b>] __mutex_lock_common+0x4c/0x340
[ 4420.437867] [<ffffffff814ae502>] mutex_lock_nested+0x2f/0x36
[ 4420.437871] [<ffffffff813a5411>] cpufreq_governor_userspace+0x5c/0x2c6
[ 4420.437876] [<ffffffff813a3ce7>] __cpufreq_governor+0x8b/0xc8
[ 4420.437879] [<ffffffff813a3ecd>] __cpufreq_set_policy+0x1a9/0x21e
[ 4420.437883] [<ffffffff813a41f2>] cpufreq_add_dev_interface+0x2b0/0x2e7
[ 4420.437887] [<ffffffff813a4708>] cpufreq_add_dev+0x4df/0x4ef
[ 4420.437890] [<ffffffff812e1c48>] sysdev_driver_register+0xc5/0x134
[ 4420.437895] [<ffffffff813a336f>] cpufreq_register_driver+0xc9/0x1bf
[ 4420.437901] [<ffffffffa02580ea>] 0xffffffffa02580ea
[ 4420.437905] [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[ 4420.437910] [<ffffffff8108989c>] sys_init_module+0x88/0x1d2
[ 4420.437915] [<ffffffff814b63c2>] system_call_fastpath+0x16/0x1b
[ 4420.437919]
[ 4420.437920] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[ 4420.437924] [<ffffffff8107f241>] lock_acquire+0xbf/0x103
[ 4420.437929] [<ffffffff814ae8e3>] down_write+0x36/0x45
[ 4420.437933] [<ffffffff813a3b0b>] lock_policy_rwsem_write+0x4b/0x7c
[ 4420.437937] [<ffffffff814a0e3d>] cpufreq_cpu_callback+0x50/0x76
[ 4420.437941] [<ffffffff814b2e2a>] notifier_call_chain+0x59/0x86
[ 4420.437946] [<ffffffff81070d7c>] __raw_notifier_call_chain+0xe/0x10
[ 4420.437950] [<ffffffff81050e97>] __cpu_notify+0x20/0x32
[ 4420.437954] [<ffffffff8148cb97>] _cpu_down+0x7c/0x246
[ 4420.437958] [<ffffffff8105105c>] disable_nonboot_cpus+0x66/0x11e
[ 4420.437963] [<ffffffff8108b545>] suspend_devices_and_enter+0xf8/0x21a
[ 4420.437967] [<ffffffff8108b747>] enter_state+0xe0/0x137
[ 4420.437970] [<ffffffff8108ad0c>] state_store+0xaf/0xc5
[ 4420.437974] [<ffffffff8122b1cb>] kobj_attr_store+0x17/0x19
[ 4420.437979] [<ffffffff8117e1c6>] sysfs_write_file+0x108/0x144
[ 4420.437984] [<ffffffff81120ec2>] vfs_write+0xac/0xf3
[ 4420.437987] [<ffffffff811210b1>] sys_write+0x4a/0x6e
[ 4420.437991] [<ffffffff814b63c2>] system_call_fastpath+0x16/0x1b
[ 4420.437995]
[ 4420.437996] -> #0 (cpu_hotplug.lock){+.+.+.}:
[ 4420.438000] [<ffffffff8107eb04>] __lock_acquire+0xa06/0xce3
[ 4420.438004] [<ffffffff8107f241>] lock_acquire+0xbf/0x103
[ 4420.438008] [<ffffffff814ae13b>] __mutex_lock_common+0x4c/0x340
[ 4420.438013] [<ffffffff814ae502>] mutex_lock_nested+0x2f/0x36
[ 4420.438017] [<ffffffff81050f81>] get_online_cpus+0x2e/0x42
[ 4420.438021] [<ffffffff810aa986>] synchronize_sched_expedited+0x2e/0xc8
[ 4420.438025] [<ffffffff810708e0>] __synchronize_srcu+0x33/0x8b
[ 4420.438029] [<ffffffff8107094d>] synchronize_srcu_expedited+0x15/0x17
[ 4420.438033] [<ffffffffa000560c>] kvm_io_bus_register_dev+0x77/0x8a [kvm]
[ 4420.438052] [<ffffffffa0005fbd>] kvm_coalesced_mmio_init+0xce/0x117 [kvm]
[ 4420.438066] [<ffffffffa00045cb>] kvm_dev_ioctl+0x30f/0x3aa [kvm]
[ 4420.438079] [<ffffffff8112fc54>] do_vfs_ioctl+0x467/0x4a8
[ 4420.438083] [<ffffffff8112fceb>] sys_ioctl+0x56/0x7b
[ 4420.438083] [<ffffffff814b63c2>] system_call_fastpath+0x16/0x1b
[ 4420.438083]
[ 4420.438083] other info that might help us debug this:
[ 4420.438083]
[ 4420.438083] Chain exists of:
[ 4420.438083] cpu_hotplug.lock --> userspace_mutex --> &sp->mutex
[ 4420.438083]
[ 4420.438083] Possible unsafe locking scenario:
[ 4420.438083]
[ 4420.438083] CPU0 CPU1
[ 4420.438083] ---- ----
[ 4420.438083] lock(&sp->mutex);
[ 4420.438083] lock(userspace_mutex);
[ 4420.438083] lock(&sp->mutex);
[ 4420.438083] lock(cpu_hotplug.lock);
[ 4420.438083]
[ 4420.438083] *** DEADLOCK ***
[ 4420.438083]
[ 4420.438083] 2 locks held by qemu-kvm/3764:
[ 4420.438083] #0: (&kvm->slots_lock){+.+.+.}, at: [<ffffffffa0005fb0>] 
kvm_coalesced_mmio_init+0xc1/0x117 [kvm]
[ 4420.438083] #1: (&sp->mutex){+.+...}, at: [<ffffffff810708d4>] 
__synchronize_srcu+0x27/0x8b
[ 4420.438083]
[ 4420.438083] stack backtrace:
[ 4420.438083] Pid: 3764, comm: qemu-kvm Not tainted 
3.1.0-rc9-00020-g3ee72ca #1
[ 4420.438083] Call Trace:
[ 4420.438083] [<ffffffff814a5981>] print_circular_bug+0x1f8/0x209
[ 4420.438083] [<ffffffff8107eb04>] __lock_acquire+0xa06/0xce3
[ 4420.438083] [<ffffffff8107cceb>] ? save_trace+0x3d/0xa7
[ 4420.438083] [<ffffffff8107ed32>] ? __lock_acquire+0xc34/0xce3
[ 4420.438083] [<ffffffff81050f81>] ? get_online_cpus+0x2e/0x42
[ 4420.438083] [<ffffffff8107f241>] lock_acquire+0xbf/0x103
[ 4420.438083] [<ffffffff81050f81>] ? get_online_cpus+0x2e/0x42
[ 4420.438083] [<ffffffff814ae13b>] __mutex_lock_common+0x4c/0x340
[ 4420.438083] [<ffffffff81050f81>] ? get_online_cpus+0x2e/0x42
[ 4420.438083] [<ffffffff8107f682>] ? trace_hardirqs_on_caller+0x121/0x158
[ 4420.438083] [<ffffffff81050f81>] ? get_online_cpus+0x2e/0x42
[ 4420.438083] [<ffffffff810708d4>] ? __synchronize_srcu+0x27/0x8b
[ 4420.438083] [<ffffffff810aa958>] ? synchronize_sched+0x7f/0x7f
[ 4420.438083] [<ffffffff814ae502>] mutex_lock_nested+0x2f/0x36
[ 4420.438083] [<ffffffff81050f81>] get_online_cpus+0x2e/0x42
[ 4420.438083] [<ffffffff810aa986>] synchronize_sched_expedited+0x2e/0xc8
[ 4420.438083] [<ffffffff810aa958>] ? synchronize_sched+0x7f/0x7f
[ 4420.438083] [<ffffffff810708e0>] __synchronize_srcu+0x33/0x8b
[ 4420.438083] [<ffffffff8107094d>] synchronize_srcu_expedited+0x15/0x17
[ 4420.438083] [<ffffffffa000560c>] kvm_io_bus_register_dev+0x77/0x8a [kvm]
[ 4420.438083] [<ffffffffa0005fbd>] kvm_coalesced_mmio_init+0xce/0x117 [kvm]
[ 4420.438083] [<ffffffffa00045cb>] kvm_dev_ioctl+0x30f/0x3aa [kvm]
[ 4420.438083] [<ffffffffa00042bc>] ? kvm_put_kvm+0x124/0x124 [kvm]
[ 4420.438083] [<ffffffff8112fc54>] do_vfs_ioctl+0x467/0x4a8
[ 4420.438083] [<ffffffff8112fceb>] sys_ioctl+0x56/0x7b
[ 4420.438083] [<ffffffff814b63c2>] system_call_fastpath+0x16/0x1b
.


when using qemu-kvm and an *,iso image.
not sure if the current has a fix for this or not.
Note: I am not on lkml lists so you will have to Cc me.

Justin P. Mattock
