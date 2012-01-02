Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2ABIVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:21:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50725 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2ABIVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:21:51 -0500
Date: Mon, 2 Jan 2012 01:21:48 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH 3/4] input: xilinx_ps2: Don't use NO_IRQ
Message-ID: <20120102082148.GE18381@ponder.secretlab.ca>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
 <1324477932-19262-2-git-send-email-monstr@monstr.eu>
 <1324477932-19262-3-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324477932-19262-3-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 03:32:11PM +0100, Michal Simek wrote:
> Drivers shouldn't use NO_IRQ. Microblaze and PPC
> define NO_IRQ as 0 and this reference will be removed
> in near future.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Rob Herring <rob.herring@calxeda.com>
> CC: Ryan Mallon <rmallon@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/input/serio/xilinx_ps2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
> index d64c5a4..f3e54b9 100644
> --- a/drivers/input/serio/xilinx_ps2.c
> +++ b/drivers/input/serio/xilinx_ps2.c
> @@ -253,7 +253,7 @@ static int __devinit xps2_of_probe(struct platform_device *ofdev)
>  	}
>  
>  	/* Get IRQ for the device */
> -	if (of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq) == NO_IRQ) {
> +	if (!of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq)) {
>  		dev_err(dev, "no IRQ found\n");
>  		return -ENODEV;
>  	}
> -- 
> 1.7.5.4
> 
