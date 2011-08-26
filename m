Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1HZB7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 21:59:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46348 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1HZB7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
References: <1313747619-32222-1-git-send-email-linus.walleij@stericsson.com>
 <CAGsJ_4z7s-ibmUuR1DA6Jps030dRrnE8M0dUWHoMhMPFtyyY_A@mail.gmail.com> <CACRpkdb4-0TfO-viUoZyW3VoLnVuo2ztHTX=8Hef3_RYWB52vg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 26 Aug 2011 09:58:39 +0800
Message-ID: <CAGsJ_4yEXEajH1JyNjnYE0hg13Fgd7bdiMNFs2fp6Ou=h_9N9g@mail.gmail.com>
Subject: Re: [PATCH 0/4 v4] pin controller subsystem v4
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/22 Linus Walleij <linus.walleij@linaro.org>:
> On Sun, Aug 21, 2011 at 4:42 PM, Barry Song <21cnbao@gmail.com> wrote:
>
>> it seems there is not an actual example that gpio requests pin from
>> pinctrl yet. i might give one on SiRFprimaII.
>
> No good example yet, no.
>
> The reason is that for the U300 that I use as guinea pig, the
> GPIO driver is tangled up in discussions about how to handle
> the special control mechanics like requesting muxing and
> biasing pins. Right now it seems easier to rewrite all that
> to use the new pinctrl subsystem rather than actually trying
> to work it into the GPIO subsystem first and refactor from
> there, and that needs quite a bit of upfront work...

Do you want the pinmux_request_gpio called by the gpiolib driver or by
every device driver who uses this gpio?
Do you think the following make sense in gpiolib driver?
static int xxx_gpio_request(struct gpio_chip *chip, unsigned offset)
{
        int ret = 0;

        ret = pinmux_request_gpio(chip->base + offset);
        if (ret)
                goto out;
        .....
out:
        return ret;
}


>
> Linus Walleij
>

Thanks
Barry
