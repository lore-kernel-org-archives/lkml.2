Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab1BRULH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:11:07 -0500
Received: from imr4.ericy.com ([198.24.6.8]:60943 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab1BRULE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:11:04 -0500
From: Dominique Toupin <dominique.toupin@ericsson.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Date: Fri, 18 Feb 2011 15:10:18 -0500
Subject: RE: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
	for x86_64 right now)
Thread-Topic: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
	for x86_64 right now)
Thread-Index: AcvPf08SL/6ABui4ROSvsMTjMwWNswAIBDYg
Message-ID: <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
References: <20110209200249.111932716@goodmis.org>
 <4D5D1672.6070206@hitachi.com>
 <1297948703.23343.907.camel@gandalf.stny.rr.com>
 <4D5D4013.4070602@hitachi.com>
 <1297957591.23343.921.camel@gandalf.stny.rr.com>
 <4D5D47C0.9020206@hitachi.com>
 <1297973501.23343.953.camel@gandalf.stny.rr.com>
 <4D5E5BCF.1040509@hitachi.com>
 <1298041659.23343.956.camel@gandalf.stny.rr.com>
 <20110218151954.GA27834@Krystal>
In-Reply-To: <20110218151954.GA27834@Krystal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My understanding is stop_machine will stop all processors for many ms.
Even if most of our systems are not hard real-time they are soft real-time and stopping all cores for a few ms is not allowed.
We can stop a few threads while we are jump patching but all processors is too much for us.

I can send other real use cases if you are interested.


> -----Original Message-----
> From: Mathieu Desnoyers [mailto:mathieu.desnoyers@efficios.com] 
> Sent: 18-Feb-11 10:20
> To: Steven Rostedt; Dominique Toupin
> Cc: Masami Hiramatsu; linux-kernel@vger.kernel.org; Ingo 
> Molnar; Andrew Morton; Thomas Gleixner; Frederic Weisbecker; 
> H. Peter Anvin; Andi Kleen; 2nddept-manager@sdl.hitachi.co.jp
> Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when 
> supported (this is for x86_64 right now)
> 
> [Adding Dominique Toupin, from Ericsson, to CC list]
> 
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Fri, 2011-02-18 at 20:45 +0900, Masami Hiramatsu wrote:
> > > (2011/02/18 5:11), Steven Rostedt wrote:
> > > > On Fri, 2011-02-18 at 01:07 +0900, Masami Hiramatsu wrote:
> > > > 
> > > >> I just thought that frequent stop-machine is not so 
> good from the 
> > > >> user's POV. I agree that disabled probe ignoring the 
> call is enough.
> > > >> Maybe, it could be done with the similar mechanism of 
> jump optimization.
> > > > 
> > > > I thought jump optimization still calls stop_machine too?
> > > 
> > > Yes, but now it does batch optimization.
> > > Even if hundreds kprobes are registered separately, jump 
> > > optimization has been done in background with a 
> stop_machine per every 256 probes.
> > > (Until optimizing, kprobes can use breakpoints instead)
> > 
> > But a single optimized kprobe still must use stopmachine.
> > 
> > But it is true that the function tracer does it as one big 
> shot. That 
> > is, it will do all functions in a single stop machine that 
> needs to be 
> > changed. It too is batched, but there is not a limit to that batch.
> > 
> > I would be interested in hearing from users and real use cases that 
> > someone would like to trace functions but stopmachine is 
> too big of a 
> > hammer.
> 
> Hi Steven,
> 
> Telecom end users are one of such cases where the latency 
> induced by stop machine while the system is running is a 
> problem. Dominique Toupin could certainly tell us more about 
> Ericsson's use-cases.
> 
> Thanks,
> 
> Mathieu
> 
> --
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant EfficiOS Inc.
> http://www.efficios.com
> 