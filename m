Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080Ab2EIUe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:34:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51613 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2EIUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:34:55 -0400
Message-ID: <4FAAD4EB.4010007@wwwdotorg.org>
Date: Wed, 09 May 2012 14:34:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 02/12] pinctrl: basic Nomadik pinctrl interface
References: <1336470270-23518-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336470270-23518-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 03:44 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This adds a scratch pin control interface to the Nomadik pinctrl
> driver, and defines the pins and groups in the DB8500 ASIC. We
> define GPIO ranges to cover the pins exposed. The DB8500 has
> more pins than this but we restrict the driver to the pins that
> can be controlled from the combined GPIO and pin control hardware
> to begin with.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> +static int nmk_list_groups(struct pinctrl_dev *pctldev, unsigned selector)
> +{
> +	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
> +
> +	if (selector >= npct->soc->ngroups)
> +		return -EINVAL;

I think all the other drivers removed this error-checking from functions
called by the pinctrl core, assuming that the core would error-check any
user-supplied data and respect limits in the pinctrl device descriptor.

> +static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)

> +	/* Poke in other ASIC variants here */
> +	if (platid->driver_data == PINCTRL_NMK_DB8500)
> +		nmk_pinctrl_db8500_init(&npct->soc);

Other platforms have a unique top-level driver for each variant, with
the probe() function for each variant calling into a utility function.
That way, the common/utility code doesn't need to contain a
table/list/... of all the variants. Can the same approach be used here?
