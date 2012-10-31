Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683Ab2JaRrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:47:10 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:37846 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935770Ab2JaRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:47:05 -0400
Date: Wed, 31 Oct 2012 17:47:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <50910A17.1090600@gmail.com>
Message-ID: <0000013ab7eefc03-20a4ba94-f83f-4624-9dac-dfe3924277b4-000000@email.amazonses.com>
References: <50910A17.1090600@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  kernel/rcutree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 74df86b..3a21fcf 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1960,7 +1960,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
>  	struct rcu_node *rnp_old = NULL;
>
>  	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> +	rnp = this_cpu_ptr(rsp->rda)->mynode;

Do

	rnp = this_cpu_read(rsp->rda->mynode);

instad.

