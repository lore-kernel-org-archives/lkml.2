Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2ISCCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:02:17 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:21707
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646Ab2ISCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:02:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202h1d1ah1d2ahzz17326ah8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 19 Sep 2012 10:25:53 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: <cjb@laptop.org>, <marex@denx.de>, <broonie@opensource.wolfsonmicro.com>,
        <vinod.koul@linux.intel.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers/mmc/host/mxs-mmc.c: fix error return code
Message-ID: <20120919022550.GA6145@S2100-06.ap.freescale.net>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
 <1347869728-2696-4-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347869728-2696-4-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:15:28AM +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/mmc/host/mxs-mmc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 80d1e6d..afd8fdd 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -674,6 +674,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
>  	if (!ssp->dmach) {
>  		dev_err(mmc_dev(host->mmc),
>  			"%s: failed to request dma\n", __func__);
> +		ret = -ENODEV;
>  		goto out_clk_put;
>  	}
>  
> -- 
> 1.7.11.4
> 

