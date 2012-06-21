Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2FUHtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:49:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2FUHtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:49:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120620143140.GA7817@linux-sh.org>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
	<20110808081552.GI32513@linux-sh.org>
	<CACxGe6ssT4=kxApaKhv+=7nDcEFVW+oyByFQ_hzcfyZ4gw2C3g@mail.gmail.com>
	<CAH9JG2V-66Wn7nwJz6tOkESoQAUJzAg-47YeMY0vzwu6T9O=Rg@mail.gmail.com>
	<4E40912C.5040801@codeaurora.org>
	<CACRpkdZUxYP0Mbe+heEwrZE5VC+J42g_-QAusrOsUuBPT324Hw@mail.gmail.com>
	<CAGsJ_4y38KBDfjZS_k-QfDUUFAtEwE-ciUgNOA0U2juOBeoXEA@mail.gmail.com>
	<CACRpkdazTKs_sNHVkVAYdz6CK9fwghf2n-Rrs7fi7R1Z=Gt+3w@mail.gmail.com>
	<20120620143140.GA7817@linux-sh.org>
Date: Thu, 21 Jun 2012 09:48:59 +0200
Message-ID: <CACRpkdZE45cSUTKBfJ=sqmw35MG1f_2s=Jyh350QXpATT_wFxQ@mail.gmail.com>
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Barry Song <21cnbao@gmail.com>, Rohit Vaswani <rvaswani@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Woo <richard.wu@lianlab.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 4:31 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Jun 20, 2012 at 10:15:01AM +0200, Linus Walleij wrote:
>> On Tue, Jun 19, 2012 at 5:25 AM, Barry Song <21cnbao@gmail.com> wrote:
>> > but i think at least the macros of GPIO_PULL_NONE, GPIO_PULL_UP and
>> > GPIO_PULL_DOWN should be standardized.
>>
>> You find an attempt at standardization in drivers/pinctrl/pinconf-generic.c
>> which is also used by the composite U300+COH901 drivers. Drivers
>> can select this support library and use the flags from
>> <linux/pinctrl/pinconf-generic.h>
>>
> What's with PIN_CONFIG_END using such an insane value?

This: PIN_CONFIG_END = 0x7FFF

It's just that I reserved 16 bits for the different stuff, and then
the bitstuffing
functions below use 16 bits for this. If it's too much we can shrink
it.

> I'm happy to consolidate on the provided definitions and add my own on top
> of that, but I'm not going to waste an insane amount of bits that I could
> be using for driver-specific data and so on instead to comply with the
> PIN_CONFIG_END comment. Is there any valid reason why this would ever
> need to exceed 4 bits?

I think we need more than 4 bits for sure, but not more than 8.

If you want to patch it down to have 8 bits for the param and 24 bits
for the argument, go ahead, it won't hurt.

Yours,
Linus Walleij
