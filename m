Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0JDJe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:34:58 -0400
Received: from shutemov.name ([188.40.19.243]:37675 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0JDJe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:34:57 -0400
Date: Mon, 4 Oct 2010 12:34:56 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org Balbir Singh" <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH v2] memcg: fix thresholds with use_hierarchy == 1
Message-ID: <20101004093456.GA26979@shutemov.name>
References: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 01:16:32PM +0300, Kirill A. Shutsemov wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
> 
> We need to check parent's thresholds if parent has use_hierarchy == 1 to
> be sure that parent's threshold events will be triggered even if parent
> itself is not active (no MEM_CGROUP_EVENTS).
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3eed583..df40eaf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3587,9 +3587,13 @@ unlock:
>  
>  static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>  {
> -	__mem_cgroup_threshold(memcg, false);
> -	if (do_swap_account)
> -		__mem_cgroup_threshold(memcg, true);
> +	while (memcg) {
> +		__mem_cgroup_threshold(memcg, false);
> +		if (do_swap_account)
> +			__mem_cgroup_threshold(memcg, true);
> +
> +		memcg =  parent_mem_cgroup(memcg);

There is two spaces after '='. Andrew, could you fix it when you'll pick
it up? Or should I resend it?

Sorry for the inconvenience.

> +	}
>  }
>  
>  static int compare_thresholds(const void *a, const void *b)
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

-- 
 Kirill A. Shutemov
