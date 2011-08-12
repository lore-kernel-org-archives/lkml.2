Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1HLRpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:45:12 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:38453 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752826Ab1HLRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:45:09 -0400
Date: Fri, 12 Aug 2011 10:28:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Josef Lusticky <jlustick@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Unable to handle kernel paging request
Message-Id: <20110812102856.8493b94e.rdunlap@xenotime.net>
In-Reply-To: <4E451ED0.1000909@redhat.com>
References: <4E3FD98C.8040607@redhat.com>
	<20110808114840.c0cbabef.rdunlap@xenotime.net>
	<4E451ED0.1000909@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 14:38:40 +0200 Josef Lusticky wrote:

> Hi Randy,
> thank you for your answer!
> 
> The commit seems to fix issues with ip_vs_ctl module,
> but I got another panic today using the script on the same machine.
> Here's the output:

Hi Josef,

Adding linux-media mailing list...


> *** Loading module lirc_dev ***
> lirc_dev: module unloaded
> IR JVC protocol handler initialized
> IR Sony protocol handler initialized
> IR MCE Keyboard/mouse protocol handler initialized
> lirc_dev: IR Remote Control driver registered, major 250
> IR LIRC bridge handler initialized
> *** Removing modBUG: unable to handle kernel paging request at 
> ffffffffa0852acc
> IP: [<ffffffffa0852acc>] 0xffffffffa0852acb
> PGD 1a06067 PUD 1a0a063 PMD 37e50067 PTE 0
> Oops: 0010 [#1] SMP
> CPU 1
> Modules linked in: ir_lirc_codec lirc_dev ir_mce_kbd_decoder 
> ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder 
> ir_nec_decoder rc_core soc_mediabus ivtv cx2341x v4l2_common videodev 
> v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote des_generic dccp_ipv6 
> dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core ts_kmp kvm mce_inject 
> cryptd aes_x86_64 aes_generic snd_mpu401_uart snd_rawmidi snd_seq_dummy 
> snd_seq snd_seq_device sunrpc cpufreq_ondemand acpi_cpufreq freq_table 
> mperf ipv6 dm_mirror dm_region_hash dm_log ppdev parport_pc parport 
> hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3 
> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd 
> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy 
> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper 
> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
> 
> Pid: 39, comm: kworker/1:2 Tainted: G          I 3.1.0-rc1 #1 
> Hewlett-Packard HP xw4600 Workstation/0AA0h
> RIP: 0010:[<ffffffffa0852acc>]  [<ffffffffa0852acc>] 0xffffffffa0852acb
> RSP: 0000:ffff8800387ffdf0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff880038784740 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000286
> RBP: ffff8800387ffdf0 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003fc8e140
> R13: ffff88003fc96400 R14: ffffffffa0852ab0 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffffffa0852acc CR3: 000000003608c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/1:2 (pid: 39, threadinfo ffff8800387fe000, task 
> ffff8800386d8b00)
> Stack:
>   ffff8800387ffe50 ffffffff81082e11 ffff880000062ac0 ffffffffa08544e0
>   ffff88003fc96405 000000003fc8e140 ffff880038784740 ffff880038784740
>   ffff88003fc8e140 ffff88003fc8e148 ffff880038784760 0000000000013c80
> Call Trace:
>   [<ffffffff81082e11>] process_one_work+0x131/0x450
>   [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>   [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>   [<ffffffff810894d6>] kthread+0x96/0xa0
>   [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>   [<ffffffff814f0110>] ? gs_change+0x13/0x13
> Code:  Bad RIP value.
> RIP  [<ffffffffa0852acc>] 0xffffffffa0852acb
>   RSP <ffff8800387ffdf0>
> CR2: ffffffffa0852acc
> ---[ end trace a7919e7f17c0a727 ]---
> ule xpnet ***
> *BUG: unable to handle kernel paging request at fffffffffffffff8
> IP: [<ffffffff81089030>] kthread_data+0x10/0x20
> PGD 1a06067 PUD 1a07067 PMD 0
> Oops: 0000 [#2] SMP
> CPU 1
> Modules linked in: xpnet(-) xp gru ir_lirc_codec lirc_dev 
> ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder 
> ir_rc5_decoder ir_nec_decoder rc_core soc_mediabus ivtv cx2341x 
> v4l2_common videodev v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote 
> des_generic dccp_ipv6 dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core 
> ts_kmp kvm mce_inject cryptd aes_x86_64 aes_generic snd_mpu401_uart 
> snd_rawmidi snd_seq_dummy snd_seq snd_seq_device sunrpc cpufreq_ondemand 
> acpi_cpufreq freq_table mperf ipv6 dm_mirror dm_region_hash dm_log ppdev 
> parport_pc parport hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3 
> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd 
> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy 
> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper 
> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
> 
> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1 
> Hewlett-Packard HP xw4600 Workstation/0AA0h
> RIP: 0010:[<ffffffff81089030>]  [<ffffffff81089030>] kthread_data+0x10/0x20
> RSP: 0018:ffff8800387ffa38  EFLAGS: 00010096
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
> RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8800386d8b00
> RBP: ffff8800387ffa38 R08: ffff8800386d8b70 R09: dead000000200200
> R10: 0000000000000400 R11: 0000000000000001 R12: ffff8800386d90a8
> R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000096
> FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: fffffffffffffff8 CR3: 000000003608c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/1:2 (pid: 39, threadinfo ffff8800387fe000, task 
> ffff8800386d8b00)
> Stack:
>   ffff8800387ffa58 ffffffff81082365 ffff8800387ffa58 ffff88003fc93280
>   ffff8800387ffaf8 ffffffff814e3a63 ffff880035c2cda8 ffff880035c2cdf8
>   0000000000013280 ffff8800387fffd8 ffff8800387fe010 0000000000013280
> Call Trace:
>   [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>   [<ffffffff814e3a63>] schedule+0x5e3/0x850
>   [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>   [<ffffffff8106b85a>] do_exit+0x26a/0x410
>   [<ffffffff814e702b>] oops_end+0xab/0xf0
>   [<ffffffff8104196c>] no_context+0xfc/0x190
>   [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>   [<ffffffff8124f371>] ? list_del+0x11/0x40
>   [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>   [<ffffffff814e9866>] do_page_fault+0x326/0x460
>   [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>   [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>   [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>   [<ffffffff814e6375>] page_fault+0x25/0x30
>   [<ffffffff81082e11>] process_one_work+0x131/0x450
>   [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>   [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>   [<ffffffff810894d6>] kthread+0x96/0xa0
>   [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>   [<ffffffff814f0110>] ? gs_change+0x13/0x13
> Code: 66 66 66 90 65 48 8b 04 25 40 c4 00 00 48 8b 80 50 05 00 00 8b 40 
> f0 c9 c3 66 90 55 48 89 e5 66 66 66 66 90 48 8b 87 50 05 00 00
>   8b 40 f8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
> RIP  [<ffffffff81089030>] kthread_data+0x10/0x20
>   RSP <ffff8800387ffa38>
> CR2: fffffffffffffff8
> ---[ end trace a7919e7f17c0a728 ]---
> Fixing recursive fault but reboot is needed!
> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1
> Call Trace:
> <NMI>  [<ffffffff814e30fb>] panic+0x91/0x1b1
>   [<ffffffff810ccc11>] watchdog_overflow_callback+0xb1/0xc0
>   [<ffffffff81102073>] __perf_event_overflow+0x93/0x200
>   [<ffffffff810905e8>] ? sched_clock_cpu+0xb8/0x110
>   [<ffffffff810fca01>] ? perf_event_update_userpage+0x11/0xc0
>   [<ffffffff811025d4>] perf_event_overflow+0x14/0x20
>   [<ffffffff81025e51>] intel_pmu_handle_irq+0x321/0x530
>   [<ffffffff814e7649>] perf_event_nmi_handler+0x29/0xa0
>   [<ffffffff814e99f5>] notifier_call_chain+0x55/0x80
>   [<ffffffff814e9a5a>] atomic_notifier_call_chain+0x1a/0x20
>   [<ffffffff814e9a8e>] notify_die+0x2e/0x30
>   [<ffffffff814e6c39>] default_do_nmi+0x39/0x1f0
>   [<ffffffff814e6e70>] do_nmi+0x80/0xa0
>   [<ffffffff814e6630>] nmi+0x20/0x30
>   [<ffffffff8106b9b0>] ? do_exit+0x3c0/0x410
>   [<ffffffff814e5c25>] ? _raw_spin_lock_irq+0x25/0x30
> <<EOE>>  [<ffffffff814e354e>] schedule+0xce/0x850
>   [<ffffffff8106b9b0>] do_exit+0x3c0/0x410
>   [<ffffffff814e702b>] oops_end+0xab/0xf0
>   [<ffffffff8104196c>] no_context+0xfc/0x190
>   [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>   [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>   [<ffffffff814e9866>] do_page_fault+0x326/0x460
>   [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>   [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>   [<ffffffff814e6375>] page_fault+0x25/0x30
>   [<ffffffff81089030>] ? kthread_data+0x10/0x20
>   [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>   [<ffffffff814e3a63>] schedule+0x5e3/0x850
>   [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>   [<ffffffff8106b85a>] do_exit+0x26a/0x410
>   [<ffffffff814e702b>] oops_end+0xab/0xf0
>   [<ffffffff8104196c>] no_context+0xfc/0x190
>   [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>   [<ffffffff8124f371>] ? list_del+0x11/0x40
>   [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>   [<ffffffff814e9866>] do_page_fault+0x326/0x460
>   [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>   [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>   [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>   [<ffffffff814e6375>] page_fault+0x25/0x30
>   [<ffffffff81082e11>] process_one_work+0x131/0x450
>   [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>   [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>   [<ffffffff810894d6>] kthread+0x96/0xa0
>   [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>   [<ffffffff814f0110>] ? gs_change+0x13/0x13
> panic occurred, switching back to text console
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x5c/0x60()
> Hardware name: HP xw4600 Workstation
> Modules linked in: xpnet(-) xp gru ir_lirc_codec lirc_dev 
> ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder 
> ir_rc5_decoder ir_nec_decoder rc_core soc_mediabus ivtv cx2341x 
> v4l2_common videodev v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote 
> des_generic dccp_ipv6 dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core 
> ts_kmp kvm mce_inject cryptd aes_x86_64 aes_generic snd_mpu401_uart 
> snd_rawmidi snd_seq_dummy snd_seq snd_seq_device sunrpc cpufreq_ondemand 
> acpi_cpufreq freq_table mperf ipv6 dm_mirror dm_region_hash dm_log ppdev 
> parport_pc parport hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3 
> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd 
> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy 
> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper 
> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1
> Call Trace:
> <IRQ>  [<ffffffff81066dbf>] warn_slowpath_common+0x7f/0xc0
>   [<ffffffff81066e1a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8103066c>] native_smp_send_reschedule+0x5c/0x60
>   [<ffffffff8105e64a>] try_to_wake_up+0x1da/0x2a0
>   [<ffffffff8105e722>] default_wake_function+0x12/0x20
>   [<ffffffff81089b6d>] autoremove_wake_function+0x1d/0x50
>   [<ffffffff8110fa5f>] ? free_pages+0x4f/0x60
>   [<ffffffff8104e6c9>] __wake_up_common+0x59/0x90
>   [<ffffffff81053df8>] __wake_up+0x48/0x70
>   [<ffffffff810678f4>] printk_tick+0x44/0x50
>   [<ffffffff8107686d>] update_process_times+0x4d/0x90
>   [<ffffffff8109b1c6>] tick_sched_timer+0x66/0xc0
>   [<ffffffff810d36be>] ? __rcu_process_callbacks+0x5e/0x1d0
>   [<ffffffff8108dc62>] __run_hrtimer+0x82/0x1d0
>   [<ffffffff8109b160>] ? tick_nohz_handler+0x100/0x100
>   [<ffffffff8108e036>] hrtimer_interrupt+0x106/0x240
>   [<ffffffff814f0ba9>] smp_apic_timer_interrupt+0x69/0x99
>   [<ffffffff814eea5e>] apic_timer_interrupt+0x6e/0x80
> <EOI> <NMI>  [<ffffffff814e31d3>] ? panic+0x169/0x1b1
>   [<ffffffff814e3130>] ? panic+0xc6/0x1b1
>   [<ffffffff810ccc11>] watchdog_overflow_callback+0xb1/0xc0
>   [<ffffffff81102073>] __perf_event_overflow+0x93/0x200
>   [<ffffffff810905e8>] ? sched_clock_cpu+0xb8/0x110
>   [<ffffffff810fca01>] ? perf_event_update_userpage+0x11/0xc0
>   [<ffffffff811025d4>] perf_event_overflow+0x14/0x20
>   [<ffffffff81025e51>] intel_pmu_handle_irq+0x321/0x530
>   [<ffffffff814e7649>] perf_event_nmi_handler+0x29/0xa0
>   [<ffffffff814e99f5>] notifier_call_chain+0x55/0x80
>   [<ffffffff814e9a5a>] atomic_notifier_call_chain+0x1a/0x20
>   [<ffffffff814e9a8e>] notify_die+0x2e/0x30
>   [<ffffffff814e6c39>] default_do_nmi+0x39/0x1f0
>   [<ffffffff814e6e70>] do_nmi+0x80/0xa0
>   [<ffffffff814e6630>] nmi+0x20/0x30
>   [<ffffffff8106b9b0>] ? do_exit+0x3c0/0x410
>   [<ffffffff814e5c25>] ? _raw_spin_lock_irq+0x25/0x30
> <<EOE>>  [<ffffffff814e354e>] schedule+0xce/0x850
>   [<ffffffff8106b9b0>] do_exit+0x3c0/0x410
>   [<ffffffff814e702b>] oops_end+0xab/0xf0
>   [<ffffffff8104196c>] no_context+0xfc/0x190
>   [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>   [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>   [<ffffffff814e9866>] do_page_fault+0x326/0x460
>   [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>   [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>   [<ffffffff814e6375>] page_fault+0x25/0x30
>   [<ffffffff81089030>] ? kthread_data+0x10/0x20
>   [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>   [<ffffffff814e3a63>] schedule+0x5e3/0x850
>   [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>   [<ffffffff8106b85a>] do_exit+0x26a/0x410
>   [<ffffffff814e702b>] oops_end+0xab/0xf0
>   [<ffffffff8104196c>] no_context+0xfc/0x190
>   [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>   [<ffffffff8124f371>] ? list_del+0x11/0x40
>   [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>   [<ffffffff814e9866>] do_page_fault+0x326/0x460
>   [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>   [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>   [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>   [<ffffffff814e6375>] page_fault+0x25/0x30
>   [<ffffffff81082e11>] process_one_work+0x131/0x450
>   [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>   [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>   [<ffffffff810894d6>] kthread+0x96/0xa0
>   [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>   [<ffffffff814f0110>] ? gs_change+0x13/0x13
> ---[ end trace a7919e7f17c0a729 ]---


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
