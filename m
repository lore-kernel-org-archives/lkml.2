Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1DVJlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:41:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1DVJlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hTW9Zbrrb/R2HLDEfYOAdZiMMcdrSSeQ8baTd1yB0kheCklnBmP4qGiTQHwlZ+ntNp
         icYaTjzftNoO5rz/C17w==
MIME-Version: 1.0
In-Reply-To: <20110422092322.GA1948@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	<20110422092322.GA1948@elte.hu>
Date: Fri, 22 Apr 2011 11:41:03 +0200
Message-ID: <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for config1/config2
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 11:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Fri, Apr 22, 2011 at 10:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >> This needs to be a *lot* more user friendly. Users do not want to type in
>> >> stupid hexa magic numbers to get profiling. We have moved beyond the oprofile
>> >> era really.
>> >>
>> >> Unless there's proper generalized and human usable support i'm leaning
>> >> towards turning off the offcore user-space accessible raw bits for now, and
>> >> use them only kernel-internally, for the cache events.
>>
>> Generic cache events are a myth. They are not usable. I keep getting
>> questions from users because nobody knows what they are actually counting,
>> thus nobody knows how to interpret the counts. You cannot really hide the
>> micro-architecture if you want to make any sensible measurements.
>
> Well:
>
>  aldebaran:~> perf stat --repeat 10 -e instructions -e L1-dcache-loads -e L1-dcache-load-misses -e LLC-misses ./hackbench 10
>  Time: 0.125
>  Time: 0.136
>  Time: 0.180
>  Time: 0.103
>  Time: 0.097
>  Time: 0.125
>  Time: 0.104
>  Time: 0.125
>  Time: 0.114
>  Time: 0.158
>
>  Performance counter stats for './hackbench 10' (10 runs):
>
>     2,102,556,398 instructions             #      0.000 IPC     ( +-   1.179% )
>       843,957,634 L1-dcache-loads            ( +-   1.295% )
>       130,007,361 L1-dcache-load-misses      ( +-   3.281% )
>         6,328,938 LLC-misses                 ( +-   3.969% )
>
>        0.146160287  seconds time elapsed   ( +-   5.851% )
>
> It's certainly useful if you want to get ballpark figures about cache behavior
> of an app and want to do comparisons.
>
What can you conclude from the above counts?
Are they good or bad? If they are bad, how do you go about fixing the app?

> There are inconsistencies in our generic cache events - but that's not really a
> reason to obcure their usage behind nonsensical microarchitecture-specific
> details.
>
The actual events are a reflection of the micro-architecture. They indirectly
describe how it works. It is not clear to me that you can really improve your
app without some exposure to the micro-architecture.

So if you want to have generic events, I am fine with this, but you should not
block access to actual events pretending they are useless. Some people are
certainly interested in using them and learning about the micro-architecture
of their processor.


> But i'm definitely in favor of making these generalized events more consistent
> across different CPU types. Can you list examples of inconsistencies that we
> should resolve? (and which you possibly consider impossible to resolve, right?)
>
To make generic events more uniform across processors, one would have to have
precise definitions as to what they are supposed to count. Once you
have that, then
we may have a better chance at finding consistent mappings for each processor.
I have not yet seen such definitions.
