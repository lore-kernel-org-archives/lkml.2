Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2G3IEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:04:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2G3IEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:04:49 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-b9-5016401f42f1
From: =?ks_c_5601-1987?B?udq787z2?= <sangsu4u.park@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Sean Paul'" <seanpaul@chromium.org>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: <1342817939-7118-1-git-send-email-seanpaul@chromium.org>
 <CAD=FV=W8oqytNM0xSHbceTEy6gAdr_Lmm7zWqogcwAPJR6jKSg@mail.gmail.com>
In-reply-to: <CAD=FV=W8oqytNM0xSHbceTEy6gAdr_Lmm7zWqogcwAPJR6jKSg@mail.gmail.com>
Subject: RE: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
Date: Mon, 30 Jul 2012 17:04:47 +0900
Message-id: <000001cd6e29$fcb4bc30$f61e3490$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK4SgvX1PG0VpVfqgzTsWJXTxDp4QJ2WJBhlVgMzYA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV15B7EAg10/jCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvzu/mQtuiFbMn/WYuYFxDl8XIyeHhICJxOwX21ggbDGJC/fW
	s4HYQgKLGCV+dEZ2MXIB2fOZJNZe3g6U4OBgE7CX2LqSEaRGRCBA4syUk0wgNrPAcUaJ5StM
	IOq7GSW6Pi1mBklwCgRLNDzsBWsQFvCQOHX5NCuIzSKgKrHjcQsjyExeAUuJjU9dQcK8AoIS
	PybfY4GYaSDxflYfK4QtL7F5zVtmiDsVJHacfQ11g5VE98yTbBA1IhL7XrxjnMAoNAvJqFlI
	Rs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLD+JnUDsaVDRaHGAU4GJV4
	eA0viwYIsSaWFVfmHmKU4GBWEuGdJCIWIMSbklhZlVqUH19UmpNafIhRmoNFSZzX2Purv5BA
	emJJanZqakFqEUyWiYNTqoGxun2PpMKmDMOlO4v/yC5YXXztzIqpJbfLgue2nEkyLs2+muq4
	aee0sCOJ31fd+tVrHVayu17ujZnkvYTP+r/0pUvXHpiyOXlqkuTjFtdXi6+u/qP79dQsVT1G
	icmyDJcX+s2YcqakrHONjVjLTvbn/Taq5bttwu5Ji/Hd25GmJ7btY8+7vPmnlViKMxINtZiL
	ihMBOQgdl18CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: dianders@google.com [mailto:dianders@google.com] On Behalf Of Doug Anderson
> Sent: Saturday, July 21, 2012 6:07 AM
> To: Sean Paul
> Cc: grant.likely@secretlab.ca; linus.walleij@stericsson.com; linux-kernel@vger.kernel.org;
> olofj@chromium.org; Sangsu Park; Thomas Abraham; Kukjin Kim
> Subject: Re: [PATCH] gpio: samsung: Fix off-by-one bug in gpio addresses
> 
> Acked-by: Doug Anderson <dianders@chromium.org>
> 
> ---
> 
> On Fri, Jul 20, 2012 at 1:58 PM, Sean Paul <seanpaul@chromium.org> wrote:
> >
> > Move gpc4 to the end of the automatically processed gpio controllers
> > so we don't taint the automatic offset calculation.
> >
> > This bug caused all controllers coming after gpc4 to map to the
> > incorrect address. The result is <&gpd1 0 0 0 0> would actually map to
> > GPIO 0 in gpd0.
> >
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > ---
> >  drivers/gpio/gpio-samsung.c |   14 +++++++-------
> >  1 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> > index b6453d0..e4599b4 100644
> > --- a/drivers/gpio/gpio-samsung.c
> > +++ b/drivers/gpio/gpio-samsung.c
> > @@ -2454,12 +2454,6 @@ static struct samsung_gpio_chip exynos5_gpios_1[] = {
> >                 },
> >         }, {
> >                 .chip   = {
> > -                       .base   = EXYNOS5_GPC4(0),
> > -                       .ngpio  = EXYNOS5_GPIO_C4_NR,
> > -                       .label  = "GPC4",
> > -               },
> > -       }, {
> > -               .chip   = {
> >                         .base   = EXYNOS5_GPD0(0),
> >                         .ngpio  = EXYNOS5_GPIO_D0_NR,
> >                         .label  = "GPD0", @@ -2513,6 +2507,12 @@
> > static struct samsung_gpio_chip exynos5_gpios_1[] = {
> >                         .label  = "GPY6",
> >                 },
> >         }, {
> > +               .chip   = {
> > +                       .base   = EXYNOS5_GPC4(0),
> > +                       .ngpio  = EXYNOS5_GPIO_C4_NR,
> > +                       .label  = "GPC4",
> > +               },
> > +       }, {
> >                 .config = &samsung_gpio_cfgs[9],
> >                 .irq_base = IRQ_EINT(0),
> >                 .chip   = {
> > @@ -2833,7 +2833,7 @@ static __init void exynos5_gpiolib_init(void)
> >         }
> >
> >         /* need to set base address for gpc4 */
> > -       exynos5_gpios_1[11].base = gpio_base1 + 0x2E0;
> > +       exynos5_gpios_1[20].base = gpio_base1 + 0x2E0;
> >
> >         /* need to set base address for gpx */
> >         chip = &exynos5_gpios_1[21];
> > --
> > 1.7.7.3
> >

I think that this modification is right.
Thanks.

