Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2FTIPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:15:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48899 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab2FTIPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
	<CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
	<4E40912C.5040801@codeaurora.org>
	<CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
	<CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com>
Date: Wed, 20 Jun 2012 10:15:01 +0200
Message-ID: <CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Woo <richard.wu@lianlab.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 5:25 AM, Barry Song <21cnbao@gmail.com> wrote:

> it seems people still use self-defined structure and APIs to set GPIO
> pull,

Yes. They came into existance before the pinctrl subsystem was invented.

> int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)

Yes, that is one example...

> or actually you mean use "pin_config_get" and "pin_config_set" with
> self-defined configuration to set pull?

I don't quite undertand this part of question, can you elaborate?

The idea is to move this driver over to using the pinctrl API and
delete these functions (or atleast make them static so they are only
used inside the driver itself).

It's taking time since legacy code needs to be handled carefully
and tested on various hardware, sorry for that, but I'm onto it.

> but i think at least the macros of GPIO_PULL_NONE, GPIO_PULL_UP and
> GPIO_PULL_DOWN should be standardized.

You find an attempt at standardization in drivers/pinctrl/pinconf-generic.c
which is also used by the composite U300+COH901 drivers. Drivers
can select this support library and use the flags from
<linux/pinctrl/pinconf-generic.h>

The reason that it's not mandated and some modern SoCs use their
own custom definitions was that it was impossible at the time to
reach consensus (review the mailing list for the discussion, but
mainly it was Mark Brow's arguments that made me give up the
general approach).

So currently this support lib is available if your pin configs are
simple, if they are complex you can cook your own (like many
drivers do).

Yours,
Linus Walleij
