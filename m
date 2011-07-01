Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1GALgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:36:38 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50917 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1GALgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:36:38 -0400
Date: Fri, 1 Jul 2011 17:06:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [BUG] kprobes crashing because of preempt count
Message-ID: <20110701113626.GB23752@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1309440213.26417.76.camel@gandalf.stny.rr.com> <4E0D1EE3.6080607@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0D1EE3.6080607@hitachi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 10:12:03AM +0900, Masami Hiramatsu wrote:
> (2011/06/30 22:23), Steven Rostedt wrote:

...

> > Do we really need to have preemption disabled throughout this? Is it
> > because we don't want to migrate or call schedule? Not sure what the
> > best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
> > is checked as well?
> 
> I think the best way to do that is just removing preemption disabling
> code, because
> - breakpoint exception itself disables interrupt (at least on x86)
> - While single stepping, interrupts also be disabled.

On 64-bit powerpc, kprobe handlers are run with interrupts enabled
(MSR_EE = 1), but most instructions (including loads/stores) are
emulated, so for the most part, we don't take the sstep exception.

Ananth
