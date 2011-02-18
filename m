Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1BRPHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:07:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1BRPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:07:45 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=JGpTz_e83PYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mpsSxIc6-QBJ2jH1_FoA:9 a=sWOljSyASkJKS6__GB0A:7 a=cQTP_8tpQS3lvqTEFvPIsCGeFj0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, 2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4D5E5BCF.1040509@hitachi.com>
References: <20110209200249.111932716@goodmis.org>
	 <4D5D1672.6070206@hitachi.com>
	 <1297948703.23343.907.camel@gandalf.stny.rr.com>
	 <4D5D4013.4070602@hitachi.com>
	 <1297957591.23343.921.camel@gandalf.stny.rr.com>
	 <4D5D47C0.9020206@hitachi.com>
	 <1297973501.23343.953.camel@gandalf.stny.rr.com>
	 <4D5E5BCF.1040509@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Feb 2011 10:07:39 -0500
Message-ID: <1298041659.23343.956.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 20:45 +0900, Masami Hiramatsu wrote:
> (2011/02/18 5:11), Steven Rostedt wrote:
> > On Fri, 2011-02-18 at 01:07 +0900, Masami Hiramatsu wrote:
> > 
> >> I just thought that frequent stop-machine is not so good from the user's
> >> POV. I agree that disabled probe ignoring the call is enough.
> >> Maybe, it could be done with the similar mechanism of jump optimization.
> > 
> > I thought jump optimization still calls stop_machine too?
> 
> Yes, but now it does batch optimization.
> Even if hundreds kprobes are registered separately, jump optimization
> has been done in background with a stop_machine per every 256 probes.
> (Until optimizing, kprobes can use breakpoints instead)

But a single optimized kprobe still must use stopmachine.

But it is true that the function tracer does it as one big shot. That
is, it will do all functions in a single stop machine that needs to be
changed. It too is batched, but there is not a limit to that batch.

I would be interested in hearing from users and real use cases that
someone would like to trace functions but stopmachine is too big of a
hammer.

-- Steve


