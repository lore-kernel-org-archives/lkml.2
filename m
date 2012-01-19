Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2ASOno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:43:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2ASOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:43:43 -0500
Message-ID: <4F182BF3.7050809@redhat.com>
Date: Thu, 19 Jan 2012 09:42:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        penberg@kernel.org, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>
Subject: Re: [RFC 2/3] vmscan hook
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-3-git-send-email-minchan@kernel.org> <20120117173932.1c058ba4.kamezawa.hiroyu@jp.fujitsu.com> <20120117091356.GA29736@barrios-desktop.redhat.com> <20120117190512.047d3a03.kamezawa.hiroyu@jp.fujitsu.com> <20120117230801.GA903@barrios-desktop.redhat.com> <20120118091824.0bde46f7.kamezawa.hiroyu@jp.fujitsu.com> <4F16D46D.5080000@redhat.com> <20120119112528.eda78467.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120119112528.eda78467.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 09:25 PM, KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Jan 2012 09:17:17 -0500
> Rik van Riel<riel@redhat.com>  wrote:
>
>> On 01/17/2012 07:18 PM, KAMEZAWA Hiroyuki wrote:
>>> On Wed, 18 Jan 2012 08:08:01 +0900
>>> Minchan Kim<minchan@kernel.org>   wrote:
>>>
>>>>>>> 2. can't we measure page-in/page-out distance by recording something ?
>>>>>>
>>>>>> I can't understand your point. What's relation does it with swapout prevent?
>>>>>>
>>>>>
>>>>> If distance between pageout ->   pagein is short, it means thrashing.
>>>>> For example, recoding the timestamp when the page(mapping, index) was
>>>>> paged-out, and check it at page-in.
>>>>
>>>> Our goal is prevent swapout. When we found thrashing, it's too late.
>>>
>>> If you want to prevent swap-out, don't swapon any. That's all.
>>> Then, you can check the number of FILE_CACHE and have threshold.
>>
>> I think you are getting hung up on a word here.
>>
>> As I understand it, the goal is to push out the point where
>> we start doing heavier swap IO, allowing us to overcommit
>> memory more heavily before things start really slowing down.
>>
>
> Yes.
>
> Hmm, considering that the issue is slow down,
>
> time values as
>
> - 'cpu time used for memory reclaim'
> - 'latency of page allocation'
> - 'application execution speed' ?
>
> may be a better score to see rather than just seeing lru's stat.

I believe those all qualify as "too late".

We want to prevent things from becoming bad, for as long
as we (easily) can.

-- 
All rights reversed
