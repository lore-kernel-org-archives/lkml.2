Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab2BVDn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:43:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2BVDnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:43:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.131.13 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F446458.8000107@openvz.org>
Date: Wed, 22 Feb 2012 07:43:20 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] mm/memcg: move lru_lock into lruvec
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils> <alpine.LSU.2.00.1202201537040.23274@eggly.anvils> <4F434300.3080001@openvz.org> <alpine.LSU.2.00.1202211205280.1858@eggly.anvils> <4F440E1D.7050004@openvz.org> <alpine.LSU.2.00.1202211406030.2012@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202211406030.2012@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 22 Feb 2012, Konstantin Khlebnikov wrote:
>> Hugh Dickins wrote:
>>>
>>> I'll have to come back to think about your locking later too;
>>> or maybe that's exactly where I need to look, when investigating
>>> the mm_inline.h:41 BUG.
>>
>> pages_count[] updates looks correct.
>> This really may be bug in locking, and this VM_BUG_ON catch it before
>> list-debug.
>
> I've still not got into looking at it yet.
>
> You're right to mention DEBUG_LIST: I have that on some of the machines,
> and I would expect that to be the first to catch a mislocking issue.
>
> In the past my problems with that BUG (well, the spur to introduce it)
> came from hugepages.

My patchset hasn't your mem_cgroup_reset_uncharged_to_root protection,
or something to replace it. So, there exist race between cgroup remove and
isolated uncharged page put-back, but it shouldn't corrupt lru lists.
There something different.

>
>>>
>>> But at first sight, I have to say I'm very suspicious: I've never found
>>> PageLRU a good enough test for whether we need such a lock, because of
>>> races with those pages on percpu lruvec about to be put on the lru.
>>>
>>> But maybe once I look closer, I'll find that's handled by your changes
>>> away from lruvec; though I'd have thought the same issue exists,
>>> independent of whether the pending pages are in vector or list.
>>
>> Are you talking about my per-cpu page-lists for lru-adding?
>
> Yes.
>
>> This is just an unnecessary patch, I don't know why I include it into v2 set.
>> It does not protect anything.
>
> Okay.
>
> Hugh

