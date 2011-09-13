Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1IMPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:17:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56052 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754829Ab1IMPRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:17:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WskVITi1WIpEDsijzowoQBONhHN0wS8WgDs35AN
	/VrTK5rvsCwEE1
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315921009.5977.6.camel@twins>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315737307.6544.1.camel@marge.simson.net>
	 <1315817948.26517.16.camel@twins>
	 <1315835562.6758.3.camel@marge.simson.net>
	 <1315839187.6758.8.camel@marge.simson.net>  <1315921009.5977.6.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 17:17:37 +0200
Message-ID: <1315927057.6445.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 15:36 +0200, Peter Zijlstra wrote:
> On Mon, 2011-09-12 at 16:53 +0200, Mike Galbraith wrote:
> > On Mon, 2011-09-12 at 15:52 +0200, Mike Galbraith wrote:
> > 
> > > 36717            <...>-6266  [002]   242.543129: sys_semop <-system_call_fastpath
> > > 36718            <...>-6266  [002]   242.543129: sys_semtimedop <-sys_semop
> > > 36719            <...>-6266  [002]   242.543131: ipc_lock_check <-sys_semtimedop
> > > 36720            <...>-6266  [002]   242.543131: ipc_lock <-ipc_lock_check
> > > 36721            <...>-6266  [002]   242.543132: __rcu_read_lock <-ipc_lock
> > > 36722            <...>-6266  [002]   242.543133: migrate_disable <-ipc_lock
> > > 36723            <...>-6266  [002]   242.543134: migrate_disable: migrate_disable: in_atomic:0 p->migrate_disable_atomic:0 p->migrate_disable:0
> > > 36724            <...>-6266  [002]   242.543134: pin_current_cpu <-migrate_disable
> > > 36725            <...>-6266  [002]   242.543134: _raw_spin_lock_irqsave <-migrate_disable
> > > 36726            <...>-6266  [002]   242.543135: _raw_spin_unlock_irqrestore <-migrate_disable
> > > 36727            <...>-6266  [002]   242.543135: rt_spin_lock <-ipc_lock
> > > 36728            <...>-6266  [002]   242.543136: ipcperms <-sys_semtimedop
> > > 36729            <...>-6266  [002]   242.543137: ns_capable <-ipcperms
> > > 36730            <...>-6266  [002]   242.543138: cap_capable <-ns_capable
> > > 36731            <...>-6266  [002]   242.543138: pid_vnr <-sys_semtimedop
> > > 36732            <...>-6266  [002]   242.543139: try_atomic_semop <-sys_semtimedop
> > > 36733            <...>-6266  [002]   242.543140: do_smart_update <-sys_semtimedop
> > > 36734            <...>-6266  [002]   242.543140: update_queue <-do_smart_update
> > > 36735            <...>-6266  [002]   242.543141: try_atomic_semop <-update_queue
> > > 36736            <...>-6266  [002]   242.543142: update_queue <-do_smart_update
> > > 36737            <...>-6266  [002]   242.543142: try_atomic_semop <-update_queue
> > > 36738            <...>-6266  [002]   242.543143: update_queue <-do_smart_update
> > > 36739            <...>-6266  [002]   242.543143: try_atomic_semop <-update_queue
> > > 36740            <...>-6266  [002]   242.543144: get_seconds <-do_smart_update
> > > 36741            <...>-6266  [002]   242.543144: rt_spin_unlock <-sys_semtimedop
> > > 36742            <...>-6266  [002]   242.543144: migrate_enable <-sys_semtimedop
> > > 36743            <...>-6266  [002]   242.543145: migrate_enable: migrate_enable: in_atomic:1 p->migrate_disable_atomic:0 p->migrate_disable:1
> > 
> > Hm.  Seems this is home grown a non-preemptive wakeup in the making.
> 
> Does the below cure things? It breaks !rt builds, but we can cure that if it works..

Warning is gone, ship it ;-)

