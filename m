Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab0EMSdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:33:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab0EMSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:33:35 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=yiYnlo-UJTIA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=tB9f0SiZxiQnIGsfSNEA:9 a=5bEc2HO6S_WlC0lQnEYA:7 a=vUAzSpqlxY6sAvjQmN6XRSX_pJMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100513171015.GA13698@Krystal>
References: <20100512180438.GE15953@Krystal>
	 <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal>
	 <1273690012.27703.38.camel@gandalf.stny.rr.com>
	 <20100512202745.GK21432@Krystal>
	 <1273702886.27703.58.camel@gandalf.stny.rr.com>
	 <20100513132029.GA22799@Krystal>
	 <1273765337.27703.1043.camel@gandalf.stny.rr.com>
	 <20100513163150.GA13005@Krystal>
	 <1273769178.27703.1119.camel@gandalf.stny.rr.com>
	 <20100513171015.GA13698@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 14:33:32 -0400
Message-ID: <1273775612.27703.1228.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 13:10 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> IOW, if the reader is trying to get subbuffers like crazy, it will maybe cause
> one loop restart when taking the subbuffer the writer was about to write to, but
> after that, the reader will be forced to exchange the next subbuffer, and so on
> until it wraps-around and comes back to the subbuffer preceding the writer
> position, as stop there. Note that during all this execution, the reader could
> only cause a single retry of the writer. In summary, the frontend range
> restrictions guarantee that the writer will retry at most once.
> 

And I take it that this is all verified in your proof.

> Note that we could also use an atomic "set bit/clear bit" for the writer, along
> with write memory barriers, when available on the architecture, and that would
> remove all need for loops. However, architectures that need to emulate set
> bit/clear bit with a cmpxchg() would behave pretty much in the same way as my
> current code does.
> 
> > 
> > I thought you said you did not have loops in the writers?

Just a note, that the current ring buffer has no such loops.

> 
> Well, while technically a loop, it is a bounded single-retry, so it's OK as far
> as wait-free guarantees are concerned. We could even put a WARN_ON() there to
> ensure that we catch double retry that should never happen, but that would be at
> the cost of a runtime veritication. A DEBUG_TRACER_RT config option could select
> this though.

No, no one would ever track that. As with todays ring buffer, we keep
all checks enabled. Sorry if it slows it down, but the kernel is at such
a flex that we must have these checks on all the time.

-- Steve


