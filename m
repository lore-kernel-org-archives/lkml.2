Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0DABPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:15:02 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35315 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0DABPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:15:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=UwMQPZZpAN4ToMxEdDynW417NJJSjnWgSrMZTuzxH436tLb8J9oIZUS8l7RrnWVUL
	W29srHQkgs5BapOvUpz5Q==
MIME-Version: 1.0
In-Reply-To: <1270081707.19685.8095.camel@gandalf.stny.rr.com>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
	 <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
	 <1270081707.19685.8095.camel@gandalf.stny.rr.com>
Date: Wed, 31 Mar 2010 18:14:57 -0700
Message-ID: <p2t5df78e1d1003311814q1f270e41o4ebdc1f48659c034@mail.gmail.com>
Subject: Re: lockup in rb_get_reader_page
From: Jiaying Zhang <jiayingz@google.com>
To: rostedt@goodmis.org
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 5:28 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2010-03-30 at 21:01 -0700, Jiaying Zhang wrote:
>
>> I am going to patch rb_get_reader_page() to print out some debugging
>> message when it enters into an infinitely loop. I will keep you updated
>> if I find any interesting info.
>
> I was just thinking about this some more. One restriction to the
> ring_buffer is that a reader can not preempt a writer, which means that
> a read can not happen in an interrupt or NMI. If a read happens there
> and preempts a writer as the writer was moving the head page, it will go
> into an infinite loop waiting for the writer to finish its move.
>
> You can only do reads from interrupt context if the writer disables
> interrupts before reserving and committing the data.
>
> Are you doing reads from interrupt context?
>
No. We are using a user-space reader that reads ring buffer via syscall
or ioctl. But even though we don't read from interrupt context, as I
understand, we can still have a reader on another cpuB reads cpuA's
buffer when the writer on cpuA moves the head page. Will we have
any problem in that case?

Jiaying

> -- Steve
>
>
>
