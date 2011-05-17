Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1EQHPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:15:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1EQHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AOqnAVpeLCIcwhVA77UNjF9b44czsAEwr+hsk4eRECLBss3oU0bUCrsl4e3NNIXqJH
         NqxkEBjncFwBIMNs08qA==
MIME-Version: 1.0
In-Reply-To: <20110511215111.GA16355@elte.hu>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com> <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com> <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo> <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo> <20110510084158.GC27426@elte.hu>
 <1305032797.2943.34.camel@frodo> <20110511215111.GA16355@elte.hu>
From: Michael Rubin <mrubin@google.com>
Date: Tue, 17 May 2011 00:15:15 -0700
Message-ID: <BANLkTikRX2gNwyUSWLNBcpc727Ww7Ya6Ow@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread is unsettling for at least one customer of kernel tracing.

Google spent a lot of time writing their own kernel tracing
infrastructure ktrace. It was working just fine for us but we
abandoned it in order to work with the community. We evaluated perf,
ftrace and LTTNG and opted for ftrace. We saw it as a efficient kernel
system that had been around long enough we could depend on it to
continue to be around. Also we could share our work this way. We
started sending patches and tried to be good Open Source citizens.

Switching from ktrace to ftrace was very painful for us. In order to
monitor the tens of thousands of computers Google maintains we wrote a
lot of tools on top of ftrace that are very specific to Google's user
space technology. What was not fun was to ask engineers to make
changes to their working systems to accommodate the switch from ktrace
to ftrace. We are not going to do this again in the near future.

On Wed, 2011-05-11 at 23:51 +0200, Ingo Molnar wrote:
> This is sadly how 'splitting a small pond into two' tends to
> work out in practice: both halves stink a little bit more than they would if
> they were kept together ;-)

I heavily agree with this statement. Having duplicate solutions
doesn't help anything.

On Wed, 2011-05-11 at 23:51 +0200, Ingo Molnar wrote:
> - If the perf UI/API/ABI design is better then ftrace can be migrated to it
>  and we can use the perf APIs to do more tooling goodness.
>  Everyone will be happy.

But I don't agree here. Everyone will _not_ be happy. Existing
customers will have to migrate to a new system, API or even worse new
semantics.

On Wed, 2011-05-11 at 23:51 +0200, Ingo Molnar wrote:
> So i really prefer the 'apps are using us' situation we are in today, and not
> breaking them is a *small* price to pay and it is a very small loss of the near
> infinite degrees of development freedom we still enjoy in the kernel.

I really prefer the 'apps are using us' situation too. Both as someone
who is working with ftrace development and also working with kernel
tracing customers.

What is the plan for customers going forward? Is it going to involve
removing ftrace in favor for perf? Removing perf in favor for ftrace?
We love perf and don't want to see it go away either.  We tend to use
the two systems differently. Do customers basically have to wait a few
years to see not only which system wins but which ones stays on top?

I apologize if this is obvious to others but I am confused.

mrubin
