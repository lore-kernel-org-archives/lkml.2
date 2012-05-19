Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2ESSfr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:35:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2ESSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:35:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/8] irqdomain: Make irq_domain_simple_map() static.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1337407908-7421-4-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org> <1337407908-7421-4-git-send-email-lethal@linux-sh.org>
Date: Sat, 19 May 2012 12:35:43 -0600
Message-Id: <20120519183543.C2F5B3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:11:43 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> Presently irq_domain_simple_map() isn't labelled as static, but there's
> no definition for it in the public irqdomain header either. At present
> all in-tree ->map users have meaningful work to do, and all others are
> using irq_domain_simple_ops directly. Make it static for now, as it can
> always be exported and added to the public API later.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Applied, thanks.

g.

> ---
>  kernel/irq/irqdomain.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 01d4a0d..92e06442 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -758,8 +758,8 @@ static int __init irq_debugfs_init(void)
>  __initcall(irq_debugfs_init);
>  #endif /* CONFIG_IRQ_DOMAIN_DEBUG */
>  
> -int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
> -			  irq_hw_number_t hwirq)
> +static int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
> +				 irq_hw_number_t hwirq)
>  {
>  	return 0;
>  }
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
