Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1G1LSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:18:01 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19620 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1G1LR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:17:58 -0400
Message-ID: <4E314562.2000001@imgtec.com>
Date: Thu, 28 Jul 2011 12:17:54 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
CC: Will Newton <will.newton@imgtec.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Fixed bug in IDMAC_SET_BUFFER1_SIZE Macro in
 dw_mmc.c
References: <1311851023-3563-1-git-send-email-shashidharh@vayavyalabs.com>
In-Reply-To: <1311851023-3563-1-git-send-email-shashidharh@vayavyalabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2011 11:17:55.0146 (UTC) FILETIME=[FF677AA0:01CC4D17]
X-SEF-Processed: 7_3_0_01158__2011_07_28_12_17_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 12:03 PM, Shashidhar Hiremath wrote:
> The mask used inside this macro was assuming Buffer_Size1's[BS1's] width to be 14 bits,
> it is actually of 13 bits, Modified masks used in IDMAC_SET_BUFFER1_SIZE such that
> they use only 13 bits instead of current 14.
> 
> Signed-off-by: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
> ---
>  drivers/mmc/host/dw_mmc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 77f0b6b..f13bb49 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -62,7 +62,7 @@ struct idmac_desc {
>  
>  	u32		des1;	/* Buffer sizes */
>  #define IDMAC_SET_BUFFER1_SIZE(d, s) \
> -	((d)->des1 = ((d)->des1 & 0x03ffc000) | ((s) & 0x3fff))
> +	((d)->des1 = ((d)->des1 & 0x03ffe000) | ((s) & 0x1fff))
>  
>  	u32		des2;	/* buffer 1 physical address */
>  

Yes, according to the TRM you appear to be correct

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

