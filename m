Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2GXOVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:21:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57403 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2GXOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:21:50 -0400
Message-ID: <500EAF23.8060909@gmail.com>
Date: Tue, 24 Jul 2012 08:20:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <robert.richter@amd.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120723181358.GC6717@infradead.org>
In-Reply-To: <20120723181358.GC6717@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/12 12:13 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 20, 2012 at 05:25:53PM -0600, David Ahern escreveu:
>> PEBS cannot be used with guest mode. If user adds :p modifier set
>> exclude_guest as well.
>
> Is this something Intel specific? Or can someone think of an arch where
> this limitation wouldn't exist?

Good point. So far precise_ip is used by arch/x86 only. I don't have an 
AMD based server so I don't know if there is a conflict between 
virtualization and IBS. Added Robert for advice.

David

>
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Link: https://lkml.org/lkml/2012/7/9/264
>> ---
>>   tools/perf/util/parse-events.c |    3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index 1aa721d..f34629b 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -653,6 +653,9 @@ int parse_events_modifier(struct list_head *list, char *str)
>>   			eH = 0;
>>   		} else if (*str == 'p') {
>>   			precise++;
>> +			/* use of precise requires exclude_guest */
>> +			if (!exclude_GH)
>> +				eG = 1;
>>   		} else
>>   			break;
>>
>> --
>> 1.7.10.1

