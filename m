Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0KDIwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:52:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62259 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0KDIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=YuHrndrGxpsUKVcl4qHvxi4gezJh6J0BV2ZFhV10+cTvLqdvQ80Xel5SWfW3j5aYyr
         HtOqCQLFElvMYLu95KR/4qoGcqZT90Of5V7WmLHh+9xbcVdNmWRJFdc/kp+QzFWPnrpt
         3b2N7Q81t0cxtRpeBWTMdku7a0t5mmi0lkXtE=
From: Francis Moreau <francis.moro@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.yHA7Aw03llqLWxPVYRnHvK5/dT8@ifi.uio.no>
	<fa.13KEqWk+Dk+jLLdFlAoZtQ2Vjuw@ifi.uio.no>
Date: Thu, 04 Nov 2010 09:52:09 +0100
In-Reply-To: <fa.13KEqWk+Dk+jLLdFlAoZtQ2Vjuw@ifi.uio.no> (Frederic
	Weisbecker's message of "Wed, 03 Nov 2010 21:43:33 UTC")
Message-ID: <m2lj59sc7a.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Wed, Nov 03, 2010 at 08:28:59PM +0100, Francis Moreau wrote:
>> Hello,
>> 
>> I'm trying to use perf-tools and also to learn some internals about
>> them. So I prefer to ask all of them in one email.
>> 
>> The first one is about the list of pre-defined events given by
>> perf-list. I couldn't find any documentations that describes these
>> events so excuse me if the question is stupid.
>
>
>
> Sorry about that. We indeed need to improve a lot the documentation.
> May be this particular part could come with the future sysfs exposure
> of the events.
>

No problem, but yes this part should be documented somewhere. And I
think the syntax of event too, specially the modifier like 'u' or 'p'.

>> 
>> What's the difference between 'cpu-clock' and 'task-clock' event ?
>
>
> cpu-clock is based on the total time spent on the cpu. task-clock is
> based only on the time spent on the profiled task, so that doesn't count
> time spent on other tasks, it has a per thread granularity.

Ok, so 'cpu-clock' could have been named 'proc-clock' even though a task
is a processus on Linux.


[...]

>> The last question is about the source code annotation done by
>> perf-report. I'm using it to locate the place in my code that generates
>> the most data cache miss events. I can read this during a perf-report
>> session:
>> 
>>    [...]
>>     0.00 :           df215:       c3                      retq
>>     0.00 :           df216:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
>>     0.00 :           df21d:       00 00 00
>>    10.00 :           df220:       48 8b 75 00             mov    0x0(%rbp),%rsi
>>    80.00 :           df224:       48 89 df                mov    %rbx,%rdi
>>     0.00 :           df227:       41 ff d4                callq  *%r12
>>     0.00 :           df22a:       85 c0                   test   %eax,%eax
>>    [...]
>> 
>> If I read the output correctly, most of the dcache misses are coming from
>> 'mov %rbx, %rdi', and AFAIK this intruction can't generate any dcache
>> miss. What am I missing ?
>
>
> Perhaps you need pebs to get the very precise location on your event.
>
> perf stat -e cache-misses:up,l1d-loads-misses:up true
>
>
> I think the more you add 'p', the more precise it is.
> Like:
>
> 	perf stat -e cache-misses:uppp,l1d-loads-misses:uppp true
>
> Not sure how much it will accept though :)

Well it doesn't want one actually:

  $ perf stat -v -e cache-misses:up true
  Error: counter 0, sys_perf_event_open() syscall returned with -1 (No
  space left on device)
  No permission to collect stats.
  Consider tweaking /proc/sys/kernel/perf_event_paranoid.

Where can I find a description of PEB ?

Thanks
-- 
Francis
