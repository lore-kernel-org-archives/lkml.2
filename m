Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2K2GHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:07:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:60532 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab2K2GHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:07:40 -0500
Message-ID: <1354169232.2179.183.camel@pasglop>
Subject: Re: [PATCH] export of_reconfig_notifier_[register,unregister]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Nov 2012 17:07:12 +1100
In-Reply-To: <50B66922.9090209@linux.vnet.ibm.com>
References: <20121128140308.abb21ec8f61553a2ed077fe3@canb.auug.org.au>
	 <50B66922.9090209@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 13:42 -0600, Nathan Fontenot wrote:
> The of reconfiguration notification chains should be exported for use
> by modules.
> 
> Signed-off-by:Nathan Fontenot <nfont@linux.vnet.ibm.com>

Grant, I'm applying that into the powerpc tree (with a slightly modified
subject line). You don't need to add it to your tree at this stage I
suspect.

Cheers,
Ben.

> ---
> Index: linux-next/drivers/of/base.c
> ===================================================================
> --- linux-next.orig/drivers/of/base.c	2012-11-28 09:18:02.000000000 -0600
> +++ linux-next/drivers/of/base.c	2012-11-28 11:05:00.000000000 -0600
> @@ -1282,11 +1282,13 @@
>  {
>  	return blocking_notifier_chain_register(&of_reconfig_chain, nb);
>  }
> +EXPORT_SYMBOL_GPL(of_reconfig_notifier_register);
>  
>  int of_reconfig_notifier_unregister(struct notifier_block *nb)
>  {
>  	return blocking_notifier_chain_unregister(&of_reconfig_chain, nb);
>  }
> +EXPORT_SYMBOL_GPL(of_reconfig_notifier_unregister);
>  
>  int of_reconfig_notify(unsigned long action, void *p)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


