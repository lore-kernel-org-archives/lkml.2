Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0C2Ir3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:47:29 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59082 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0C2Ir2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:47:28 -0400
Date: Mon, 29 Mar 2010 10:47:24 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 09/12] ehca: convert cpu notifier to return encapsulate
 errno value
Message-ID: <20100329104724.48b23c09@alex-laptop>
In-Reply-To: <1268903124-10237-9-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
	<1268903124-10237-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 18:05:21 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> By the previous modification, the cpu notifier can return encapsulate
> errno value. This converts the cpu notifiers for ehca.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
> Cc: Christoph Raisch <raisch@de.ibm.com>
> Cc: linux-rdma@vger.kernel.org

Acked-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>

> ---
>  drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
> index b2b6fea..31f3ee1 100644
> --- a/drivers/infiniband/hw/ehca/ehca_irq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_irq.c
> @@ -845,7 +845,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
>  		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
>  		if (!create_comp_task(pool, cpu)) {
>  			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
> -			return NOTIFY_BAD;
> +			return notifier_from_errno(-ENOMEM);
>  		}
>  		break;
>  	case CPU_UP_CANCELED:
