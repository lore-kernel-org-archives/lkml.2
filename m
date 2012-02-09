Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2BHXcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:32:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50858 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2BHXcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:32:17 -0500
Message-ID: <1328751082.5611.6.camel@lappy>
Subject: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
From: Sasha Levin <levinsasha928@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>
Date: Wed, 08 Feb 2012 20:31:22 -0500
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got the following warning when shutting down a KVM guest with a whole bunch of cores (254 in this case).

It's actually pretty easy to reproduce it, it happens every once in 2-3 shutdowns.

[   32.448626] ------------[ cut here ]------------
[   32.449160] WARNING: at arch/x86/kernel/smp.c:119 native_smp_send_reschedule+0x25/0x43()
[   32.449621] Pid: 1, comm: init_stage2 Not tainted 3.2.0+ #14
[   32.449621] Call Trace:
[   32.449621]  <IRQ>  [<ffffffff81041a44>] ? native_smp_send_reschedule+0x25/0x43
[   32.449621]  [<ffffffff810735b2>] warn_slowpath_common+0x7b/0x93
[   32.449621]  [<ffffffff810962cc>] ? tick_nohz_handler+0xc9/0xc9
[   32.449621]  [<ffffffff81073675>] warn_slowpath_null+0x15/0x18
[   32.449621]  [<ffffffff81041a44>] native_smp_send_reschedule+0x25/0x43
[   32.449621]  [<ffffffff81067a00>] smp_send_reschedule+0xa/0xc
[   32.449621]  [<ffffffff8106f25e>] scheduler_tick+0x21a/0x242
[   32.449621]  [<ffffffff8107da10>] update_process_times+0x62/0x73
[   32.449621]  [<ffffffff81096336>] tick_sched_timer+0x6a/0x8a
[   32.449621]  [<ffffffff8108c5eb>] __run_hrtimer.clone.26+0x55/0xcb
[   32.449621]  [<ffffffff8108cd77>] hrtimer_interrupt+0xcb/0x19b
[   32.449621]  [<ffffffff810428a8>] smp_apic_timer_interrupt+0x72/0x85
[   32.449621]  [<ffffffff8165a8de>] apic_timer_interrupt+0x6e/0x80
[   32.449621]  <EOI>  [<ffffffff8165928e>] ? _raw_spin_unlock_irqrestore+0x3a/0x3e
[   32.449621]  [<ffffffff81042f4e>] ? arch_local_irq_restore+0x6/0xd
[   32.449621]  [<ffffffff810430c4>] default_send_IPI_mask_allbutself_phys+0x78/0x88
[   32.449621]  [<ffffffff8106c3c4>] ? __migrate_task+0xf1/0xf1
[   32.449621]  [<ffffffff81045445>] physflat_send_IPI_allbutself+0x12/0x14
[   32.449621]  [<ffffffff81041aaf>] native_stop_other_cpus+0x4d/0xa8
[   32.449621]  [<ffffffff810411c6>] native_machine_shutdown+0x56/0x6d
[   32.449621]  [<ffffffff81048499>] kvm_shutdown+0x1a/0x1c
[   32.449621]  [<ffffffff810411f9>] machine_shutdown+0xa/0xc
[   32.449621]  [<ffffffff81041265>] native_machine_restart+0x20/0x32
[   32.449621]  [<ffffffff81041297>] machine_restart+0xa/0xc
[   32.449621]  [<ffffffff81081d53>] kernel_restart+0x49/0x4d
[   32.449621]  [<ffffffff81081f26>] sys_reboot+0x14b/0x18a
[   32.449621]  [<ffffffff81089937>] ? remove_wait_queue+0x4c/0x51
[   32.449621]  [<ffffffff8107637f>] ? do_wait+0x1a4/0x1e7
[   32.449621]  [<ffffffff8107735a>] ? sys_wait4+0xa8/0xbc
[   32.449621]  [<ffffffff8107522b>] ? clear_tsk_thread_flag+0xf/0xf
[   32.449621]  [<ffffffff81659a25>] ? async_page_fault+0x25/0x30
[   32.449621]  [<ffffffff81659e92>] system_call_fastpath+0x16/0x1b
[   32.449621] ---[ end trace d0f03651493fd3d6 ]--

-- 

Sasha.

