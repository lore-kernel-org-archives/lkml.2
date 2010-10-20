Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab0JTP2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab0JTP2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:28:46 -0400
Date: Wed, 20 Oct 2010 11:27:45 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101020152745.GA7348@redhat.com>
References: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal> <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287529515.16971.538.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 07:05:15PM -0400, Steven Rostedt wrote:
> On Tue, 2010-10-19 at 15:49 -0700, H. Peter Anvin wrote:
> > On 10/19/2010 03:41 PM, Mathieu Desnoyers wrote:
> > >>
> > >> OK, first of all, there are some serious WTFs here:
> > >>
> > >> # define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> > >>
> > >> A jump instruction is one of the worst possible NOPs.  Why are we doing
> > >> this?
> > > 
> > > This code is dynamically patched at boot time (and module load time) with a
> > > better nop, just like the function tracer does.
> > > 
> > 
> > That's just ridiculous... start out with something sane and you at least
> > have the chance of not having to patch it.
> 
> Yep we can fix this. Jason?
> 

sure. The idea of the 'jmp 0' was simply to be an lcd for x86, if
there's a better lcd for x86, I'll update it. But note, that since the
'jmp 0' is patched to a better nop at boot, we wouldn't see much gain.
And in the boot path we are using 'text_poke_early()', so avoiding that
isn't going to improve things much.

I've got a few fixup patches in the queue that I'm going to post first,
and then I'll take a look at this change.

thanks,

-Jason

