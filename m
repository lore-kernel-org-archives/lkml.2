Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2ABIV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:21:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2ABIV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:21:28 -0500
Date: Mon, 2 Jan 2012 01:21:24 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 2/4] net: ethernet: xilinx: Don't use NO_IRQ in xilinx
Message-ID: <20120102082124.GD18381@ponder.secretlab.ca>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
 <1324477932-19262-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324477932-19262-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 03:32:10PM +0100, Michal Simek wrote:
> Fix ll_temac and emaclite drivers. Only Microblaze and Xilinx PPC
> use then and both use NO_IRQ as 0. It will be removed in near future.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: "David S. Miller" <davem@davemloft.net> (commit_signer:7/10=70%)
> CC: Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/10=10%)
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Ryan Mallon <rmallon@gmail.com>
> ---

Acked-by: Grant Likely <grant.likely@secretlab.ca>

>  drivers/net/ethernet/xilinx/ll_temac_main.c   |    2 +-
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 2681b53..87775d7 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1077,7 +1077,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
>  
>  	of_node_put(np); /* Finished with the DMA node; drop the reference */
>  
> -	if ((lp->rx_irq == NO_IRQ) || (lp->tx_irq == NO_IRQ)) {
> +	if (!lp->rx_irq || !lp->tx_irq) {
>  		dev_err(&op->dev, "could not determine irqs\n");
>  		rc = -ENOMEM;
>  		goto err_iounmap_2;
> diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> index 8018d7d..252edf7 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> @@ -1129,7 +1129,7 @@ static int __devinit xemaclite_of_probe(struct platform_device *ofdev)
>  
>  	/* Get IRQ for the device */
>  	rc = of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq);
> -	if (rc == NO_IRQ) {
> +	if (!rc) {
>  		dev_err(dev, "no IRQ found\n");
>  		return rc;
>  	}
> -- 
> 1.7.5.4
> 
