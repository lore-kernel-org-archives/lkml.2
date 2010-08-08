Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0HHPSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 11:18:05 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:20242 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab0HHPSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 11:18:03 -0400
Message-ID: <4C5ECAA4.9050606@bfs.de>
Date: Sun, 08 Aug 2010 17:17:56 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Roberto Rodriguez Alkala <rralcala@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] stating: otus: fix compile warning and some style issues
References: <1281225149.10826.5.camel@lenovo>
In-Reply-To: <1281225149.10826.5.camel@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Roberto Rodriguez Alkala schrieb:
> In today linux-next I got a compile warning in staging/otus driver. 
> This patch solves the issue and also improves the coding style.
> 
> Signed-off-by: Roberto Rodriguez Alcala <rralcala@gmail.com>
> ---
>  drivers/staging/otus/80211core/ratectrl.c |   26 +++++++++-----------------
>  1 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/otus/80211core/ratectrl.c b/drivers/staging/otus/80211core/ratectrl.c
> index a1abe2f..283b2b5 100644
> --- a/drivers/staging/otus/80211core/ratectrl.c
> +++ b/drivers/staging/otus/80211core/ratectrl.c
> @@ -422,23 +422,15 @@ u8_t zfRateCtrlRateDiff(struct zsRcCell* rcCell, u8_t retryRate)
>      u16_t i;
>  
>      /* Find retryRate in operationRateSet[] */
> -    for (i=0; i<rcCell->operationRateCount; i++)
> -    {
> -        if (retryRate == rcCell->operationRateSet[i])
> -        {
> -            if (i < rcCell->currentRateIndex)
> -            {
> -                return ((rcCell->currentRateIndex - i)+1)>>1;
> -            }
> -            else if (i == rcCell->currentRateIndex == 0)
> -            {
> -                return 1;
> -            }
> -            else
> -            {
> -                return 0;
> -            }
> -        }
> +    for (i = 0; i < rcCell->operationRateCount; i++) {
> +	if (retryRate == rcCell->operationRateSet[i]) {
> +		if (i < rcCell->currentRateIndex)
> +			return ((rcCell->currentRateIndex - i)+1)>>1;
> +		else if (i == rcCell->currentRateIndex && i == 0)
> +			return 1;
> +		else
> +			return 0;
> +	}
>      }
>      /* TODO : retry rate not in operation rate set */
>      zm_msg1_tx(ZM_LV_0, "Not in operation rate set:", retryRate);


mmh, it is a matter of taste but to improve readablity
i would make the special case i=0 first and let the  loop
start with i=1. /* untested code below, assuming rcCell->currentRateIndex>=0 */

 if ( retryRate == rcCell->operationRateSet[0] && rcCell->currentRateIndex== 0 )
	return 1;

  for (i = 1; i < rcCell->operationRateCount; i++) {
               if (i < rcCell->currentRateIndex)
                  return ((rcCell->currentRateIndex - i)+1)>>1;
               else
                  return 0;
   }



just my 2 cents,

re,
 wh
