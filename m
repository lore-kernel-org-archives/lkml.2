Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2FKH3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:29:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60883 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007Ab2FKH3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:29:30 -0400
Message-ID: <4FD59E55.3030703@openvz.org>
Date: Mon, 11 Jun 2012 11:29:25 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120517 Firefox/10.0.4 Iceape/2.7.4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix use_hierarchy css_is_ancestor oops regression
References: <alpine.LSU.2.00.1206101150230.4239@eggly.anvils> <20120610221516.GJ1761@cmpxchg.org>
In-Reply-To: <20120610221516.GJ1761@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Sun, Jun 10, 2012 at 11:54:47AM -0700, Hugh Dickins wrote:
>> If use_hierarchy is set, reclaim testing soon oopses in css_is_ancestor()
>> called from __mem_cgroup_same_or_subtree() called from page_referenced():
>> when processes are exiting, it's easy for mm_match_cgroup() to pass along
>> a NULL memcg coming from a NULL mm->owner.
>>
>> Check for that in __mem_cgroup_same_or_subtree().  Return true or false?
>> False because we cannot know if it was in the hierarchy, but also false
>> because it's better not to count a reference from an exiting process.
>>
>> Signed-off-by: Hugh Dickins<hughd@google.com>
>
> Looks like an older version of the patch that introduced it slipped
> into the tree, Konstantin noted this problem during review.  The final
> version did
>
> 	match = memcg&&  __mem_cgroup_same_or_subtree(root, memcg);
>
> in the caller because of it.
>
> Do you think it would be cleaner this way, since this is also the
> place where that memcg is looked up, and so the "can return NULL"
> handling after mem_cgroup_from_task() would be in the same place?

I agree, it cleaner, but nevertheless:

Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Thanks, Hugh!

>
> But either way,
>
> Acked-by: Johannes Weiner<hannes@cmpxchg.org>
>
> Thanks, Hugh!
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

