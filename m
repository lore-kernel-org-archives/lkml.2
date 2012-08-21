Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2HUACn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:02:43 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46796 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2HUACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:02:40 -0400
Date: Mon, 20 Aug 2012 17:02:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        catalin.marinas@arm.com
Subject: Re: [PATCH 2/3] kmemleak: replace list_for_each_continue_rcu with
 new interface
Message-ID: <20120821000230.GO2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <502CB92F.2010700@linux.vnet.ibm.com>
 <502DC99E.4060408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502DC99E.4060408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082100-7408-0000-0000-000007C67299
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 12:33:34PM +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> This patch replaces list_for_each_continue_rcu() with
> list_for_each_entry_continue_rcu() to save a few lines
> of code and allow removing list_for_each_continue_rcu().
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  mm/kmemleak.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 45eb621..0de83b4 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1483,13 +1483,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  {
>  	struct kmemleak_object *prev_obj = v;
>  	struct kmemleak_object *next_obj = NULL;
> -	struct list_head *n = &prev_obj->object_list;
> +	struct kmemleak_object *obj = prev_obj;
> 
>  	++(*pos);
> 
> -	list_for_each_continue_rcu(n, &object_list) {
> -		struct kmemleak_object *obj =
> -			list_entry(n, struct kmemleak_object, object_list);
> +	list_for_each_entry_continue_rcu(obj, &object_list, object_list) {
>  		if (get_object(obj)) {
>  			next_obj = obj;
>  			break;
> -- 
> 1.7.4.1
> 
> 

