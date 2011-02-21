Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1BUNEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:04:40 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39109 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab1BUNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:04:39 -0500
Date: Mon, 21 Feb 2011 14:04:31 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v2 1/2] memcg: remove unnecessary BUG_ON
Message-ID: <20110221130431.GF25382@cmpxchg.org>
References: <cover.1298214672.git.minchan.kim@gmail.com>
 <b691a7be970d6aafcd12ccc32ba812ce39fcf027.1298214672.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b691a7be970d6aafcd12ccc32ba812ce39fcf027.1298214672.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 12:17:17AM +0900, Minchan Kim wrote:
> Now memcg in unmap_and_move checks BUG_ON of charge.
> But mem_cgroup_prepare_migration returns either 0 or -ENOMEM.
> If it returns -ENOMEM, it jumps out unlock without the check.
> If it returns 0, it can pass BUG_ON. So it's meaningless.
> Let's remove it.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/migrate.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index eb083a6..2abc9c9 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -683,7 +683,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  		rc = -ENOMEM;
>  		goto unlock;
>  	}
> -	BUG_ON(charge);

You remove this assertion of the mem_cgroup_prepare_migration() return
value but only add a comment about the expectations in the next patch.

Could you write a full-blown kerneldoc on mem_cgroup_prepare_migration
and remove this BUG_ON() in the same patch?
