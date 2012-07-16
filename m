Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2GPP3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:29:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42307 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GPP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:29:32 -0400
Date: Mon, 16 Jul 2012 08:22:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
Message-ID: <20120716152224.GF2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716103749.122800930@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071615-7282-0000-0000-00000AF70325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:42:34AM -0000, Thomas Gleixner wrote:
> The following series implements the infrastructure for parking and
> unparking kernel threads to avoid the full teardown and fork on cpu
> hotplug operations along with management infrastructure for hotplug
> and users.
> 
> Changes vs. V2:
> 
>  Use callbacks for all functionality. Thanks to Rusty for pointing
>  that out. It makes the use sites nice and simple and keeps all the
>  code which would be duplicated otherwise on the core.

Hello, Thomas,

What version should I apply this patchset to?  I tried v3.5-rc7, but
got lots of warnings (one shown below) and the watchdog patch did not
apply.

							Thanx, Paul

------------------------------------------------------------------------

[    0.280196] BUG: scheduling while atomic: ksoftirqd/1/7/0x00000004
[    0.280968] Modules linked in:
[    0.282064] Pid: 7, comm: ksoftirqd/1 Not tainted 3.5.0-rc7+ #1559
[    0.283990] Call Trace:
[    0.284987]  [<c16314f1>] __schedule_bug+0x49/0x55
[    0.285975]  [<c1638e1a>] __schedule+0x6ca/0x780
[    0.286977]  [<c109b556>] ? rcu_process_callbacks+0x66/0x130
[    0.288983]  [<c10362c4>] ? __local_bh_enable+0x24/0x70
[    0.289975]  [<c105f02b>] ? default_wake_function+0xb/0x10
[    0.291972]  [<c1638fbe>] schedule+0x1e/0x50
[    0.292969]  [<c1639202>] schedule_preempt_disabled+0x12/0x20
[    0.294975]  [<c1075ff8>] smpboot_thread_fn+0xe8/0x240
[    0.295968]  [<c1075f10>] ? smpboot_register_percpu_thread+0xc0/0xc0
[    0.295969]  [<c104fe5f>] kthread+0x8f/0xa0
[    0.295969]  [<c104fdd0>] ? flush_kthread_worker+0x80/0x80
[    0.295969]  [<c163ffb6>] kernel_thread_helper+0x6/0xd

