Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab1H3Hbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1H3Hbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:31:42 -0400
Message-ID: <4E5C91DB.4020208@redhat.com>
Date: Tue, 30 Aug 2011 09:31:39 +0200
From: Josef Lusticky <jlustick@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Unable to handle kernel paging request
References: <4E3FD98C.8040607@redhat.com> <20110808114840.c0cbabef.rdunlap@xenotime.net> <4E451ED0.1000909@redhat.com> <20110812102856.8493b94e.rdunlap@xenotime.net> <4E457987.8090707@redhat.com>
In-Reply-To: <4E457987.8090707@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 12.8.2011 21:05, Mauro Carvalho Chehab napsal(a):
> Hi Josef,
>
> Em 12-08-2011 14:28, Randy Dunlap escreveu:
>> On Fri, 12 Aug 2011 14:38:40 +0200 Josef Lusticky wrote:
>>
>>> Hi Randy,
>>> thank you for your answer!
>>>
>>> The commit seems to fix issues with ip_vs_ctl module,
>>> but I got another panic today using the script on the same machine.
>>> Here's the output:
>> Hi Josef,
>>
>> Adding linux-media mailing list...
>
> What kernel are you using? There were some fixes applied recently
> that fixes the register/unregister logic at the rc-core stuff. It helps
> if you could test against linux-next (not sure if all such fixes were already
> added at 3.0).
>
>>
>>> *** Loading module lirc_dev ***
>>> lirc_dev: module unloaded
>>> IR JVC protocol handler initialized
>>> IR Sony protocol handler initialized
>>> IR MCE Keyboard/mouse protocol handler initialized
>>> lirc_dev: IR Remote Control driver registered, major 250
>>> IR LIRC bridge handler initialized
>>> *** Removing modBUG: unable to handle kernel paging request at
>>> ffffffffa0852acc
>>> IP: [<ffffffffa0852acc>] 0xffffffffa0852acb
>>> PGD 1a06067 PUD 1a0a063 PMD 37e50067 PTE 0
>>> Oops: 0010 [#1] SMP
>>> CPU 1
>>> Modules linked in: ir_lirc_codec lirc_dev ir_mce_kbd_decoder
>>> ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder
>>> ir_nec_decoder rc_core soc_mediabus ivtv cx2341x v4l2_common videodev
>>> v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote des_generic dccp_ipv6
>>> dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core ts_kmp kvm mce_inject
>>> cryptd aes_x86_64 aes_generic snd_mpu401_uart snd_rawmidi snd_seq_dummy
>>> snd_seq snd_seq_device sunrpc cpufreq_ondemand acpi_cpufreq freq_table
>>> mperf ipv6 dm_mirror dm_region_hash dm_log ppdev parport_pc parport
>>> hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3
>>> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd
>>> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy
>>> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper
>>> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
>>>
>>> Pid: 39, comm: kworker/1:2 Tainted: G          I 3.1.0-rc1 #1
>>> Hewlett-Packard HP xw4600 Workstation/0AA0h
>>> RIP: 0010:[<ffffffffa0852acc>]  [<ffffffffa0852acc>] 0xffffffffa0852acb
>>> RSP: 0000:ffff8800387ffdf0  EFLAGS: 00010246
>>> RAX: 0000000000000000 RBX: ffff880038784740 RCX: 0000000000000000
>>> RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000286
>>> RBP: ffff8800387ffdf0 R08: 0000000000000000 R09: 0000000000000001
>>> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003fc8e140
>>> R13: ffff88003fc96400 R14: ffffffffa0852ab0 R15: 0000000000000000
>>> FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: ffffffffa0852acc CR3: 000000003608c000 CR4: 00000000000006e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process kworker/1:2 (pid: 39, threadinfo ffff8800387fe000, task
>>> ffff8800386d8b00)
>>> Stack:
>>>    ffff8800387ffe50 ffffffff81082e11 ffff880000062ac0 ffffffffa08544e0
>>>    ffff88003fc96405 000000003fc8e140 ffff880038784740 ffff880038784740
>>>    ffff88003fc8e140 ffff88003fc8e148 ffff880038784760 0000000000013c80
>>> Call Trace:
>>>    [<ffffffff81082e11>] process_one_work+0x131/0x450
>>>    [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>>>    [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>>>    [<ffffffff810894d6>] kthread+0x96/0xa0
>>>    [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>>>    [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>>>    [<ffffffff814f0110>] ? gs_change+0x13/0x13
>>> Code:  Bad RIP value.
>>> RIP  [<ffffffffa0852acc>] 0xffffffffa0852acb
>>>    RSP<ffff8800387ffdf0>
>>> CR2: ffffffffa0852acc
>>> ---[ end trace a7919e7f17c0a727 ]---
>>> ule xpnet ***
>>> *BUG: unable to handle kernel paging request at fffffffffffffff8
>>> IP: [<ffffffff81089030>] kthread_data+0x10/0x20
>>> PGD 1a06067 PUD 1a07067 PMD 0
>>> Oops: 0000 [#2] SMP
>>> CPU 1
>>> Modules linked in: xpnet(-) xp gru ir_lirc_codec lirc_dev
>>> ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
>>> ir_rc5_decoder ir_nec_decoder rc_core soc_mediabus ivtv cx2341x
>>> v4l2_common videodev v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote
>>> des_generic dccp_ipv6 dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core
>>> ts_kmp kvm mce_inject cryptd aes_x86_64 aes_generic snd_mpu401_uart
>>> snd_rawmidi snd_seq_dummy snd_seq snd_seq_device sunrpc cpufreq_ondemand
>>> acpi_cpufreq freq_table mperf ipv6 dm_mirror dm_region_hash dm_log ppdev
>>> parport_pc parport hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3
>>> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd
>>> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy
>>> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper
>>> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
>>>
>>> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1
>>> Hewlett-Packard HP xw4600 Workstation/0AA0h
>>> RIP: 0010:[<ffffffff81089030>]  [<ffffffff81089030>] kthread_data+0x10/0x20
>>> RSP: 0018:ffff8800387ffa38  EFLAGS: 00010096
>>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
>>> RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8800386d8b00
>>> RBP: ffff8800387ffa38 R08: ffff8800386d8b70 R09: dead000000200200
>>> R10: 0000000000000400 R11: 0000000000000001 R12: ffff8800386d90a8
>>> R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000096
>>> FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> CR2: fffffffffffffff8 CR3: 000000003608c000 CR4: 00000000000006e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process kworker/1:2 (pid: 39, threadinfo ffff8800387fe000, task
>>> ffff8800386d8b00)
>>> Stack:
>>>    ffff8800387ffa58 ffffffff81082365 ffff8800387ffa58 ffff88003fc93280
>>>    ffff8800387ffaf8 ffffffff814e3a63 ffff880035c2cda8 ffff880035c2cdf8
>>>    0000000000013280 ffff8800387fffd8 ffff8800387fe010 0000000000013280
>>> Call Trace:
>>>    [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>>>    [<ffffffff814e3a63>] schedule+0x5e3/0x850
>>>    [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>>>    [<ffffffff8106b85a>] do_exit+0x26a/0x410
>>>    [<ffffffff814e702b>] oops_end+0xab/0xf0
>>>    [<ffffffff8104196c>] no_context+0xfc/0x190
>>>    [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>>>    [<ffffffff8124f371>] ? list_del+0x11/0x40
>>>    [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>>>    [<ffffffff814e9866>] do_page_fault+0x326/0x460
>>>    [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>>>    [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>>>    [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>>>    [<ffffffff814e6375>] page_fault+0x25/0x30
>>>    [<ffffffff81082e11>] process_one_work+0x131/0x450
>>>    [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>>>    [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>>>    [<ffffffff810894d6>] kthread+0x96/0xa0
>>>    [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>>>    [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>>>    [<ffffffff814f0110>] ? gs_change+0x13/0x13
>>> Code: 66 66 66 90 65 48 8b 04 25 40 c4 00 00 48 8b 80 50 05 00 00 8b 40
>>> f0 c9 c3 66 90 55 48 89 e5 66 66 66 66 90 48 8b 87 50 05 00 00
>>>    8b 40 f8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
>>> RIP  [<ffffffff81089030>] kthread_data+0x10/0x20
>>>    RSP<ffff8800387ffa38>
>>> CR2: fffffffffffffff8
>>> ---[ end trace a7919e7f17c0a728 ]---
>>> Fixing recursive fault but reboot is needed!
>>> Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
>>> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1
>>> Call Trace:
>>> <NMI>   [<ffffffff814e30fb>] panic+0x91/0x1b1
>>>    [<ffffffff810ccc11>] watchdog_overflow_callback+0xb1/0xc0
>>>    [<ffffffff81102073>] __perf_event_overflow+0x93/0x200
>>>    [<ffffffff810905e8>] ? sched_clock_cpu+0xb8/0x110
>>>    [<ffffffff810fca01>] ? perf_event_update_userpage+0x11/0xc0
>>>    [<ffffffff811025d4>] perf_event_overflow+0x14/0x20
>>>    [<ffffffff81025e51>] intel_pmu_handle_irq+0x321/0x530
>>>    [<ffffffff814e7649>] perf_event_nmi_handler+0x29/0xa0
>>>    [<ffffffff814e99f5>] notifier_call_chain+0x55/0x80
>>>    [<ffffffff814e9a5a>] atomic_notifier_call_chain+0x1a/0x20
>>>    [<ffffffff814e9a8e>] notify_die+0x2e/0x30
>>>    [<ffffffff814e6c39>] default_do_nmi+0x39/0x1f0
>>>    [<ffffffff814e6e70>] do_nmi+0x80/0xa0
>>>    [<ffffffff814e6630>] nmi+0x20/0x30
>>>    [<ffffffff8106b9b0>] ? do_exit+0x3c0/0x410
>>>    [<ffffffff814e5c25>] ? _raw_spin_lock_irq+0x25/0x30
>>> <<EOE>>   [<ffffffff814e354e>] schedule+0xce/0x850
>>>    [<ffffffff8106b9b0>] do_exit+0x3c0/0x410
>>>    [<ffffffff814e702b>] oops_end+0xab/0xf0
>>>    [<ffffffff8104196c>] no_context+0xfc/0x190
>>>    [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>>>    [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>>>    [<ffffffff814e9866>] do_page_fault+0x326/0x460
>>>    [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>>>    [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>>>    [<ffffffff814e6375>] page_fault+0x25/0x30
>>>    [<ffffffff81089030>] ? kthread_data+0x10/0x20
>>>    [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>>>    [<ffffffff814e3a63>] schedule+0x5e3/0x850
>>>    [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>>>    [<ffffffff8106b85a>] do_exit+0x26a/0x410
>>>    [<ffffffff814e702b>] oops_end+0xab/0xf0
>>>    [<ffffffff8104196c>] no_context+0xfc/0x190
>>>    [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>>>    [<ffffffff8124f371>] ? list_del+0x11/0x40
>>>    [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>>>    [<ffffffff814e9866>] do_page_fault+0x326/0x460
>>>    [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>>>    [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>>>    [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>>>    [<ffffffff814e6375>] page_fault+0x25/0x30
>>>    [<ffffffff81082e11>] process_one_work+0x131/0x450
>>>    [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>>>    [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>>>    [<ffffffff810894d6>] kthread+0x96/0xa0
>>>    [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>>>    [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>>>    [<ffffffff814f0110>] ? gs_change+0x13/0x13
>>> panic occurred, switching back to text console
>>> ------------[ cut here ]------------
>>> WARNING: at arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x5c/0x60()
>>> Hardware name: HP xw4600 Workstation
>>> Modules linked in: xpnet(-) xp gru ir_lirc_codec lirc_dev
>>> ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
>>> ir_rc5_decoder ir_nec_decoder rc_core soc_mediabus ivtv cx2341x
>>> v4l2_common videodev v4l2_compat_ioctl32 tveeprom dvb_usb_af9005_remote
>>> des_generic dccp_ipv6 dccp_ipv4 dccp sctp libcrc32c nf_tproxy_core
>>> ts_kmp kvm mce_inject cryptd aes_x86_64 aes_generic snd_mpu401_uart
>>> snd_rawmidi snd_seq_dummy snd_seq snd_seq_device sunrpc cpufreq_ondemand
>>> acpi_cpufreq freq_table mperf ipv6 dm_mirror dm_region_hash dm_log ppdev
>>> parport_pc parport hp_wmi sparse_keymap rfkill pcspkr serio_raw sg tg3
>>> snd_hda_codec_realtek snd_hda_codec snd_hwdep snd_pcm snd_timer snd
>>> soundcore snd_page_alloc x38_edac edac_core ext4 mbcache jbd2 floppy
>>> sr_mod cdrom sd_mod crc_t10dif ahci libahci nouveau ttm drm_kms_helper
>>> drm i2c_algo_bit i2c_core mxm_wmi wmi video dm_mod [last unloaded: lirc_dev]
>>> Pid: 39, comm: kworker/1:2 Tainted: G      D   I 3.1.0-rc1 #1
>>> Call Trace:
>>> <IRQ>   [<ffffffff81066dbf>] warn_slowpath_common+0x7f/0xc0
>>>    [<ffffffff81066e1a>] warn_slowpath_null+0x1a/0x20
>>>    [<ffffffff8103066c>] native_smp_send_reschedule+0x5c/0x60
>>>    [<ffffffff8105e64a>] try_to_wake_up+0x1da/0x2a0
>>>    [<ffffffff8105e722>] default_wake_function+0x12/0x20
>>>    [<ffffffff81089b6d>] autoremove_wake_function+0x1d/0x50
>>>    [<ffffffff8110fa5f>] ? free_pages+0x4f/0x60
>>>    [<ffffffff8104e6c9>] __wake_up_common+0x59/0x90
>>>    [<ffffffff81053df8>] __wake_up+0x48/0x70
>>>    [<ffffffff810678f4>] printk_tick+0x44/0x50
>>>    [<ffffffff8107686d>] update_process_times+0x4d/0x90
>>>    [<ffffffff8109b1c6>] tick_sched_timer+0x66/0xc0
>>>    [<ffffffff810d36be>] ? __rcu_process_callbacks+0x5e/0x1d0
>>>    [<ffffffff8108dc62>] __run_hrtimer+0x82/0x1d0
>>>    [<ffffffff8109b160>] ? tick_nohz_handler+0x100/0x100
>>>    [<ffffffff8108e036>] hrtimer_interrupt+0x106/0x240
>>>    [<ffffffff814f0ba9>] smp_apic_timer_interrupt+0x69/0x99
>>>    [<ffffffff814eea5e>] apic_timer_interrupt+0x6e/0x80
>>> <EOI>  <NMI>   [<ffffffff814e31d3>] ? panic+0x169/0x1b1
>>>    [<ffffffff814e3130>] ? panic+0xc6/0x1b1
>>>    [<ffffffff810ccc11>] watchdog_overflow_callback+0xb1/0xc0
>>>    [<ffffffff81102073>] __perf_event_overflow+0x93/0x200
>>>    [<ffffffff810905e8>] ? sched_clock_cpu+0xb8/0x110
>>>    [<ffffffff810fca01>] ? perf_event_update_userpage+0x11/0xc0
>>>    [<ffffffff811025d4>] perf_event_overflow+0x14/0x20
>>>    [<ffffffff81025e51>] intel_pmu_handle_irq+0x321/0x530
>>>    [<ffffffff814e7649>] perf_event_nmi_handler+0x29/0xa0
>>>    [<ffffffff814e99f5>] notifier_call_chain+0x55/0x80
>>>    [<ffffffff814e9a5a>] atomic_notifier_call_chain+0x1a/0x20
>>>    [<ffffffff814e9a8e>] notify_die+0x2e/0x30
>>>    [<ffffffff814e6c39>] default_do_nmi+0x39/0x1f0
>>>    [<ffffffff814e6e70>] do_nmi+0x80/0xa0
>>>    [<ffffffff814e6630>] nmi+0x20/0x30
>>>    [<ffffffff8106b9b0>] ? do_exit+0x3c0/0x410
>>>    [<ffffffff814e5c25>] ? _raw_spin_lock_irq+0x25/0x30
>>> <<EOE>>   [<ffffffff814e354e>] schedule+0xce/0x850
>>>    [<ffffffff8106b9b0>] do_exit+0x3c0/0x410
>>>    [<ffffffff814e702b>] oops_end+0xab/0xf0
>>>    [<ffffffff8104196c>] no_context+0xfc/0x190
>>>    [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>>>    [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>>>    [<ffffffff814e9866>] do_page_fault+0x326/0x460
>>>    [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>>>    [<ffffffff810d3405>] ? call_rcu_sched+0x15/0x20
>>>    [<ffffffff814e6375>] page_fault+0x25/0x30
>>>    [<ffffffff81089030>] ? kthread_data+0x10/0x20
>>>    [<ffffffff81082365>] wq_worker_sleeping+0x15/0xa0
>>>    [<ffffffff814e3a63>] schedule+0x5e3/0x850
>>>    [<ffffffff8122812b>] ? put_io_context+0x4b/0x60
>>>    [<ffffffff8106b85a>] do_exit+0x26a/0x410
>>>    [<ffffffff814e702b>] oops_end+0xab/0xf0
>>>    [<ffffffff8104196c>] no_context+0xfc/0x190
>>>    [<ffffffff81041b25>] __bad_area_nosemaphore+0x125/0x1e0
>>>    [<ffffffff8124f371>] ? list_del+0x11/0x40
>>>    [<ffffffff81041bf3>] bad_area_nosemaphore+0x13/0x20
>>>    [<ffffffff814e9866>] do_page_fault+0x326/0x460
>>>    [<ffffffff81053e03>] ? __wake_up+0x53/0x70
>>>    [<ffffffff81080b9e>] ? call_usermodehelper_exec+0x9e/0xe0
>>>    [<ffffffff81080e1b>] ? __request_module+0x18b/0x220
>>>    [<ffffffff814e6375>] page_fault+0x25/0x30
>>>    [<ffffffff81082e11>] process_one_work+0x131/0x450
>>>    [<ffffffff81084bbb>] worker_thread+0x17b/0x3c0
>>>    [<ffffffff81084a40>] ? manage_workers+0x120/0x120
>>>    [<ffffffff810894d6>] kthread+0x96/0xa0
>>>    [<ffffffff814f0114>] kernel_thread_helper+0x4/0x10
>>>    [<ffffffff81089440>] ? kthread_worker_fn+0x1a0/0x1a0
>>>    [<ffffffff814f0110>] ? gs_change+0x13/0x13
>>> ---[ end trace a7919e7f17c0a729 ]---
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello,
I got this panic today using kernel 3.1.0-rc4 on i686 machine:

*** Loading module saa7146_vv **IR Sony protocol handler initialized
BUG: unable to handle kernel paging request at f899b7c7
IP: [<f899b7c7>] 0xf899b7c6
*pdpt = 0000000000af2001 *pde = 0000000028c68067 *pte = 0000000000000000
Oops: 0010 [#1] SMP
Modules linked in: videobuf_core ir_sony_decoder(+) ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core 
dvb_usb_af9005_remote aes_generic des_generic input_polldev 
sparse_keymap nls_cp932 nls_koi8_u bridge stp llc sunrpc 
cpufreq_ondemand acpi_cpufreq mperf ipv6 cdc_ether usbnet mii microcode 
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac 
edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx 
scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas 
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ir_rc5_sz_decoder]

Pid: 4794, comm: kworker/9:2 Tainted: G        W   3.1.0-rc4 #1 IBM 
BladeCenter HS22 -[7870B3G]-/68Y8182
EIP: 0060:[<f899b7c7>] EFLAGS: 00010282 CPU: 9
EIP is at 0xf899b7c7
EAX: 00000000 EBX: f899cc70 ECX: e77b9ebc EDX: 00000000
ESI: f899cc74 EDI: e7622780 EBP: ee323200 ESP: e77b9f50
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/9:2 (pid: 4794, ti=e77b8000 task=e7207ab0 task.ti=e77b8000)
Stack:
  00000001 f899c4b2 c046d9d8 c0aed580 c0aed580 c0aed580 00000000 ee328100
  00000000 f899b7b0 ee328105 e7622780 ee323200 ee323204 e7207ab0 c046eb88
  00000003 e7622790 c0aedb40 c0aedb40 e7622790 e7207ab0 ee323200 e7207ab0
Call Trace:
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Code:  Bad EIP value.
EIP: [<f899b7c7>] 0xf899b7c7 SS:ESP 0068:e77b9f50
CR2: 00000000f899b7c7
---[ end trace a7919e7f17c0a733 ]---
BUG: unable to handle kernel paging request at fffffffc
IP: [<c0472ac6>] kthread_data+0x6/0x10
*pdpt = 0000000000af2001 *pde = 00000000011fb067 *pte = 0000000000000000
Oops: 0000 [#2] SMP
Modules linked in: videobuf_core ir_sony_decoder(+) ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core 
dvb_usb_af9005_remote aes_generic des_generic input_polldev 
sparse_keymap nls_cp932 nls_koi8_u bridge stp llc sunrpc 
cpufreq_ondemand acpi_cpufreq mperf ipv6 cdc_ether usbnet mii microcode 
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac 
edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx 
scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas 
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ir_rc5_sz_decoder]

Pid: 4794, comm: kworker/9:2 Tainted: G      D W   3.1.0-rc4 #1 IBM 
BladeCenter HS22 -[7870B3G]-/68Y8182
EIP: 0060:[<c0472ac6>] EFLAGS: 00010002 CPU: 9
EIP is at kthread_data+0x6/0x10
EAX: 00000000 EBX: 00000009 ECX: c0aed580 EDX: 00000009
ESI: e7207d40 EDI: 00000000 EBP: e7207ab0 ESP: e77b9dac
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/9:2 (pid: 4794, ti=e77b8000 task=e7207ab0 task.ti=e77b8000)
Stack:
  c046d119 00000009 e7207d40 c0830131 00000086 e77b9dd4 f6fa4848 e93c0da4
  c05d7d1d ee327580 c0aed580 e8c0f000 e4efd050 c0aed580 c0aed580 c0aed580
  c0aed580 00000082 e91d45e0 f6fa4848 e8c0f000 f6fa4868 e93c0d88 c05d0600
Call Trace:
  [<c046d119>] ? wq_worker_sleeping+0x9/0x80
  [<c0830131>] ? schedule+0x561/0x820
  [<c05d7d1d>] ? radix_tree_delete+0x18d/0x230
  [<c05d0600>] ? __cfq_exit_single_io_context+0x60/0xa0
  [<c05cc7d9>] ? cic_free_func+0x59/0x80
  [<c0458f4b>] ? do_exit+0x1db/0x360
  [<c0455266>] ? kmsg_dump+0x36/0xd0
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c046bee9>] ? __request_module+0x129/0x1c0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c046d9d8>] ? process_one_work+0xf8/0x360
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 9
Pid: 4794, comm: kworker/9:2 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:>] ? kthread+0x74/0x80
  [<c082f910>] ? panic+0x57/0x158n+0x150/0x150
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb00 90 90 90 90 90 64 
a1 ec 7d ae c0 8b 80 64 02 00 00 8b 40 f8 c3 8b 80 64 02 00 00 <8b> 40 
fc c3 8d b6 00 00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260068:e77b9dac
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c05db5bb>] ? string+0x3b/0xd02.00
  [<c05dc04c>] ? pointer+0x7c/0x2e0
  [<c0478655>] ? down_trylock+0x25/0x40
  [<c045543a>] ? console_trylock+0xa/0x5030 03:03:42 ...
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20...
  [<c0835990>] ? notify_die+0x30/0x4094, ti=e77b8000 task=e7207ab0 
task.ti=e77b8000)
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80 at Aug 30 03:03:42 ...
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c045908c>] ? do_exit+0x31c/0x360
  [<c0831d5a>] ? _raw_spin_lock_irq+0x1a/0x203:03:42 ...
  [<c082fc7c>] ? schedule+0xac/0x820
  [<c0478655>] ? down_trylock+0x25/0x40
  [<c045543a>] ? console_trylock+0xa/0x50
  [<c0472ada>] ? tsk_fork_get_node+0xa/0x10
  [<c04100b8>] ? __switch_to+0x108/0x1b0
  [<c045908c>] ? do_exit+0x31c/0x360
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c044882f>] ? update_curr+0x1bf/0x2f0
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c0442c92>] ? account_entity_dequeue+0x72/0x90
  [<c044fdaf>] ? dequeue_entity+0x6f/0x1a0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c044007b>] ? ftrace_raw_output_sched_stat_runtime+0xab/0xf0
  [<c0472ac6>] ? kthread_data+0x6/0x10
  [<c046d119>] ? wq_worker_sleeping+0x9/0x80
  [<c0830131>] ? schedule+0x561/0x820
  [<c05d7d1d>] ? radix_tree_delete+0x18d/0x230
  [<c05d0600>] ? __cfq_exit_single_io_context+0x60/0xa0
  [<c05cc7d9>] ? cic_free_func+0x59/0x80
  [<c0458f4b>] ? do_exit+0x1db/0x360
  [<c0455266>] ? kmsg_dump+0x36/0xd0
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c046bee9>] ? __request_module+0x129/0x1c0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 13
Pid: 5, comm: kworker/u:0 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260:42 ...
  [<c047764d>] ? hrtimer_interrupt+0x1ad/0x290
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20:03:42 ...
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510:e77b9f50
  [<c042c231>] ? smp_apic_timer_interrupt+0x51/0x90
  [<c045ad25>] ? irq_exit+0x35/0xc0t Aug 30 03:03:42 ...
  [<c042c231>] ? smp_apic_timer_interrupt+0x51/0x90
  [<c0832a29>] ? apic_timer_interrupt+0x31/0x38
  [<c05a63b3>] ? constraint_expr_eval+0x3d3/0x3e0:42 ...
  [<c05e3958>] ? list_del+0x8/0x20
  [<c04de9f3>] ? __rmqueue+0x93/0x430
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80:42 ...
  [<c0835914>] ? notifier_call_chain+0x44/0x607b8000 task=e7207ab0 
task.ti=e77b8000)
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40Aug 30 03:03:42 ...
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c044a4f9>] ? select_task_rq_fair+0x519/0x600
  [<c083345f>] ? do_nmi+0x5f/0x80 at Aug 30 03:03:42 ...
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c0831d02>] ? _raw_spin_lock+0x12/0x20
  [<c044e4a2>] ? wake_up_new_task+0x72/0x12003:03:42 ...
  [<c0454431>] ? do_fork+0xb1/0x2e0 51 18 eb 8a 90 90 90 90 90 90 90 90 
90 90 64 a1 ec 7d ae c0 8b 80 64 02 00 00 8b 40 f8 c3 8b 80 64 02 00 00 
<8b> 40 fc c3 8d b6 00 00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc
  [<c041008b>] ? __switch_to+0xdb/0x1b0
  [<c046bae0>] ? ____call_usermodehelper+0xe0/0xe042 ...
  [<c041773c>] ? kernel_thread+0x9c/0xb00x6/0x10 SS:ESP 0068:e77b9dac
  [<c046bae0>] ? ____call_usermodehelper+0xe0/0xe0
  [<c08393b8>] ? common_interrupt+0x38/0x38 03:03:42 ...
  [<c046bda1>] ? __call_usermodehelper+0x81/0xa0
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c046d7c0>] ? cwq_activate_first_delayed+0x40/0xd0
  [<c046bd20>] ? call_usermodehelper_exec+0xd0/0xd0
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
Pid: 2, comm: kthreadd Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c0483a89>] ? tick_program_event+0x19/0x20
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c045ad25>] ? irq_exit+0x35/0xc0
  [<c042c231>] ? smp_apic_timer_interrupt+0x51/0x90
  [<c05e3958>] ? list_del+0x8/0x20
  [<c04de9f3>] ? __rmqueue+0x93/0x430
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c044a4f9>] ? select_task_rq_fair+0x519/0x600
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c0831d02>] ? _raw_spin_lock+0x12/0x20
  [<c044e4a2>] ? wake_up_new_task+0x72/0x120
  [<c0454431>] ? do_fork+0xb1/0x2e0
  [<c082ff4e>] ? schedule+0x37e/0x820
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c041773c>] ? kernel_thread+0x9c/0xb0
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393b8>] ? common_interrupt+0x38/0x38
  [<c0472f4f>] ? kthreadd+0xbf/0xf0
  [<c0472e90>] ? kthread+0x80/0x80
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 15
Pid: 72, comm: migration/15 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c044007b>] ? ftrace_raw_output_sched_stat_runtime+0xab/0xf0
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d00>] ? _raw_spin_lock+0x10/0x20
  [<c0442616>] ? double_rq_lock+0x26/0x60
  [<c044d6a4>] ? __migrate_task+0x54/0xd0
  [<c044d73a>] ? migration_cpu_stop+0x1a/0x30
  [<c049fdea>] ? cpu_stopper_thread+0x9a/0x170
  [<c044d720>] ? __migrate_task+0xd0/0xd0
  [<c082ff4e>] ? schedule+0x37e/0x820
  [<c043f7e2>] ? check_preempt_curr+0x62/0x80
  [<c043eba7>] ? __wake_up_common+0x47/0x70
  [<c0443040>] ? complete+0x40/0x60
  [<c049fd50>] ? res_counter_charge+0xf0/0xf0
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 4
Pid: 3027, comm: runtest.sh Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c043cb2b>] ? __kunmap_atomic+0x8b/0xe0
  [<c04f77ad>] ? copy_pte_range+0x37d/0x5a0
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c044a4f9>] ? select_task_rq_fair+0x519/0x600
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c0831d00>] ? _raw_spin_lock+0x10/0x20
  [<c044e4a2>] ? wake_up_new_task+0x72/0x120
  [<c0454431>] ? do_fork+0xb1/0x2e0
  [<c04a7f0e>] ? audit_syscall_entry+0x1ae/0x1d0
  [<c04661ec>] ? set_current_blocked+0x2c/0x50
  [<c046638d>] ? sigprocmask+0x5d/0xb0
  [<c0417780>] ? sys_clone+0x30/0x40
  [<c0838f59>] ? ptregs_clone+0x15/0x3c
  [<c0838e1f>] ? sysenter_do_call+0x12/0x28


----------------------------------------------------------------------------------------------------

Another call trace on the same machine, same kernel version:

*** Loading module saa7146_vIR MCE Keyboard/mouse protocol handler 
initialized
Linux video capture interface: v2.00
BUG: unable to handle kernel paging request at faa067c7
IP: [<faa067c7>] 0xfaa067c6
*pdpt = 0000000000af2001 *pde = 0000000026b50067 *pte = 0000000000000000
Oops: 0010 [#1] SMP
Modules linked in: saa7146_vv(-) videodev ir_mce_kbd_decoder(+) saa7146 
videobuf_dma_sg videobuf_core ir_sony_decoder ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core 
dvb_usb_af9005_remote aes_generic des_generic input_polldev 
sparse_keymap nls_cp932 nls_koi8_u bridge stp llc sunrpc 
cpufreq_ondemand acpi_cpufreq mperf ipv6 cdc_ether usbnet mii microcode 
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac 
edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx 
scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas 
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ir_rc5_sz_decoder]

Pid: 93, comm: kworker/14:1 Tainted: G        W   3.1.0-rc4 #1 IBM 
BladeCenter HS22 -[7870B3G]-/68Y8182
EIP: 0060:[<faa067c7>] EFLAGS: 00010282 CPU: 14
EIP is at 0xfaa067c7
EAX: 00000000 EBX: faa07c70 ECX: e9569ebc EDX: 00000000
ESI: faa07c74 EDI: e9b086c0 EBP: ee3c3200 ESP: e9569f50
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/14:1 (pid: 93, ti=e9568000 task=e9542a30 task.ti=e9568000)
Stack:
  00000001 faa074b2 c046d9d8 c0464197 e9b62000 00000000 00000086 ee3c8100
  00000000 faa067b0 ee3c8105 e9b086c0 ee3c3200 ee3c3204 e9542a30 c046eb88
  00000003 e9b086d0 c0aedb40 c0aedb40 e9b086d0 e9542a30 ee3c3200 e9542a30
Call Trace:
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c0464197>] ? mod_timer+0x127/0x250
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Code:  Bad EIP value.
EIP: [<faa067c7>] 0xfaa067c7 SS:ESP 0068:e9569f50
CR2: 00000000faa067c7
---[ end trace a7919e7f17c0a733 ]---
BUG: unable to handle kernel paging request at fffffffc
IP: [<c0472ac6>] kthread_data+0x6/0x10
*pdpt = 0000000000af2001 *pde = 00000000011fb067 *pte = 0000000000000000
Oops: 0000 [#2] SMP
Modules linked in: saa7146_vv(-) videodev ir_mce_kbd_decoder(+) saa7146 
videobuf_dma_sg videobuf_core ir_sony_decoder ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core 
dvb_usb_af9005_remote aes_generic des_generic input_polldev 
sparse_keymap nls_cp932 nls_koi8_u bridge stp llc sunrpc 
cpufreq_ondemand acpi_cpufreq mperf ipv6 cdc_ether usbnet mii microcode 
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac 
edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx 
scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas 
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ir_rc5_sz_decoder]

Pid: 93, comm: kworker/14:1 Tainted: G      D W   3.1.0-rc4 #1 IBM 
BladeCenter HS22 -[7870B3G]-/68Y8182
EIP: 0060:[<c0472ac6>] EFLAGS: 00010002 CPU: 14
EIP is at kthread_data+0x6/0x10
EAX: 00000000 EBX: 0000000e ECX: c0aed580 EDX: 0000000e
ESI: e9542cc0 EDI: 00000000 EBP: e9542a30 ESP: e9569dac
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kworker/14:1 (pid: 93, ti=e9568000 task=e9542a30 task.ti=e9568000)
Stack:
  c046d119 0000000e e9542cc0 c0830131 00000086 e9569dd4 e900b488 e91b4fb4
  c05d7d1d ee3c7580 c0aed580 e91bd800 edae8be0 c0aed580 c0aed580 c0aed580
  c0aed580 00000082 e91428d8 e900b488 e91bd800 e900b4a8 e91b4f98 c05d0600
Call Trace:
  [<c046d119>] ? wq_worker_sleeping+0x9/0x80
  [<c0830131>] ? schedule+0x561/0x820
  [<c05d7d1d>] ? radix_tree_delete+0x18d/0x230
  [<c05d0600>] ? __cfq_exit_single_io_context+0x60/0xa0
  [<c05cc7d9>] ? cic_free_func+0x59/0x80
  [<c0458f4b>] ? do_exit+0x1db/0x360
  [<c0455266>] ? kmsg_dump+0x36/0xd0
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c046bee9>] ? __request_module+0x129/0x1c0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c0464197>] ? mod_timer+0x127/0x250
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Code: 14 89 41 14 31 c0 89 51 18 eb 8a 90 90 90 90 90 90 90 90 90 90 64 
a1 ec 7d ae c0 8b 80 64 02 00 00 8b 40 f8 c3 8b 80 64 02 00 00 <8b> 40 
fc c3 8d b6 00 00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc
EIP: [<c0472ac6>] kthread_data+0x6/0x10 SS:ESP 0068:e9569dac
CR2: 00000000fffffffc
---[ end trace a7919e7f17c0a734 ]---
Fixing recursive fault but reboot is needed!
v ***

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Oops: 0010 [#1] SMP

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Process kworker/14:1 (pid: 93, ti=e9568000 task=e9542a30 
task.ti=e9568000)

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Stack:

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Call Trace:

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Code:  Bad EIP value.

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:EIP: [<faa067c7>] 0xfaa067c7 SS:ESP 0068:e9569f50

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:CR2: 00000000faa067c7

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Oops: 0000 [#2] SMP

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Process kworker/14:1 (pid: 93, ti=e9568000 task=e9542a30 
task.ti=e9568000)

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Stack:

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Call Trace:

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:Code: 14 89 41 14 31 c0 89 51 18 eb 8a 90 90 90 90 90 90 90 90 
90 90 64 a1 ec 7d ae c0 8b 80 64 02 00 00 8b 40 f8 c3 8b 80 64 02 00 00 
<8b> 40 fc c3 8d b6 00 00 00 00 31 c0 c3 8d b6 00 00 00 00 8d bc

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:EIP: [<c0472ac6>] kthread_data+0x6/0x10 SS:ESP 0068:e9569dac

Message from syslogd@ibm-hs22-03 at Aug 30 03:18:42 ...
  kernel:CR2: 00000000fffffffc
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
Pid: 0, comm: swapper Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c04794a2>] ? sched_clock_local+0xb2/0x190
  [<c04cf22a>] ? perf_event_update_userpage+0x1a/0x160
  [<c0442e63>] ? inc_rt_group+0xc3/0x100
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c0831cfa>] ? _raw_spin_lock+0xa/0x20
  [<c045183c>] ? do_sched_rt_period_timer+0x10c/0x310
  [<c0451a61>] ? sched_rt_period_timer+0x21/0x60
  [<c0477225>] ? __run_hrtimer+0x75/0x190
  [<c047d3b0>] ? ktime_get+0x60/0x100
  [<c0451a40>] ? do_sched_rt_period_timer+0x310/0x310
  [<c0477591>] ? hrtimer_interrupt+0xf1/0x290
  [<c047d3b0>] ? ktime_get+0x60/0x100
  [<c0483082>] ? tick_do_broadcast+0x32/0x70
  [<c0483194>] ? tick_handle_oneshot_broadcast+0xd4/0x110
  [<c04af970>] ? handle_level_irq+0xa0/0xa0
  [<c0412a21>] ? timer_interrupt+0x11/0x20
  [<c04ad2f2>] ? handle_irq_event_percpu+0x52/0x1e0
  [<c042f51a>] ? msi_set_affinity+0x6a/0x80
  [<c04af970>] ? handle_level_irq+0xa0/0xa0
  [<c04ad4ac>] ? handle_irq_event+0x2c/0x50
  [<c04af970>] ? handle_level_irq+0xa0/0xa0
  [<c04af9bc>] ? handle_edge_irq+0x4c/0xd0
<IRQ>  [<c0411d4d>] ? do_IRQ+0x3d/0xc0
  [<c0482c05>] ? tick_notify+0xf5/0x190
  [<c08393b0>] ? common_interrupt+0x30/0x38
  [<c045007b>] ? __enqueue_rt_entity+0xdb/0x240
  [<c0628f60>] ? intel_idle+0xa0/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c0a6e86d>] ? start_kernel+0x390/0x395
  [<c0a6e31b>] ? kernel_init+0x13b/0x13b
  [<c0a6e0bc>] ? i386_start_kernel+0xab/0xb6
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 8
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c041df01>] ? intel_pmu_enable_all+0x91/0x130
  [<c041fa00>] ? intel_pmu_disable_event+0x220/0x220
  [<c041e5b2>] ? x86_pmu_enable+0x1f2/0x270
  [<c04768b3>] ? hrtimer_forward+0x163/0x1b0
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c04794a2>] ? sched_clock_local+0xb2/0x190
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d31>] ? _raw_spin_lock_irqsave+0x21/0x30
  [<c0482725>] ? clockevents_notify+0x15/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 14
Pid: 93, comm: kworker/14:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c05db5bb>] ? string+0x3b/0xd0
  [<c05dc04c>] ? pointer+0x7c/0x2e0
  [<c0478655>] ? down_trylock+0x25/0x40
  [<c045543a>] ? console_trylock+0xa/0x50
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c045908c>] ? do_exit+0x31c/0x360
  [<c0831d58>] ? _raw_spin_lock_irq+0x18/0x20
  [<c082fc7c>] ? schedule+0xac/0x820
  [<c0478655>] ? down_trylock+0x25/0x40
  [<c045543a>] ? console_trylock+0xa/0x50
  [<c0472ada>] ? tsk_fork_get_node+0xa/0x10
  [<c04100b8>] ? __switch_to+0x108/0x1b0
  [<c045908c>] ? do_exit+0x31c/0x360
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c044882f>] ? update_curr+0x1bf/0x2f0
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c0442c92>] ? account_entity_dequeue+0x72/0x90
  [<c044fdaf>] ? dequeue_entity+0x6f/0x1a0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c044007b>] ? ftrace_raw_output_sched_stat_runtime+0xab/0xf0
  [<c0472ac6>] ? kthread_data+0x6/0x10
  [<c046d119>] ? wq_worker_sleeping+0x9/0x80
  [<c0830131>] ? schedule+0x561/0x820
  [<c05d7d1d>] ? radix_tree_delete+0x18d/0x230
  [<c05d0600>] ? __cfq_exit_single_io_context+0x60/0xa0
  [<c05cc7d9>] ? cic_free_func+0x59/0x80
  [<c0458f4b>] ? do_exit+0x1db/0x360
  [<c0455266>] ? kmsg_dump+0x36/0xd0
  [<c08337ab>] ? oops_end+0x8b/0xd0
  [<c0436c2f>] ? bad_area_nosemaphore+0xf/0x20
  [<c08357a7>] ? do_page_fault+0x2d7/0x400
  [<c046bee9>] ? __request_module+0x129/0x1c0
  [<c08354d0>] ? spurious_fault+0x130/0x130
  [<c0832c57>] ? error_code+0x67/0x6c
  [<c046d9d8>] ? process_one_work+0xf8/0x360
  [<c0464197>] ? mod_timer+0x127/0x250
  [<c046eb88>] ? worker_thread+0x138/0x310
  [<c046ea50>] ? manage_workers+0x100/0x100
  [<c0472e84>] ? kthread+0x74/0x80
  [<c0472e10>] ? kthread_worker_fn+0x150/0x150
  [<c08393be>] ? kernel_thread_helper+0x6/0x10
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 11
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c041df01>] ? intel_pmu_enable_all+0x91/0x130
  [<c041df01>] ? intel_pmu_enable_all+0x91/0x130
  [<c041fa00>] ? intel_pmu_disable_event+0x220/0x220
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c0831d31>] ? _raw_spin_lock_irqsave+0x21/0x30
  [<c0483264>] ? tick_broadcast_oneshot_control+0x64/0x130
  [<c0482c05>] ? tick_notify+0xf5/0x190
  [<c042c231>] ? smp_apic_timer_interrupt+0x51/0x90
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c0478827>] ? raw_notifier_call_chain+0x17/0x20
  [<c0482735>] ? clockevents_notify+0x25/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 10
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c041df01>] ? intel_pmu_enable_all+0x91/0x130
  [<c041fa00>] ? intel_pmu_disable_event+0x220/0x220
  [<c041e5b2>] ? x86_pmu_enable+0x1f2/0x270
  [<c04768b3>] ? hrtimer_forward+0x163/0x1b0
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c04794a2>] ? sched_clock_local+0xb2/0x190
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d2f>] ? _raw_spin_lock_irqsave+0x1f/0x30
  [<c0482725>] ? clockevents_notify+0x15/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 9
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c04768b3>] ? hrtimer_forward+0x163/0x1b0
  [<c041df01>] ? intel_pmu_enable_all+0x91/0x130
  [<c041fa00>] ? intel_pmu_disable_event+0x220/0x220
  [<c041e5b2>] ? x86_pmu_enable+0x1f2/0x270
  [<c04768b3>] ? hrtimer_forward+0x163/0x1b0
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c04794a2>] ? sched_clock_local+0xb2/0x190
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d33>] ? _raw_spin_lock_irqsave+0x23/0x30
  [<c0482725>] ? clockevents_notify+0x15/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 6
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c082f910>] ? panic+0x57/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c05da178>] ? timerqueue_add+0x58/0xb0
  [<c047716a>] ? enqueue_hrtimer+0x1a/0x60
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c04124f1>] ? handle_irq+0x21/0xc0
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d31>] ? _raw_spin_lock_irqsave+0x21/0x30
  [<c0482725>] ? clockevents_notify+0x15/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
