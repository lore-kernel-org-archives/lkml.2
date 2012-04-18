Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab2DRNwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:52:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61245 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2DRNwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120418122832.GP20478@pengutronix.de>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
	<4F8C42D6.2000607@wwwdotorg.org>
	<20120417034210.GD17173@shlinux2.ap.freescale.net>
	<CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>
	<20120418122832.GP20478@pengutronix.de>
Date: Wed, 18 Apr 2012 15:52:23 +0200
Message-ID: <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 2:28 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Currently Dong Aisheng is working on i.MX6, we have i.MX31, i.MX35,
> i.MX51 and i.MX53 enabled in the same defconfig. Waiting for all
> machines turn over at once to pinctrl is illusionary. We have to make
> drivers work with and without pinctrl. We have a bunch of bad choices:
>
> - create a dummy pinctrl for all boards which do not have real pinmux
>  support

Viable compromise.

> - ignore pinctrl_request errors in drivers.

Ugh. Not good.

> - generate and return a dummy pinctrl in the core if no real pinctrl is
>  found.
>
> (replace pinctrl with regulators or clocks, it's the same situation, and
> it's not only i.MX specific)

Since we have dummy regulators, we should not break the design
pattern creating more confusion.

Stephen can you live with dummy pinctrl handles emitted by the
core, if explictly enabled by a Kconfig option?

Yours,
Linus Walleij
