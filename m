Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2J2ITr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:19:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50215 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2J2ITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:19:44 -0400
Message-ID: <508E3BE6.3070609@ti.com>
Date: Mon, 29 Oct 2012 13:48:46 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH v3 11/16] mmc: omap_hsmmc: limit max_segs with the
 EDMA DMAC
References: <1350566815-409-1-git-send-email-mporter@ti.com> <1350566815-409-12-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-12-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 6:56 PM, Matt Porter wrote:
> The EDMA DMAC has a hardware limitation that prevents supporting
> scatter gather lists with any number of segments. Since the EDMA
> DMA Engine driver sets the maximum segments to 16, we do the
> same.
> 
> TODO: this will be replaced once the DMA Engine API supports an
> API to query the DMAC's segment size limit.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index b327cd0..52bab01 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1828,6 +1828,16 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
>  	 * as we want. */
>  	mmc->max_segs = 1024;
>  
> +	/* Eventually we should get our max_segs limitation for EDMA by
> +	 * querying the dmaengine API */

Nit picking: This is not as per multi-line comment style in
Documentation/CodingStyle.

Thanks,
Sekhar
