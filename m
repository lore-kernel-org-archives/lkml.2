Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0CRSQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:16:41 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:57170 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0CRSQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=NUpMqHSSD6lLihRTYYurGy3bNBDsBvuI4GaFkGwnUbr1HMxXnHERkapwlJB1WdBK3k
         gYWRz//ti5JFi7Y9cnGaPeezXy7NNQ1S6PcHLRWPmbzb2DTllo0xbIXERjG70mOL8MSM
         VZqKd/cs/okm0qlkMfURlV+rc1Bw3p5R5l5I4=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20100318173615.GA2456@elte.hu>
References: <4ba0e3c7.1c185e0a.7786.ffffb1d9@mx.google.com>
	 <20100318173615.GA2456@elte.hu>
Date: Thu, 18 Mar 2010 19:16:37 +0100
Message-ID: <7c86c4471003181116i6ea31333tecf79eb487fcad7b@mail.gmail.com>
Subject: Re: [PATCH] perf: fix stat attach bogus counts
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 6:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>>       When perf stat -p pid is used, the events must be enabled
>>       immediately as there is no exec and thus no enable_on_exec.
>>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> --
>>  builtin-stat.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>> index 95db31c..3a91fad 100644
>> --- a/tools/perf/builtin-stat.c
>> +++ b/tools/perf/builtin-stat.c
>> @@ -159,8 +159,10 @@ static void create_perf_stat_counter(int counter, int pid)
>>               }
>>       } else {
>>               attr->inherit        = inherit;
>> -             attr->disabled       = 1;
>> -             attr->enable_on_exec = 1;
>> +             if (target_pid == -1) {
>> +                     attr->disabled       = 1;
>> +                     attr->enable_on_exec = 1;
>> +             }
>
> Mind checking latest -tip, which has these commits:
>
> d6d901c: perf events: Change perf parameter --pid to process-wide collection instead of thread-wid
> 46be604: perf record: Enable counters only when kernel is execing subcommand
> 6be2850: perf stat: Enable counters when collecting process-wide or system-wide data
>
> as they fix/improve various --pid related behavioral aspects of perf. Does it
> work fine for you now?
>
They indeed included the same fix.
So that's fine now.
