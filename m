Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2JCAyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:54:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43024 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JCAyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:54:40 -0400
Date: Wed, 3 Oct 2012 09:54:29 +0900
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO
 class
Message-ID: <20121003005429.GA15806@localhost>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 03:32:42PM -0400, Vivek Goyal wrote:
> Currently CFQ has three IO classes, RT, BE and IDLE. At many a places we
> are calling workloads belonging to these classes as "prio". This gets
> very confusing as one starts to associate it with ioprio.
> 
> So this patch just does bunch of renaming so that reading code becomes
> easier. All reference to RT, BE and IDLE workload are done using keyword
> "class" and all references to subclass, SYNC, SYNC-IDLE, ASYNC are made
> using keyword "type".
> 
> This makes me feel much better while I am reading the code. There is no
> functionality change due to this patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

> @@ -751,16 +751,16 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
>  	return SYNC_WORKLOAD;
>  }
>  
> -static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
> +static inline int cfq_group_busy_queues_wl(enum wl_class_t wl_class,
>  					struct cfq_data *cfqd,
>  					struct cfq_group *cfqg)
>  {
> -	if (wl == IDLE_WORKLOAD)
> +	if (wl_class == IDLE_WORKLOAD)
>  		return cfqg->service_tree_idle.count;
>  
> -	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
> -		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
> -		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
> +	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
> +		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
> +		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;

While at it, maybe move the operator to the end of the preceding line
like everybody else?

Thanks.

-- 
tejun
