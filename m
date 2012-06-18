Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab2FRL4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:56:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47995 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2FRL4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:56:19 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix> <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 18 Jun 2012 19:55:59 +0800
Message-ID: <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to regulator_[is_enabled|get_voltage_sel]_regmap
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Basically regmap pointer is missed out in runtime configutaion data. Without this we
> can see NULL pointer exception because config.regmap is NULL.
>
> +       config.regmap = tps->regmap;
>
Since this patch is target for 3.6, this is not required.
The regulator core will set it automatically.
In drivers/regulator/core.c
        if (config->regmap)
                rdev->regmap = config->regmap;
        else
                rdev->regmap = dev_get_regmap(dev, NULL);


Regards,
Axel
