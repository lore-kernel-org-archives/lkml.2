Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2KLBUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 20:20:31 -0500
Received: from tx2outboundsmtppool1.messaging.microsoft.com ([65.55.83.131]:57410
	"EHLO TX2EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750897Ab2KLBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 20:20:30 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-BigFish: VS48(zz98dI1432Izz1de0h1202h1d1ah1d2ahzz8275bh8275dh179766kjz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh)
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 48
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 12 Nov 2012 09:46:16 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] pinctrl: mxs: Make PINCTRL_MXS select PINMUX &&
 PINCONF
Message-ID: <20121112014615.GA415@S2100-06.ap.freescale.net>
References: <1352600482.23129.1.camel@phoenix>
 <1352600562.23129.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1352600562.23129.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Reply-To: <shawn.guo@linaro.org>
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 10:22:42AM +0800, Axel Lin wrote:
> Then we can remove "select PINMUX && PINCONF" from PINCTRL_IMX{23,28}.
> This simplifies the dependency.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/pinctrl/Kconfig |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index fc0f49a..d5c9431 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -99,18 +99,16 @@ config PINCTRL_MMP2
>  	select PINCONF
>  
>  config PINCTRL_MXS
> +	select PINMUX
> +	select PINCONF

Better have them after 'bool' below, otherwise,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

>  	bool
>  
>  config PINCTRL_IMX23
>  	bool
> -	select PINMUX
> -	select PINCONF
>  	select PINCTRL_MXS
>  
>  config PINCTRL_IMX28
>  	bool
> -	select PINMUX
> -	select PINCONF
>  	select PINCTRL_MXS
>  
>  config PINCTRL_NOMADIK
> -- 
> 1.7.9.5
> 
> 
> 

