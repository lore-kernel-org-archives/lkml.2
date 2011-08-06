Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1HFBBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:01:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1HFBBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:01:31 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=JVmKiHRY1FkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=alDACJeCYuxwud8HA6EA:9 a=NAvtaTI1aq90uoR69xwA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20110805212409.GA21114@elte.hu>
References: <20110805205921.909038487@goodmis.org>
	 <20110805212409.GA21114@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 05 Aug 2011 21:01:28 -0400
Message-ID: <1312592488.18583.215.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 23:24 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > By keeping the code separate from perf, made the transition from 
> > trace-cmd to tools much easier. I've wasted too many days trying to 
> > get other ways working, and I don't want to rewrite perf to do so.
> 
> But we want to move tools together, not further apart. Every code 
> activity i see from you is trying to tear apart instrumentation 

Ouch!

Ingo, I was trying to do as you said, but to do so would require a lot
of restructuring of the perf code base. I started talking with Arnaldo,
as he's doing a lot of the work in the tools/perf code, and he's the one
that suggested that I do it this way. It made things a lot easier.

Seriously, I wasted Mon-Wed trying to see how it would work in
tools/perf. I went through iteration after iteration, and each time I
either rewrote the tools/perf/Makefile, or hacked apart the libparsevent
code to be strictly perf specific, and not very useful for anything
else.

It took me half of Thursday to get something working with this method.
It made sense and was easy to do. I don't have much more time to spend
on this. Red Hat does not pay me to do tracing/perf work. There's other
things that I need to focus on, and there's other aspects of ftrace that
needs to get done too (-mfentry for one).


> tooling - while previously you agreed that it should be unified. So 
> why not do tools/perf/lib/ as you agreed before?

Because Arnaldo and Frederic convinced me the tools/lib made more sense.

> 
> I'm really not interested in seeing the libdrm/libdri mess repeated. 
> Libraries have their uses when there's some very important external 
> interface, but here it's actively harmful as it complicates and 
> hardcodes APIs into ABIs that are clearly not finished yet.

What API/ABI is being hardcoded here?

-- Steve


