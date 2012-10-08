Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2JHK4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:56:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab2JHK4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:56:47 -0400
Date: Mon, 8 Oct 2012 12:56:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: fix the return value check in
 imx_clk_busy_divider()
Message-ID: <20121008105641.GP1322@pengutronix.de>
References: <CAPgLHd-0wYjWxWrmLdc+an0RVfEicv3QBEtvsuvQtphti3phdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-0wYjWxWrmLdc+an0RVfEicv3QBEtvsuvQtphti3phdw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:56:30 up 107 days,  2:08, 95 users,  load average: 1.12, 4.31,
 3.55
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 02:14:25PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_register() returns ERR_PTR()
> no NULL pointer. The NULL test in the return value check should
> be replaced with IS_ERR().
> 
> dpatch engine is used to auto generated this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks

Sascha

> ---
>  arch/arm/mach-imx/clk-busy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-busy.c b/arch/arm/mach-imx/clk-busy.c
> index 1a7a8dd..1ab91b5 100644
> --- a/arch/arm/mach-imx/clk-busy.c
> +++ b/arch/arm/mach-imx/clk-busy.c
> @@ -108,7 +108,7 @@ struct clk *imx_clk_busy_divider(const char *name, const char *parent_name,
>  	busy->div.hw.init = &init;
>  
>  	clk = clk_register(NULL, &busy->div.hw);
> -	if (!clk)
> +	if (IS_ERR(clk))
>  		kfree(busy);
>  
>  	return clk;
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
