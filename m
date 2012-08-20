Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2HTOZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:25:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46195 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2HTOZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-5-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-5-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 16:25:05 +0200
Message-ID: <CACRpkdYNZar7865-T12J37h3AWA9-8R1R5tymuOhaB0b3ddEAA@mail.gmail.com>
Subject: Re: [PATCH 04/11] pinctrl: mvebu: add pinctrl driver for Armada 370
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This pinctrl driver is not a full-blown pinctrl driver from scratch:
> it relies on the common pinctrl-mvebu driver, which is used for all
> Marvell EBU SoCs.

Good!

> +config PINCTRL_ARMADA_370
> +       bool "Support for Marvell Armada 370 SoCs"
> +       depends on PINCTRL_MVEBU
> +       depends on MACH_ARMADA_370_XP

select PINCTRL_MVEBU simply?

And then have the Armada Kconfig

select PINCTRL
select PINCTRL_ARMADA_370

This machine doesn't seem to depend in the MVEBU driver, I guess it's
the same ARCH as something else, oh well. Still suspect the
MVEBU driver should depend on PLAT_ORION until proven
wrong.

(...)
> +static int __devinit armada_370_pinctrl_probe(struct platform_device *pdev)
> +{
> +       struct mvebu_pinctrl_soc_info *soc = &armada_370_pinctrl_info;
> +
> +       soc->variant = 0;

Shouldn't this be a #defined thing or something. "variant 0" doesn't
tell me much.

No further comments, looking good.

Yours,
Linus Walleij
