Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2CXRVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 13:21:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37082 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2CXRVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 13:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <4F6DEF86.7050303@gmail.com>
References: <1332598796-3586-1-git-send-email-jolsa@redhat.com>
	<4F6DEF86.7050303@gmail.com>
Date: Sat, 24 Mar 2012 18:21:05 +0100
Message-ID: <CABPqkBR+SOVzKjaP4oiapPbS2x+pheooVF=6qL15VVG=KuFYyw@mail.gmail.com>
Subject: Re: [PATCH] perf, tool: Fix the array pointer to follow event data properly
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, and I haven't heard back since then

On Sat, Mar 24, 2012 at 5:00 PM, David Ahern <dsahern@gmail.com> wrote:
> Stephane submitted a similar patch a week ago:
> https://lkml.org/lkml/2012/3/17/91
>
> David
>
>
> On 3/24/12 8:19 AM, Jiri Olsa wrote:
>>
>> Currently we dont update the 'array' pointer properly after
>> processing the RAW data. This way perf might report wrong data
>> for branch stack if it is used along with tracepoint sample.
>>
>> I'm not sure tracepoint could be connected with branch stack,
>> but I think the array pointer should have correct value after
>> each sample processing.
>>
>> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
>> ---
>>  tools/perf/util/evsel.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index d9da62a..56a96896 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -580,6 +580,7 @@ int perf_event__parse_sample(const union perf_event
>> *event, u64 type,
>>                        return -EFAULT;
>>
>>                data->raw_data = (void *) pdata;
>> +               array = (u64 *)(((char *)array) + data->raw_size +
>> sizeof(u32));
>>        }
>>
>>        if (type&  PERF_SAMPLE_BRANCH_STACK) {
>
>
