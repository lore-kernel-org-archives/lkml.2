Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2FGMJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:09:44 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:22392
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520Ab2FGMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:09:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(z616jz148cI1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 7 Jun 2012 20:09:11 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pinctrl: free if of_get_parent fails to get the
 parent node
Message-ID: <20120607120910.GE8354@shlinux2.ap.freescale.net>
References: <1338656677-3979-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1338656677-3979-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 10:34:37PM +0530, Devendra Naga wrote:
> of_get_parent can return null if no parent node found, so the allocated new_map
> should be freed.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/pinctrl/pinctrl-imx.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
Thanks for fixing.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> index 553ed95..82c1d80 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/pinctrl-imx.c
> @@ -173,8 +173,10 @@ static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
>  
>  	/* create mux map */
>  	parent = of_get_parent(np);
> -	if (!parent)
> +	if (!parent) {
> +		kfree(new_map);
>  		return -EINVAL;
> +	}
>  	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
>  	new_map[0].data.mux.function = parent->name;
>  	new_map[0].data.mux.group = np->name;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

