Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0CYIDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:03:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58767 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0CYIDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:03:44 -0400
Message-ID: <4BAB1924.4060304@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 16:04:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
References: <4BA082EC.8030101@cn.fujitsu.com>	 <4BA9A885.9050105@cn.fujitsu.com>	 <1269415964.6530.25.camel@marge.simson.net> <1269418671.6465.6.camel@marge.simson.net>
In-Reply-To: <1269418671.6465.6.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Wed, 2010-03-24 at 08:32 +0100, Mike Galbraith wrote:
> 
>> I just saw this, hunted down your testcase and tried it here.  Looks
>> like perf_output_lock() wedged box.
> 
> (turns on frame pointers, and adds noinline)
> 

Thanks! Then who's going to fix this...

--Li

> [   90.276644] BUG: NMI Watchdog detected LOCKUP on CPU2, ip ffffffff812b54a8, registers:
> [   90.276644] CPU 2 
> [   90.276644] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel firewire_ohci firewire_core snd_hda_codec usbmouse crc_itu_t snd_hwdep snd_pcm usb_storage snd_timer sr_mod usbhid ohci1394 snd rtc_cmos soundcore rtc_core ieee1394 usb_libusual thermal i2c_i801 processor button e1000e snd_page_alloc cdrom rtc_lib hid sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
> [   90.276644] 
> [   90.276644] Pid: 20237, comm: forkbomb Not tainted 2.6.34-smpx #1477 MS-7502/MS-7502
> [   90.276644] RIP: 0010:[<ffffffff812b54a8>]  [<ffffffff812b54a8>] _raw_spin_lock+0x12/0x1a
> [   90.276644] RSP: 0018:ffff880001703ee8  EFLAGS: 00000097
> [   90.276644] RAX: 000000000000c3c2 RBX: ffff880001712e40 RCX: 0000001504ab3a62
> [   90.276644] RDX: 0000001504ab3b83 RSI: 0000000000000026 RDI: ffff880001712e40
> [   90.276644] RBP: ffff880001703ee8 R08: 000000001ba05e30 R09: ffff880001703f88
> [   90.276644] R10: 0000000000000038 R11: 0000000000000038 R12: 0000000000000002
> [   90.276644] R13: ffff8800b48de2d0 R14: 0000000000000038 R15: 00000000ffffffe4
> [   90.276644] FS:  0000000000000000(0000) GS:ffff880001700000(0000) knlGS:0000000000000000
> [   90.276644] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   90.276644] CR2: 00007ff05702a4a8 CR3: 0000000001430000 CR4: 00000000000006e0
> [   90.276644] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   90.276644] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   90.276644] Process forkbomb (pid: 20237, threadinfo ffff8800bd3f8000, task ffff8800b48de2d0)
> [   90.276644] Stack:
> [   90.276644]  ffff880001703f18 ffffffff8102ecc4 ffff8800b48de2d0 ffff8800b48de2d0
> [   90.276644] <0> 0000000000000000 0000000000000002 ffff880001703f48 ffffffff8103f082
> [   90.276644] <0> ffffea00029f9ee0 ffff88000170d170 ffff88000170d170 0000000000000002
> [   90.276644] Call Trace:
> [   90.276644]  <IRQ> 
> [   90.276644]  [<ffffffff8102ecc4>] scheduler_tick+0x3c/0x1e6
> [   90.276644]  [<ffffffff8103f082>] update_process_times+0x4b/0x5b
> [   90.276644]  [<ffffffff81054229>] tick_periodic+0x5d/0x5f
> [   90.276644]  [<ffffffff8105428e>] tick_handle_periodic+0x21/0x6e
> [   90.276644]  [<ffffffff810167a7>] smp_apic_timer_interrupt+0x83/0x96
> [   90.276644]  [<ffffffff81002813>] apic_timer_interrupt+0x13/0x20
> [   90.276644]  <EOI> 
> [   90.276644]  [<ffffffff8107c1df>] ? perf_output_unlock+0x27/0x122
> [   90.276644]  [<ffffffff8107d45f>] ? perf_swevent_overflow+0x58/0x76
> [   90.276644]  [<ffffffff8107c6c6>] perf_output_begin+0x16e/0x180
> [   90.276644]  [<ffffffff8107d5a2>] ? perf_swevent_ctx_event+0xdd/0xee
> [   90.276644]  [<ffffffff8107c80d>] perf_event_task_ctx+0xf8/0x110
> [   90.276644]  [<ffffffff8104ed00>] ? sched_clock_cpu+0xc0/0xce
> [   90.276644]  [<ffffffff8107c8b7>] perf_event_task+0x92/0xc3
> [   90.276644]  [<ffffffff8107e25e>] perf_event_exit_task+0x27/0x112
> [   90.276644]  [<ffffffff810c6dca>] ? free_fs_struct+0x2d/0x31
> [   90.276644]  [<ffffffff81034e4e>] do_exit+0x264/0x67a
> [   90.276644]  [<ffffffff8101cd6f>] ? do_page_fault+0x222/0x253
> [   90.276644]  [<ffffffff810354e7>] do_group_exit+0x6f/0x98
> [   90.276644]  [<ffffffff81035522>] sys_exit_group+0x12/0x16
> [   90.276644]  [<ffffffff81001f2b>] system_call_fastpath+0x16/0x1b
> [   90.276644] Code: 00 00 75 05 f0 66 0f b1 17 0f 94 c2 0f b6 c2 85 c0 c9 0f 95 c0 0f b6 c0 c3 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 38 e0 74 06 <f3> 90 8a 07 eb f6 c9 c3 55 48 89 e5 9c 58 fa ba 00 01 00 00 f0 
> [   90.276639] BUG: NMI Watchdog detected LOCKUP
> [   90.276644] ---[ end trace ef30915e055ad1b9 ]---
> [   90.276639]  on CPU1, ip ffffffff81079014, registers:
> [   90.276639] CPU 1 
> [   90.276639] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel firewire_ohci firewire_core snd_hda_codec usbmouse crc_itu_t snd_hwdep snd_pcm usb_storage snd_timer sr_mod usbhid ohci1394 snd rtc_cmos soundcore rtc_core ieee1394 usb_libusual thermal i2c_i801 processor button e1000e snd_page_alloc cdrom rtc_lib hid sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
> [   90.276639] 
> [   90.276639] Pid: 0, comm: swapper Tainted: G      D    2.6.34-smpx #1477 MS-7502/MS-7502
> [   90.276639] RIP: 0010:[<ffffffff81079014>]  [<ffffffff81079014>] perf_output_lock+0x30/0x4e
> [   90.276639] RSP: 0018:ffff880001683a00  EFLAGS: 00000082
> [   90.276639] RAX: 0000000000000002 RBX: ffff880001683ab0 RCX: ffff8800bc454000
> [   90.276639] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880001683ab0
> [   90.276639] RBP: ffff880001683a10 R08: 0000000000000001 R09: ffff880001683ae0
> [   90.276639] R10: 0000000000000200 R11: 0000000000000000 R12: ffff8800bc454000
> [   90.276639] R13: ffff880037788000 R14: 0000000000000070 R15: 00000000ffffffe4
> [   90.276639] FS:  0000000000000000(0000) GS:ffff880001680000(0000) knlGS:0000000000000000
> [   90.276639] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   90.276639] CR2: 00007ff05702a4a8 CR3: 0000000001430000 CR4: 00000000000006e0
> [   90.276639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   90.276639] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   90.276639] Process swapper (pid: 0, threadinfo ffff8800bf888000, task ffff8800bf8422e0)
> [   90.276639] Stack:
> [   90.276639]  00000001374fb210 00000002ffffffff ffff880001683a90 ffffffff8107c5cf
> [   90.276639] <0> ffff880001683a40 000000000002b3c6 ffff880001683a40 ffff880001683ae0
> [   90.276639] <0> ffff880001683a90 ffffffff8107d13c ffffffff8104eb6b ffff8800bf8422e0
> [   90.276639] Call Trace:
> [   90.276639]  <IRQ> 
> [   90.276639]  [<ffffffff8107c5cf>] perf_output_begin+0x77/0x180
> [   90.276639]  [<ffffffff8107d13c>] ? perf_prepare_sample+0xb5/0x1d3
> [   90.276639]  [<ffffffff8104eb6b>] ? sched_clock_local+0x12/0x75
> [   90.276639]  [<ffffffff8107d3c5>] __perf_event_overflow+0x16b/0x1ad
> [   90.276639]  [<ffffffff8107d13c>] ? perf_prepare_sample+0xb5/0x1d3
> [   90.276639]  [<ffffffff8107d45f>] perf_swevent_overflow+0x58/0x76
> [   90.276639]  [<ffffffff8107d4c3>] perf_swevent_add+0x46/0x48
> [   90.276639]  [<ffffffff8107d5a2>] perf_swevent_ctx_event+0xdd/0xee
> [   90.276639]  [<ffffffff8107d601>] do_perf_sw_event+0x4e/0x8c
> [   90.276639]  [<ffffffff8107d670>] perf_tp_event+0x31/0x33
> [   90.276639]  [<ffffffff8102c425>] ? try_to_wake_up+0x165/0x226
> [   90.276639]  [<ffffffff810752e6>] ? perf_trace_buf_prepare+0x8e/0xb5
> [   90.276639]  [<ffffffff81024142>] perf_trace_templ_sched_wakeup_template+0xca/0xe0
> [   90.276639]  [<ffffffff81024167>] perf_trace_sched_wakeup+0xf/0x11
> [   90.276639]  [<ffffffff8102c425>] try_to_wake_up+0x165/0x226
> [   90.276639]  [<ffffffff8102c505>] wake_up_process+0x10/0x12
> [   90.276639]  [<ffffffff8102df50>] load_balance+0x3d3/0x47f
> [   90.276639]  [<ffffffff8107cc69>] ? perf_event_task_tick+0x6e/0x124
> [   90.276639]  [<ffffffff8102e0d6>] rebalance_domains+0xda/0x14a
> [   90.276639]  [<ffffffff8102e18a>] run_rebalance_domains+0x44/0xd4
> [   90.276639]  [<ffffffff810377e7>] __do_softirq+0xd7/0x193
> [   90.276639]  [<ffffffff810050a5>] ? timer_interrupt+0x19/0x20
> [   90.276639]  [<ffffffff81002d4c>] call_softirq+0x1c/0x28
> [   90.276639]  [<ffffffff810049fa>] do_softirq+0x33/0x69
> [   90.276639]  [<ffffffff8103793d>] irq_exit+0x36/0x78
> [   90.276639]  [<ffffffff81004733>] do_IRQ+0xa7/0xbe
> [   90.276639]  [<ffffffff812b5893>] ret_from_intr+0x0/0xa
> [   90.276639]  <EOI> 
> [   90.276639]  [<ffffffff810093ca>] ? mwait_idle+0xa2/0xa9
> [   90.276639]  [<ffffffff8104e1b2>] ? atomic_notifier_call_chain+0x13/0x15
> [   90.276639]  [<ffffffff81000736>] cpu_idle+0x52/0x6f
> [   90.276639]  [<ffffffff812b0d53>] start_secondary+0x1ae/0x1b2
> [   90.276639] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 58 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 08 39 
> [   90.276639] ---[ end trace ef30915e055ad1ba ]---
> [   90.276644] BUG: NMI Watchdog detected LOCKUP on CPU3, ip ffffffff81079014, registers:
> [   90.276644] CPU 3 
> [   90.276644] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel firewire_ohci firewire_core snd_hda_codec usbmouse crc_itu_t snd_hwdep snd_pcm usb_storage snd_timer sr_mod usbhid ohci1394 snd rtc_cmos soundcore rtc_core ieee1394 usb_libusual thermal i2c_i801 processor button e1000e snd_page_alloc cdrom rtc_lib hid sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
> [   90.276644] 
> [   90.276644] Pid: 5146, comm: forkbomb Tainted: G      D    2.6.34-smpx #1477 MS-7502/MS-7502
> [   90.276644] RIP: 0010:[<ffffffff81079014>]  [<ffffffff81079014>] perf_output_lock+0x30/0x4e
> [   90.276644] RSP: 0018:ffff880001783b88  EFLAGS: 00000082
> [   90.276644] RAX: 0000000000000002 RBX: ffff880001783c38 RCX: ffff8800bc454000
> [   90.276644] RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff880001783c38
> [   90.276644] RBP: ffff880001783b98 R08: 0000000000000001 R09: ffff880001783c68
> [   90.276644] R10: 0000000000000003 R11: 0000000000000246 R12: ffff8800bc454000
> [   90.276644] R13: ffff880037788000 R14: 0000000000000078 R15: 00000000ffffffe4
> [   90.276644] FS:  00007ff057202700(0000) GS:ffff880001780000(0000) knlGS:0000000000000000
> [   90.276644] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   90.276644] CR2: 00007ff05702be04 CR3: 00000000bf8c4000 CR4: 00000000000006e0
> [   90.276644] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   90.276644] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   90.276644] Process forkbomb (pid: 5146, threadinfo ffff8800bbebc000, task ffff8800bc128000)
> [   90.276644] Stack:
> [   90.276644]  000000030178f9e0 00000002ffffffff ffff880001783c18 ffffffff8107c5cf
> [   90.276644] <0> ffff880001783bc8 000000000002b3c6 ffff880001783bc8 ffff880001783c68
> [   90.276644] <0> ffff880001783c18 ffffffff8107d13c ffff880001783be8 ffff8800bc128000
> [   90.276644] Call Trace:
> [   90.276644]  <IRQ> 
> [   90.276644]  [<ffffffff8107c5cf>] perf_output_begin+0x77/0x180
> [   90.276644]  [<ffffffff8107d13c>] ? perf_prepare_sample+0xb5/0x1d3
> [   90.276644]  [<ffffffff8107d3c5>] __perf_event_overflow+0x16b/0x1ad
> [   90.276644]  [<ffffffff8107d45f>] perf_swevent_overflow+0x58/0x76
> [   90.276644]  [<ffffffff8107d4c3>] perf_swevent_add+0x46/0x48
> [   90.276644]  [<ffffffff8107d5a2>] perf_swevent_ctx_event+0xdd/0xee
> [   90.276644]  [<ffffffff8107d601>] do_perf_sw_event+0x4e/0x8c
> [   90.276644]  [<ffffffff8107d670>] perf_tp_event+0x31/0x33
> [   90.276644]  [<ffffffff810263b8>] ? task_tick_fair+0x47/0x103
> [   90.276644]  [<ffffffff810752e6>] ? perf_trace_buf_prepare+0x8e/0xb5
> [   90.276644]  [<ffffffff810247ff>] perf_trace_sched_stat_runtime+0xc4/0xdc
> [   90.276644]  [<ffffffff81026227>] update_curr+0x87/0xc8
> [   90.276644]  [<ffffffff810263b8>] task_tick_fair+0x47/0x103
> [   90.276644]  [<ffffffff8102ed61>] scheduler_tick+0xd9/0x1e6
> [   90.276644]  [<ffffffff8103f082>] update_process_times+0x4b/0x5b
> [   90.276644]  [<ffffffff81054229>] tick_periodic+0x5d/0x5f
> [   90.276644]  [<ffffffff8105428e>] tick_handle_periodic+0x21/0x6e
> [   90.276644]  [<ffffffff810167a7>] smp_apic_timer_interrupt+0x83/0x96
> [   90.276644]  [<ffffffff81002813>] apic_timer_interrupt+0x13/0x20
> [   90.276644]  <EOI> 
> [   90.276644]  [<ffffffff810a493a>] ? kmem_cache_alloc+0x6a/0xdc
> [   90.276644]  [<ffffffff8109ba31>] anon_vma_fork+0x40/0xca
> [   90.276644]  [<ffffffff81030377>] dup_mm+0x206/0x43f
> [   90.276644]  [<ffffffff81030dac>] copy_process+0x7b2/0xea9
> [   90.276644]  [<ffffffff81031625>] do_fork+0x15e/0x2b4
> [   90.276644]  [<ffffffff8101cd6f>] ? do_page_fault+0x222/0x253
> [   90.276644]  [<ffffffff81009a6f>] sys_clone+0x23/0x25
> [   90.276644]  [<ffffffff81002193>] stub_clone+0x13/0x20
> [   90.276644]  [<ffffffff81001f2b>] ? system_call_fastpath+0x16/0x1b
> [   90.276644] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 58 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 08 39 
> [   90.276644] ---[ end trace ef30915e055ad1bb ]---
> [   90.276643] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff81079014, registers:
> [   90.276643] CPU 0 
> [   90.276643] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave
> [   90.276644] Kernel panic - not syncing: Aiee, killing interrupt handler!
> [   90.276643]  acpi_cpufreqPid: 5146, comm: forkbomb Tainted: G      D    2.6.34-smpx #1477
> [   90.276643]  snd_pcm_ossCall Trace:
> [   90.276643]  snd_mixer_oss <NMI>  microcode snd_seq [<ffffffff812b3364>] panic+0x73/0xe1
> [   90.276643]  snd_seq_device fuse [<ffffffff8103794f>] ? irq_exit+0x48/0x78
> [   90.276643]  loop dm_mod [<ffffffff81034c57>] do_exit+0x6d/0x67a
> [   90.276643]  snd_hda_codec_realtek snd_hda_intel [<ffffffff8104e164>] ? notifier_call_chain+0x32/0x5e
> [   90.276643]  firewire_ohci firewire_core [<ffffffff81005f8c>] die_nmi+0xd2/0xde
> [   90.276643]  snd_hda_codec usbmouse [<ffffffff8101751d>] nmi_watchdog_tick+0x41/0x19d
> [   90.276643]  crc_itu_t snd_hwdep [<ffffffff81003812>] do_nmi+0x222/0x24c
> [   90.276643]  snd_pcm usb_storage [<ffffffff812b5cfa>] nmi+0x1a/0x20
> [   90.276643]  snd_timer sr_mod [<ffffffff81005f87>] ? die_nmi+0xcd/0xde
> [   90.276643]  usbhid <<EOE>>  ohci1394 snd rtc_cmos soundcore rtc_core ieee1394 usb_libusual thermal i2c_i801 processor button e1000e snd_page_alloc cdrom rtc_lib hid sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
> [   90.276643] 
> [   90.276643] Pid: 20238, comm: forkbomb Tainted: G      D    2.6.34-smpx #1477 MS-7502/MS-7502
> [   90.276643] RIP: 0010:[<ffffffff81079014>]  [<ffffffff81079014>] perf_output_lock+0x30/0x4e
> [   90.276643] RSP: 0000:ffff880001603b88  EFLAGS: 00000082
> [   90.276643] RAX: 0000000000000002 RBX: ffff880001603c38 RCX: ffff8800bc454000
> [   90.276643] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880001603c38
> [   90.276643] RBP: ffff880001603b98 R08: 0000000000000001 R09: ffff880001603c68
> [   90.276643] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800bc454000
> [   90.276643] R13: ffff880037788000 R14: 0000000000000078 R15: 00000000ffffffe4
> [   90.276643] FS:  00007ff057202700(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
> [   90.276643] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   90.276643] CR2: 00007ff056d05510 CR3: 00000000bd9f7000 CR4: 00000000000006f0
> [   90.276643] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   90.276643] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   90.276643] Process forkbomb (pid: 20238, threadinfo ffff8800bd3fa000, task ffff8800b48de8a0)
> [   90.276643] Stack:
> [   90.276643]  00000000071cf224 00000002ffffffff ffff880001603c18 ffffffff8107c5cf
> [   90.276643] <0> ffff880001603bc8 000000000002b3c6 ffff880001603bc8 ffff880001603c68
> [   90.276643] <0> ffff880001603c18 ffffffff8107d13c ffff8800bc690888 ffff8800b48de8a0
> [   90.276643] Call Trace:
> [   90.276643]  <IRQ> 
> [   90.276643]  [<ffffffff8107c5cf>] perf_output_begin+0x77/0x180
> [   90.276643]  [<ffffffff8107d13c>] ? perf_prepare_sample+0xb5/0x1d3
> [   90.276643]  [<ffffffff8107d3c5>] __perf_event_overflow+0x16b/0x1ad
> [   90.276643]  [<ffffffff8107d45f>] perf_swevent_overflow+0x58/0x76
> [   90.276643]  [<ffffffff8107d4c3>] perf_swevent_add+0x46/0x48
> [   90.276643]  [<ffffffff8107d5a2>] perf_swevent_ctx_event+0xdd/0xee
> [   90.276643]  [<ffffffff8107d601>] do_perf_sw_event+0x4e/0x8c
> [   90.276643]  [<ffffffff811b8f9e>] ? put_device+0x12/0x14
> [   90.276643]  [<ffffffff8107d670>] perf_tp_event+0x31/0x33
> [   90.276643]  [<ffffffff810263b8>] ? task_tick_fair+0x47/0x103
> [   90.276643]  [<ffffffff810752e6>] ? perf_trace_buf_prepare+0x8e/0xb5
> [   90.276643]  [<ffffffff810247ff>] perf_trace_sched_stat_runtime+0xc4/0xdc
> [   90.276643]  [<ffffffffa0000773>] ? scsi_finish_command+0xec/0xf5 [scsi_mod]
> [   90.276643]  [<ffffffff81026227>] update_curr+0x87/0xc8
> [   90.276643]  [<ffffffff810263b8>] task_tick_fair+0x47/0x103
> [   90.276643]  [<ffffffff8102ed61>] scheduler_tick+0xd9/0x1e6
> [   90.276643]  [<ffffffff8103f082>] update_process_times+0x4b/0x5b
> [   90.276643]  [<ffffffff81054229>] tick_periodic+0x5d/0x5f
> [   90.276643]  [<ffffffff8105428e>] tick_handle_periodic+0x21/0x6e
> [   90.276643]  [<ffffffff810167a7>] smp_apic_timer_interrupt+0x83/0x96
> [   90.276643]  [<ffffffff81002813>] apic_timer_interrupt+0x13/0x20
> [   90.276643]  <EOI> 
> [   90.276643]  [<ffffffff8101cbd1>] ? do_page_fault+0x84/0x253
> [   90.276643]  [<ffffffff8101cd6f>] ? do_page_fault+0x222/0x253
> [   90.276643]  [<ffffffff812b5a9f>] page_fault+0x1f/0x30
> [   90.276643] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 58 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 08 39 
> [   90.276643] ---[ end trace ef30915e055ad1bc ]---
> 
