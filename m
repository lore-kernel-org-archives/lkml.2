Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2A3BJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:09:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65151 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2A3BJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:09:38 -0500
X-AuditID: 9c930197-b7ba2ae000000eab-8f-4f25edcea457
Message-ID: <4F25EDCC.3010800@gmail.com>
Date: Mon, 30 Jan 2012 10:09:32 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf record: Add error message for EMFILE
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com> <1327827356-8786-2-git-send-email-namhyung@gmail.com> <4F256587.3090504@gmail.com>
In-Reply-To: <4F256587.3090504@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-01-30 12:28 AM, David Ahern wrote:
> On 01/29/2012 01:55 AM, Namhyung Kim wrote:
>> When a user tries to open so many events, perf_event_oen syscall
>> may fail with EMFILE. Provide an advice for that case.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>   tools/perf/builtin-record.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 32870eef952f..5d3b6794d93b 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -249,6 +249,10 @@ try_again:
>>   				ui__warning("The %s event is not supported.\n",
>>   					    event_name(pos));
>>   				exit(EXIT_FAILURE);
>> +			} else if (err == EMFILE) {
>> +				ui__warning("Too many events are opened.\n"
>> +					    "Try again after reducing the number of events.\n");
>> +				exit(EXIT_FAILURE);
>>   			}
>>
>>   			printf("\n");
>
> It's not just the number of events: an fd is opened for each specified
> event on each specified cpu and for each specified task. See
> __perf_evsel__open(). e.g., the new --uid option on a 16 cpu server can
> hit the limit pretty fast.
>
> David

Right. How about this then? If it looks OK to you, I'll resend the patch 
for record, top, stat:

	Too many events are opened.
	Try again after reducing the number of events,
	tasks and/or cpus.


Thanks,
Namhyung
