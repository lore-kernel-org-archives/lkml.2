Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2LTWj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:39:26 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47233 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2LTWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:39:21 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.39.152
Date: Thu, 20 Dec 2012 14:39:12 -0800
From: Josh Triplett <josh@freedesktop.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcutorture: don't compare ptr with 0
Message-ID: <20121220223912.GA12614@leaf>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-20-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356030701-16284-20-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 02:11:28PM -0500, Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Fair enough.  You might as well change the first half of the conditional
too, though.  In any case:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutorture.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 31dea01..0249800 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1749,7 +1749,7 @@ static int rcu_torture_barrier_init(void)
>  	barrier_cbs_wq =
>  		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
>  			GFP_KERNEL);
> -	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
> +	if (barrier_cbs_tasks == NULL || !barrier_cbs_wq)
>  		return -ENOMEM;
>  	for (i = 0; i < n_barrier_cbs; i++) {
>  		init_waitqueue_head(&barrier_cbs_wq[i]);
> -- 
> 1.8.0
> 
