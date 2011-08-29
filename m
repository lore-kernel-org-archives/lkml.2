Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1H2L7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:59:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1H2L7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:59:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYmmY8ycBUL70ERawumSMdZEORYsmMBxBxZxchcfMS7EA@mail.gmail.com>
References: <1314329782-17238-1-git-send-email-Baohua.Song@csr.com> <CACRpkdYmmY8ycBUL70ERawumSMdZEORYsmMBxBxZxchcfMS7EA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 29 Aug 2011 19:58:53 +0800
Message-ID: <CAGsJ_4xXMx7_G2ADJF-s4Xws4k4XqBnE3eysokd66ogdb=jbOA@mail.gmail.com>
Subject: Re: [PATCH] pinmux: add a driver for the CSR SiRFprimaII pinmux
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <Baohua.Song@csr.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        grant.likely@secretlab.ca, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Thanks !

2011/8/29 Linus Walleij <linus.walleij@linaro.org>
>
> On Fri, Aug 26, 2011 at 5:36 AM, Barry Song <Baohua.Song@csr.com> wrote:
>
> > Though there are still many discussions about data model and device/function
> > mapping, pinmux core is basically usable to CSR SiRFprimaII for the moment.
> >
> > This patch is another example to use Linus W's pinmux framework.
> >
> > Tests by this example show basic pinmux APIs like pinmux_get, pinmux_enable,
> > pinmux_disable and pinmux_put are able to work in Linus W's patch v4.
>
> Thanks a lot Barry, if you rebase this to the v5 patch set I can probably
> carry it as part of my set.

i'll rebase it to your v5 and make some tests.

>
> > diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_platform.h>
>
> It's especially nice to see these DT-bindings!
>
> > +static const struct sirfsoc_muxmask lcd_16bits_sirfsoc_muxmask[] = {
> > +       {
> > +               .group = 3,
> > +               .mask = 0x7FFFF,
>
> These things look a bit magic...

register seems to be magic by itself. this is register set mask of
group 3 for LCD. group in the structure is also an offset of register
layout.

>
> Maybe: #define SIRFSOC_PMX_ALLBITS 0x7FFFF

0x7fff is only for all LCD. maybe "#define SIRFSOC_LCD_GROUP3_MASK
0x7FFFF". that seems ugly too :-)

> (Just a suggestion)
>
> > +       }, {
> > +               .group = 2,
> > +               .mask = 1 << 31,
>
> This too.
>
> To make it clearer:
>
> #include <linux/bitops.h>
>
> .mask = BIT(31),

agree

>
> > +       },
> > +};
> > +
> > +static const struct sirfsoc_padmux lcd_16bits_padmux = {
> > +       .muxmask_counts = ARRAY_SIZE(lcd_16bits_sirfsoc_muxmask),
> > +       .muxmask = lcd_16bits_sirfsoc_muxmask,
> > +       .funcmask = 1 << 4,
> > +       .funcval = 0 << 4,
>
> BIT(1)

agree

> BIT(0)
>
> > +};
> > +
> > +static const unsigned lcd_16bits_pins[] = { 95, 96, 97, 98, 99, 100, 101, 102, 103, 104,
> > +       105, 106, 107, 108, 109, 110, 111, 112, 113, 114 };
> > +
> > +static const struct sirfsoc_muxmask lcd_18bits_muxmask[] = {
> > +       {
> > +               .group = 3,
> > +               .mask = 0x7FFFF,
> > +       }, {
> > +               .group = 2,
> > +               .mask = 1 << 31,
>
> BIT(31)
>
> > +       }, {
> > +               .group = 0,
> > +               .mask = (1 << 16) | (1 << 17),
>
> BIT(16)|BIT(17)
>
> (etc)
>
agree

> > +static int sirfsoc_pinmux_enable(struct pinctrl_dev *pmxdev, unsigned selector)
>
> These will have an optional "position" parameter now, which you can
> ignore for this simple driver. (Compare U300 pinmux v5).

ok.

>
> > +{
> > +       struct sirfsoc_pmx *upmx;
>
> I think "upmx" = U300 padmux :-D
>
> Maybe rename it something like spmx or so, globally...

could be.


>
> Yours,
> Linus Walleij
>

-barry
