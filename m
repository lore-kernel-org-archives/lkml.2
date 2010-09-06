Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0IFAs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:48:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35235 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0IFAsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:48:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 14/14] mm: oom_kill: use IS_ERR() instead of strict checking
Cc: kosaki.motohiro@jp.fujitsu.com, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1283711592-7669-1-git-send-email-segooon@gmail.com>
References: <1283711592-7669-1-git-send-email-segooon@gmail.com>
Message-Id: <20100906094555.C8BB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  6 Sep 2010 09:48:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> Use IS_ERR() instead of strict checking.

Umm...

I don't like this. IS_ERR() imply an argument is error code. but in
this case, we don't use error code. -1 mean oom special purpose meaning
value.

So, if we take this direction, It would be better to use EAGAIN or something
instead -1.



> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  mm/oom_kill.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index fc81cb2..2ee3350 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -514,7 +514,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
>  	read_lock(&tasklist_lock);
>  retry:
>  	p = select_bad_process(&points, limit, mem, NULL);
> -	if (!p || PTR_ERR(p) == -1UL)
> +	if (IS_ERR_OR_NULL(p))
>  		goto out;
>  
>  	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem, NULL,
> @@ -691,7 +691,7 @@ retry:
>  	p = select_bad_process(&points, totalpages, NULL,
>  			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
>  								 NULL);
> -	if (PTR_ERR(p) == -1UL)
> +	if (IS_ERR(p))
>  		goto out;
>  
>  	/* Found nothing?!?! Either we hang forever, or we panic. */
> -- 
> 1.7.0.4
> 