------------[ cut here ]------------
WARNING: at kernel/rcutree.c:393 rcu_exit_nohz+0x53/0x60()
Hardware name: BladeCenter HS22 -[7870B3G]-
Modules linked in: saa7146_vv(-) videodev ir_mce_kbd_decoder saa7146 
videobuf_dma_sg videobuf_core ir_sony_decoder ir_jvc_decoder 
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core 
dvb_usb_af9005_remote aes_generic des_generic input_polldev 
sparse_keymap nls_cp932 nls_koi8_u bridge stp llc sunrpc 
cpufreq_ondemand acpi_cpufreq mperf ipv6 cdc_ether usbnet mii microcode 
i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support ioatdma dca i7core_edac 
edac_core bnx2 sg ext4 mbcache jbd2 sd_mod crc_t10dif qla2xxx 
scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas 
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ir_rc5_sz_decoder]
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.1.0-rc4 #1
Call Trace:
  [<c0454d68>] ? warn_slowpath_common+0x78/0xb0
  [<c04b1663>] ? rcu_exit_nohz+0x53/0x60
  [<c04b1663>] ? rcu_exit_nohz+0x53/0x60
  [<c0454dbb>] ? warn_slowpath_null+0x1b/0x20
  [<c04b1663>] ? rcu_exit_nohz+0x53/0x60
  [<c045ae3d>] ? irq_enter+0xd/0x60
  [<c042b148>] ? smp_reboot_interrupt+0x18/0x30
  [<c08322b9>] ? reboot_interrupt+0x31/0x38
  [<c04a00e0>] ? stop_machine_cpu_stop+0xb0/0xc0
  [<c082f9d1>] ? panic+0x118/0x158
  [<c04ac8b0>] ? watchdog_nmi_enable+0x120/0x120
  [<c04ac95f>] ? watchdog_overflow_callback+0xaf/0xb0
  [<c04d4858>] ? __perf_event_overflow+0xa8/0x260
  [<c041e0db>] ? x86_perf_event_set_period+0x13b/0x210
  [<c04d4ec2>] ? perf_event_overflow+0x12/0x20
  [<c041fc6a>] ? intel_pmu_handle_irq+0x26a/0x510
  [<c0415cb8>] ? sched_clock+0x8/0x10
  [<c05da178>] ? timerqueue_add+0x58/0xb0
  [<c047716a>] ? enqueue_hrtimer+0x1a/0x60
  [<c0833d00>] ? perf_event_nmi_handler+0x20/0x80
  [<c0835914>] ? notifier_call_chain+0x44/0x60
  [<c083595a>] ? atomic_notifier_call_chain+0x1a/0x20
  [<c0835990>] ? notify_die+0x30/0x40
  [<c083319f>] ? default_do_nmi+0x2f/0x290
  [<c04124f1>] ? handle_irq+0x21/0xc0
  [<c083345f>] ? do_nmi+0x5f/0x80
  [<c0832d14>] ? nmi_stack_correct+0x2f/0x34
  [<c083007b>] ? schedule+0x4ab/0x820
  [<c0831d31>] ? _raw_spin_lock_irqsave+0x21/0x30
  [<c0482725>] ? clockevents_notify+0x15/0xf0
  [<c0628f78>] ? intel_idle+0xb8/0x100
  [<c074c8d6>] ? cpuidle_idle_call+0xc6/0x1e0
  [<c040ff6f>] ? cpu_idle+0x9f/0xe0
  [<c082b513>] ? start_secondary+0xf5/0xfa
