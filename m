Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2EHNSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:18:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:46889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab2EHNSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:18:39 -0400
Message-ID: <1336483073.16236.37.camel@twins>
Subject: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>
Date: Tue, 08 May 2012 15:17:53 +0200
In-Reply-To: <1336481312.14207.164.camel@gandalf.stny.rr.com>
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
	 <1336476588.16236.20.camel@twins>
	 <1336481312.14207.164.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 08:48 -0400, Steven Rostedt wrote:
> On Tue, 2012-05-08 at 13:29 +0200, Peter Zijlstra wrote:
> > On Tue, 2012-05-08 at 16:41 +0530, Srikar Dronamraju wrote:
> > > +    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
> > 
> > can you also do things like:
> > 
> >  p:uprobes/ponies /bin/zsh:foo arg1=bar
> > 
> > when bar is either a function argument of foo (or an otherwise live
> > variable at the probe point)?
> > 
> > Only sampling register content is somewhat limiting, you might want to
> > have %ax[5] + 24 for example, or a pure memory deref -- and the dwarves
> > know where it all lives.
> 
> But this is for the raw entry into the kernel. The kernel wont know the
> variable name. Although perf could do that parsing for you.

Ah, ok. Yes I meant for perf to do this, I overlooked it was the kernel
input.

> That said, the %ax[5] + 24 could be done in kernel, and that would be
> useful. Does kprobes handle that?

In general something like: %mr + %c * %cr + %cr would be most useful I
think (%m - memory address, %r - register, %c - constant). Although
maybe it needs segment registers too, dunno. Also no idea if this covers
the addressing scope of all archs.
