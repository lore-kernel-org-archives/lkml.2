Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1FICEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:04:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1FICEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:04:24 -0400
Date: Thu, 9 Jun 2011 12:03:58 +1000
From: NeilBrown <neilb@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 19/28] md,rcu: Convert call_rcu(free_conf)
 to kfree_rcu()
Message-ID: <20110609120358.550fcc06@notabene.brown>
In-Reply-To: <1307561407-13809-19-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
	<1307561407-13809-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Jun 2011 12:29:58 -0700 "Paul E. McKenney"
<paulmck@linux.vnet.ibm.com> wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The rcu callback free_conf() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(free_conf).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Neil Brown <neilb@suse.de>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: NeilBrown <neilb@suse.de>

Please submit this yourself - I won't be touching that area of code at all.

Thanks,
NeilBrown


> ---
>  drivers/md/linear.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index abfb59a..6cd2c31 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -213,12 +213,6 @@ static int linear_run (mddev_t *mddev)
>  	return md_integrity_register(mddev);
>  }
>  
> -static void free_conf(struct rcu_head *head)
> -{
> -	linear_conf_t *conf = container_of(head, linear_conf_t, rcu);
> -	kfree(conf);
> -}
> -
>  static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
>  {
>  	/* Adding a drive to a linear array allows the array to grow.
> @@ -247,7 +241,7 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rdev)
>  	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	revalidate_disk(mddev->gendisk);
> -	call_rcu(&oldconf->rcu, free_conf);
> +	kfree_rcu(oldconf, rcu);
>  	return 0;
>  }
>  

