Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1CLTNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 14:13:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1CLTNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 14:13:05 -0500
Date: Sat, 12 Mar 2011 14:08:51 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: WARNING: Perf: bad frame pointer = (null), 2.6.38-rc8
Message-ID: <20110312140851.52420149@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[17609.564972] ------------[ cut here ]------------
[17609.569598] WARNING: at arch/x86/kernel/dumpstack_64.c:129
dump_trace+0x2bc/0x308()
[17609.577246] Hardware name: X8DTH-i/6/iF/6F
[17609.581342] Perf: bad frame pointer =           (null) in callchain
[17609.587608] Modules linked in: fuse crc32c_intel oprofile w83627ehf
hwmon_vid adm1021 ipmi_devintf ipmi_si ipmi_msghandler dm_round_robin
dm_multipath ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm
ib_addr ipv6 ib_sa mlx4_ib ib_mad ib_core mlx4_en microcode ghes hed ses
i2c_i801 i7core_edac ioatdma igb i2c_core enclosure edac_core dca iTCO_wdt
mlx4_core iTCO_vendor_support uas mpt2sas usb_storage scsi_transport_sas
raid_class [last unloaded: oprofile]
[17609.629722] Pid: 11410, comm: sysprof Not tainted
2.6.38-0.rc8.git0.2.fc14.x86_64 #1
[17609.637459] Call Trace:
[17609.639908]  <IRQ>  [<ffffffff81059357>] ? warn_slowpath_common+0x85/0x9d
[17609.646714]  [<ffffffff81059412>] ? warn_slowpath_fmt+0x46/0x48
[17609.652633]  [<ffffffff81490a26>] ? bad_to_user+0x70/0x764
[17609.658119]  [<ffffffff8100d5b4>] ? dump_trace+0x2bc/0x308
[17609.663605]  [<ffffffff8107b578>] ? timekeeping_get_ns+0x1b/0x3d
[17609.669608]  [<ffffffff8101b4a8>] ? perf_callchain_kernel+0x5a/0x5c
[17609.675874]  [<ffffffff810db732>] ? perf_prepare_sample+0xf2/0x1d2
[17609.682049]  [<ffffffff810db96f>] ? __perf_event_overflow+0x15d/0x1ab
[17609.688489]  [<ffffffff81010f89>] ? paravirt_read_tsc+0x9/0xd
[17609.694233]  [<ffffffff810114a7>] ? native_sched_clock+0x35/0x37
[17609.700235]  [<ffffffff810114b2>] ? sched_clock+0x9/0xd
[17609.705461]  [<ffffffff81078ac8>] ? sched_clock_cpu+0x42/0xc6
[17609.711206]  [<ffffffff810dbfdc>] ? perf_event_overflow+0x14/0x16
[17609.717298]  [<ffffffff810dc070>] ? perf_swevent_hrtimer+0x92/0xde
[17609.723477]  [<ffffffff810a6591>] ? audit_syscall_exit+0x0/0x14c
[17609.729482]  [<ffffffff8123f2bb>] ? timerqueue_del+0x59/0x6a
[17609.735141]  [<ffffffff810765d8>] ? __remove_hrtimer+0x62/0x6e
[17609.740969]  [<ffffffff81076854>] ? __run_hrtimer+0xb9/0x13f
[17609.746626]  [<ffffffff810dbfde>] ? perf_swevent_hrtimer+0x0/0xde
[17609.752715]  [<ffffffff81077046>] ? hrtimer_interrupt+0xd1/0x1b0
[17609.758713]  [<ffffffff81049126>] ? account_system_vtime+0x6f/0x8c
[17609.764892]  [<ffffffff8148f026>] ? smp_apic_timer_interrupt+0x79/0x8c
[17609.771418]  [<ffffffff8100b613>] ? apic_timer_interrupt+0x13/0x20
[17609.777592]  <EOI>  [<ffffffff8112bfd4>] ? vfs_read+0xbc/0xfc
[17609.783357]  [<ffffffff810a6591>] ? audit_syscall_exit+0x0/0x14c
[17609.789360]  [<ffffffff8100ad74>] ? sysret_audit+0x16/0x20
[17609.794836] ---[ end trace 14962c7de7a584a6 ]---

