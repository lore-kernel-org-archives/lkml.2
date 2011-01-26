Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1AZN32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:29:28 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1AZN30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kiWpfhe2oHMNU2tXaSV13sOnFamC56ZEh0XX3P06QXU4Ppw/EKSXf4NM0Acmkq4QFo
         tgzXbY/7BNOLbo2oNVyw==
MIME-Version: 1.0
In-Reply-To: <20110126120646.GA20064@elte.hu>
References: <201101062000.p06K0ESw011195@hera.kernel.org>
	<20110126113740.GA13911@elte.hu>
	<AANLkTintgqOkwo=WRH_9vGwGgXf0XrfU2e++daUOOG=i@mail.gmail.com>
	<20110126120646.GA20064@elte.hu>
Date: Wed, 26 Jan 2011 14:29:21 +0100
Message-ID: <AANLkTikjEGMV=ZwiUmFxmQaELG525ntd=Xi8_EXFT9J7@mail.gmail.com>
Subject: Re: perf, x86: Provide a PEBS capable cycle event
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 1:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Wed, Jan 26, 2011 at 12:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>> >
>> >> Gitweb:     http://git.kernel.org/linus/7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> >> Commit:     7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> >> Parent:     abe43400579d5de0078c2d3a760e6598e183f871
>> >> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> AuthorDate: Tue Dec 14 21:26:40 2010 +0100
>> >> Committer:  Ingo Molnar <mingo@elte.hu>
>> >> CommitDate: Thu Dec 16 11:36:44 2010 +0100
>> >>
>> >>     perf, x86: Provide a PEBS capable cycle event
>> >>
>> >>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >>     LKML-Reference: <new-submission>
>> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> >> ---
>> >>  arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
>> >>  1 files changed, 26 insertions(+), 0 deletions(-)
>> >
>> > btw., precise profiling via PEBS:
>> >
>> >  perf record -e cycles:p ...
>> >
>> > works pretty nicely now on Nehalem CPUs and later.
>> >
>> The problem is that cycles:p is not equivalent to cycles in terms of how
>> cycles are counted. cycles counts only unhalted cycles. cycles:p counts
>> ALL cycles, event when the CPU is in halted state.
>
> That's not really an issue in practice: it at most can cause a bit larger value for:
>
>     2.38%       swapper  [kernel.kallsyms]      [k] mwait_idle_with_hints                             ▮
>
> Which entry exists with regular cycles event _anyway_, because every irq entry ends
> up there.
>

There is a difference in interpretation. Because now when you get
samples in those
idle routines, you cannot tell whether it is because you actually
execute code there
or because you were halted (not executing) and now sampling has
altered the behavior
of the system in that you wake up from halted state to service a PMU interrupt.

> So the difference is that this entry is now more accurate and correctly displays the
> amount of time spent in idle.
>
> Is there any reason why we should not regard this as good thing, as a feature in
> essence?
>
> Thanks,
>
>        Ingo
>
