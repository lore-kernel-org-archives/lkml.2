Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2BOEiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:38:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64172 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2BOEiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:38:19 -0500
Date: Tue, 14 Feb 2012 20:38:13 -0800
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: Make "hog" mapping table entries work
Message-ID: <20120215043813.GA3607@b29396-Latitude-E6410>
References: <1329241841-21357-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329241841-21357-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:50:41AM -0700, Stephen Warren wrote:
> Commit 77a5988 "pinctrl: changes hog mechanism to be self-referential"
> modified the way "hog" entries were represented in the mapping table.
> However, the new representation failed some error checks in
> pinctrl_hog_map(). Remove the now-bogus error-check, and fix the code
> to solve the issue the error-check used to avoid.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> ---
>  drivers/pinctrl/core.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index c5f76ad..8a91eb2 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -725,23 +725,11 @@ static int pinctrl_hog_map(struct pinctrl_dev *pctldev,
>  	struct pinctrl *p;
>  	int ret;
>  
> -	if (map->dev_name) {
> -		/*
> -		 * TODO: the day we have device tree support, we can
> -		 * traverse the device tree and hog to specific device nodes
> -		 * without any problems, so then we can hog pinmuxes for
> -		 * all devices that just want a static pin mux at this point.
> -		 */
> -		dev_err(pctldev->dev, "map %s wants to hog a non-system pinmux, this is not going to work\n",
> -				map->name);
> -		return -EINVAL;
> -	}
> -
>  	hog = kzalloc(sizeof(struct pinctrl_hog), GFP_KERNEL);
>  	if (!hog)
>  		return -ENOMEM;
>  
> -	p = pinctrl_get(NULL, map->name);
> +	p = pinctrl_get(pctldev->dev, map->name);
>  	if (IS_ERR(p)) {
>  		kfree(hog);
>  		dev_err(pctldev->dev,
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
