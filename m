Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab0KQDeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:34:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab0KQDeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:34:05 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2kSzP4yT2LoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=PbuKkTiDa67qIFTR3XoA:9 a=s8FFLRhH5zhWICEPk1EA:7 a=FGPjvfEIcILlHNDIFvj_Adtggh8A:4 a=PUjeQqilurYA:10 a=8YmfhXGTcq14MqZf:21 a=rwGiIaorOixybRtt:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Steven Rostedt <rostedt@goodmis.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117031609.GE3290@thunk.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org>
	 <1289958460.30543.13.camel@gandalf.stny.rr.com>
	 <20101117031609.GE3290@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Nov 2010 22:34:00 -0500
Message-ID: <1289964840.30543.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 22:16 -0500, Ted Ts'o wrote:
> On Tue, Nov 16, 2010 at 08:47:40PM -0500, Steven Rostedt wrote:
> > 
> > Note, I just posted an RFC stable event patch set. I would like any tool
> > that does general analysis, to use stable events and not random raw
> > events created by the perspective maintainers.
> > 
> > The tool could tap into the raw events, but I don't like the "trace
> > check" I think anything that the trace needs should be guaranteed there
> > (with the stable tracepoints).
> > 
> > The tracepoints used for general analysis should be stable, anything
> > else is just shear bonus.
> 
> Which is fine with me, so long as it is accepted that the 'trace' tool
> is not targetted at kernel developers (who would probably like to use
> a combination of stable and unstable tracepoints).
> 
> Do we all agree on what the intended target audience is for this
> 'trace' tool?
> 
> My one concern of having a tool that doesn't support the unstable
> tracepoints is that if the kernel developers aren't using it for their
> day-to-day use, it won't get attention/love, and it risks the fate of
> 'systemtap' --- ignored by kernel developers and treated as if it
> doesn't exist.
> 
> Maybe the answer is there's a #ifdef, and there's one version of the
> tool that is intended for use by kernel developers, and one which is
> restricted to the stable interface that we give to the hoi polloi?

I was not involved in making of this tool, but I would envision that it
would probably have special options to enable the raw events. That is,
basic users would never see the events that kernel developers use, but
with a simple switch (-r?) it would enable all events (both stable and
raw). It just wont have the ability to do any analysis of these events.
That is, it can just report the events (much like what trace-cmd does
today), but they will just exist as an event, not anything the tool can
give true meaning to. But the kernel developer should be able to
understand it.(*)

If we get a consensus on stable events, I would like to add
a /debug/events directory that will be similar to
the /debug/tracing/events, except that it will have the new format for
all raw events.

-- Steve

(*) Currently in trace-cmd I have plugins. These plugins are simple
functions to read events and either output better displays of the event
or do something special (Avi wrote some for his kvm events). I would
like to create a tools/trace/plugins directory that this trace tool
could use. A kernel developer could write the code to pretty print their
event and show much better information that reading a bunch of hex
fields. But more on this later, I would like to work on getting stable
events done first.


