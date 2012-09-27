Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2I0BZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:25:19 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:42495 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab2I0BZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:25:17 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Sep 2012 18:25:02 -0700
Subject: RE: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
Thread-Topic: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
Thread-Index: Ac2bslu0yKips0u5Re+y5gs0VkM0vgAmoZxg
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE1B63A6AB24@SC-VEXCH4.marvell.com>
References: <1348624007-16634-1-git-send-email-zhangwm@marvell.com>
 <CAN1soZzoCHwrDiQEW7sBL3Tj8fc=yqh2Sbi=eZeqi7iTJjAZsQ@mail.gmail.com>
In-Reply-To: <CAN1soZzoCHwrDiQEW7sBL3Tj8fc=yqh2Sbi=eZeqi7iTJjAZsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8R1PbAH002361


> -----Original Message-----
> From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
> Sent: 2012Äê9ÔÂ26ÈÕ 14:44
> To: Neil Zhang
> Cc: grant.likely@secretlab.ca; linus.walleij@linaro.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH V2] GPIO: gpio-pxa: fix bug when get gpio value
> 
> On Wed, Sep 26, 2012 at 9:46 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> > We need to return 0 or 1 when get gpio value.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  drivers/gpio/gpio-pxa.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
> > index 9cac88a..3c9dc8c 100644
> > --- a/drivers/gpio/gpio-pxa.c
> > +++ b/drivers/gpio/gpio-pxa.c
> > @@ -269,7 +269,9 @@ static int pxa_gpio_direction_output(struct gpio_chip
> *chip,
> >
> >  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
> >  {
> > -       return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 <<
> offset);
> > +       u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
> > +
> > +       return (gplr & (1 << offset)) ? 1 : 0;
> >  }
> >
> >  static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int
> value)
> > --
> > 1.7.4.1
> >
> 
> gpio_get_value() is used to dump bits from GPLR register in mach-pxa
> directory.
> Unless you update those code at the same time, this patch can't be merged.
> 
It's a big change, I will do it when I have time.

> Regards
> Haojian

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
