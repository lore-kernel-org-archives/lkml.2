Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2EJAzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:55:47 -0400
Received: from void.printf.net ([89.145.121.20]:60882 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab2EJAzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:55:45 -0400
From: Chris Ball <cjb@laptop.org>
To: Philippe De Swert <philippedeswert@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.calixto@modsystems.com, prakity@marvell.com
Subject: Re: [PATCH 2/2] mmc: Remove dead code
References: <1334176325-6221-1-git-send-email-philippedeswert@gmail.com>
Date: Wed, 09 May 2012 20:55:33 -0400
In-Reply-To: <1334176325-6221-1-git-send-email-philippedeswert@gmail.com>
	(Philippe De Swert's message of "Wed, 11 Apr 2012 23:32:05 +0300")
Message-ID: <87y5p0lure.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 11 2012, Philippe De Swert wrote:
> bus_width is passed to the function and when 0 (MMC_BUS_WIDTH_1)
> will cause the function to return. So in in the second test it 
> definitly is different from 0, and the third test is redundant.
>
> Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
> ---
>  drivers/mmc/core/mmc.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 54df5ad..4a1bf8f 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -556,14 +556,10 @@ static int mmc_compare_ext_csds(struct mmc_card *card, unsigned bus_width)
>  	err = mmc_get_ext_csd(card, &bw_ext_csd);
>  
>  	if (err || bw_ext_csd == NULL) {
> -		if (bus_width != MMC_BUS_WIDTH_1)
> -			err = -EINVAL;
> +		err = -EINVAL;
>  		goto out;
>  	}
>  
> -	if (bus_width == MMC_BUS_WIDTH_1)
> -		goto out;
> -
>  	/* only compare read only fields */
>  	err = !((card->ext_csd.raw_partition_support ==
>  			bw_ext_csd[EXT_CSD_PARTITION_SUPPORT]) &&

Thanks, pushed for mmc-next for 3.5.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
