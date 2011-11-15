Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab1KOKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:21:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45675 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1KOKVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:21:08 -0500
X-AuditID: cbfee61a-b7cf1ae00000208e-eb-4ec23d09443d
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Peiyong Feng'" <peiyong.feng.kernel@gmail.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1321006467-15824-1-git-send-email-peiyong.feng.kernel@gmail.com>
 <CAJuYYwRueftNrWofo744vWXPa+vkgv3r4CyOr_Q_GNrcfct4YA@mail.gmail.com>
 <CAN_1RdvdeXHdM50utA8objg46Q2GM23pwzAiB7itswrTm1FqSQ@mail.gmail.com>
In-reply-to: <CAN_1RdvdeXHdM50utA8objg46Q2GM23pwzAiB7itswrTm1FqSQ@mail.gmail.com>
Subject: RE: [PATCH] Add dm9000 network support for OK6410 board.
Date: Tue, 15 Nov 2011 19:20:56 +0900
Message-id: <006201cca380$43998e20$caccaa60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acygd0cFgGt2vn54RW++u+fzI9X7KwDBpGkw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peiyong Feng wrote:
> 
Hi Peiyong,

Thanks for your submitting and replying.
But you need to make sure your e-mail uses text-typed instead of html before
replying.

And there are comments below.

> Well, The OK6410 board is based on smdk6410 board.
> And there many other boards that also are based on smdk6410 like mini6410
board.
>
> The reasons why I modified smdk6410 board file are as follows: 
> A. Almost all the devices on OK6410 is supported in smdk6410, and the
device drivers of smdk6410 can work well in OK6410.
>
Okay, you mean, just your OK6410 can work with smdk6410.

> B. If we just make other board file like mini6410 which is also based on
smdk6410, there maybe too many files that are as the same of smdk6410.
>
Okay, you mean, we don't need duplicated codes.

Right, but how do you think that if the dm9000 or something cannot be used
on smdk6410?
Nevertheless, we _really_ need to add it for other board not smdk6410?

Actually, there are codes for SMSC Lan9115 at mach-smdk6410.c......

If you want to use mach-smdk6410.c on your ok6410, well, let us think the
way.

> 2011/11/11 Thomas Abraham <thomas.abraham@linaro.org>
> On 11 November 2011 15:44, peiyong feng <peiyong.feng.kernel@gmail.com>
wrote:
> > Signed-off-by: peiyong feng <peiyong.feng.kernel@gmail.com>
> > ---
> >  arch/arm/mach-s3c64xx/mach-smdk6410.c |    1 +
> >  arch/arm/plat-samsung/devs.c          |   40
+++++++++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+), 0 deletions(-)
> If the change is intended for OK6410 board, any reason for modifying
> mach-smdk6410.c board file?
>
> >
> > diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c
b/arch/arm/mach-s3c64xx/mach-smdk6410.c
> > index 8bc8edd..71e817a 100644
> > --- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
> > +++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
> > @@ -276,6 +276,7 @@ static struct platform_device *smdk6410_devices[]
__initdata = {
> >        &s3c_device_fb,
> >        &s3c_device_ohci,
> >        &s3c_device_usb_hsotg,
> > +       &s3c_device_dm9000,
> >        &samsung_asoc_dma,
> >        &s3c64xx_device_iisv4,
> >        &samsung_device_keypad,
> > diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
> > index 4ca8b57..38edc1a 100644
> > --- a/arch/arm/plat-samsung/devs.c
> > +++ b/arch/arm/plat-samsung/devs.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/mtd/partitions.h>
> >  #include <linux/mmc/host.h>
> > #include <linux/ioport.h>
> > +#include <linux/dm9000.h>
> >
> >  #include <asm/irq.h>
> >  #include <asm/pmu.h>
> > @@ -1401,6 +1402,45 @@ void __init s5p_ehci_set_platdata(struct
s5p_ehci_platdata *pd)
> >  }
> >  #endif /* CONFIG_S5P_DEV_USB_EHCI */
> >
> > +/* Ethernet */
> > +#ifdef CONFIG_DM9000
> > +#define S3C64XX_PA_DM9000      (0x18000000)
> > +#define S3C64XX_SZ_DM9000      SZ_1M
> > +#define S3C64XX_VA_DM9000      S3C_ADDR(0x03b00300)
> There could be other boards based on other samsung soc's which would
> be using dm9000. So arch/arm/plat-samsung/devs.c might not be correct
> place for these additions. And, there is S3C64XX_PA_XM0CSN0 in
> mach-s3c64xx/include/mach/map.h which should be reused instead of
> these new macros.
>
Yes right.

Peiyong, you need to think that your codes affect others or not before
submitting.

> Please refer to other board files in arch/arm/mach-s3c64xx for
> reference on adding dm9000 support for OK6410 board.
>
> Regards,
> Thomas.
>
> > +
> > +static struct resource dm9000_resources[] = {
> > +       [0] = {
> > +               .start          = S3C64XX_PA_DM9000,
> > +               .end            = S3C64XX_PA_DM9000 + 3,

What is '3'?

> > +               .flags          = IORESOURCE_MEM,

And you can use DEFINE_RES_MEM macro here.

(snip)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

