Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1LFJ3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:29:35 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:28242 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1LFJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:29:33 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 17:42:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Message-ID: <20111206094203.GC3864@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322999384-7886-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 07:49:42PM +0800, Dong Aisheng wrote:
> +static struct pinmux_ops imx_pmx_ops = {
> +	.list_functions = imx_pmx_list_funcs,
> +	.get_function_name = imx_pmx_get_func_name,
> +	.get_function_groups = imx_pmx_get_groups,
> +	.enable = imx_pmx_enable,
> +};

The pinmux core code will check the pinmux_ops as below.  !ops->disable
is one of the checking, while you do not have .disable hook.

int pinmux_check_ops(const struct pinmux_ops *ops)
{
        /* Check that we implement required operations */
        if (!ops->list_functions ||
            !ops->get_function_name ||
            !ops->get_function_groups ||
            !ops->enable ||
            !ops->disable)
                return -EINVAL;

        return 0;
}

[...]

> +static int __init imx_pmx_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct imx_pmx *ipmx;
> +	struct resource *res;
> +	struct imx_pinctrl_info *info;
> +	resource_size_t res_size;
> +
> +	info = (struct imx_pinctrl_info *)pdev->id_entry->driver_data;
> +	if (!info || !info->pins || !info->groups || !info->functions
> +		|| (info->maxpin > info->npins)) {

You must mean !(info->maxpin > info->npins) here?

Regards,
Shawn

> +		dev_err(&pdev->dev, "wrong pinctrl info\n");
> +		return -EINVAL;
> +	}

