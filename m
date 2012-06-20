Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2FTFCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:02:45 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6193 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214Ab2FTFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:02:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzz8275dhz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 20 Jun 2012 13:23:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <swarren@wwwdotorg.org>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/1] pinctrl: pinctrl-mxs: fix a compiling error
Message-ID: <20120620052312.GA1568@S2100-06.ap.freescale.net>
References: <1340167717-13082-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340167717-13082-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:48:37PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The compiling error is:
> drivers/pinctrl/pinctrl-mxs.c: In function 'mxs_dt_node_to_map':
> drivers/pinctrl/pinctrl-mxs.c:140: error: implicit declaration of function 'free'
> drivers/pinctrl/pinctrl-mxs.c:140: warning: incompatible implicit declaration of built-in function 'free'
> It should be kfree.
> 

Already fixed by Fabio.

http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=commit;h=14e1e9f5cadb7cff3a2846c27cc1b9c8f207ee18

Regards,
Shawn

> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-mxs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
> index afb50ee..4ba4636 100644
> --- a/drivers/pinctrl/pinctrl-mxs.c
> +++ b/drivers/pinctrl/pinctrl-mxs.c
> @@ -137,7 +137,7 @@ static int mxs_dt_node_to_map(struct pinctrl_dev *pctldev,
>  
>  free_group:
>  	if (!purecfg)
> -		free(group);
> +		kfree(group);
>  free:
>  	kfree(new_map);
>  	return ret;
> -- 
> 1.7.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

