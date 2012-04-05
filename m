Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2DEUip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:38:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52685 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2DEUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120323132648.GA18218@redhat.com>
References: <CA+1xoqfYPYi2godgsgmnX7z7GQL+spNmMZhpdGU4UqfYGTB06g@mail.gmail.com>
	<4F34EC35.7010109@linux.vnet.ibm.com>
	<1328900283.25989.45.camel@laptop>
	<1328900633.25989.47.camel@laptop>
	<20120210200250.GG5650@redhat.com>
	<1328905121.25989.52.camel@laptop>
	<20120210203117.GI5650@redhat.com>
	<1328906163.25989.59.camel@laptop>
	<20120210210423.GJ5650@redhat.com>
	<CA+1xoqeSMSaXCUbZyB2GAXc+2i=gcX3+zP41ss45YUjyr7F_zA@mail.gmail.com>
	<20120323132648.GA18218@redhat.com>
Date: Thu, 5 Apr 2012 13:38:41 -0700
Message-ID: <CA+8MBbK9phKABBoE0Tom6+bfm=3t=0GKK4WdHNGkpHS5dyu+gA@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119 native_smp_send_reschedule+0x25/0x43()
From: Tony Luck <tony.luck@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A plain v3.3 kernel hits this when I just type "reboot" on a 32 cpu (2
socket * 8 core * 2 HT) system:


sd 0:0:0:0: [sda] Synchronizing SCSI cache
Restarting system.
machine restart
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x5c/0x60()
Hardware name: S2600CP
Modules linked in:
Pid: 10068, comm: reboot Not tainted 3.3.0- #1
Call Trace:
 <IRQ>  [<ffffffff8104c37f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104c3da>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810314bc>] native_smp_send_reschedule+0x5c/0x60
 [<ffffffff81084824>] trigger_load_balance+0x244/0x2f0
 [<ffffffff8107bf71>] scheduler_tick+0x101/0x160
 [<ffffffff8105b1de>] update_process_times+0x6e/0x90
 [<ffffffff8109e6a6>] tick_sched_timer+0x66/0xc0
 [<ffffffff81072d63>] __run_hrtimer+0x83/0x1d0
 [<ffffffff8109e640>] ? tick_nohz_handler+0xf0/0xf0
 [<ffffffff81073146>] hrtimer_interrupt+0x106/0x240
 [<ffffffff8157bf69>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff8157ac1e>] apic_timer_interrupt+0x6e/0x80
 <EOI>  [<ffffffff81033276>] ? default_send_IPI_mask_allbutself_phys+0xd6/0x110
 [<ffffffff81036397>] physflat_send_IPI_allbutself+0x17/0x20
 [<ffffffff81031849>] native_nmi_stop_other_cpus+0xa9/0x110
 [<ffffffff81030e24>] native_machine_shutdown+0x64/0x90
 [<ffffffff81030a97>] native_machine_restart+0x27/0x40
 [<ffffffff810309cf>] machine_restart+0xf/0x20
 [<ffffffff810637de>] kernel_restart+0x3e/0x60
 [<ffffffff810639e0>] sys_reboot+0x1c0/0x240
 [<ffffffff811734af>] ? __d_free+0x4f/0x70
 [<ffffffff8117353c>] ? d_free+0x6c/0x80
 [<ffffffff81174dbd>] ? d_kill+0xad/0x110
 [<ffffffff8117b603>] ? mntput+0x23/0x40
 [<ffffffff8115f9b7>] ? fput+0x197/0x260
 [<ffffffff8115ba63>] ? filp_close+0x63/0x90
 [<ffffffff8157a169>] system_call_fastpath+0x16/0x1b
---[ end trace 5e0dddabdbb21c7e ]---
