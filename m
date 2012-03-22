Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2CVPSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2CVPSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:18:48 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Date: Thu, 22 Mar 2012 11:17:20 -0400
Message-Id: <1332429440-7167-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <4F69A4C4.4080602@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 06:52:04PM +0900, KAMEZAWA Hiroyuki wrote:
> As discussed before, I post this to fix the spec and implementation of task moving.
> Then, do you think what target kernel version should be ? 3.4/3.5 ?
> but yes, it may be late for 3.4....
> 
> ==
> In documentation, it's said that 'shared anon are not moved'.
> But in implementation, the check was wrong.
> 
>   if (!move_anon() || page_mapcount(page) > 2)
> 
> Ah, memcg has been moving shared anon pages for a long time.
> 
> Then, here is a discussion about handling of shared anon pages.
> 
>  - It's complex
>  - Now, shared file caches are moved in force.
>  - It adds unclear check as page_mapcount(). To do correct check,
>    we should check swap users, etc.
>  - No one notice this implementation behavior. So, no one get benefit
>    from the design.
>  - In general, once task is moved to a cgroup for running, it will not
>    be moved....
>  - Finally, we have control knob as memory.move_charge_at_immigrate.
> 
> Here is a patch to allow moving shared pages, completely. This makes
> memcg simpler and fix current broken code.
> 
> Note:
>  IIUC, libcgroup's cgroup daemon moves tasks after exec().
>  So, it's not affected.
>  libcgroup's command "cgexec" does move itsef to a memcg and call exec()
>  without fork(). it's not affected.
> 
> Changelog:
>  - fixed PageAnon() check.
>  - remove call of lookup_swap_cache()
>  - fixed Documentation.
> 
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It looks good to me.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya
