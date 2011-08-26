Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1HZH5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:57:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56756 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1HZH5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
	<CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com>
	<CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
	<CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
Date: Fri, 26 Aug 2011 09:57:49 +0200
Message-ID: <CACRpkdba4XM7Wr61pjXnBpgJY=U1F-772_ArfPDhjpRVd1NFUA@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] pin controller subsystem v4
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 3:58 AM, Barry Song <21cnbao@gmail.com> wrote:

> Do you want the pinmux_request_gpio called by the gpiolib driver or by
> every device driver who uses this gpio?

I always thought about the gpiolib driver.

I think Grant told me he wanted drivers with combined GPIO and
pinmuxing to reside in drivers/pinctrl and expose an additional
gpiolib interface.

> Do you think the following make sense in gpiolib driver?
> static int xxx_gpio_request(struct gpio_chip *chip, unsigned offset)
> {
>        int ret = 0;
>
>        ret = pinmux_request_gpio(chip->base + offset);
>        if (ret)
>                goto out;
>        .....
> out:
>        return ret;
> }

Looks sane to me. It's a bit unfortunate to have to subtract
the base and then add it again before passing to pinmux but
the idea is to drop the global GPIO pinspace down the road
and then it makes more sense.

Yours,
Linus Walleij
