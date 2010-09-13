Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0IMHoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:44:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0IMHoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=cpu1S5uCwgDipQ0uzyfTeXlVImCR+iq28pHGg7HtyTTin0lbnXhyOn9VEVcBScjAeW
         xcrJMmEK0QURW/fUdwOlQnORdLJ9XIdNvnjwAAMo3uDCYyUchylVQwLsJF+FSsoqEpy/
         v7+G3piiq1MpPauxojDE/9WJtDF7HGuBJCoxs=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: pxa168/teton bga: add board support for i2c and rtc-ds1337
Date: Mon, 13 Sep 2010 09:44:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Mark F. Brown" <mark.brown314@gmail.com>, eric.y.miao@gmail.com,
        haojian.zhuang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, markb@marvell.com
References: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com> <1284349896-14545-4-git-send-email-mark.brown314@gmail.com> <AANLkTikEnw2OwJ73NJg1WdSSYF8EXAdbd-HUteDjaqRm@mail.gmail.com>
In-Reply-To: <AANLkTikEnw2OwJ73NJg1WdSSYF8EXAdbd-HUteDjaqRm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009130944.12792.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 13. září 2010 07:34:36 Haojian Zhuang napsal(a):
> On Mon, Sep 13, 2010 at 11:51 AM, Mark F. Brown <mark.brown314@gmail.com> 
wrote:
> > Defined I2C/ALARM pin definitions
> > DS1337 RTC alarm support is tied to RTC_INT_GPIO
> > 
> > Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> > ---
> >  arch/arm/mach-mmp/teton_bga.c |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-mmp/teton_bga.c
> > b/arch/arm/mach-mmp/teton_bga.c index 2966117..d631bbc 100644
> > --- a/arch/arm/mach-mmp/teton_bga.c
> > +++ b/arch/arm/mach-mmp/teton_bga.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/gpio.h>
> >  #include <linux/input.h>
> >  #include <plat/pxa27x_keypad.h>
> > +#include <linux/i2c.h>
> > 
> >  #include <asm/mach-types.h>
> >  #include <asm/mach/arch.h>
> > @@ -38,6 +39,13 @@ static unsigned long teton_bga_pin_config[] __initdata
> > = { GPIO110_KP_MKIN0,
> >        GPIO111_KP_MKOUT7,
> >        GPIO112_KP_MKOUT6,
> > +
> > +       /* I2C Bus */
> > +       GPIO105_CI2C_SDA,
> > +       GPIO106_CI2C_SCL,
> > +
> > +       /* RTC */
> > +       GPIO78_GPIO,
> >  };
> > 
> >  static unsigned int teton_bga_matrix_key_map[] = {
> > @@ -55,6 +63,13 @@ static struct pxa27x_keypad_platform_data
> > teton_bga_keypad_info __initdata = { .debounce_interval      = 30,
> >  };
> > 
> > +static struct i2c_board_info teton_bga_i2c_info[] __initdata = {
> > +       {
> > +               I2C_BOARD_INFO("ds1337", 0x68),
> > +               .irq = gpio_to_irq(RTC_INT_GPIO)
> > +       },
> > +};
> > +
> >  static void __init teton_bga_init(void)
> >  {
> >        mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
> > @@ -62,6 +77,7 @@ static void __init teton_bga_init(void)
> >        /* on-chip devices */
> >        pxa168_add_uart(1);
> >        pxa168_add_keypad(&teton_bga_keypad_info);
> > +       pxa168_add_twsi(0, NULL, ARRAY_AND_SIZE(teton_bga_i2c_info));
> >  }
> > 
> >  MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
> > --
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> Acked

Yes, they look good:

Acked-by: Marek Vasut <marek.vasut@gmail.com>