---[ end trace a7919e7f17c0a735 ]---



-----------------------------------------------------------------------------------------------------


I got this one today on x86_64 macine, same kernel as above:


*** Loading module mt9t031 ***
BUG: unable to handle kernel paging request at ffffffffa06cbacc
IP: [<ffffffffa06cbacc>] 0xffffffffa06cbacb
Linux video capture interface: v2.00
PGD 1a07067 PUD 1a0b063 PMD 1353f8067 PTE 0
Oops: 0010 [#1] SMP
CPU 3
Modules linked in: videodev v4l2_compat_ioctl32 soc_mediabus sr_mod 
cdrom video parport_pc ppdev parport sunrpc p4_clockmod freq_table 
speedstep_lib ipv6 e1000 floppy microcode dcdbas serio_raw pcspkr 
iTCO_wdt iTCO_vendor_support e752x_]

Pid: 34, comm: kworker/3:1 Not tainted 3.1.0-rc4 #1 Dell Computer 
Corporation PowerEdge 2850/0C8306
RIP: 0010:[<ffffffffa06cbacc>]  [<ffffffffa06cbacc>] 0xffffffffa06cbacb
RSP: 0018:ffff8801391dddf0  EFLAGS: 00010246
RAX: 0000000000000100 RBX: ffff880139009740 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff8801391dddf0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88013fcce140
R13: ffff88013fcd6400 R14: ffffffffa06cbab0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffa06cbacc CR3: 00000001351cb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/3:1 (pid: 34, threadinfo ffff8801391dc000, task 
ffff8801391db4c0)
Stack:
  ffff8801391dde50 ffffffff81082fc1 ffff880133dc6b00 ffffffffa06cd4e0
  ffff88013fcd6405 000000003fcce140 ffff880139009740 ffff880139009740
  ffff88013fcce140 ffff88013fcce148 ffff880139009760 0000000000013c80
