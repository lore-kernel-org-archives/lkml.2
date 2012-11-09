Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2KIUJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:09:48 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44370 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315Ab2KIUJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:09:47 -0500
Date: Fri, 9 Nov 2012 20:09:45 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: venkat.x.venkatsubra@oracle.com, David Miller <davem@davemloft.net>,
        rds-devel@oss.oracle.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] net: rds: use this_cpu_ptr per-cpu helper
In-Reply-To: <509C687E.1080106@gmail.com>
Message-ID: <0000013ae6cadebe-0e44d6a0-5e8c-4ded-a337-d2f41f2ab0e4-000000@email.amazonses.com>
References: <509C687E.1080106@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

>  net/rds/ib_recv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index 8d19491..a4a5064 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -423,7 +423,7 @@ static void rds_ib_recv_cache_put(struct list_head *new_item,
>
>  	local_irq_save(flags);
>
> -	chp = per_cpu_ptr(cache->percpu, smp_processor_id());
> +	chp = this_cpu_ptr(cache->percpu);
>  	if (!chp->first)

if (!__this_cpu_read(cache-0>percpu->first))

?

