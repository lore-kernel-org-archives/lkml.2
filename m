Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab0KQXWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:22:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54191 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0KQXWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wrbrn0nws+YR5lVQRAH8Rm/nBDDSKOO7FrswIA6qIfhWLUAXQoFNfFTNexCEMLM0hs
         HjQtjK2D4g4AKyXZqJmA==
MIME-Version: 1.0
In-Reply-To: <1290034589.4ce45d9d7be28@www.imp.polymtl.ca>
References: <1290029498.4ce449ba1679d@www.imp.polymtl.ca> <1290030106.30543.74.camel@gandalf.stny.rr.com>
 <1290034589.4ce45d9d7be28@www.imp.polymtl.ca>
From: David Sharp <dhsharp@google.com>
Date: Wed, 17 Nov 2010 15:22:15 -0800
Message-ID: <AANLkTim9f2aNAaF8YgbOH3xKY9pjAtkHOoYVTv+XOE8W@mail.gmail.com>
Subject: Re: Benchmarks of kernel tracing options 2 (ftrace, lttng and perf)
To: Douglas Santos <douglas.santos@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 2:56 PM, Douglas Santos
<douglas.santos@polymtl.ca> wrote:
> Quoting Steven Rostedt <rostedt@goodmis.org>:
>> On Wed, 2010-11-17 at 16:31 -0500, Douglas Santos wrote:
>> > Hi all,
>> >
>> > This is a response to a benchmark, submitted a few weeks ago, comparing
>> kernel
>> > tracing options.
>> > http://lkml.org/lkml/2010/10/28/422
>> >
>> > We followed the methodology described in the link bellow,
>> > but using the shellscripts posted there to reproduce autotest scripts.
>> > http://lkml.org/lkml/2010/10/28/261
>> >
>> > We disabled the extra syscall tracing on lttng, for a fair comparison.
>> > http://lkml.org/lkml/2010/10/28/290
>> >
>> > Average results with tracing "on":
>> >
>> > lttng:  220 ns
>> > ftrace: 260 ns
>>
>> Heh, so ftrace got worse with the new kernel?

Steve, can you explain how you're drawing that conclusion? Did Douglas
run this benchmark before on a previous kernel (I didn't see it if
so)?

- You can't directly compare to my results because of different hardware.
- The methodology for lttng is different (syscall tracing was removed).
- My results were also on 2.6.36

> The previous bench was doing tracing "on" minus "off"
> average results. They also used autotest scripts, not sure if
> it does exactly the same thing.

I think the subtraction is important, or it is at least important to
see what the "off" result is as a baseline of comparison. Otherwise, a
huge portion of the measurement is the cost of making the syscall
itself.

>
> I'll check if we missed something.
>
>
>