[  216.115993] BUG: soft lockup - CPU#1 stuck for 23s! [lmsched:6247]
[  216.115996] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge ipv6 stp cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave microcode acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep kvm_intel usb_storage snd_pcm snd_timer kvm sr_mod cdrom usb_libusual uas sg e1000e snd firewire_ohci firewire_core i2c_i801 soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 usbhid hid uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
[  216.116000] CPU 1 
[  216.116000] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge ipv6 stp cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave microcode acpi_cpufreq mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep kvm_intel usb_storage snd_pcm snd_timer kvm sr_mod cdrom usb_libusual uas sg e1000e snd firewire_ohci firewire_core i2c_i801 soundcore snd_page_alloc crc_itu_t button ext4 mbcache jbd2 crc16 usbhid hid uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
[  216.116000] 
[  216.116000] Pid: 6247, comm: lmsched Not tainted 3.0.4-rt13 #2049 MEDIONPC MS-7502/MS-7502
[  216.116000] RIP: 0010:[<ffffffff81359b62>]  [<ffffffff81359b62>] _raw_spin_lock+0x22/0x30
[  216.116000] RSP: 0018:ffff8801f1a97b98  EFLAGS: 00000293
[  216.116000] RAX: 0000000000006900 RBX: ffffffff81036ec0 RCX: 0000000000000001
[  216.116000] RDX: ffff8801ed3d2300 RSI: 0000000000000282 RDI: ffff8801f1a97f70
[  216.116000] RBP: ffff8801f1a97b98 R08: ffff88022fcdf128 R09: 0000000000000040
[  216.116000] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8135b02e
[  216.116000] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8801ed3d2300
[  216.116000] FS:  00007f5989dde720(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[  216.116000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  216.116000] CR2: 00007f0f32fc2000 CR3: 0000000222212000 CR4: 00000000000006e0
[  216.116000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  216.116000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  216.116000] Process lmsched (pid: 6247, threadinfo ffff8801f1a96000, task ffff8801ed3d2300)
[  216.116000] Stack:
[  216.116000]  ffff8801f1a97c48 ffffffff81359353 ffff88022693a540 ffff88022fcdf040
[  216.116000]  ffff88022693a540 0000000000000005 ffff88022fcdf040 ffff88022693a540
[  216.116000]  ffff8801f1a97bf8 ffffffff81036024 0000000000000001 ffff88022693a540
[  216.116000] Call Trace:
[  216.116000]  [<ffffffff81359353>] rt_spin_lock_slowlock+0x33/0x1b0
[  216.116000]  [<ffffffff81036024>] ? check_preempt_curr+0x84/0xa0
[  216.116000]  [<ffffffff8103d84f>] ? ttwu_do_wakeup+0x5f/0x130
[  216.116000]  [<ffffffff81359836>] rt_spin_lock+0x26/0x30
[  216.116000]  [<ffffffff8103eea9>] __wake_up+0x39/0x70
[  216.116000]  [<ffffffff81174d70>] wake_up_sem_queue_do+0x60/0x70
[  216.116000]  [<ffffffff8117611d>] sys_semtimedop+0x36d/0xb40
[  216.116000]  [<ffffffff8106dfdc>] ? __hrtimer_start_range_ns+0x15c/0x2c0
[  216.116000]  [<ffffffff810964fb>] ? rcu_read_unlock_special+0x1bb/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8103dd8d>] ? migrate_disable+0x15d/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8105c0eb>] ? do_sigtimedwait+0xab/0x1d0
[  216.116000]  [<ffffffff8105c299>] ? sys_rt_sigtimedwait+0x89/0xe0
[  216.116000]  [<ffffffff81068005>] ? sys_timer_settime+0x185/0x220
[  216.116000]  [<ffffffff81176a00>] copy_semundo+0xf0/0x100
[  216.116000]  [<ffffffff8135a72b>] system_call_fastpath+0x16/0x1b
[  216.116000] Code: 00 00 00 00 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 65 48 8b 04 25 c8 95 00 00 ff 80 44 e0 ff ff b8 00 01 00 00 f0 66 0f c1 07 
[  216.116000]  e0 74 06 f3 90 8a 07 eb f6 c9 c3 66 90 55 48 89 e5 66 66 66 
[  216.116000] Call Trace:
[  216.116000]  [<ffffffff81359353>] rt_spin_lock_slowlock+0x33/0x1b0
[  216.116000]  [<ffffffff81036024>] ? check_preempt_curr+0x84/0xa0
[  216.116000]  [<ffffffff8103d84f>] ? ttwu_do_wakeup+0x5f/0x130
[  216.116000]  [<ffffffff81359836>] rt_spin_lock+0x26/0x30
[  216.116000]  [<ffffffff8103eea9>] __wake_up+0x39/0x70
[  216.116000]  [<ffffffff81174d70>] wake_up_sem_queue_do+0x60/0x70
[  216.116000]  [<ffffffff8117611d>] sys_semtimedop+0x36d/0xb40
[  216.116000]  [<ffffffff8106dfdc>] ? __hrtimer_start_range_ns+0x15c/0x2c0
[  216.116000]  [<ffffffff810964fb>] ? rcu_read_unlock_special+0x1bb/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8103dd8d>] ? migrate_disable+0x15d/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8105c0eb>] ? do_sigtimedwait+0xab/0x1d0
[  216.116000]  [<ffffffff8105c299>] ? sys_rt_sigtimedwait+0x89/0xe0
[  216.116000]  [<ffffffff81068005>] ? sys_timer_settime+0x185/0x220
[  216.116000]  [<ffffffff81176a00>] copy_semundo+0xf0/0x100
[  216.116000]  [<ffffffff8135a72b>] system_call_fastpath+0x16/0x1b
[  216.116000] Kernel panic - not syncing: softlockup: hung tasks
[  216.116000] Pid: 6247, comm: lmsched Not tainted 3.0.4-rt13 #2049
[  216.116000] Call Trace:
[  216.116000]  <IRQ>  [<ffffffff81357080>] panic+0xa0/0x1a8
[  216.116000]  [<ffffffff8108fd63>] watchdog_timer_fn+0x183/0x190
[  216.116000]  [<ffffffff8106d683>] __run_hrtimer+0x73/0x240
[  216.116000]  [<ffffffff8108fbe0>] ? __touch_watchdog+0x30/0x30
[  216.116000]  [<ffffffff8106e2f4>] hrtimer_interrupt+0x174/0x340
[  216.116000]  [<ffffffff8135bb29>] smp_apic_timer_interrupt+0x69/0x99
[  216.116000]  [<ffffffff8135b033>] apic_timer_interrupt+0x13/0x20
[  216.116000]  <EOI>  [<ffffffff81036ec0>] ? update_curr_rt+0x180/0x230
[  216.116000]  [<ffffffff81359b62>] ? _raw_spin_lock+0x22/0x30
[  216.116000]  [<ffffffff81038bf0>] ? enqueue_task_rt+0x120/0x2e0
[  216.116000]  [<ffffffff81359353>] rt_spin_lock_slowlock+0x33/0x1b0
[  216.116000]  [<ffffffff81036024>] ? check_preempt_curr+0x84/0xa0
[  216.116000]  [<ffffffff8103d84f>] ? ttwu_do_wakeup+0x5f/0x130
[  216.116000]  [<ffffffff81359836>] rt_spin_lock+0x26/0x30
[  216.116000]  [<ffffffff8103eea9>] __wake_up+0x39/0x70
[  216.116000]  [<ffffffff81174d70>] wake_up_sem_queue_do+0x60/0x70
[  216.116000]  [<ffffffff8117611d>] sys_semtimedop+0x36d/0xb40
[  216.116000]  [<ffffffff8106dfdc>] ? __hrtimer_start_range_ns+0x15c/0x2c0
[  216.116000]  [<ffffffff810964fb>] ? rcu_read_unlock_special+0x1bb/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8103dd8d>] ? migrate_disable+0x15d/0x1f0
[  216.116000]  [<ffffffff8103db42>] ? migrate_enable+0x192/0x280
[  216.116000]  [<ffffffff8105c0eb>] ? do_sigtimedwait+0xab/0x1d0
[  216.116000]  [<ffffffff8105c299>] ? sys_rt_sigtimedwait+0x89/0xe0
[  216.116000]  [<ffffffff81068005>] ? sys_timer_settime+0x185/0x220
[  216.116000]  [<ffffffff81176a00>] copy_semundo+0xf0/0x100
[  216.116000]  [<ffffffff8135a72b>] system_call_fastpath+0x16/0x1b


