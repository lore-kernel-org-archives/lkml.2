Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1GABiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:38:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1GABiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:38:21 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=EAdfuy46jrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=36EdqO7F9hGmj-ZezaMA:9 a=bivkmJAksUN_cAdW5SQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        MartinSchwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <4E0D2141.4080608@hitachi.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <1309449117.26417.90.camel@gandalf.stny.rr.com>
	 <1309470997.12449.614.camel@twins>  <4E0D2141.4080608@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 21:38:17 -0400
Message-ID: <1309484297.26417.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added some of the affected maintainers, left off David Howells and
David Miller due to LKML Cc limit ]

On Fri, 2011-07-01 at 10:22 +0900, Masami Hiramatsu wrote:
> (2011/07/01 6:56), Peter Zijlstra wrote:
> > On Thu, 2011-06-30 at 11:51 -0400, Steven Rostedt wrote:
> >>
> >> To solve this, I've added a per_cpu variable called
> >> kprobe_preempt_disabled, that is set by the kprobe code. If it is set,
> >> the preempt_schedule() will not preempt the code.
> 
> Sorry for replying so late :(

Heh, who can blame you? Timezones make open source development a
wait-and-see affair.

> 
> > Damn this is ugly. Can we step back and see if we can make the
> > requirement for kprobe to disable preemption go away?
> 
> As I replied right now, I think we can just eliminate that
> disabling preemption code. At least we'd better try it.
> I agree with you, introducing this kind of complexity
> just for kprobes is not what I want. :(

Note, I did clean up this patch, so it is not as fugly.

> 
> > Why does it have to do that anyway? Isn't it keeping enough per-task
> > state to allow preemption over the single step?
> 
> preemption itself must not happen on single stepping, but it seems
> impossible to do heavy context switching with setting TF bit...

Yeah, if all archs single step with interrupts disabled, then we should
be fine with removing preemption.

-- Steve



