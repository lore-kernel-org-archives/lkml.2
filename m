Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1CJTpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:45:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1CJTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:45:32 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=niRJQ5NdebbLZNx8V1kA:9 a=OC57vgZZZzemxGPPF5UA:7 a=c1xza0Kz4SJo0qucXvQQ4uCN5v8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <1299785143.15854.407.camel@gandalf.stny.rr.com>
References: <cover.1299702291.git.jbaron@redhat.com>
	 <1299728191.15854.319.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>
	 <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 14:45:29 -0500
Message-ID: <1299786329.15854.409.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 14:25 -0500, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 10:57 -0800, David Daney wrote:
> > On 03/10/2011 10:53 AM, Steven Rostedt wrote:
> > > On Thu, 2011-03-10 at 10:47 -0800, David Daney wrote:
> > >
> > >> The alignment requested by the assembler will have to satisfy *all* the
> > >> requested alignments, so manually forcing everything to .align 8 (or
> > >> .align 4 for 32-bit) should ensure that the linker doesn't put in any holes.
> > >
> > > I would agree with the assessment although, I don't know that it is
> > > documented anywhere that this is what happens. As the previous "bug"
> > > with the trace_events was solved by me adding .align(4) everywhere, I
> > > would think that .align(sizeof(long)) would work here too.
> > >
> > > It may be a good ideal to force this alignment, and not add wasted
> > > space. If anything, if this (hypothetical) bug appears, it will most
> > > likely show up as a crash on boot up. I'm not too concerned about it.
> > >
> > 
> > If the linker put in gratuitous holes, things like  __ex_table would 
> > break too.
> 
> Again, as I have said (although I said extable not __ex_table), there
> seems to be no problem when the data is of a power of 2 as well. As
> __ex_table size is a power of 2. We just don't know if the linker will
> add holes when the size is something other than power of 2.

Anyway, I think the best thing for now is to have Jason add
the .align(sizeof(long)) in the inline assembly for all locations and be
done with it.

-- Steve


