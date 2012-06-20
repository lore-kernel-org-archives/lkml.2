Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2FTKID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:08:03 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41546 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FTKIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:08:01 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
 <20110808081552.GI32513@linux-sh.org> <CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
 <CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
 <4E40912C.5040801@codeaurora.org> <CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
 <CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com> <CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 20 Jun 2012 18:07:40 +0800
Message-ID: <CAGsJ_4xuoxgKbSdhkMYadiJTK141-BB13F8cRvo6qny_wzOHDA@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Woo <richard.wu@lianlab.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

2012/6/20 Linus Walleij <linus.walleij@linaro.org>:
> On Tue, Jun 19, 2012 at 5:25 AM, Barry Song <21cnbao@gmail.com> wrote:
>
>> it seems people still use self-defined structure and APIs to set GPIO
>> pull,
>
> Yes. They came into existance before the pinctrl subsystem was invented.
>
>> int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
>
> Yes, that is one example...
>
>> or actually you mean use "pin_config_get" and "pin_config_set" with
>> self-defined configuration to set pull?
>
> I don't quite undertand this part of question, can you elaborate?
>

i just want to make sure whether these two functions are provided to
support for users to set pin config dynamically.
for example, one driver might get GPIO number from DT and set
PIN_CONFIG_BIAS_xxx by pin_config_set() after that.
until now, no real driver has called pin_config_set(), so i am not sure....

> The idea is to move this driver over to using the pinctrl API and
> delete these functions (or atleast make them static so they are only
> used inside the driver itself).
>
> It's taking time since legacy code needs to be handled carefully
> and tested on various hardware, sorry for that, but I'm onto it.
>
>> but i think at least the macros of GPIO_PULL_NONE, GPIO_PULL_UP and
>> GPIO_PULL_DOWN should be standardized.
>
> You find an attempt at standardization in drivers/pinctrl/pinconf-generic.c
> which is also used by the composite U300+COH901 drivers. Drivers
> can select this support library and use the flags from
> <linux/pinctrl/pinconf-generic.h>
>
> The reason that it's not mandated and some modern SoCs use their
> own custom definitions was that it was impossible at the time to
> reach consensus (review the mailing list for the discussion, but
> mainly it was Mark Brow's arguments that made me give up the
> general approach).

Thanks for update. i am sorry recently i have missed many discussions ~^。^~
i guess the generic pin_config_param should be able to cover most cases.

>
> So currently this support lib is available if your pin configs are
> simple, if they are complex you can cook your own (like many
> drivers do).
>
> Yours,
> Linus Walleij

-barry
