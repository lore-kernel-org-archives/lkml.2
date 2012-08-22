Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2HVEgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:36:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9364 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2HVEf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:35:29 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-01-5034618f6a5f
Message-id: <50346181.3010406@samsung.com>
Date: Wed, 22 Aug 2012 13:35:13 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/2] mmc: core: Add a capability for disabling mmc cards
References: <1345608318-15347-1-git-send-email-dianders@chromium.org>
In-reply-to: <1345608318-15347-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jAd3+RJMAgx/rhCwu75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlLdyUVvOWt2HOpi62BcRp3FyMnh4SAicTvv1MYIWwx
	iQv31rN1MXJxCAksYpT4u/81M4TzklFi6Ya77CBVvAJaEhdfnAOzWQRUJbauX8sEYrMJ6Ehs
	/3YczBYVCJG4vmcDI0S9oMSPyfdYQGwRAU2JZw0vwYYyC7xkljhx+QTYIGEBH4npSx6DNQsJ
	uEr8+X+XtYuRg4NTwE3i+VJVkDAz0Pz9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHIrPpHYwrmywOMQowMGoxMPrkWASIMSaWFZcmXuI
	UYKDWUmEV++7cYAQb0piZVVqUX58UWlOavEhRmkOFiVxXv4+wwAhgfTEktTs1NSC1CKYLBMH
	p1QD445Xd7Xl3z3gY1T33TZj+xqljif+gse5JpdzzqpZWSvsaR8le8UmcffnIMFD8xz3zFvi
	+EvB0vjBOoONln73DA6uMlq0aurXWI2al6uLzjAyy3vzzX2SHVypyMW9pXzC1jWiteyNynPe
	mO3Y+902KPC2tKtgktpNLrbH/2b/cf62t2vRSY5wdiWW4oxEQy3mouJEAK7nPUpBAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

I didn't know what purpose is.
Why need to add the MMC_CAP2_NO_MMC?
If card is SD or SDIO, mmc_attach_mmc(host) should not be entered.
Could you explain to me in more detail?

Best Regards,
Jaehoon Chung

On 08/22/2012 01:05 PM, Doug Anderson wrote:
> On some systems we need a way to disable MMC card support in a MMC/SD
> card slot.  Add support in the core SD/MMC code to support this.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/mmc/core/core.c  |    2 +-
>  include/linux/mmc/host.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 8ac5246..3214972 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1981,7 +1981,7 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
>  		return 0;
>  	if (!mmc_attach_sd(host))
>  		return 0;
> -	if (!mmc_attach_mmc(host))
> +	if (!(host->caps2 & MMC_CAP2_NO_MMC) && !mmc_attach_mmc(host))
>  		return 0;
>  
>  	mmc_power_off(host);
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f578a71..f36370e 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -257,6 +257,7 @@ struct mmc_host {
>  #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
>  #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
>  #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
> +#define MMC_CAP2_NO_MMC		(1 << 12)	/* Only SD supported, not MMC */
>  
>  	mmc_pm_flag_t		pm_caps;	/* supported pm features */
>  	unsigned int        power_notify_type;
> 

