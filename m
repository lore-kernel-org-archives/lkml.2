Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab2GSEAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:00:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51482 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1749667Ab2GSEAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:00:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19rgipxoHNr3kct0Rb/odoPoV55yjIl+rRUu3BUeR
	Xk/Kq75edG7YQT
Message-ID: <1342670426.7342.8.camel@marge.simpson.net>
Subject: Re: [PATCH RT 00/12] [ANNOUNCE] 3.0.36-rt58-rc1 stable review
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Thu, 19 Jul 2012 06:00:26 +0200
In-Reply-To: <20120718223910.898476857@goodmis.org>
References: <20120718223910.898476857@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 18:39 -0400, Steven Rostedt wrote:

> Please test the patches too.

Your hotplug stress test script made x3550 M3 box fall over.  It took a
bit, but down she went.  64 core test box fell over quickly, but that's
very far from virgin source.. seems to be the same though.

[  255.016043] CPU 1 MCA<0>Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 7
Pid: 9914, comm: migration/7 Not tainted 3.0.36-rt57 #49
Call Trace:
 <NMI>  [<ffffffff814a0f7b>] panic+0x9b/0x1b0
 [<ffffffff810b0627>] watchdog_overflow_callback+0xd7/0xe0
 [<ffffffff810c3dad>] __perf_event_overflow+0x9d/0x240
 [<ffffffff810c066b>] ? perf_event_update_userpage+0x9b/0xe0
 [<ffffffff810c41a4>] perf_event_overflow+0x14/0x20
 [<ffffffff81015707>] intel_pmu_handle_irq+0x177/0x230
 [<ffffffff814a5549>] perf_event_nmi_handler+0x39/0xc0
 [<ffffffff814a727d>] notifier_call_chain+0x4d/0x70
 [<ffffffff814a72e3>] __atomic_notifier_call_chain+0x43/0x60
 [<ffffffff814a7311>] atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814a734e>] notify_die+0x2e/0x30
 [<ffffffff814a4699>] default_do_nmi+0x39/0x200
 [<ffffffff814a4a48>] do_nmi+0x78/0x80
 [<ffffffff814a44d0>] nmi+0x20/0x30
 [<ffffffff810a461a>] ? stop_machine_cpu_stop+0x6a/0xe0
 <<EOE>>  [<ffffffff810a47f4>] cpu_stopper_thread+0xf4/0x1d0
 [<ffffffff810a45b0>] ? wait_for_stop_done+0xa0/0xa0
 [<ffffffff814a1397>] ? __schedule+0x2c7/0x630
 [<ffffffff810a4700>] ? cpu_stop_queue_work+0x70/0x70
 [<ffffffff810a4700>] ? cpu_stop_queue_work+0x70/0x70
 [<ffffffff810702c6>] kthread+0xa6/0xb0
 [<ffffffff81056328>] ? do_exit+0x278/0x450
 [<ffffffff810016b2>] ? __switch_to+0xf2/0x370
 [<ffffffff81040f15>] ? finish_task_switch+0x55/0xd0
 [<ffffffff814aa6e4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81070220>] ? __init_kthread_worker+0x50/0x50
 [<ffffffff814aa6e0>] ? gs_change+0x13/0x13


