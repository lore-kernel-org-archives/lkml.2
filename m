Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1GBGJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 02:09:47 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60469 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1GBGJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 02:09:46 -0400
Date: Sat, 2 Jul 2011 11:39:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip ] [BUGFIX] x86: Remove preempt disabling from
	kprobes
Message-ID: <20110702060929.GA5511@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4E0DC859.6050405@hitachi.com> <20110701131408.30886.45766.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701131408.30886.45766.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 10:14:08PM +0900, Masami Hiramatsu wrote:
> Steven Rostedt reported that putting kprobe on the instruction which
> loads preempt_count causes the wrong result, as below.
> 
> Kprobes requires preemption to be disabled as it single steps the code
> it replaced with a breakpoint. But because the code that is single
> stepped could be reading the preempt count, the kprobe disabling of the
> preempt count can cause the wrong value to end up as a result. Here's an
> example:

...

> We just caused preempt count to increment twice when it should have only
> incremented once, and this screws everything else up.
> 
> To solve this, I've removed preempt disabling code from kprobes,
> since the breakpoint exception and kprobes single step routine
> disables interrupts, it doesn't need to disable preemption while
> single-stepping anymore.
> 
> This patch is for -tip tree, and it can be applied to linus tree too.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> ---

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
