Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab2J2Ujc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:32 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60027 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2J2Uj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121029194203.GK2266@tassilo.jf.intel.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-5-git-send-email-eranian@google.com>
	<20121029194203.GK2266@tassilo.jf.intel.com>
Date: Mon, 29 Oct 2012 21:39:26 +0100
Message-ID: <CABPqkBQ3pdvhV=tYjmdaAFyZFvUsM0PkvVw385c1cLA9_Z3KoQ@mail.gmail.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 8:42 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> +
>> +struct attribute *nhm_events_attrs[] = {
>> +     EVENT_PTR(CPU_CYCLES),
>> +     EVENT_PTR(INSTRUCTIONS),
>> +     EVENT_PTR(CACHE_REFERENCES),
>> +     EVENT_PTR(CACHE_MISSES),
>> +     EVENT_PTR(BRANCH_INSTRUCTIONS),
>> +     EVENT_PTR(BRANCH_MISSES),
>> +     EVENT_PTR(BUS_CYCLES),
>> +     EVENT_PTR(STALLED_CYCLES_FRONTEND),
>> +     EVENT_PTR(STALLED_CYCLES_BACKEND),
>> +     EVENT_PTR(REF_CPU_CYCLES),
>> +     EVENT_PTR(mem_ld_nhm),
>> +     NULL,
>> +};
>
> I thought Jiri's patch already exports all the generic ones?
>
> Why do you need to replace the whole table?
>
Because I am extending them with one or two events based on cpu
model. That was the easiest way of doing this instead of playing
some kind of malloc+copy trick.

> BTW I still think my approach in the v4 Haswell patchkit
> is simpler and didn't rely on hardcoding these events.
>
I don't care about those events. As I found out, they are not even
used by perf because they are all hardcoded and that's what gets
used. I assume they are exposed for reference only. I don't object
to that. But I think the right mechanism would be one where you
can add events at boot time based on CPU model. It could be used
to add the common events as well in the common part of the init
code.
