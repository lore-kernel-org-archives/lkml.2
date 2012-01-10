Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2AJSxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:53:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2AJSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:53:10 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=WezrCgqdwWkfiEVh-dcA:9 a=QOt_RskcgpJhy5bqBqoA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326221586.7642.47.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Karsten Wiese <fzuuzf@googlemail.com>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Tue, 10 Jan 2012 13:53:06 -0500
In-Reply-To: <CAM=nh0S1zNoR7WHgQDQ2rspc3qGcKxF8nQ-VyLPhcCCGV+5gEA@mail.gmail.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.02.1112221759480.6601@icf.org.ru>
	 <1324565048.5916.139.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.02.1112221926460.15997@icf.org.ru>
	 <1324571011.5916.141.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.02.1112222031390.22183@icf.org.ru>
	 <CAM=nh0S1zNoR7WHgQDQ2rspc3qGcKxF8nQ-VyLPhcCCGV+5gEA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-24 at 01:02 +0100, Karsten Wiese wrote:
> Hi Steven,
> below trace shows regularly here:
> 
> [ 3560.172428] BUG: sleeping function called from invalid context at
> kernel/rtmutex.c:645
> [ 3560.172431] in_atomic(): 1, irqs_disabled(): 1, pid: 28, name: irq/9-acpi
> [ 3560.172434] 1 lock held by irq/9-acpi/28:
> [ 3560.172436]  #0:  (acpi_gbl_gpe_lock){+.+...}, at: [<c0644c8e>]
> acpi_ev_gpe_detect+0x29/0x12f
> [ 3560.172447] irq event stamp: 9680
> [ 3560.172449] hardirqs last  enabled at (9679): [<c0850a19>]
> _raw_spin_unlock_irq+0x27/0x48
> [ 3560.172455] hardirqs last disabled at (9680): [<c0850831>]
> _raw_spin_lock_irqsave+0x1c/0x82
> [ 3560.172460] softirqs last  enabled at (0): [<c043ed99>]
> copy_process+0x530/0x1086
> [ 3560.172464] softirqs last disabled at (0): [<  (null)>]   (null)
> [ 3560.172469] Pid: 28, comm: irq/9-acpi Not tainted
> 3.0.14-1.rt31.1.fc16.ccrma.i686.rt #1
> [ 3560.172471] Call Trace:
> [ 3560.172476]  [<c0432ad7>] __might_sleep+0xf4/0xfb
> [ 3560.172479]  [<c085004e>] rt_spin_lock+0x1f/0x56
> [ 3560.172483]  [<c04f5c71>] __local_lock_irq+0x1e/0x5b
> [ 3560.172486]  [<c04f5cc7>] __local_lock_irqsave+0x19/0x27
> [ 3560.172490]  [<c04f75ce>] kmem_cache_alloc_trace+0x67/0xf5
> [ 3560.172493]  [<c0644833>] ? acpi_os_allocate_zeroed+0x2f/0x2f
> [ 3560.172497]  [<c0632a9f>] __acpi_os_execute+0x66/0x15b
> [ 3560.172501]  [<c0644833>] ? acpi_os_allocate_zeroed+0x2f/0x2f
> [ 3560.172504]  [<c0632bab>] acpi_os_execute+0x17/0x19
> [ 3560.172508]  [<c0644c0c>] acpi_ev_gpe_dispatch+0xe4/0x13d
> [ 3560.172511]  [<c0644d54>] acpi_ev_gpe_detect+0xef/0x12f
> [ 3560.172516]  [<c064314e>] acpi_ev_sci_xrupt_handler+0x1a/0x20
> [ 3560.172519]  [<c0632c22>] acpi_irq+0x13/0x2e
> [ 3560.172522]  [<c049c730>] irq_forced_thread_fn+0x1d/0x36
> [ 3560.172525]  [<c049c607>] irq_thread+0xc0/0x1a0
> [ 3560.172529]  [<c0439b19>] ? migrate_enable+0x124/0x133
> [ 3560.172532]  [<c049c713>] ? irq_thread_fn+0x2c/0x2c
> [ 3560.172535]  [<c049c547>] ? irq_finalize_oneshot+0x94/0x94
> [ 3560.172539]  [<c045b336>] kthread+0x76/0x7b
> [ 3560.172544]  [<c05f24b4>] ? trace_hardirqs_on_thunk+0xc/0x10
> [ 3560.172548]  [<c0850cbd>] ? restore_all+0xf/0xf
> [ 3560.172551]  [<c045b2c0>] ? __init_kthread_worker+0x67/0x67
> [ 3560.172555]  [<c0856802>] kernel_thread_helper+0x6/0x10

Seems the back traces that have been currently reported have been for
i386. Although Clark Williams has been saying he's been seeing it on
x86_64, but only when he does a suspend and resume on his laptop.

Does this just happen randomly? Or do you do something in particular
when this happens, (like a suspend and resume)?

Thanks,

-- Steve


