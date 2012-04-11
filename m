Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab2DKU6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:58:04 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54343 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933238Ab2DKU6C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:58:02 -0400
From: Philip Rakity <prakity@marvell.com>
To: Philippe De Swert <philippedeswert@gmail.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.calixto@modsystems.com" <john.calixto@modsystems.com>,
        "cjb@laptop.org" <cjb@laptop.org>
Date: Wed, 11 Apr 2012 13:56:39 -0700
Subject: Re: [PATCH 2/2] mmc: Remove dead code
Thread-Topic: [PATCH 2/2] mmc: Remove dead code
Thread-Index: Ac0YJZcup8v74omNQgCB/MYtjNdsLQ==
Message-ID: <5D6E9FAF-376B-44A8-89DC-691AC5187FB6@marvell.com>
References: <1334176325-6221-1-git-send-email-philippedeswert@gmail.com>
In-Reply-To: <1334176325-6221-1-git-send-email-philippedeswert@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Philip Rakity <prakity@marvell.com>

On Apr 11, 2012, at 1:32 PM, Philippe De Swert wrote:

> bus_width is passed to the function and when 0 (MMC_BUS_WIDTH_1)
> will cause the function to return. So in in the second test it 
> definitly is different from 0, and the third test is redundant.
> 
> Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
> ---
> drivers/mmc/core/mmc.c |    6 +-----
> 1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 54df5ad..4a1bf8f 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -556,14 +556,10 @@ static int mmc_compare_ext_csds(struct mmc_card *card, unsigned bus_width)
> 	err = mmc_get_ext_csd(card, &bw_ext_csd);
> 
> 	if (err || bw_ext_csd == NULL) {
> -		if (bus_width != MMC_BUS_WIDTH_1)
> -			err = -EINVAL;
> +		err = -EINVAL;
> 		goto out;
> 	}
> 
> -	if (bus_width == MMC_BUS_WIDTH_1)
> -		goto out;
> -
> 	/* only compare read only fields */
> 	err = !((card->ext_csd.raw_partition_support ==
> 			bw_ext_csd[EXT_CSD_PARTITION_SUPPORT]) &&
> -- 
> 1.7.9.5
> 

