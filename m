Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031316Ab2CPDmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:42:02 -0400
Received: from void.printf.net ([89.145.121.20]:50581 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275Ab2CPDl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:41:59 -0400
From: Chris Ball <cjb@laptop.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: sdhci-pci: Add MSI support
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com>
Date: Thu, 15 Mar 2012 23:41:37 -0400
In-Reply-To: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com>
	(Alexander Stein's message of "Tue, 13 Mar 2012 18:16:40 +0100")
Message-ID: <87ty1pb4b2.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Tue, Mar 13 2012, Alexander Stein wrote:
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 7165e6a..9382f27 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -1379,6 +1379,8 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
>  
>  	slots = chip->num_slots;	/* Quirk may have changed this */
>  
> +	pci_enable_msi(pdev);
> +
>  	for (i = 0; i < slots; i++) {
>  		slot = sdhci_pci_probe_slot(pdev, chip, first_bar, i);
>  		if (IS_ERR(slot)) {
> @@ -1397,6 +1399,8 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
>  	return 0;
>  
>  free:
> +	pci_disable_msi(pdev);
> +
>  	pci_set_drvdata(pdev, NULL);
>  	kfree(chip);
>  
> @@ -1419,6 +1423,8 @@ static void __devexit sdhci_pci_remove(struct pci_dev *pdev)
>  		for (i = 0; i < chip->num_slots; i++)
>  			sdhci_pci_remove_slot(chip->slots[i]);
>  
> +		pci_disable_msi(pdev);
> +
>  		pci_set_drvdata(pdev, NULL);
>  		kfree(chip);
>  	}

Thanks, I've merged all three patches to mmc-next for 3.4, using v2 of
patches 2 and 3, and adding Adrian's ACK to patch 2.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
