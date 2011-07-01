Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1GANxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:53:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab1GANxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:53:33 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=J5aFgaVnb1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=T5ghlZuFmIMCY4AcciAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH -tip ] [BUGFIX] x86: Remove preempt disabling from
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <1309527824.26417.149.camel@gandalf.stny.rr.com>
References: <4E0DC859.6050405@hitachi.com>
	 <20110701131408.30886.45766.stgit@localhost.localdomain>
	 <1309527824.26417.149.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 09:53:31 -0400
Message-ID: <1309528411.26417.153.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 09:43 -0400, Steven Rostedt wrote:

> I applied it to v3.0-rc5. And not surprisingly it works. But the
> question I have is, when we return from the trap, and NEED_RECHED is
> set, will it schedule? My test placed the probe within the scheduler
> where preemption is already disabled. Let me do this in places that has
> preemption and interrupts enabled.
> 
> I'll also try a kernel mod that adds a probe handler that does a
> udelay() loop, forcing the timer interrupt to be set on return of the
> trap, and see what happens there.

I didn't need to do the above. Just adding a probe at the beginning of
schedule() should do the trick. As I see from the latency-format option
set, that NEED_RESCHED is enabled when we enter the path. If interrupts
are enabled on single step, I would think that the code would go into an
infinite loop if it had issues there.

Thus I think we can say that removing preempt_disable() from kprobes in
x86_64 (and probably 32) is safe. I'll go and test this on my PPC64 and
mips (if I can get that compiled).

-- Steve


