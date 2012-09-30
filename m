Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2I3I3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:29:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55988 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2I3I25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <1348574622-11632-1-git-send-email-zhangwm@marvell.com>
References: <1348574622-11632-1-git-send-email-zhangwm@marvell.com>
Date: Sun, 30 Sep 2012 10:28:55 +0200
Message-ID: <CACRpkdaL_EbGxBknoQMnnHCND=AKyY+qBZ5pTBC+-dVC2Ab4ZQ@mail.gmail.com>
Subject: Re: [PATCH] GPIO: gpio-pxa: fix bug when get gpio value
From: Linus Walleij <linus.walleij@linaro.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: grant.likely@secretlab.ca, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 2:03 PM, Neil Zhang <zhangwm@marvell.com> wrote:

> We need to return 0 or 1 when get gpio value.

OK...

>  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> -       return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 << offset);
> +       u32 gplr = __raw_readl(gpio_chip_base(chip) + GPLR_OFFSET);
> +       u32 mask = 1 << offset;
> +
> +       return (gplr & mask) != 0;

So why are you switching the perfectly working readl_relaxed() call to
a __raw_readl()?

Please don't do this, and respin the patch.

Yours,
Linus Walleij
