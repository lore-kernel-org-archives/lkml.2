Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2JHJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 05:25:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49482 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2JHJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 05:25:53 -0400
Date: Mon, 8 Oct 2012 11:25:47 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: fix return value check in imx3_init_l2x0()
Message-ID: <20121008092547.GK1322@pengutronix.de>
References: <CAPgLHd8Rma5fSWPtjvLr18TEmmC=8kOjmSJtneO0Ecd1bvOrcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8Rma5fSWPtjvLr18TEmmC=8kOjmSJtneO0Ecd1bvOrcg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:25:30 up 107 days, 37 min, 80 users,  load average: 0.48, 2.01,
 3.22
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 01:54:01PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function ioremap() returns NULL
> not ERR_PTR(). The IS_ERR() test in the return value
> check should be replaced with NULL test.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Appied, thanks

Sascha


> ---
>  arch/arm/mach-imx/mm-imx3.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
> index 9d2c843..b5deb05 100644
> --- a/arch/arm/mach-imx/mm-imx3.c
> +++ b/arch/arm/mach-imx/mm-imx3.c
> @@ -108,9 +108,8 @@ void __init imx3_init_l2x0(void)
>  	}
>  
>  	l2x0_base = ioremap(MX3x_L2CC_BASE_ADDR, 4096);
> -	if (IS_ERR(l2x0_base)) {
> -		printk(KERN_ERR "remapping L2 cache area failed with %ld\n",
> -				PTR_ERR(l2x0_base));
> +	if (!l2x0_base) {
> +		printk(KERN_ERR "remapping L2 cache area failed\n");
>  		return;
>  	}
>  
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
