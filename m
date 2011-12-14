Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab1LNWPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:15:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1LNWPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <20111214211152.GM27267@pengutronix.de>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
Date: Wed, 14 Dec 2011 23:15:53 +0100
Message-ID: <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dong Aisheng <b29396@freescale.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, shawn.guo@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:11 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:

>> +     pmx = pinmux_get(&pdev->dev, NULL);
>> +     if (IS_ERR(pmx)) {
>> +             err = PTR_ERR(pmx);
>> +             goto err_pmx_get;
>> +     }
>> +     err = pinmux_enable(pmx);
>> +     if (err)
>> +             goto err_pmx_enable;
>> +     imx_data->pmx = pmx;
>> +
>
> Won't this break every i.MX except i.MX6?

Not this patch on its own, first the machines have to
select PINCTRL
select PINMUX_FOO

*Then* it will break :-D

So if you want to do this for i.MX you need something like
selectable dummy pinmuxes, i.e. pinmux_get() to return something
that just say "OK" to everything like the dummy regulators.

Shall I try to create something like that?

Yours,
Linus Walleij
