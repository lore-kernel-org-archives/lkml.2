Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835Ab2FANgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:36:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60778 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705Ab2FANgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:36:11 -0400
Date: Fri, 1 Jun 2012 15:36:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/smp.c:119
 native_smp_send_reschedule+0x25/0x43()
Message-ID: <20120601133607.GA5519@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>, Don Zickus <dzickus@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Josh Boyer <jwboyer@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
References: <1328900283.25989.45.camel@laptop>
 <1328900633.25989.47.camel@laptop>
 <20120210200250.GG5650@redhat.com>
 <1328905121.25989.52.camel@laptop>
 <20120210203117.GI5650@redhat.com>
 <1328906163.25989.59.camel@laptop>
 <20120210210423.GJ5650@redhat.com>
 <CA+1xoqeSMSaXCUbZyB2GAXc+2i=gcX3+zP41ss45YUjyr7F_zA@mail.gmail.com>
 <20120323132648.GA18218@redhat.com>
 <CA+8MBbK9phKABBoE0Tom6+bfm=3t=0GKK4WdHNGkpHS5dyu+gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbK9phKABBoE0Tom6+bfm=3t=0GKK4WdHNGkpHS5dyu+gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 01:38:41PM -0700, Tony Luck wrote:
> A plain v3.3 kernel hits this when I just type "reboot" on a 32 cpu (2
> socket * 8 core * 2 HT) system:

Same here on latest linus on a 24 CPU box right before the box reboots:

[ 6851.207504] ------------[ cut here ]------------
[ 6851.212340] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x2a/0x56()
[ 6851.220727] Hardware name: Dinar
[ 6851.224096] Modules linked in: kvm_amd kvm radeon microcode ttm drm_kms_helper hwmon amd64_edac_mod e1000e ohci_hcd backlight cfbcopyarea cfbimgblt cfbfillrect ehci_hcd edac_core
[ 6851.240585] Pid: 23976, comm: reboot Tainted: G        W    3.4.0+ #15
[ 6851.247351] Call Trace:
[ 6851.249895]  <IRQ>  [<ffffffff8102f114>] warn_slowpath_common+0x85/0x9d
[ 6851.256753]  [<ffffffff8102f146>] warn_slowpath_null+0x1a/0x1c
[ 6851.262801]  [<ffffffff81019bbd>] native_smp_send_reschedule+0x2a/0x56
[ 6851.269573]  [<ffffffff8105e625>] trigger_load_balance+0x1ed/0x21a
[ 6851.275983]  [<ffffffff810582ac>] scheduler_tick+0xe9/0xf2
[ 6851.281671]  [<ffffffff8103cb91>] update_process_times+0x67/0x77
[ 6851.287900]  [<ffffffff81071323>] tick_sched_timer+0x72/0x91
[ 6851.293769]  [<ffffffff8104e5e5>] __run_hrtimer+0xc3/0x17f
[ 6851.299456]  [<ffffffff810712b1>] ? tick_nohz_handler+0xd1/0xd1
[ 6851.305593]  [<ffffffff8104eee1>] hrtimer_interrupt+0xd4/0x197
[ 6851.311642]  [<ffffffff8145e36a>] smp_apic_timer_interrupt+0x86/0x99
[ 6851.325636]  [<ffffffff8145d35c>] apic_timer_interrupt+0x6c/0x80
[ 6851.339424]  <EOI>  [<ffffffff811d68ea>] ? delay_tsc+0x23/0x50
[ 6851.353034]  [<ffffffff811d6849>] __delay+0xf/0x11
[ 6851.365561]  [<ffffffff811d6874>] __const_udelay+0x29/0x2b
[ 6851.378817]  [<ffffffff81019c8a>] native_stop_other_cpus+0x78/0x13d
[ 6851.392924]  [<ffffffff81019305>] native_machine_shutdown+0x53/0x6a
[ 6851.406992]  [<ffffffff81019347>] machine_shutdown+0xf/0x11
[ 6851.420438]  [<ffffffff810193ae>] native_machine_restart+0x25/0x37
[ 6851.434580]  [<ffffffff810193ea>] machine_restart+0xf/0x11
[ 6851.448039]  [<ffffffff81041b62>] kernel_restart+0x4e/0x52
[ 6851.461517]  [<ffffffff81041cc9>] sys_reboot+0x151/0x187
[ 6851.474818]  [<ffffffff81114ba6>] ? mntput_no_expire+0x31/0x105
[ 6851.488748]  [<ffffffff81114ca4>] ? mntput+0x2a/0x2c
[ 6851.501659]  [<ffffffff810fe66e>] ? fput+0x1e0/0x1ef
[ 6851.514551]  [<ffffffff811d7a0e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 6851.529021]  [<ffffffff8145c952>] system_call_fastpath+0x16/0x1b
[ 6851.543148] ---[ end trace 4eaa2a86a8e2da24 ]---


-- 
Regards/Gruss,
Boris.
