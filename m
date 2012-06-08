Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132Ab2FHQj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:39:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53182 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:39:25 -0400
Message-ID: <4FD22ABA.6010607@wwwdotorg.org>
Date: Fri, 08 Jun 2012 10:39:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl/nomadik: add STn8815 ASIC support
References: <1339146426-20697-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1339146426-20697-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 03:07 AM, Linus Walleij wrote:
> This adds support for the STN8815 ASIC for the Nomadik pin
> controller.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> @@ -1717,6 +1717,8 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>  			of_match_device(nmk_pinctrl_match, &pdev->dev)->data;
>  
>  	/* Poke in other ASIC variants here */
> +	if (version == PINCTRL_NMK_STN8815)
> +		nmk_pinctrl_stn8815_init(&npct->soc);
>  	if (version == PINCTRL_NMK_DB8500)
>  		nmk_pinctrl_db8500_init(&npct->soc);

One comment that came up in other reviews is that we shouldn't have a
single driver that switches on the SoC type it's running on and then
dispatches to different ${soc}_init() functions, but rather should have
multiple separate drivers, where each probe calls some utility function
with the appropriate SoC parameterization structures/tables.

IIRC, it was SPEAr, and I appear to have already converted Tegra to that
scheme.

Should we do the same conversion for nomadik too?

Aside from that, the series looks fine.
