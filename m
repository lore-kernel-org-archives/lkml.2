Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2GXOBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:01:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56697 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2GXOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:01:43 -0400
Message-ID: <500EAAC2.2020802@gmail.com>
Date: Tue, 24 Jul 2012 08:01:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 09/11] perf top: error handling for counter creation should
 parallel perf-record
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-10-git-send-email-dsahern@gmail.com> <20120723181521.GD6717@infradead.org>
In-Reply-To: <20120723181521.GD6717@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/12 12:15 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 20, 2012 at 05:25:54PM -0600, David Ahern escreveu:
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index e3cab5f..0ce665c 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -943,8 +943,10 @@ try_again:
>>   			 * based cpu-clock-tick sw counter, which
>>   			 * is always available even if no PMU support:
>>   			 */
>> -			if (attr->type == PERF_TYPE_HARDWARE &&
>> -			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
>> +			if ((err == ENOENT || err == ENXIO)
>> +				&& attr->type == PERF_TYPE_HARDWARE
>> +				&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
>> +
>
> usual style:
>
> 			if ((err == ENOENT || err == ENXIO) &&
> 			    attr->type == PERF_TYPE_HARDWARE &&
> 			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
>

Right. I literally made it the same as builtin-record.c. I'll resubmit.

David

