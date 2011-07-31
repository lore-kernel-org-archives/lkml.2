Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1GaFiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:38:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:46738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1GaFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:38:49 -0400
Date: Sun, 31 Jul 2011 01:38:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the moduleh tree
Message-ID: <20110731053843.GC31842@windriver.com>
References: <20110729160943.c77bc737188b0cf9dace922a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729160943.c77bc737188b0cf9dace922a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build warnings after merge of the moduleh tree] On 29/07/2011 (Fri 16:09) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> drivers/of/of_pci_irq.c:92:1: warning: data definition has no type or storage class
> drivers/of/of_pci_irq.c:92:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/of/of_pci_irq.c:92:1: warning: parameter names (without types) in function declaration
> 
> This is an interaction with commit 98d9f30c820d ("pci/of: Match PCI
> devices to OF nodes dynamically") which split off part of
> drivers/of/of_pci.c.

Thanks, I've picked this one up as well.

Paul.

> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 29 Jul 2011 16:05:38 +1000
> Subject: [PATCH] pci/of: include export.h for EXPORT_SYMBOL_GPL
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/of/of_pci_irq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/of_pci_irq.c b/drivers/of/of_pci_irq.c
> index ac1ec54..9312516 100644
> --- a/drivers/of/of_pci_irq.c
> +++ b/drivers/of/of_pci_irq.c
> @@ -1,6 +1,7 @@
>  #include <linux/kernel.h>
>  #include <linux/of_pci.h>
>  #include <linux/of_irq.h>
> +#include <linux/export.h>
>  #include <asm/prom.h>
>  
>  /**
> -- 
> 1.7.5.4
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
