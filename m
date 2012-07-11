Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2GKFhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:37:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:49390 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2GKFhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:37:11 -0400
Message-ID: <1341985013.18850.29.camel@pasglop>
Subject: Re: [PATCH] [powerpc] Export memory limit via device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com
Date: Wed, 11 Jul 2012 15:36:53 +1000
In-Reply-To: <20120702114855.22333.95335.stgit@suzukikp.in.ibm.com>
References: <20120702114855.22333.95335.stgit@suzukikp.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
> index c957b12..0c9695d 100644
> --- a/arch/powerpc/kernel/machine_kexec.c
> +++ b/arch/powerpc/kernel/machine_kexec.c
> @@ -207,6 +207,12 @@ static struct property crashk_size_prop = {
>  	.value = &crashk_size,
>  };
>  
> +static struct property memory_limit_prop = {
> +	.name = "linux,memory-limit",
> +	.length = sizeof(phys_addr_t),
> +	.value = &memory_limit,
> +};
> +

AFAIK. phys_addr_t can change size, so instead make it point to a known
fixes size quantity (a u64).

> +
> +	/* memory-limit is needed for constructing the crash regions */
> +	prop = of_find_property(node, memory_limit_prop.name, NULL);
> +	if (prop)
> +		prom_remove_property(node, prop);
> +
> +	if (memory_limit)
> +		prom_add_property(node, &memory_limit_prop);
> +

There's a patch floating around making prom_update_property properly
handle both pre-existing and non-pre-existing props, you should probably
base yourself on top of it. I'm about to stick that patch in powerpc
-next

Cheers,
Ben.


