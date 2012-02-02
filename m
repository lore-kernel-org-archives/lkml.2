Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2BBLMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:12:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57881 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2BBLMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:12:20 -0500
Message-ID: <1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 02 Feb 2012 12:12:15 +0100
In-Reply-To: <1311923731.7845.25.camel@edumazet-laptop>
References: <1311923731.7845.25.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 juillet 2011 à 09:15 +0200, Eric Dumazet a écrit :
> Since create_comp_task() creates percpu kthread, it makes
> sense to use kthread_create_on_node() to get proper NUMA affinity for
> kthread stack.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
> CC: Christoph Raisch <raisch@de.ibm.com>
> CC: Roland Dreier <roland@kernel.org>
> CC: Sean Hefty <sean.hefty@intel.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_irq.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
> index e571e60..5358900 100644
> --- a/drivers/infiniband/hw/ehca/ehca_irq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_irq.c
> @@ -786,7 +786,8 @@ static struct task_struct *create_comp_task(struct ehca_comp_pool *pool,
>  	spin_lock_init(&cct->task_lock);
>  	INIT_LIST_HEAD(&cct->cq_list);
>  	init_waitqueue_head(&cct->wait_queue);
> -	cct->task = kthread_create(comp_task, cct, "ehca_comp/%d", cpu);
> +	cct->task = kthread_create_on_node(comp_task, cct, cpu_to_node(cpu),
> +					   "ehca_comp/%d", cpu);
>  
>  	return cct->task;
>  }
> 


Any news on this patch ?

Should I submit it again ?



