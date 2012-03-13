Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab2CMBgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:36:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42604 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272Ab2CMBgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:36:35 -0400
X-AuditID: 9c930197-b7cacae00000461f-75-4f5ea4a13c16
Message-ID: <4F5EA49F.7020706@lge.com>
Date: Tue, 13 Mar 2012 10:36:31 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.perf.user,gmane.linux.kernel
To: Arun Sharma <asharma@fb.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com> <4F5E3E8C.1020005@fb.com> <4F5E554C.4060209@fb.com>
In-Reply-To: <4F5E554C.4060209@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-13 4:58 AM, Arun Sharma wrote:
> On 3/12/12 11:21 AM, Arun Sharma wrote:
>>> BTW, I don't like the name 'inclusive' as a sort key. If it cares about
>>> time, IMHO, the name should contain 'time' - something like 'itime' or
>>> 'inctime'?
>>
>> The existing sort orders: pid, comm, dso, symbol, parent -- all care
>> about time, but none of them have time in their name?
>
> I'll take that back. What they sort on depends on the event.
>
> perf record -ge cache-misses
> perf report -s inclusive
>
> will sort by the number of cache-misses and not time.
>
> -Arun

AFAIK, "sort" here means how perf identifies a sample event from others: 
"comm" will collect samples have same pid/comm, then "dso" will group samples 
belong to same library, and "symbol" will group again samples have same symbol 
name. This is what default sort order (comm,dso,symbol) does.

In case of "inclusive" it does same thing with "symbol" as you use sort_sym 
for the inclusive sort_dimension. Sorting by period for output is done at 
final stage and it won't be affected by any sort orders. It maybe sound 
confusing but that's how it works.

Thanks,
Namhyung
