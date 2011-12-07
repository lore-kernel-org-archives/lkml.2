Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1LGIhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:37:19 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:33765
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab1LGIhR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:37:17 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzc89bh179dN1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 16:49:54 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: don't
 munge MAC address from platform data
Message-ID: <20111207084953.GD5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <55b78c1766da5b0d0d679f5eae3fb9fc74a6ceef.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:13AM +0100, Lothar Waﬂmann wrote:
> When the MAC address is supplied via platform_data it should be OK as
> it is and should not be modified in case of a dual FEC setup.
> Also copying the MAC from platform_data to the single 'macaddr'
> variable will overwrite the MAC for the first interface in case of a
> dual FEC setup.

Hmm, I do not follow that.  If 'macaddr' holds a valid mac address,
the code path has no chance to be hit at all.  Otherwise, 'macaddr'
is just a place holder for copying mac address from pdata, in which
case the mac address will be fixed up at the end of the function for
dual FEC setup.

Regards,
Shawn

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
>  #endif
>  	}
>  
> -- 
> 1.5.6.5

