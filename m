Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3ABRHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:07:11 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:56272 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3ABRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130102140405.GA931@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<1356018108-6081-2-git-send-email-eranian@google.com>
	<20130102140405.GA931@krava.brq.redhat.com>
Date: Wed, 2 Jan 2013 18:07:07 +0100
Message-ID: <CABPqkBQvUNvpgsqnxGAfgOHr3pdEfTW+C6iEJQFkZ7MjLCD-1g@mail.gmail.com>
Subject: Re: [PATCH v4 01/18] perf, x86: Support CPU specific sysfs events
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 3:04 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 04:41:31PM +0100, Stephane Eranian wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Add a way for the CPU initialization code to register additional events,
>> and merge them into the events attribute directory. Used in the next
>> patch.
>>
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++++++++++++
>>  arch/x86/kernel/cpu/perf_event.h |    1 +
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 4428fd1..83f4c1a 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -1341,6 +1341,30 @@ static void __init filter_events(struct attribute **attrs)
>>       }
>>  }
>>
>> +/* Merge two pointer arrays */
>> +static __init struct attribute **merge_attr(struct attribute **a,
>> +                                         struct attribute **b)
>> +{
>> +     struct attribute **new;
>> +     int j, i;
>> +
>> +     for (j = 0; a[j]; j++)
>> +             ;
>> +     for (i = 0; b[i]; i++)
>> +             j++;
>> +     j++;
>> +     new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
>> +     if (!new)
>> +             return a;
>
> not likely to happen, but still.. do we want proper error handling?
>
Ok, will fix the error path from Andi's patch.
Thanks.

> other than that the patch looks ok to me
>
> jirka
