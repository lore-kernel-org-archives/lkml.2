Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2I1HIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:08:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56133 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I1HH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <874nmivgqk.fsf@sejong.aot.lge.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	<87pq5awvgp.fsf@sejong.aot.lge.com>
	<20120927230138.GA10660@somewhere.redhat.com>
	<874nmivgqk.fsf@sejong.aot.lge.com>
Date: Fri, 28 Sep 2012 09:07:57 +0200
Message-ID: <CABPqkBQbaDdGwyOK-qcheqyTzrr505undnFae8BQGEx+r0hKyg@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 7:49 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Frederic,
>
> On Fri, 28 Sep 2012 01:01:48 +0200, Frederic Weisbecker wrote:
>> When Arun was working on this, I asked him to explore if it could make sense to reuse
>> the "-b, --branch-stack"  perf report option. Because after all, this feature is doing
>> about the same than "-b" except it's using callchains instead of full branch tracing.
>> But callchains are branches. Just a limited subset of all branches taken on excecution.
>> So you can probably reuse some interface and even ground code there.
>>
>> What do you think?
>
> Umm.. first of all, I'm not familiar with the branch stack thing.  It's
> intel-specific, right?
>
The kernel API is NOT specific to Intel. It is abstracted to be portable
across architecture. The implementation only exists on certain Intel
X86 processors.

> Also I don't understand what exactly you want here.  What kind of
> interface did you say?  Can you elaborate it bit more?
>
Not clear to me either.

> And AFAIK branch stack can collect much more branch information than
> just callstacks.  Can we differentiate which is which easily?  Is there
> any limitation on using it?  What if callstacks are not sync'ed with
> branch stacks - is it possible though?
>
First of all branch stack is not a branch tracing mechanism. This is a
branch sampling mechanism. Not all branches are captured. Only the
last N consecutive branches leading to a PMU interrupt are captured
in each sample.

Yes, the branch stack mechanism as it exists on Intel processors
can capture more then call branches. It is HW based and provides
a branch type filter. Filtering capability is exposed at the API level
in a generic fashion. The hw filter is based on opcodes. Call branches
all cover call, syscall instructions. As such, the branch stack mechanism
cannot be used to capture callstacks to shared libraries, simply because
there a a non call instruction in the trampoline. To obtain a better quality
callstack you have instead to sample return branches. So yes, callstacks
are not sync'ed with branch stack even if limited to call branches.



> But I think it'd be good if the branch stack can be changed to call
> stack in general.  Did you mean this?
>
That's not going to happen. The mechanism is much more generic than
that.

Quite frankly, I don't understand Frederic's motivation here. The mechanism
are not quite the same.
