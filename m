Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2BVGlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:41:20 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:42141
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752773Ab2BVGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:41:18 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Feb 2012 14:49:11 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/20] pinctrl: Assume map table entries can't have a
 NULL ctrl_dev_name field
Message-ID: <20120222064910.GD11087@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-11-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-11-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:45:50PM -0700, Stephen Warren wrote:
> These are already disallowed. Clean up some code that doesn't assume this.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/pinctrl/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index 331ffb6..37dfac7 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -770,8 +770,7 @@ static int pinctrl_hog_maps(struct pinctrl_dev *pctldev)
>  
>  	mutex_lock(&pinctrl_maps_mutex);
>  	for_each_maps(maps_node, i, map) {
> -		if (map->ctrl_dev_name &&
> -		    !strcmp(map->ctrl_dev_name, devname) &&
> +		if (!strcmp(map->ctrl_dev_name, devname) &&
>  		    !strcmp(map->dev_name, devname)) {
>  			/* OK time to hog! */
>  			ret = pinctrl_hog_map(pctldev, map);
> -- 
> 1.7.5.4
> 

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

