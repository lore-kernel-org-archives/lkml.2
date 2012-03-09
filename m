Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab2CJCyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:54:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59074 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232Ab2CJCyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:54:40 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device info
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
In-Reply-To: <1323403905-3432-1-git-send-email-tomoya.rohm@gmail.com>
References: <1323403905-3432-1-git-send-email-tomoya.rohm@gmail.com>
Date: Fri, 09 Mar 2012 16:45:58 -0700
Message-Id: <20120309234558.692513E093E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 13:11:42 +0900, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
>  drivers/spi/spi-topcliff-pch.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 99ec279..fcd9462 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -920,7 +920,8 @@ static void pch_spi_request_dma(struct pch_spi_data *data, int bpw)
>  	dma_cap_set(DMA_SLAVE, mask);
>  
>  	/* Get DMA's dev information */
> -	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(12, 0));
> +	dma_dev = pci_get_bus_and_slot(data->board_dat->pdev->bus->number,
> +				       PCI_DEVFN(12, 0));

Applied, thanks

g.

