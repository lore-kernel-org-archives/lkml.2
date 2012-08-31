Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2HaSz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:55:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36865 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab2HaSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:55:25 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:55:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 15/15] kmemleak: Replace
 list_for_each_continue_rcu with new interface
Message-ID: <20120831185516.GO4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-15-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-15-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:28AM -0700, Paul E. McKenney wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> This patch replaces list_for_each_continue_rcu() with
> list_for_each_entry_continue_rcu() to save a few lines
> of code and allow removing list_for_each_continue_rcu().
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
> 1.7.8
> 
