Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab1LOI26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:28:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56989 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1LOI25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:28:57 -0500
MIME-Version: 1.0
In-Reply-To: <7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-5-git-send-email-b29396@freescale.com>
	<20111214211152.GM27267@pengutronix.de>
	<CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
	<7FE21149F4667147B645348EC60578850561FF@039-SN2MPN1-013.039d.mgd.msft.net>
Date: Thu, 15 Dec 2011 09:28:56 +0100
Message-ID: <CACRpkda-hzrgQ7YttN3Vi3E6jTv-LaQDyAqyJjdvqYDL+C50XA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 8:23 AM, Dong Aisheng-B29396
<B29396@freescale.com> wrote:
> [Me]
>> So if you want to do this for i.MX you need something like selectable
>> dummy pinmuxes, i.e. pinmux_get() to return something that just say "OK"
>> to everything like the dummy regulators.
>>
>> Shall I try to create something like that?
>
> For those platforms do not select PINCTRL, current code does not block.

Yeah I know...

> For platforms do select PINCTRL but does not have pinmux driver ready,
> for example, single image for both mx5&mx6,
> IMHO it may be better to fix in driver to avoid introduce too much
> complexity in pinctrl core.

If you mean that you fix the i.MX driver for all the combines i.MX variants
then I agree.

If you mean to do stuff like allow the code to continue even if the pinmux
isn't found - no. That is not the way we proceed with clocks and
regulators as Mark has taught me recently, so for consistency we
need to error out if no pinmux is found.

Thanks,
Linus Walleij
