Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab1BRWqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:46:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34571 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1BRWqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:46:01 -0500
Message-ID: <4D5EF67F.20007@zytor.com>
Date: Fri, 18 Feb 2011 14:45:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC][PATCH 0/4] ftrace: Use -mfentry when supported (this is
 for x86_64 right now)
References: <4D5D1672.6070206@hitachi.com> <1297948703.23343.907.camel@gandalf.stny.rr.com> <4D5D4013.4070602@hitachi.com> <1297957591.23343.921.camel@gandalf.stny.rr.com> <4D5D47C0.9020206@hitachi.com> <1297973501.23343.953.camel@gandalf.stny.rr.com> <4D5E5BCF.1040509@hitachi.com> <1298041659.23343.956.camel@gandalf.stny.rr.com> <20110218151954.GA27834@Krystal> <D58A856745AB5A47B1448181D1A8BBFA07673BC266@EUSAACMS0701.eamcs.ericsson.se> <20110218223902.GR5818@one.firstfloor.org>
In-Reply-To: <20110218223902.GR5818@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 02:39 PM, Andi Kleen wrote:
> On Fri, Feb 18, 2011 at 03:10:18PM -0500, Dominique Toupin wrote:
>>
>> My understanding is stop_machine will stop all processors for many ms.
> 
> I haven't measured it recently, but as long as the callback inside stop
> machine is short it definitely shouldn't be "many ms". The latency
> is bound by how long each CPU needs to answer to an interrupt, so if
> you have some code that disables interrupts for a long time it will take
> long -- but then your realtime response will be already bad. 
> 
> The interrupts are also done in parallel, so the interrupt latencies
> don't add up.
> 
> If all the CPUs answer in a reasonable time it's still not a cheap
> operation, but nothing that takes "many ms". Most likely it's fine
> for most soft real time purposes.
> 

We should also be able to use the breakpoint hack to avoid holding all
the CPUs.  They still need to be interrupted, but that skips the
rendezvous operation.

	-hpa