Call Trace:
  [<ffffffff81082fc1>] process_one_work+0x131/0x450
  [<ffffffff81084d6b>] worker_thread+0x17b/0x3c0
  [<ffffffff81084bf0>] ? manage_workers+0x120/0x120
  [<ffffffff81089686>] kthread+0x96/0xa0
  [<ffffffff814f3834>] kernel_thread_helper+0x4/0x10
  [<ffffffff810895f0>] ? kthread_worker_fn+0x1a0/0x1a0
  [<ffffffff814f3830>] ? gs_change+0x13/0x13
Code:  Bad RIP value.
RIP  [<ffffffffa06cbacc>] 0xffffffffa06cbacb
  RSP <ffff8801391dddf0>
CR2: ffffffffa06cbacc
---[ end trace b17dde93e72acf8f ]---
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff810891e0>] kthread_data+0x10/0x20
PGD 1a07067 PUD 1a08067 PMD 0
Oops: 0000 [#2] SMP
CPU 3
Modules linked in: videodev v4l2_compat_ioctl32 soc_mediabus sr_mod 
cdrom video parport_pc ppdev parport sunrpc p4_clockmod freq_table 
speedstep_lib ipv6 e1000 floppy microcode dcdbas serio_raw pcspkr 
iTCO_wdt iTCO_vendor_support e752x_]

