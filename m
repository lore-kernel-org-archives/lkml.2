Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1DHQkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:40:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40384 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012Ab1DHQkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:40:13 -0400
Date: Fri, 8 Apr 2011 09:39:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Patch v2] rcu: update the CONFIG logic in
 include/linux/pagemap.h
Message-ID: <20110408163904.GD2277@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1302071569-23217-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302071569-23217-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 02:32:48PM +0800, Amerigo Wang wrote:
> TREE_RCU depends on !PREEMPT && SMP, when !CONFIG_SMP is true, CONFIG_TREE_RCU
> will be false, thus "!defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)"
> is always false.
> 
> Paul suggested to update the logic to
> !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU).

Hello, Amerigo,

Thank you for keeping on top of this one!

But how does this patch handle the #else clauses?

							Thanx, Paul

> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
>  include/linux/pagemap.h |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index c119506..a296d7c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -133,10 +133,9 @@ static inline int page_cache_get_speculative(struct page *page)
>  {
>  	VM_BUG_ON(in_interrupt());
> 
> -#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
> -# ifdef CONFIG_PREEMPT
> +#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU)
> +	/* Must have CONFIG_PREEMPT here, implied by CONFIG_TREE_PREEMPT_RCU. */
>  	VM_BUG_ON(!in_atomic());
> -# endif
>  	/*
>  	 * Preempt must be disabled here - we rely on rcu_read_lock doing
>  	 * this for us.
> @@ -171,10 +170,8 @@ static inline int page_cache_add_speculative(struct page *page, int count)
>  {
>  	VM_BUG_ON(in_interrupt());
> 
> -#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
> -# ifdef CONFIG_PREEMPT
> +#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU)
>  	VM_BUG_ON(!in_atomic());
> -# endif
>  	VM_BUG_ON(page_count(page) == 0);
>  	atomic_add(count, &page->_count);
> 
