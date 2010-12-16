Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0LPXpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:45:15 -0500
Received: from void.printf.net ([89.145.121.20]:60015 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0LPXpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:45:13 -0500
Date: Thu, 16 Dec 2010 23:45:11 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Aries Lee <arieslee@jmicron.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Fix a typo in ocr_avail mask check for MMC
Message-ID: <20101216234511.GB17239@void.printf.net>
References: <s5h62uvnpgk.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h62uvnpgk.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Wed, Dec 15, 2010 at 02:19:22PM +0100, Takashi Iwai wrote:
> In the patch "mmc: Add support for JMicron 388 SD/MMC controller",
> I changed a wrong field for MMC during rewrite.  Fixed now.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/mmc/host/sdhci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 51f5209..be0ff14 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1919,7 +1919,7 @@ int sdhci_add_host(struct sdhci_host *host)
>  		mmc->ocr_avail_sd &= ~MMC_VDD_165_195;
>  	mmc->ocr_avail_mmc = ocr_avail;
>  	if (host->ocr_avail_mmc)
> -		mmc->ocr_avail_sd &= host->ocr_avail_mmc;
> +		mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
>  
>  	if (mmc->ocr_avail == 0) {
>  		printk(KERN_ERR "%s: Hardware doesn't report any "

Thanks, I've rebased this change into the original patch on my mmc-next
branch.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
