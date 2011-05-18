Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab1ERBI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:08:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59674 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1ERBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:08:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD31C20.8050608@jp.fujitsu.com>
Date: Wed, 18 May 2011 10:08:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com
Subject: Re: [PATCH 3/3] vmscan: implement swap token priority decay
References: <4DCD1824.1060801@jp.fujitsu.com>	<4DCD1913.2090200@jp.fujitsu.com> <20110516172258.c7dcd982.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110516172258.c7dcd982.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/mm/thrash.c b/mm/thrash.c
>> index 14c6c9f..0c4f0a8 100644
>> --- a/mm/thrash.c
>> +++ b/mm/thrash.c
>> @@ -47,6 +47,9 @@ void grab_swap_token(struct mm_struct *mm)
>>   	if (!swap_token_mm)
>>   		goto replace_token;
>>
>> +	if (!(global_faults&  0xff))
>> +		mm->token_priority /= 2;
>> +
>
> I personally don't like this kind of checking counter with mask.
> Hmm. How about this ?
>
> ==
> 	#define TOKEN_AGE_MASK	~(0xff)
> 	/*
> 	 * If current global_fault is in different age from previous global_fault,
> 	 * Aging priority and starts new era.
> 	 */
> 	if ((mm->faultstamp&  TOKEN_AGE_MASK) != (global_faults&  MM_TOKEN_MASK))
> 		mm->token_priority /= 2;
> ==

OK. will do.


