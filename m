Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab1BRWjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:39:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59601 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1BRWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:39:07 -0500
Date: Fri, 18 Feb 2011 23:39:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dominique Toupin <dominique.toupin@ericsson.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is for x86_64 right now)
Message-ID: <20110218223902.GR5818@one.firstfloor.org>
References: <4D5D1672.6070206@hitachi.com> <1297948703.23343.907.camel@gandalf.stny.rr.com> <4D5D4013.4070602@hitachi.com> <1297957591.23343.921.camel@gandalf.stny.rr.com> <4D5D47C0.9020206@hitachi.com> <1297973501.23343.953.camel@gandalf.stny.rr.com> <4D5E5BCF.1040509@hitachi.com> <1298041659.23343.956.camel@gandalf.stny.rr.com> <20110218151954.GA27834@Krystal> <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 03:10:18PM -0500, Dominique Toupin wrote:
> 
> My understanding is stop_machine will stop all processors for many ms.

I haven't measured it recently, but as long as the callback inside stop
machine is short it definitely shouldn't be "many ms". The latency
is bound by how long each CPU needs to answer to an interrupt, so if
you have some code that disables interrupts for a long time it will take
long -- but then your realtime response will be already bad. 

The interrupts are also done in parallel, so the interrupt latencies
don't add up.

If all the CPUs answer in a reasonable time it's still not a cheap
operation, but nothing that takes "many ms". Most likely it's fine
for most soft real time purposes.

-Andi
