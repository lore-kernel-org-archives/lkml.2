Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab1EETqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 15:46:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab1EETqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 15:46:00 -0400
Date: Thu, 5 May 2011 12:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] cpumask: alloc_cpumask_var() use NUMA_NO_NODE
Message-Id: <20110505124556.3c8a7e5b.akpm@linux-foundation.org>
In-Reply-To: <20110428231856.3D54.A69D9226@jp.fujitsu.com>
References: <20110428231856.3D54.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 23:17:15 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> NUMA_NO_NODE and numa_node_id() are different meanings. NUMA_NO_NODE 
> is obviously recomended fallback.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  lib/cpumask.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/cpumask.c b/lib/cpumask.c
> index 4f6425d..af3e581 100644
> --- a/lib/cpumask.c
> +++ b/lib/cpumask.c
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL(zalloc_cpumask_var_node);
>   */
>  bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
>  {
> -	return alloc_cpumask_var_node(mask, flags, numa_node_id());
> +	return alloc_cpumask_var_node(mask, flags, NUMA_NO_NODE);
>  }
>  EXPORT_SYMBOL(alloc_cpumask_var);
>  

So effectively this will replace numa_node_id() with numa_mem_id(),
yes?  What runtime effects might this have?  
