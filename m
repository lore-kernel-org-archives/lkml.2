Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1LTAf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:35:27 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1LTAfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111219153738.GC1415@cmpxchg.org>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
	<20111214165124.4d2cf723.kamezawa.hiroyu@jp.fujitsu.com>
	<20111219153738.GC1415@cmpxchg.org>
Date: Tue, 20 Dec 2011 09:35:24 +0900
Message-ID: <CABEgKgoJpv5YAvRQ82QL7RrrznGLFr-CD6=DWhw=VL5uWohxeA@mail.gmail.com>
Subject: Re: [PATCH 3/4] memcg: clear pc->mem_cgorup if necessary.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/20 Johannes Weiner <hannes@cmpxchg.org>:
> On Wed, Dec 14, 2011 at 04:51:24PM +0900, KAMEZAWA Hiroyuki wrote:
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> This is a preparation before removing a flag PCG_ACCT_LRU in page_cgroup
>> and reducing atomic ops/complexity in memcg LRU handling.
>>
>> In some cases, pages are added to lru before charge to memcg and pages
>> are not classfied to memory cgroup at lru addtion. Now, the lru where
>> the page should be added is determined a bit in page_cgroup->flags and
>> pc->mem_cgroup. I'd like to remove the check of flag.
>>
>> To handle the case pc->mem_cgroup may contain stale pointers if pages are
>> added to LRU before classification. This patch resets pc->mem_cgroup to
>> root_mem_cgroup before lru additions.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> The followup compilation fixes aside, I agree.  But the sites where
> the owner is actually reset are really not too obvious.  How about the
> comment patch below?
>
> Otherwise,
>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: memcg: clear pc->mem_cgorup if necessary fix
>
> Add comments to the clearing sites.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Ah, yes. This seems better. Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
