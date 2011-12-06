Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab1LFMts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:49:48 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:55174 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933195Ab1LFMtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:49:46 -0500
Date: Tue, 6 Dec 2011 14:48:58 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: netdev@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: don't
 munge MAC address from platform data
Message-ID: <20111206124857.GB14048@sapphire.tkos.co.il>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On Tue, Dec 06, 2011 at 11:27:13AM +0100, Lothar Waﬂmann wrote:
> When the MAC address is supplied via platform_data it should be OK as
> it is and should not be modified in case of a dual FEC setup.
> Also copying the MAC from platform_data to the single 'macaddr'
> variable will overwrite the MAC for the first interface in case of a
> dual FEC setup.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  drivers/net/ethernet/freescale/fec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
> index e2b5ce6..11534b9 100644
> --- a/drivers/net/ethernet/freescale/fec.c
> +++ b/drivers/net/ethernet/freescale/fec.c
> @@ -818,7 +818,7 @@ static void __inline__ fec_get_mac(struct net_device *ndev)
>  			iap = (unsigned char *)FEC_FLASHMAC;
>  #else
>  		if (pdata)
> -			memcpy(iap, pdata->mac, ETH_ALEN);
> +			iap = (unsigned char *)&pdata->mac;

Since pdata might point to __initdata struct, you must hold a copy of its 
content.

baruch

>  #endif
>  	}
>  
> -- 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
