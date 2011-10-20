Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1JTBrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 21:47:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61433 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1JTBrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 21:47:04 -0400
Date: Wed, 19 Oct 2011 19:01:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] gpio-ml-ioh: Use NUMA_NO_NODE not GFP_KERNEL
Message-ID: <20111020010157.GB2153@ponder.secretlab.ca>
References: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
 <1318988260-19462-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318988260-19462-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:37:40AM +0900, Tomoya MORINAGA wrote:
> Currently, GFP_KERNEL is used as parameter of irq_alloc_descs like below.
> 
>           irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
>                                      GFP_KERNEL);
> 
> This is not true.
> So, this patch uses NUMA_NO_NODE not GFP_KERNEL.

Applied both, thanks.

g.

> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> ---
>  drivers/gpio/gpio-ml-ioh.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
> index 88d65be..1b59003 100644
> --- a/drivers/gpio/gpio-ml-ioh.c
> +++ b/drivers/gpio/gpio-ml-ioh.c
> @@ -429,7 +429,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
>  	chip = chip_save;
>  	for (j = 0; j < 8; j++, chip++) {
>  		irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
> -					   GFP_KERNEL);
> +					   NUMA_NO_NODE);
>  		if (irq_base < 0) {
>  			dev_warn(&pdev->dev,
>  				"ml_ioh_gpio: Failed to get IRQ base num\n");
> -- 
> 1.7.4.4
> 
