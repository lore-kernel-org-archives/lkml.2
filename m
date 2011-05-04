Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1EDAPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 20:15:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1EDAPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 20:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MLQCkxAWkzgcXUIKdZ26qhLKyJuPL7ApLhbFyf3ChR1zIrya6fZI2Z4V9/n5InxIsZ
         SVJ+ag6xKOs2hKKaLa/A==
MIME-Version: 1.0
In-Reply-To: <20110503233503.GH2678@nowhere>
References: <1304456616-30281-1-git-send-email-vnagarnaik@google.com>
 <20110503214142.GC2678@nowhere> <BANLkTinA8M8Ok2jghtCoeBiTfw6n3NSziA@mail.gmail.com>
 <20110503220948.GE2678@nowhere> <1304462852.25414.2417.camel@gandalf.stny.rr.com>
 <20110503230812.GF2678@nowhere> <BANLkTikRxY_NiNG+z+t_BDwDAom_rpNmdg@mail.gmail.com>
 <20110503233503.GH2678@nowhere>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 3 May 2011 17:14:43 -0700
Message-ID: <BANLkTi=NMp-bPGLgTP9OJnROasx3Q9Rqgw@mail.gmail.com>
Subject: Re: [RFC PATCH] tracing: Don't call wakeup() when committing the event
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 4:35 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, May 03, 2011 at 04:27:22PM -0700, Vaibhav Nagarnaik wrote:
>> How about this? Check if the waitqueue is active and if true, operate on the
>> trace_wait queue.
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 06f4458..e03ee24 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -353,7 +353,7 @@ void trace_wake_up(void)
>>  {
>>       int cpu;
>>
>> -     if (trace_flags & TRACE_ITER_BLOCK)
>> +     if (trace_flags & TRACE_ITER_BLOCK || !waitqueue_active(&trace_wait))
>>               return;
>>       /*
>>        * The runqueue_is_locked() can fail, but this is the best we
>>
>
> Hehe, seems it should work :)
>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
>
Thanks for reviewing the change. I have sent an updated patch with a better
commit message and your Ack.

Vaibhav Nagarnaik
