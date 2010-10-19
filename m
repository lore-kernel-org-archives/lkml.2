Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab0JSVpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:45:51 -0400
Received: from www.tglx.de ([62.245.132.106]:46028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab0JSVpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:45:50 -0400
Date: Tue, 19 Oct 2010 23:45:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <1287521757.16971.397.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1010192307560.6815@localhost6.localdomain6>
References: <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>  <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>  <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>  <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
  <20101019132236.GA19197@Krystal>  <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>  <1287496495.16971.372.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>  <20101019142820.GA14520@Krystal> 
 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Steven Rostedt wrote:
> On Tue, 2010-10-19 at 21:49 +0200, Thomas Gleixner wrote:
> 
> Because you do the h - softvec in the tracepoint parameter? I got a
> different result:

I guess some serious whacking is due.

The compiler adds two jumps when the parameter changes due to
 (h -softvec) instead of (h, softvec) ????

Dude, you can't be serious.

If you would have asked about the compiler version I'm using and told
me about the compiler version you are using, then I could take that
answer somehow serious.

It still would miss the "Uhhhh, your compiler creates crap code"
alert, because that double jump is seriously broken and braindead.

And I tell you more about this. You are going to piss off a lot of
users of distro compilers because they will set CC_HAVE_ASM_GOTO
happily and create the code I posted. Which will break the tracer no
matter what.

So you tracer maniacs happily played with some experimental compiler
stuff w/o even testing your crap against something which ships with
distros or is the reference 4.5 compiler on kernel.org ?

I prefer you sending a patch to disable this, until it's sorted out,
unless you want me to add some really outrageous changelog to the
patch I'm going to put into tip tomorrow night, ok ?

Thanks,

	tglx
