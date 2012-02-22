Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2BVPj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:39:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36884 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2BVPjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:39:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.197.231 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F450C45.9070405@gmail.com>
Date: Wed, 22 Feb 2012 08:39:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: Fix ordering with unstable tsc
References: <20120206132546.GA30854@quad> <1329583837-7469-1-git-send-email-fweisbec@gmail.com> <CABPqkBRDLrK=GvXWTZob_EQ2dqnWJg5GeWMYFj0N5t8z265Y9Q@mail.gmail.com>
In-Reply-To: <CABPqkBRDLrK=GvXWTZob_EQ2dqnWJg5GeWMYFj0N5t8z265Y9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/12 8:35 AM, Stephane Eranian wrote:
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index 302d49a..1c8eb4b 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -119,9 +119,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
>>         if (opts->raw_samples) {
>>                 attr->sample_type       |= PERF_SAMPLE_TIME;
>>                 attr->sample_type       |= PERF_SAMPLE_RAW;
>> -               attr->sample_type       |= PERF_SAMPLE_CPU;
>>         }
>>
> I don't get this bit here. You may want CPU information when capturing
> in raw + per-thread mode.

TIME is added to sample_type for raw samples and then CPU gets added below.

>
>
>> +       /* Need to know the CPU for tools that need to order events */
>> +       if (attr->sample_type&  PERF_SAMPLE_TIME)
>> +               attr->sample_type       |= PERF_SAMPLE_CPU;
>> +


David
