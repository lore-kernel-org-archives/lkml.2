Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1KGVyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:54:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41741 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KGVym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:54:42 -0500
Date: Mon, 7 Nov 2011 13:54:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] oom: do not kill tasks with oom_score_adj
 OOM_SCORE_ADJ_MIN
In-Reply-To: <20111104143145.0F93B8B45E@mx2.suse.de>
Message-ID: <alpine.DEB.2.00.1111071353140.27419@chino.kir.corp.google.com>
References: <20111104143145.0F93B8B45E@mx2.suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Nov 2011, Michal Hocko wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index e916168..4883514 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -185,6 +185,9 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  	if (!p)
>  		return 0;
>  
> +	if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> +		return 0;
> +
>  	/*
>  	 * The memory controller may have a limit of 0 bytes, so avoid a divide
>  	 * by zero, if necessary.

This leaves p locked, you need to do task_unlock(p) first.

Once that's fixed, please add my

	Acked-by: David Rientjes <rientjes@google.com>

and resubmit to Andrew for the 3.2 rc series.  Thanks!
