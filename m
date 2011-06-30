Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1F3V5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:57:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56498 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1F3V5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:57:48 -0400
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for
 kprobes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1309449117.26417.90.camel@gandalf.stny.rr.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <1309449117.26417.90.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:56:37 +0200
Message-ID: <1309470997.12449.614.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 11:51 -0400, Steven Rostedt wrote:
> 
> To solve this, I've added a per_cpu variable called
> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
> the preempt_schedule() will not preempt the code.

Damn this is ugly. Can we step back and see if we can make the
requirement for kprobe to disable preemption go away?

Why does it have to do that anyway? Isn't it keeping enough per-task
state to allow preemption over the single step?