Pid: 34, comm: kworker/3:1 Tainted: G      D     3.1.0-rc4 #1
Message from Dell Computer Corporation PowerEdge 2850/0C8306
RIP: 0010:[<ffffffff810891e0>]  [<ffffffff810891e0>] kthread_data+0x10/0x20
RSP: 0018:ffff8801391dda38  EFLAGS: 00010096
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000003
RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff8801391db4c0
RBP: ffff8801391dda38 R08: ffff8801391db530 R09: dead000000200200
R10: 0000000000000400 R11: 0000000000000001 R12: ffff8801391dba68
R13: 0000000000000003 R14: 0000000000000003 R15: 0000000000000096
FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
  syslogd@dell-peCS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffffffffffffff8 CR3: 00000001351cb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/3:1 (pid: 34, threadinfo ffff8801391dc000, task 
ffff8801391db4c0)
Stack:
  ffff8801391dda58 ffffffff81082515 ffff8801391dda58 ffff88013fcd3280
  ffff8801391ddaf8 ffffffff814e71a3 ffff880131851f28 ffff880131851f78
  0000000000013280 ffff8801391ddfd8 ffff8801391dc010 0000000000013280
Call Trace:
  [<ffffffff81082515>] wq_worker_sleeping+0x15/0xa0
