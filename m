Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2BBSaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:30:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52688 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2BBSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:30:25 -0500
Date: Thu, 2 Feb 2012 11:30:23 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-topcliff-pch: rename pch_spi_pcidev to
 pch_spi_pcidev_driver
Message-ID: <20120202183023.GP15343@ponder.secretlab.ca>
References: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
 <1328188830-28133-3-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328188830-28133-3-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 02:20:30PM +0100, Danny Kukawka wrote:
> Rename static struct pci_driver pch_spi_pcidev to
> pch_spi_pcidev_driver to get rid of warnings from modpost checks.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Merged, thanks.
g.

> ---
>  drivers/spi/spi-topcliff-pch.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 2a6429d..10182eb 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1720,7 +1720,7 @@ static int pch_spi_resume(struct pci_dev *pdev)
>  
>  #endif
>  
> -static struct pci_driver pch_spi_pcidev = {
> +static struct pci_driver pch_spi_pcidev_driver = {
>  	.name = "pch_spi",
>  	.id_table = pch_spi_pcidev_id,
>  	.probe = pch_spi_probe,
> @@ -1736,7 +1736,7 @@ static int __init pch_spi_init(void)
>  	if (ret)
>  		return ret;
>  
> -	ret = pci_register_driver(&pch_spi_pcidev);
> +	ret = pci_register_driver(&pch_spi_pcidev_driver);
>  	if (ret)
>  		return ret;
>  
> @@ -1746,7 +1746,7 @@ module_init(pch_spi_init);
>  
>  static void __exit pch_spi_exit(void)
>  {
> -	pci_unregister_driver(&pch_spi_pcidev);
> +	pci_unregister_driver(&pch_spi_pcidev_driver);
>  	platform_driver_unregister(&pch_spi_pd_driver);
>  }
>  module_exit(pch_spi_exit);
> -- 
> 1.7.7.3
> 
