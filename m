Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab1KJRpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:45:46 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52130 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752141Ab1KJRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:45:43 -0500
Message-ID: <4EBC0D77.1000406@xenotime.net>
Date: Thu, 10 Nov 2011 09:44:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix compile error when CONFIG_ATA_BMDMA is not
 defined
References: <1320941426-1100-1-git-send-email-asbjorn@asbjorn.biz>
In-Reply-To: <1320941426-1100-1-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 08:10 AM, Asbjoern Sloth Toennesen wrote:
> 3.2-rc1 and Linus' tree at 5e442a49, fails to compile,
> with CONFIG_SFF defined without CONFIG_ATA_BMDMA.
> 
> The error was introduced by:
>   [ c2036033 ] libata: reduce ata_pci_[sff,bmdma]_init_one() size
> 
> Note this patch have only been compile tested.
> 
> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/ata/libata-sff.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 63d5327..82b1237 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -2533,10 +2533,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
>  	if (rc)
>  		goto out;
>  
> +	#ifdef CONFIG_ATA_BMDMA
>  	if (bmdma)
>  		/* prepare and activate BMDMA host */
>  		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
>  	else
> +	#endif /* CONFIG_ATA_BMDMA */
>  		/* prepare and activate SFF host */
>  		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
>  	if (rc)
> @@ -2544,10 +2546,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
>  	host->private_data = host_priv;
>  	host->flags |= hflags;
>  
> +	#ifdef CONFIG_ATA_BMDMA
>  	if (bmdma) {
>  		pci_set_master(pdev);
>  		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
>  	} else
> +	#endif /* CONFIG_ATA_BMDMA */
>  		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
>  out:
>  	if (rc == 0)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
