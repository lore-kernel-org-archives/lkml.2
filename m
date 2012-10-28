Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2J1Rph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:45:37 -0400
Received: from antcom.de ([188.40.178.216]:37295 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2J1Rpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:45:36 -0400
Message-ID: <508D6F17.4000405@antcom.de>
Date: Sun, 28 Oct 2012 18:44:55 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: davem@davemloft.net, edumazet@google.com, djduanjiong@gmail.com,
        aletes.xgr@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister
 before mdiobus_free
References: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1351440721-9121-1-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/12 17:12, Peter Senna Tschudin wrote:
> Based on commit b27393aecf66199f5ddad37c302d3e0cfadbe6c0
> 
> Calling mdiobus_free without calling mdiobus_unregister causes
> BUG_ON(). This patch fixes the issue.
> 
> The semantic patch that found this issue(http://coccinelle.lip6.fr/):
> // <smpl>
> @@
> expression E;
> @@
>   ... when != mdiobus_unregister(E);
> 
> + mdiobus_unregister(E);
>   mdiobus_free(E);
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Tested-by: Roland Stigge <stigge@antcom.de>

Thanks for the patch!

Roland

> ---
> This problem is somewhat mystifying. If the patch is correct, there were
> probably many OOPSese caused by not calling mdiobus_unregister...
> Reporting anyway...
> 
>  drivers/net/ethernet/nxp/lpc_eth.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
> index 53743f7..af8b414 100644
> --- a/drivers/net/ethernet/nxp/lpc_eth.c
> +++ b/drivers/net/ethernet/nxp/lpc_eth.c
> @@ -1524,6 +1524,7 @@ static int lpc_eth_drv_remove(struct platform_device *pdev)
>  				  pldat->dma_buff_base_p);
>  	free_irq(ndev->irq, ndev);
>  	iounmap(pldat->net_base);
> +	mdiobus_unregister(pldat->mii_bus);
>  	mdiobus_free(pldat->mii_bus);
>  	clk_disable(pldat->clk);
>  	clk_put(pldat->clk);