2850-04 at Aug 3 [<ffffffff814e71a3>] schedule+0x5e3/0x850
  [<ffffffff81228dbb>] ? put_io_context+0x4b/0x60
  [<ffffffff8106b8da>] do_exit+0x26a/0x410

  kernel:Oops: 0 [<ffffffff814ea76b>] oops_end+0xab/0xf0
  [<ffffffff8104199c>] no_context+0xfc/0x190
010 [#1] SMP
  [<ffffffff81041b65>] __bad_area_nosemaphore+0x135/0x220
  [<ffffffff812505c1>] ? list_del+0x11/0x40

Message from [<ffffffff81041c63>] bad_area_nosemaphore+0x13/0x20
  [<ffffffff814ecfa6>] do_page_fault+0x326/0x460
  syslogd@dell-pe [<ffffffff81053e73>] ? __wake_up+0x53/0x70
2850-04 at Aug 3 [<ffffffff81080d4e>] ? call_usermodehelper_exec+0x9e/0xe0
  [<ffffffff81080fcb>] ? __request_module+0x18b/0x220
  [<ffffffff814e9ab5>] page_fault+0x25/0x30
  [<ffffffff81082fc1>] process_one_work+0x131/0x450

  [<ffffffff81084d6b>] worker_thread+0x17b/0x3c0
  [<ffffffff81084bf0>] ? manage_workers+0x120/0x120


Message fr [<ffffffff81089686>] kthread+0x96/0xa0
  [<ffffffff814f3834>] kernel_thread_helper+0x4/0x10
om syslogd@dell- [<ffffffff810895f0>] ? kthread_worker_fn+0x1a0/0x1a0
  [<ffffffff814f3830>] ? gs_change+0x13/0x13
pe2850-04 at AugCode: 66 66 66 90 65 48 8b 04 25 40 c4 00 00 48 8b 80 50 
05 00 00 8b 40 f0 c9 c3 66 90 55 48 89 e5 66 66 66 66 90 48 8b 87 50 05 
00 00
  8b 40 f8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66
RIP  [<ffffffff810891e0>] kthread_data+0x10/0x20
  RSP <ffff8801391dda38>
CR2: fffffffffffffff8
---[ end trace b17dde93e72acf90 ]---
Fixing recursive fault but reboot is needed!
  30 03:27:03 ...
  kernel:Call Trace:

Message from syslogd@dell-pe2850-04 at Aug 30 03:27:03 ...
  kernel:Code:  Bad RIP value.

Message from syslogd@dell-pe2850-04 at Aug 30 03:27:03 ...
  kernel:CR2: ffffffffa06cbacc

----------------------------------------------------------------------------------

If you want me to collect more info reply please.
Regards,
Josef
