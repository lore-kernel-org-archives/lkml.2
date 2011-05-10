Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1EJTON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:14:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EJTOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=hGKZ3WQJAVj/n3NXPxLZky5ZZrkeGdEKvLSxKGttfo6XmtRkIpJRcxQqkSU0HHaS0x
         gL2Mc8lqBMsxQHYIkR7Q==
MIME-Version: 1.0
In-Reply-To: <1305023588.2971.6.camel@frodo>
References: <4DC45537.6070609@linux.intel.com> <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com> <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com> <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo> <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo> <20110510084732.GE27426@elte.hu> <1305023588.2971.6.camel@frodo>
From: David Sharp <dhsharp@google.com>
Date: Tue, 10 May 2011 12:13:48 -0700
Message-ID: <BANLkTimzpoB3v9SAG4pGfux0q2PnzRxmNQ@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 3:33 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-05-10 at 10:47 +0200, Ingo Molnar wrote:
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> > [...] Thus a library is a perfect solution. [...]
>>
>> Btw., just to make things clear, if we indeed have a library to parse things
>> and if all apps use that then the ABI moves to another (library) level.
>>
>> The requirement from my maintenance POV is very, very simple: apps should not
>> break on new kernels. If this is achieved by making apps smarter then that's a
>> valid solution.
>>
>
> Great! Because this is what I want. I would also want a way to designate
> events as stable. I'll add a TRACE_EVENT_STABLE() that can only have the
> events that maintainers agree to maintain. And give the apps an ability
> to only see these.

A TRACE_EVENT_STABLE() would mark the entire event as stable. I was
wondering if we should instead mark fields within events as stable.
Even within a "stable" event, certain fields we might not want to
guarantee to be in the next release. This might also make it clearer
that the position of a field (stable or not) in an event can change,
and tools really should parse the event format.

> Have the other events need either a separate library,
> or perhaps just separate calls from within the same library, so the XFS
> developers can feel safe that their tracepoints will not be depended on.
> And perhaps have two tracepoints for sched_switch such that Peter
> Zijlsta is happy that he's not bound by an tracepoint that keeps him
> from getting rid of FIFO ;)
>
> I'm happy to write a libperf.so and I can discuss with Arnaldo, Arjan
> and yourself what is the best way of doing this.
>
> Thanks,
>
> -- Steve
>
>
>
