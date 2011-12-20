Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1LTSTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:19:23 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40335 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1LTSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:19:18 -0500
Message-ID: <4EF0D1A3.7010700@gmail.com>
Date: Tue, 20 Dec 2011 13:19:15 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Caspar Zhang <caspar@casparzhang.com>
Subject: Re: [PATCH] mempolicy: refix mbind_range() vma issue
References: <1323449709-25923-1-git-send-email-kosaki.motohiro@gmail.com> <20111212112000.GB18789@cmpxchg.org>
In-Reply-To: <20111212112000.GB18789@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +		pgoff = vma->vm_pgoff + ((vmstart - vma->vm_start)>>  PAGE_SHIFT);
>>   		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
>> -				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
>> +				  vma->anon_vma, vma->vm_file, pgoff,
>>   				  new_pol);
>>   		if (prev) {
>>   			vma = prev;
>
> This is essentially a revert of the aforementioned commit.
>
> What you added instead is the fixing of @prev: only when mbind is
> vma-aligned can the new area be potentially merged into the preceding
> one.  Otherwise that original vma is the one we need to check for
> compatibility with the mbind range and leave the original prev alone:
>
> 	[prev         ][vma            ]
> 	                    |start
>
> 	[prev         ][vma][mbind vma ]
>
> This should NOT attempt to merge mbind vma with prev (and forget about
> and leak vma, iirc), but check if vma and the mbind vma are compatible
> or should be separate areas.
>
> Could you please add something to that extent to the changelog?

When making new test case, I've found one bug in my patch. So, I've
sent new patch w/ detailed bug explanaion. :)

Thanks.


