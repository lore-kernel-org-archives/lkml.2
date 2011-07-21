Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1GUSEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:04:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46275 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1GUSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:04:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=JvX3uqtD3xBmibTz9qeT6+zcKjH0tZPRY7bVtTIn8dOOnkcNWAPjbVctcDU+Xv5ZJ
	NEBdpaWCbbaw0SW5GKSmw==
MIME-Version: 1.0
In-Reply-To: <1311251487.29152.136.camel@twins>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-5-git-send-email-vnagarnaik@google.com> <20110714220233.GC26786@somewhere.redhat.com>
 <1310719682.2586.289.camel@twins> <CAJL_ektnxUZaRJmx14H9psJ8MFBZ8iD5ET14WgT8CoJdMvH40w@mail.gmail.com>
 <1311251487.29152.136.camel@twins>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 21 Jul 2011 11:04:01 -0700
Message-ID: <CAL26m8JvhzkweuCD1NGvbr_xDEskF3me5FxTpuX7o5DiwHCJTg@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: Add tracepoints to reschedule interrupt handler
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Sharp <dhsharp@google.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 5:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-07-15 at 10:50 -0700, David Sharp wrote:
>> On Fri, Jul 15, 2011 at 1:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Fri, 2011-07-15 at 00:02 +0200, Frederic Weisbecker wrote:
>> >> > This is a part of overall effort to trace all the interrupts happening
>> >> > in a system to figure out what time is spent in kernel space versus user
>> >> > space.
>> >
>> > How about you enable CONFIG_IRQ_TIME_ACCOUNTING and get all that?
>> >
>>
>> It's not just about how long, it's when, and what other events the
>> interrupts are interacting with.
>
> But that's not what the Changelog said, how am I supposed to smell that?

I will update the changelog to be clearer.

>
> As to the patch in particular, I hate it, why do you need separate
> tracepoints for the resched ipi and wtf is up with that ignore argument.
>

By separate tracepoints if you mean the entry and exit tracepoints, we
use it to trace the interrupts in the system and get the timing for each
interrupt to complete. When interleaved with the other system trace, we
get how it affected other tasks. It would be hard to know that by using
CONFIG_IRQ_TIME_ACCOUNTING.

The 'ignore' argument is due to the limitation of the TRACE_EVENT macro,
which requires at least 1 argument passed to it. I could not think of a
suitable data argument for the tracepoint, so I had to use a dummy
argument. If you can suggest something that can be used instead, I will
be glad to update the patch.


Vaibhav Nagarnaik
