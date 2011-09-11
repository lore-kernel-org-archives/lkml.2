Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1IKKfO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 06:35:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37522 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753990Ab1IKKfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:35:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YtOg6IHaYFLvc6bLTIB0/Ctm+y8V7xVp6mpXmQx
	ju3NY0IaOs7Ro8
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1109101052340.2723@ionos>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 12:35:07 +0200
Message-ID: <1315737307.6544.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-10 at 11:12 +0200, Thomas Gleixner wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0.4-rt13 release.
> 
> Changes versus 3.0.2-rt11
> 
>   * Migrate disable cure (Mike, Peter)

The warning triggers.

[  134.105241] ------------[ cut here ]------------
[  134.105249] WARNING: at kernel/sched.c:6146 migrate_disable+0x1ae/0x1f0()
[  134.105250] Hardware name: MS-7502
[  134.105252] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge ipv6 stp cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq microcode mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep kvm_intel kvm snd_pcm usb_storage usb_libusual uas snd_timer snd sr_mod cdrom firewire_ohci sg firewire_core e1000e soundcore snd_page_alloc crc_itu_t i2c_i801 button ext4 mbcache jbd2 crc16 usbhid hid uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
[  134.105291] Pid: 6224, comm: lmsched Not tainted 3.0.4-rt13 #2040
[  134.105293] Call Trace:
[  134.105298]  [<ffffffff8103e25a>] warn_slowpath_common+0x7a/0xb0
[  134.105300]  [<ffffffff8103e2a5>] warn_slowpath_null+0x15/0x20
[  134.105303]  [<ffffffff810360de>] migrate_disable+0x1ae/0x1f0
[  134.105307]  [<ffffffff8104f3e2>] do_sigtimedwait+0x62/0x1c0
[  134.105310]  [<ffffffff8104f5c4>] sys_rt_sigtimedwait+0x84/0xd0
[  134.105314] ------------[ cut here ]------------
[  134.105324] WARNING: at kernel/sched.c:6146 migrate_disable+0x1ae/0x1f0()
[  134.105329]  [<ffffffff8105a215>] ? sys_timer_settime+0x185/0x220
[  134.105331] Hardware name: MS-7502
[  134.105334] Modules linked in: [<ffffffff8130983b>] system_call_fastpath+0x16/0x1b
[  134.105341]  snd_pcm_oss
[  134.105343] ---[ end trace 0000000000000002 ]---
[  134.105346]  snd_mixer_oss
[  134.105348] ------------[ cut here ]------------
[  134.105351]  snd_seq
[  134.105354] WARNING: at kernel/sched.c:6205 migrate_enable+0x200/0x280()
[  134.105357]  snd_seq_device
[  134.105359] Hardware name: MS-7502
[  134.105363] ------------[ cut here ]------------
[  134.105369]  edd
[  134.105370] Modules linked in:
[  134.105376] WARNING: at kernel/sched.c:6205 migrate_enable+0x200/0x280()
[  134.105384]  nfsd snd_pcm_oss
[  134.105387] Hardware name: MS-7502
[  134.105391]  lockd snd_mixer_oss
[  134.105393] Modules linked in: nfs_acl snd_seq snd_pcm_oss auth_rpcgss snd_seq_device snd_mixer_oss sunrpc edd snd_seq parport_pc nfsd snd_seq_device parport lockd edd bridge nfs_acl nfsd ipv6 auth_rpcgss lockd stp sunrpc nfs_acl cpufreq_conservative parport_pc auth_rpcgss cpufreq_ondemand parport sunrpc cpufreq_userspace bridge parport_pc cpufreq_powersave ipv6 parport acpi_cpufreq stp bridge microcode cpufreq_conservative ipv6 mperf cpufreq_ondemand stp nls_iso8859_1 cpufreq_userspace cpufreq_conservative nls_cp437 cpufreq_powersave cpufreq_ondemand vfat acpi_cpufreq cpufreq_userspace fat microcode cpufreq_powersave fuse mperf acpi_cpufreq ext3 nls_iso8859_1 microcode jbd nls_cp437 mperf dm_mod vfat nls_iso8859_1 snd_hda_codec_realtek fat nls_cp437 snd_hda_intel fuse vfat snd_hda_codec ext3 fat snd_hwdep jbd fuse kvm_intel dm_mod ext3 kvm snd_hda_codec_realtek jbd snd_pcm snd_hda_intel dm_mod usb_storage snd_hda_codec snd_hda_codec_realtek usb_libusual snd_hwdep snd_hda_intel uas kvm_intel snd_hda_codec snd_timer kvm snd_hwdep snd snd_pcm kvm_intel sr_mod usb_storage kvm cdrom usb_libusual snd_pcm firewire_ohci uas usb_storage sg snd_timer usb_libusual firewire_core snd uas e1000e sr_mod snd_timer soundcore cdrom snd snd_page_alloc firewire_ohci sr_mod crc_itu_t sg cdrom i2c_i801 firewire_core firewire_ohci button e1000e sg ext4 soundcore firewire_core mbcache snd_page_alloc e1000e jbd2 crc_itu_t soundcore crc16 i2c_i801 snd_page_alloc usbhid button crc_itu_t hid ext4 i2c_i801 uhci_hcd mbcache button sd_mod jbd2 ext4 ehci_hcd crc16 mbcache usbcore usbhid jbd2 rtc_cmos hid crc16 ahci uhci_hcd usbhid libahci sd_mod hid libata ehci_hcd uhci_hcd scsi_mod usbcore sd_mod fan rtc_cmos ehci_hcd processor ahci usbcore thermal libahci rtc_cmos
[  134.105548]  libata ahciPid: 6220, comm: lmsched Tainted: G        W   3.0.4-rt13 #2040
[  134.105553]  scsi_mod libahciCall Trace:
[  134.105559]  fan libata processor scsi_mod thermal fan [<ffffffff8103e25a>] warn_slowpath_common+0x7a/0xb0
[  134.105566] 
[  134.105568]  processorPid: 6224, comm: lmsched Tainted: G        W   3.0.4-rt13 #2040
[  134.105577]  thermal [<ffffffff8103e2a5>] warn_slowpath_null+0x15/0x20
[  134.105582] Call Trace:
[  134.105584] 
[  134.105588] Pid: 6222, comm: lmsched Tainted: G        W   3.0.4-rt13 #2040
[  134.105596]  [<ffffffff810360de>] migrate_disable+0x1ae/0x1f0
[  134.105599]  [<ffffffff8103e25a>] warn_slowpath_common+0x7a/0xb0
[  134.105606] Call Trace:
[  134.105611]  [<ffffffff8104f3e2>] do_sigtimedwait+0x62/0x1c0
[  134.105614]  [<ffffffff8103e2a5>] warn_slowpath_null+0x15/0x20
[  134.105622]  [<ffffffff8103e25a>] warn_slowpath_common+0x7a/0xb0
[  134.105631]  [<ffffffff8104f5c4>] sys_rt_sigtimedwait+0x84/0xd0
[  134.105635]  [<ffffffff81035eb0>] migrate_enable+0x200/0x280
[  134.105642]  [<ffffffff8103e2a5>] warn_slowpath_null+0x15/0x20
[  134.105650]  [<ffffffff81307547>] ? preempt_schedule_irq+0x37/0x50
[  134.105655]  [<ffffffff8104f4df>] do_sigtimedwait+0x15f/0x1c0
[  134.105664]  [<ffffffff81035eb0>] migrate_enable+0x200/0x280
[  134.105672]  [<ffffffff81309346>] ? retint_kernel+0x26/0x30
[  134.105676]  [<ffffffff8104f5c4>] sys_rt_sigtimedwait+0x84/0xd0
[  134.105683]  [<ffffffff8104f4df>] do_sigtimedwait+0x15f/0x1c0
[  134.105691]  [<ffffffff8130983b>] system_call_fastpath+0x16/0x1b
[  134.105694]  [<ffffffff8105a215>] ? sys_timer_settime+0x185/0x220
[  134.105703]  [<ffffffff8104f5c4>] sys_rt_sigtimedwait+0x84/0xd0
[  134.105710] ---[ end trace 0000000000000003 ]---
[  134.105714]  [<ffffffff8130983b>] system_call_fastpath+0x16/0x1b
[  134.105721]  [<ffffffff8105a215>] ? sys_timer_settime+0x185/0x220
[  134.105726] ------------[ cut here ]------------
[  134.105729] ---[ end trace 0000000000000004 ]---
[  134.105735] WARNING: at kernel/sched.c:6205 migrate_enable+0x200/0x280()
[  134.105739]  [<ffffffff8130983b>] system_call_fastpath+0x16/0x1b
[  134.105742] Hardware name: MS-7502
[  134.105744] ---[ end trace 0000000000000005 ]---
[  134.105746] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfsd lockd nfs_acl auth_rpcgss sunrpc parport_pc parport bridge ipv6 stp cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq microcode mperf nls_iso8859_1 nls_cp437 vfat fat fuse ext3 jbd dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep kvm_intel kvm snd_pcm usb_storage usb_libusual uas snd_timer snd sr_mod cdrom firewire_ohci sg firewire_core e1000e soundcore snd_page_alloc crc_itu_t i2c_i801 button ext4 mbcache jbd2 crc16 usbhid hid uhci_hcd sd_mod ehci_hcd usbcore rtc_cmos ahci libahci libata scsi_mod fan processor thermal
[  134.105769] Pid: 6220, comm: lmsched Tainted: G        W   3.0.4-rt13 #2040
[  134.105771] Call Trace:
[  134.105773]  [<ffffffff8103e25a>] warn_slowpath_common+0x7a/0xb0
[  134.105775]  [<ffffffff8103e2a5>] warn_slowpath_null+0x15/0x20
[  134.105777]  [<ffffffff81035eb0>] migrate_enable+0x200/0x280
[  134.105779]  [<ffffffff8104f4df>] do_sigtimedwait+0x15f/0x1c0
[  134.105782]  [<ffffffff8104f5c4>] sys_rt_sigtimedwait+0x84/0xd0
[  134.105784]  [<ffffffff81307547>] ? preempt_schedule_irq+0x37/0x50
[  134.105786]  [<ffffffff81309346>] ? retint_kernel+0x26/0x30
[  134.105789]  [<ffffffff8130983b>] system_call_fastpath+0x16/0x1b
[  134.105791] ---[ end trace 0000000000000006 ]---

(gdb) list *do_sigtimedwait+0x62
0xffffffff8104f3e2 is in do_sigtimedwait (kernel/signal.c:2628).
2623             * Invert the set of allowed signals to get those we want to block.
2624             */
2625            sigdelsetmask(&mask, sigmask(SIGKILL) | sigmask(SIGSTOP));
2626            signotset(&mask);
2627
2628            spin_lock_irq(&tsk->sighand->siglock);
2629            sig = dequeue_signal(tsk, &mask, info);
2630            if (!sig && timeout) {
2631                    /*
2632                     * None ready, temporarily unblock those we're interested
(gdb) list *do_sigtimedwait+0x15f
0xffffffff8104f4df is in do_sigtimedwait (kernel/signal.c:2642).
2637                    tsk->real_blocked = tsk->blocked;
2638                    sigandsets(&tsk->blocked, &tsk->blocked, &mask);
2639                    recalc_sigpending();
2640                    spin_unlock_irq(&tsk->sighand->siglock);
2641
2642                    timeout = schedule_timeout_interruptible(timeout);
2643
2644                    spin_lock_irq(&tsk->sighand->siglock);
2645                    __set_task_blocked(tsk, &tsk->real_blocked);
2646                    siginitset(&tsk->real_blocked, 0);



