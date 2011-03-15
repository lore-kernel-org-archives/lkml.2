Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1COIJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:09:00 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57979 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab1COII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:08:57 -0400
Message-ID: <4D7F1E63.2060907@dcl.info.waseda.ac.jp>
Date: Tue, 15 Mar 2011 17:08:03 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b10pre) Gecko/20110114 Thunderbird/3.3a2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf lock: fix sorting by wait_min
References: <20110222174715.GC9687@joi.lan> <20110314165458.GA2693@joi.lan> <20110314192303.GB9388@ghostprotocols.net>
In-Reply-To: <20110314192303.GB9388@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年03月15日 04:23, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 14, 2011 at 05:54:58PM +0100, Marcin Slusarz escreveu:
>> On Tue, Feb 22, 2011 at 06:47:15PM +0100, Marcin Slusarz wrote:
>>> if lock was uncontended, wait_time_min == ULLONG_MAX, so we need to handle
>>> this case differently to show high wait times first
>>>
>>> Signed-off-by: Marcin Slusarz<marcin.slusarz@gmail.com>
>>> ---
>>>   tools/perf/builtin-lock.c |   13 ++++++++++++-
>>>   1 files changed, 12 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
>>> index 0305a40..812ad26 100644
>>> --- a/tools/perf/builtin-lock.c
>>> +++ b/tools/perf/builtin-lock.c
>>> @@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
>>>   SINGLE_KEY(nr_acquired)
>>>   SINGLE_KEY(nr_contended)
>>>   SINGLE_KEY(wait_time_total)
>>> -SINGLE_KEY(wait_time_min)
>>>   SINGLE_KEY(wait_time_max)
>>>
>>> +static int lock_stat_key_wait_time_min(struct lock_stat *one,
>>> +					struct lock_stat *two)
>>> +{
>>> +	u64 s1 = one->wait_time_min;
>>> +	u64 s2 = two->wait_time_min;
>>> +	if (s1 == ULLONG_MAX)
>>> +		s1 = 0;
>>> +	if (s2 == ULLONG_MAX)
>>> +		s2 = 0;
>>> +	return s1>  s2;
>>> +}
>>> +
>>>   struct lock_key {
>>>   	/*
>>>   	 * name: the value for specify by user
>>> --
>>
>> Anything wrong with this patch?
>> I can't find it in linux-next.
>
> Hitoshi-san, can I have your acked-by for this one?
>
> Thanks,
>
> - Arnaldo
>

Hi Arnaldo and Marcin,

Sure, ignoring the case of wait_time_min == ULLONG_MAX is my mistake.
Thanks a lot!

