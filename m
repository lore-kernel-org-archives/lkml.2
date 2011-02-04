Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1BDAHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:07:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37287 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1BDAHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:07:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 09:01:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] memcg: no uncharged pages reach
 page_cgroup_zoneinfo
Message-Id: <20110204090145.7f1918fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Feb 2011 15:26:02 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> All callsites check PCG_USED before passing pc->mem_cgroup, so the
> latter is never NULL.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I want BUG_ON() here.


> ---
>  mm/memcontrol.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e071d7e..85b4b5a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -370,9 +370,6 @@ page_cgroup_zoneinfo(struct page_cgroup *pc)
>  	int nid = page_cgroup_nid(pc);
>  	int zid = page_cgroup_zid(pc);
>  
> -	if (!mem)
> -		return NULL;
> -
>  	return mem_cgroup_zoneinfo(mem, nid, zid);
>  }
>  
> -- 
> 1.7.4
> 
> 

