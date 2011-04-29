Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab1D2XQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:16:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab1D2XQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:16:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mbc7h7iXVXbiHafpgr6/ty2NkmbrbBtR/hIWZ4zrypvjMvGFN2cVK4RJ68jTHegqkk
         TrVosj2KOrSfsTpirViA==
MIME-Version: 1.0
In-Reply-To: <1304107275.18763.279.camel@gandalf.stny.rr.com>
References: <1303512373-25992-1-git-send-email-vnagarnaik@google.com>
 <1304033561.18763.212.camel@gandalf.stny.rr.com> <BANLkTimY9weoBhiQv+dfS4UzYPGBFDdPQQ@mail.gmail.com>
 <1304107275.18763.279.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Apr 2011 16:15:28 -0700
Message-ID: <BANLkTimBKM1QkjH97QHp0YNG0O-0gYOJtw@mail.gmail.com>
Subject: Re: [PATCH] trace: Add a free on close control mechanism for buffer_size_kb
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 1:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-04-29 at 12:45 -0700, Vaibhav Nagarnaik wrote:
>
>> > Why call it "atomic"? Because you do the mutex? Anyway I hate the name.
>> > It sounds like it can do it without preemption, which it clearly can't
>> > do.
>>
>> I just wanted to note that it was a locked operation. I have changed the name
>> to tracing_buffer_resize_locked.
>>
>> If you think it can be named better, I will change it.
>
> Actually, the normal convention that I noticed that is used around the
> kernel is the "normal" name is used when locking is applied. For
> functions that do the same thing but does not lock, add two underscores
> in front of the name:
>
>
> void __foo(void)
> {
>        do_foo();
> }
>
> void foo(void)
> {
>        mutex_lock(&foo_lock);
>        __foo();
>        mutex_unlock(&foo_lock);
> }
>
> But if this has no real equivalent, just remove that name altogether.
>
> Not to lock should be the exception, not locking.

Ok. It makes sense. I now use __tracing_resize_ring_buffer to call the
unlocked version and tracing_resize_ring_buffer as a wrapper around it with
mutex locking.

I am sending the patch in a moment.

>
> -- Steve
>
>
>

Thanks

Vaibhav Nagarnaik
