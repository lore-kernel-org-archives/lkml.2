Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0G3Xzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:55:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab0G3Xzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:55:52 -0400
Date: Fri, 30 Jul 2010 16:55:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 1/2] workqueue: mark init_workqueues() as
 early_initcall()
Message-Id: <20100730165522.22dc982b.akpm@linux-foundation.org>
In-Reply-To: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 14:57:37 -0700
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Mark init_workqueues() as early_initcall() and thus it will be initialized
> before smp bringup. init_workqueues() registers for the hotcpu notifier
> and thus it should cope with the processors that are brought online after
> the workqueues are initialized.
> 
> x86 smp bringup code uses workqueues and uses a workaround for the
> cold boot process (as the workqueues are initialized post smp_init()).
> Marking init_workqueues() as early_initcall() will pave the way for
> cleaning up this code.
> 

I sure hope this has been tested against linux-next. 
kernel/workqueue.c has been vastly changed and -tip doesn't know about
that.  linux-next should include -tip and is hence a better tree to
develop and test against.

AFAICT the main thing which needs checking is that the new
init_workqueues() doesn't do anything which requires that
sched_init_smp() has been executed.

The patch otherwise looks OK and killing that hack in the x86 code was
most merciful.

for_each_gcwq_cpu(), for_each_online_gcwq_cpu() and for_each_cwq_cpu()
make me cry.
