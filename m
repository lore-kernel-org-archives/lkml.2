Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1ECXhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:37:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1ECXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LJUv8QiclG+/Shodg9PorV2f7IZ+JYhM4Z6yl++SezPjD1bqQIXkZta/elDnB8I+zG
         BrZIIgZZ6IZ89CVo0XrA==
MIME-Version: 1.0
In-Reply-To: <1304462852.25414.2417.camel@gandalf.stny.rr.com>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
 <20110503214142.GC2678@nowhere> <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
 <20110503220948.GE2678@nowhere> <1304462852.25414.2417.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 3 May 2011 16:36:56 -0700
Message-ID: <BANLkTinorSVh+HGXFk3WAR7==ceAosjnOQ@mail.gmail.com>
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the event
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 3:47 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-05-04 at 00:09 +0200, Frederic Weisbecker wrote:
>
>> I wonder if we should have a lite version of wake_up() that checks
>> if the list of waiters is empty before locking the queue.
>> After all we don't care much about tight races for tracing.
>
> Since tracing is a special case here, we probably could get away to just
> do it ourselves. That is, have our own flag that determines if we should
> wakeup or not.

I had another question looking at the implementation of
ftrace_raw_event_##call in include/trace/ftrace.h.

All the raw trace events are traced through this function and it does not
call wakeup() on the trace_wait waitqueue. How do the current implementations
of readers handle tracing anything other than syscalls? Since wakeup() will
never get called, do the readers never poll on the waitqueue?

I understand from the logs that due to hard lockups while tracing sched
events, this new API was added. But does this mean that the tracing waitqueues
functionality is not being used by the readers?


>
> -- Steve
>
>
>

Vaibhav Nagarnaik
