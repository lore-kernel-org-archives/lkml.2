Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2JIGE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:04:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55396 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JIGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:04:43 -0400
Subject: Re: net: fix typo in freescale/ucc_geth.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Eric Dumazet <edumazet@google.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Bizon <mbizon@freebox.fr>,
        "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org
In-Reply-To: <23452.1349740345@neuling.org>
References: <20121008173653.1d17895964980c98af59c8ea@canb.auug.org.au>
	 <23452.1349740345@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Oct 2012 08:04:39 +0200
Message-ID: <1349762679.21172.3842.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 10:52 +1100, Michael Neuling wrote:
> The following patch: 
>   acb600d net: remove skb recycling
> added dev_free_skb() to drivers/net/ethernet/freescale/ucc_geth.c
> 
> This is a typo and should be dev_kfree_skb().  This fixes this.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> This hit as a compile error in next-20121008 with mpc85xx_defconfig.
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index dfa0aaa..0a70bb5 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -3268,7 +3268,7 @@ static int ucc_geth_rx(struct ucc_geth_private *ugeth, u8 rxQ, int rx_work_limit
>  			if (netif_msg_rx_err(ugeth))
>  				ugeth_err("%s, %d: ERROR!!! skb - 0x%08x",
>  					   __func__, __LINE__, (u32) skb);
> -			dev_free_skb(skb);
> +			dev_kfree_skb(skb);
>  
>  			ugeth->rx_skbuff[rxQ][ugeth->skb_currx[rxQ]] = NULL;
>  

Oops, thanks Michael !


