Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2LXNIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:08:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34536 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LXNIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:08:07 -0500
Date: Mon, 24 Dec 2012 14:08:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH 3/7] MFD:rtsx: Declare that the DMA address limitation is
 32bit explicitly
Message-ID: <20121224130801.GC6702@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
References: <cover.1356319097.git.wei_wang@realsil.com.cn>
 <af58804b4774b109fbd6022ce7cc8081990b3625.1356319097.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af58804b4774b109fbd6022ce7cc8081990b3625.1356319097.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 02:03:30PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index fa2c2bc..2ee6be5 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -1084,6 +1084,10 @@ static int __devinit rtsx_pci_probe(struct pci_dev *pcidev,
>  	pci_set_master(pcidev);
>  	synchronize_irq(pcr->irq);
>  
> +	ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
> +	if (ret < 0)
> +		goto disable_irq;

This piece is deep down in rtsx_pci_probe() and if it fails, the _probe
function has do to all the error unwinding on the error path. Why not
push it up before the pci_enable_device(pcidev) call so in case it
fails, you can save yourself all the needless unwinding?

Oh, and ditto here, commit message is missing.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
