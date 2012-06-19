Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2FSD0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 23:26:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44904 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2FSD0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 23:26:04 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
 <20110808081552.GI32513@linux-sh.org> <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
 <CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
 <4E40912C.5040801@codeaurora.org> <CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 19 Jun 2012 11:25:43 +0800
Message-ID: <CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Woo <richard.wu@lianlab.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
it seems people still use self-defined structure and APIs to set GPIO
pull, for example:

drivers/pinctrl/pinctrl-nomadik.c:

 48 /* Pull up/down values */
 49 enum nmk_gpio_pull {
 50         NMK_GPIO_PULL_NONE,
 51         NMK_GPIO_PULL_UP,
 52         NMK_GPIO_PULL_DOWN,
 53 };

int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)

or actually you mean use "pin_config_get" and "pin_config_set" with
self-defined configuration to set pull?

but i think at least the macros of GPIO_PULL_NONE, GPIO_PULL_UP and
GPIO_PULL_DOWN should be standardized.

2011/8/9 Linus Walleij <linus.walleij@linaro.org>
>
> On Tue, Aug 9, 2011 at 3:45 AM, Rohit Vaswani <rvaswani@codeaurora.org>
> wrote:
>
> > If we add this API - the remaining gpio controls like drive strength and
> > function select could also be added,
>
> I agree.
>
> > which eats into the pinmux domain.
>
> That's not so bad, since the pinctrl/pinmux subsystem is just a prototype
> people may want to wrap up their drivers into gpio_chip/gpiolib as
> they stand today to atleast get some isolation. Later on they can
> refactor and migrate to a pinctrl/pinmux subsystem.
>
> The latter will take some time to provide anyway, since I have been
> asked to restructure it so as not to use a global pin number space.
>
> > Linus W. had a patch earlier which added an API for a gpio config to be
> > specified through gpiolib. " gpio: add a custom configuration mechanism
> > to
> > gpiolib" which is sort of an extensible model of this API.
>
> Yes I think I have already suggested a bunch of ways to skin this
> cat but somehow none of them seem to win general approval.
>
> Yours,
> Linus Walleij

-barry
