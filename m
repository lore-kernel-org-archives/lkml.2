Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0GANQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:16:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40772 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0GANQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:16:28 -0400
X-Auth-Info: 05dEiexnl7lhPMRPPgs9ir1AQn+Bfbfdui4wzLdbULA=
Date: Thu, 1 Jul 2010 15:16:24 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [git pull] (updated) OF-related build breakage fixes
Message-ID: <20100701151624.2bf6c533@wker>
In-Reply-To: <AANLkTimvYT9MFPzX7xmCXPZ6ScFQZxO3zSKlcqczd_GO@mail.gmail.com>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
	<AANLkTimvYT9MFPzX7xmCXPZ6ScFQZxO3zSKlcqczd_GO@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 02:06:35 -0700
Dan Williams <dan.j.williams@gmail.com> wrote:

> of/dma: fix remaining ppc4xx build breakage
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Commit 05c02542 "of/dma: fix build breakage in ppc4xx adma driver"
> missed one conversion site.
> 
> Cc: Anatolij Gustschin <agust@denx.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/dma/ppc4xx/adma.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

Acked-by: Anatolij Gustschin <agust@denx.de>

Thanks for fixing!

> 
> 
> diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> index 5a22ca6..7c37479 100644
> --- a/drivers/dma/ppc4xx/adma.c
> +++ b/drivers/dma/ppc4xx/adma.c
> @@ -4257,10 +4257,12 @@ static int ppc440spe_adma_setup_irqs(struct ppc440spe_adma_device *adev,
>  				     struct ppc440spe_adma_chan *chan,
>  				     int *initcode)
>  {
> +	struct of_device *ofdev;
>  	struct device_node *np;
>  	int ret;
>  
> -	np = container_of(adev->dev, struct of_device, dev)->node;
> +	ofdev = container_of(adev->dev, struct of_device, dev);
> +	np = ofdev->dev.of_node;
>  	if (adev->id != PPC440SPE_XOR_ID) {
>  		adev->err_irq = irq_of_parse_and_map(np, 1);
>  		if (adev->err_irq == NO_IRQ) {
