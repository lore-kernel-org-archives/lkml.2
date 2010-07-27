Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0G0XSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:18:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab0G0XSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:18:38 -0400
Date: Tue, 27 Jul 2010 16:18:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: monstr@monstr.eu
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: Use raw_local_irq_save/restore instead
 local_irq_save/restore
Message-Id: <20100727161819.cf6feab1.akpm@linux-foundation.org>
In-Reply-To: <4C4D4C2E.8010103@monstr.eu>
References: <1274863724-14906-1-git-send-email-monstr@monstr.eu>
	<1274863724-14906-2-git-send-email-monstr@monstr.eu>
	<1274884963.22648.245.camel@gandalf.stny.rr.com>
	<20100526100805.171b3c48.akpm@linux-foundation.org>
	<4C4D4C2E.8010103@monstr.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 10:49:50 +0200
Michal Simek <monstr@monstr.eu> wrote:

> start/stop_critical_timing function for preemptirqsoff, preemptoff
> and irqsoff tracers contains atomic_inc and atomic_dec operations.
> 
> Atomic operations used local_irq_save/restore macros to ensure
> atomic access but they are traced by the same function which is causing
> recursion problem.
> 
> The reason is when these tracers are turn ON then local_irq_save/restore
> macros are changed in include/linux/irqflags.h to call trace_hardirqs_on/off
> which call start/stop_critical_timing.
> 
> Microblaze was affected because use generic atomic implementation.

Seems that this will also affect blackfin, mn10300 and score.  I guess
they aren't supporting tracing yet?

> Signed-off-by: Michal Simek <monstr@monstr.eu>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

hm, I wonder how my signoff got there.  Doesn't matter.
