Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab0L2GvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 01:51:12 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:45624 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0L2GvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 01:51:11 -0500
Date: Tue, 28 Dec 2010 23:51:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] spi_topcliff_pch: change calling function order
 correctly in remove
Message-ID: <20101229065108.GD8172@angua.secretlab.ca>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293449027-3219-2-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 08:23:46PM +0900, Tomoya MORINAGA wrote:
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Hi Tomoya,

This looks like a bug fix that should be applied now, but I cannot
apply it to mainline because it depends on the first patch in your
series which I'm not going to apply.  If you respin this patch to
apply without the first patch, then I can pick it up immediately.

g.

> ---
>  drivers/spi/spi_topcliff_pch.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index 18e077b..a796eaf 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -1166,21 +1166,21 @@ static void pch_spi_remove(struct pci_dev *pdev)
>  		spin_unlock(&board_dat->data[i]->lock);
>  	}
>  
> -	/* Free resources allocated for PCH SPI */
> -	pch_spi_free_resources(board_dat);
> -
>  	/* Unregister SPI master */
>  	for (i = 0; i < board_dat->num; i++)
>  		spi_unregister_master(board_dat->data[i]->master);
>  
> -	/* free memory for private data */
> -	kfree(board_dat);
> +	/* Free resources allocated for PCH SPI */
> +	pch_spi_free_resources(board_dat);
>  
>  	pci_set_drvdata(pdev, NULL);
>  
>  	/* disable PCI device */
>  	pci_disable_device(pdev);
>  
> +	/* free memory for private data */
> +	kfree(board_dat);
> +
>  	dev_dbg(&pdev->dev, "%s invoked pci_disable_device\n", __func__);
>  }
>  
> -- 
> 1.6.0.6
> 
