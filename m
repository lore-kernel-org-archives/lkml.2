Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab2JYPr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:47:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49200 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2JYPry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:47:54 -0400
Date: Thu, 25 Oct 2012 17:47:45 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM i.MX: fix error-valued pointer dereference in
 clk_register_gate2()
Message-ID: <20121025154745.GG27665@pengutronix.de>
References: <CAPgLHd9Q3bZVth2NSxwH6kBpPsBmRGD+4pfZRpWL69KCw4HY4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9Q3bZVth2NSxwH6kBpPsBmRGD+4pfZRpWL69KCw4HY4g@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:47:36 up 124 days,  6:59, 104 users,  load average: 3.28, 2.03,
 2.18
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 11:02:18PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> The error-valued pointer clk is used for the arg of kfree, it should be
> kfree(gate) if clk_register() return ERR_PTR().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks

Sascha

> ---
>  arch/arm/mach-imx/clk-gate2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
> index 3c1b8ff..cc49c7a 100644
> --- a/arch/arm/mach-imx/clk-gate2.c
> +++ b/arch/arm/mach-imx/clk-gate2.c
> @@ -112,7 +112,7 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
>  
>  	clk = clk_register(dev, &gate->hw);
>  	if (IS_ERR(clk))
> -		kfree(clk);
> +		kfree(gate);
>  
>  	return clk;
>  }
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
