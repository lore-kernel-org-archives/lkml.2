Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab1BRVqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:46:10 -0500
Received: from imr4.ericy.com ([198.24.6.8]:52490 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1BRVqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:46:08 -0500
From: Dominique Toupin <dominique.toupin@ericsson.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Date: Fri, 18 Feb 2011 16:45:31 -0500
Subject: RE: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
Thread-Topic: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
Thread-Index: AcvPq5P826IDTfQrQKuB8/vxoFUeuwABJMBg
Message-ID: <D58A856745AB5A47B1448181D1A8BBFA07673BC2D6@EUSAACMS0701.eamcs.ericsson.se>
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
	 <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
 <1298061395.23343.975.camel@gandalf.stny.rr.com>
In-Reply-To: <1298061395.23343.975.camel@gandalf.stny.rr.com>
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


If it's 1 us it might be OK for some of our "server" type of system, still the number of cores are growing quite fast and stopping _all_ of them is a bit scary. Some cores are dedicated to a special telecom subsystem which is very sensitive to even very small hic-up, we don't want to stop those cores.

As background info, we can use GDB dynamic tracepoint in those systems because GDB doesn't stop all cores when the tracepoint are inserted with a jump.


> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org] 
> Sent: 18-Feb-11 15:37
> To: Dominique Toupin
> Cc: Mathieu Desnoyers; Masami Hiramatsu; 
> linux-kernel@vger.kernel.org; Ingo Molnar; Andrew Morton; 
> Thomas Gleixner; Frederic Weisbecker; H. Peter Anvin; Andi 
> Kleen; 2nddept-manager@sdl.hitachi.co.jp
> Subject: RE: [RFC][PATCH 0/4] ftrace: Use -mfentry when 
> supported (this is for x86_64 right now)
> 
> On Fri, 2011-02-18 at 15:10 -0500, Dominique Toupin wrote:
> > My understanding is stop_machine will stop all processors 
> for many ms.
> 
> s/ms/us/
> 
> 
> > Even if most of our systems are not hard real-time they are 
> soft real-time and stopping all cores for a few ms is not allowed.
> > We can stop a few threads while we are jump patching but 
> all processors is too much for us.
> 
> I think I could hit a single ms if we enable full function 
> tracing which disables ~22,000 functions in one shot. But if 
> you enable full function tracing, the kernel can slow down 
> quite drastically, and that would even be more problematic 
> than a single ms hic-up. As hackbench showed a %150 slowdown 
> when function tracer was running.
> 
> Now the last measurements I took was a few years ago and it 
> was on a 4 CPU box. Perhaps stop_machine() may be a bit more 
> expensive on a 1024 CPU box.
> 
> -- Steve
> 
> 
> 