Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2FZIKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:10:00 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40538 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab2FZIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:09:55 -0400
Message-ID: <4FE96DAF.3050208@parallels.com>
Date: Tue, 26 Jun 2012 12:07:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: RFC:  Easy-Reclaimable LRU list
References: <4FE012CD.6010605@kernel.org> <4FE82555.2010704@parallels.com> <4FE8FE70.6050107@kernel.org>
In-Reply-To: <4FE8FE70.6050107@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.9.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 04:12 AM, Minchan Kim wrote:
> On 06/25/2012 05:46 PM, Glauber Costa wrote:
>
>> On 06/19/2012 09:49 AM, Minchan Kim wrote:
>>> Hi everybody!
>>>
>>> Recently, there are some efforts to handle system memory pressure.
>>>
>>> 1) low memory notification - [1]
>>> 2) fallocate(VOLATILE) - [2]
>>> 3) fadvise(NOREUSE) - [3]
>>>
>>> For them, I would like to add new LRU list, aka "Ereclaimable" which
>>> is opposite of "unevictable".
>>> Reclaimable LRU list includes_easy_  reclaimable pages.
>>> For example, easy reclaimable pages are following as.
>>>
>>> 1. invalidated but remained LRU list.
>>> 2. pageout pages for reclaim(PG_reclaim pages)
>>> 3. fadvise(NOREUSE)
>>> 4. fallocate(VOLATILE)
>>>
>>> Their pages shouldn't stir normal LRU list and compaction might not
>>> migrate them, even.
>> What about other things moving memory like CMA ?
>
>
> Sorry for not being able to understand your point.
> Can you elaborate a bit more?
>

Well, maybe I didn't =)
I was just wondering why exactly it is that troubles your scheme with 
compaction, and if such restriction would also apply to memory movement
schemes like CMA.


