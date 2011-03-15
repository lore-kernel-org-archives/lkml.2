Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1COUBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:01:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42425 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab1COUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:01:04 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=DpMNfemkRQYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=OenoeLH2CSrvmxo01XQA:9 a=EzddUgAhRnokyV_d_uAFFQ1ZEMEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1103152038280.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314163028.a05cec49.akpm@linux-foundation.org>
	 <20110314234754.GP2499@one.firstfloor.org>
	 <alpine.LFD.2.00.1103150114590.2787@localhost6.localdomain6>
	 <20110315180639.GQ2499@one.firstfloor.org>
	 <alpine.LFD.2.00.1103152038280.2787@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Mar 2011 16:01:01 -0400
Message-ID: <1300219261.9910.300.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 20:43 +0100, Thomas Gleixner wrote:
> On Tue, 15 Mar 2011, Andi Kleen wrote:
> > > > How do you envisage these features actually get used?  For example,
> > > > will gdb be modified?  Will other debuggers be modified or written?
> > > 
> > > How about answering this question first _BEFORE_ advertising
> > > systemtap?
> > 
> > I thought this was obvious.  systemtap is essentially a script driven 
> > debugger. 
> 
> Oh thanks for the clarification. I always wondered why a computer
> would need a tap.
> 
> And it does not matter at all whether systemtap can use this or
> not. If the main debuggers used like gdb are not going to use it then
> it's a complete waste. We don't need another debugging interface just
> for a single esoteric use case.

The question is, can we have a tracing interface? I don't care about a
debugging interface as PTRACE (although the ABI sucks) is fine for that.
But any type of live tracing it really sucks for.

Hopefully this will allow perf (and yes even LTTng and systemtap) to be
finally able to do seamless tracing between userspace and kernel space.
The only other thing we have now is PTRACE, and if you think that's
sufficient, then spend a day programming with it.


-- Steve


