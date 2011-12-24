Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1LXAC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 19:02:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43311 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1LXACz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 19:02:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1112222031390.22183@icf.org.ru>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112221759480.6601@icf.org.ru>
	<1324565048.5916.139.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112221926460.15997@icf.org.ru>
	<1324571011.5916.141.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.02.1112222031390.22183@icf.org.ru>
Date: Sat, 24 Dec 2011 01:02:54 +0100
Message-ID: <CAM=nh0S1zNoR7WHgQDQ2rspc3qGcKxF8nQ-VyLPhcCCGV+5gEA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Karsten Wiese <fzuuzf@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,
below trace shows regularly here:

[ 3560.172428] BUG: sleeping function called from invalid context at
kernel/rtmutex.c:645
[ 3560.172431] in_atomic(): 1, irqs_disabled(): 1, pid: 28, name: irq/9-acpi
[ 3560.172434] 1 lock held by irq/9-acpi/28:
[ 3560.172436]  #0:  (acpi_gbl_gpe_lock){+.+...}, at: [<c0644c8e>]
acpi_ev_gpe_detect+0x29/0x12f
[ 3560.172447] irq event stamp: 9680
[ 3560.172449] hardirqs last  enabled at (9679): [<c0850a19>]
_raw_spin_unlock_irq+0x27/0x48
[ 3560.172455] hardirqs last disabled at (9680): [<c0850831>]
_raw_spin_lock_irqsave+0x1c/0x82
[ 3560.172460] softirqs last  enabled at (0): [<c043ed99>]
copy_process+0x530/0x1086
[ 3560.172464] softirqs last disabled at (0): [<  (null)>]   (null)
[ 3560.172469] Pid: 28, comm: irq/9-acpi Not tainted
3.0.14-1.rt31.1.fc16.ccrma.i686.rt #1
[ 3560.172471] Call Trace:
[ 3560.172476]  [<c0432ad7>] __might_sleep+0xf4/0xfb
[ 3560.172479]  [<c085004e>] rt_spin_lock+0x1f/0x56
[ 3560.172483]  [<c04f5c71>] __local_lock_irq+0x1e/0x5b
[ 3560.172486]  [<c04f5cc7>] __local_lock_irqsave+0x19/0x27
[ 3560.172490]  [<c04f75ce>] kmem_cache_alloc_trace+0x67/0xf5
[ 3560.172493]  [<c0644833>] ? acpi_os_allocate_zeroed+0x2f/0x2f
[ 3560.172497]  [<c0632a9f>] __acpi_os_execute+0x66/0x15b
[ 3560.172501]  [<c0644833>] ? acpi_os_allocate_zeroed+0x2f/0x2f
[ 3560.172504]  [<c0632bab>] acpi_os_execute+0x17/0x19
[ 3560.172508]  [<c0644c0c>] acpi_ev_gpe_dispatch+0xe4/0x13d
[ 3560.172511]  [<c0644d54>] acpi_ev_gpe_detect+0xef/0x12f
[ 3560.172516]  [<c064314e>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[ 3560.172519]  [<c0632c22>] acpi_irq+0x13/0x2e
[ 3560.172522]  [<c049c730>] irq_forced_thread_fn+0x1d/0x36
[ 3560.172525]  [<c049c607>] irq_thread+0xc0/0x1a0
[ 3560.172529]  [<c0439b19>] ? migrate_enable+0x124/0x133
[ 3560.172532]  [<c049c713>] ? irq_thread_fn+0x2c/0x2c
[ 3560.172535]  [<c049c547>] ? irq_finalize_oneshot+0x94/0x94
[ 3560.172539]  [<c045b336>] kthread+0x76/0x7b
[ 3560.172544]  [<c05f24b4>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 3560.172548]  [<c0850cbd>] ? restore_all+0xf/0xf
[ 3560.172551]  [<c045b2c0>] ? __init_kthread_worker+0x67/0x67
[ 3560.172555]  [<c0856802>] kernel_thread_helper+0x6/0x10
