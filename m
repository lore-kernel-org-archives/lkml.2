Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0DUCF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:05:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57151
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab0DUCF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:05:56 -0400
Date: Tue, 20 Apr 2010 19:06:00 -0700 (PDT)
Message-Id: <20100420.190600.268103639.davem@davemloft.net>
To: h-shimamoto@ct.jp.nec.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, divy@chelsio.com
Subject: Re: [PATCH] cxgb3: fix linkup issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BCD0424.8030501@ct.jp.nec.com>
References: <4BCD0424.8030501@ct.jp.nec.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date: Tue, 20 Apr 2010 10:32:20 +0900

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> I encountered an issue that not to link up on cxgb3 fabric.
> I bisected and found that this regression was introduced by
> 0f07c4ee8c800923ae7918c231532a9256233eed.
> 
> Correct to pass phy_addr to cphy_init() at t3_xaui_direct_phy_prep().
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

CXGB3 maintainers, please review.

> ---
>  drivers/net/cxgb3/ael1002.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/cxgb3/ael1002.c b/drivers/net/cxgb3/ael1002.c
> index 5248f9e..35cd367 100644
> --- a/drivers/net/cxgb3/ael1002.c
> +++ b/drivers/net/cxgb3/ael1002.c
> @@ -934,7 +934,7 @@ static struct cphy_ops xaui_direct_ops = {
>  int t3_xaui_direct_phy_prep(struct cphy *phy, struct adapter *adapter,
>  			    int phy_addr, const struct mdio_ops *mdio_ops)
>  {
> -	cphy_init(phy, adapter, MDIO_PRTAD_NONE, &xaui_direct_ops, mdio_ops,
> +	cphy_init(phy, adapter, phy_addr, &xaui_direct_ops, mdio_ops,
>  		  SUPPORTED_10000baseT_Full | SUPPORTED_AUI | SUPPORTED_TP,
>  		  "10GBASE-CX4");
>  	return 0;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
