Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1EKCWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:22:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59170 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1EKCWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:22:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q/Ro1wlvgD11WOWIq4/CSKIcZB6USI13Dh70fL4gGmqb4PEK1e75cL0ks+jakUoUNw
         Tf3tHEx7dQLgYHrzVpkWvvtNZ8c+FPTUu+xHvNQT84nHymOEgjnDt5jktBAqVCd/1fvH
         +gLB9ZliBs17FlZEsCPK0J53h2MixhfnE4i4c=
Date: Tue, 10 May 2011 21:47:09 -0500
From: Josh Cartwright <joshc@linux.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/4] pinmux: add a driver for the U300 pinmux
Message-ID: <20110511024709.GA16868@kryptos.austin.rr.com>
References: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304363798-30409-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 09:16:38PM +0200, Linus Walleij wrote:
[]
> +
> +static int __init u300_pmx_probe(struct platform_device *pdev)
> +{
[]
> +	upmx->phybase = res->start;
> +	upmx->physize = resource_size(res);
> +
> +	if (request_mem_region(upmx->phybase, upmx->physize,
> +			       DRIVER_NAME) == NULL) {
> +		ret = -EBUSY;
> +		goto out_no_memregion;
> +	}
> +
> +	upmx->virtbase = ioremap(upmx->phybase, upmx->physize);
> +	if (!upmx->virtbase) {
> +		ret = -ENOMEM;
> +		goto out_no_remap;
> +	}
> +
> +	upmx->pmx = pinmux_register(&u300_pmx_desc, &pdev->dev, upmx);
> +	if (IS_ERR(upmx->pmx)) {
> +		ret = PTR_ERR(upmx->pmx);
> +		goto out_no_pmx;
> +	}
> +	platform_set_drvdata(pdev, upmx);
> +
> +	dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
> +
> +	return 0;
> +
> +out_no_pmx:
> +	iounmap(upmx->virtbase);
> +out_no_remap:
> +	platform_set_drvdata(pdev, NULL);
> +out_no_memregion:
> +	release_mem_region(upmx->phybase, SZ_4K);

release_mem_region(upmx->phybase, upmx->physize); ?

-- 
                           joshc
