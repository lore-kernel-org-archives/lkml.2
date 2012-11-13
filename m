Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2KMGh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:37:56 -0500
Received: from co9outboundsmtppool1.messaging.microsoft.com ([157.56.73.193]:57858
	"EHLO CO9EHSNDR003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab2KMGhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:37:55 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-BigFish: VS47(zz98dI1432I1447Izz1de0h1202h1d1ah1d2ahzz17326ah8275bh8275dh179766kjz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 47
Date: Tue, 13 Nov 2012 14:37:30 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: imx: Fix the logic checking if not able to find
 pin reg map
Message-ID: <20121113063729.GA11892@b29396-Latitude-E6410>
References: <1352768407.19229.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1352768407.19229.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Reply-To: <B29396@freescale.com>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:00:07AM +0800, Axel Lin wrote:
> Current code sets "pin_reg = &info->pin_regs[i];" in each loop iteration,
> so in the case of no-match, pin_reg is not NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks for the fix.
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng
> ---
>  drivers/pinctrl/pinctrl-imx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index f3d2384..525a2c8 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -71,7 +71,7 @@ static const struct imx_pin_reg *imx_find_pin_reg(
>  			break;
>  	}
>  
> -	if (!pin_reg) {
> +	if (i == info->npin_regs) {
>  		dev_err(info->dev, "Pin(%s): unable to find pin reg map\n",
>  			info->pins[pin].name);
>  		return NULL;
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

