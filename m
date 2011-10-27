Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1J0P7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:59:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7795 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab1J0P7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:59:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 27 Oct 2011 08:59:44 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Belisko Marek <marek.belisko@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Oct 2011 08:59:43 -0700
Subject: RE: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
Thread-Topic: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
Thread-Index: AcyUb34cPlGpjUaUSpel9CoACzcRAAAUPoZQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B48AB@HQMAIL01.nvidia.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
	<1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
	<alpine.DEB.2.00.1110261405400.23111@chino.kir.corp.google.com>
 <CAAfyv35KsspWGAkmZmZOaDw5v3tngKuV8YqQ_fvZU4azHCUtYA@mail.gmail.com>
In-Reply-To: <CAAfyv35KsspWGAkmZmZOaDw5v3tngKuV8YqQ_fvZU4azHCUtYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9RFxxSr024412

Belisko Marek wrote at Thursday, October 27, 2011 12:13 AM:
> On Wed, Oct 26, 2011 at 11:06 PM, David Rientjes <rientjes@google.com> wrote:
> > On Wed, 26 Oct 2011, Marek Belisko wrote:
> >
> >> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
> >> index 3605e94..34c33c7 100644
> >> --- a/include/linux/pinctrl/pinctrl.h
> >> +++ b/include/linux/pinctrl/pinctrl.h
> >> @@ -112,7 +112,7 @@ struct pinctrl_desc {
> >> Â extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
> >> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  struct device *dev, void *driver_data);
> >> Â extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
> >> -extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
> >> +extern bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin);
> >> Â extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
> >> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  struct pinctrl_gpio_range *range);
> >> Â extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
> >> @@ -123,7 +123,7 @@ extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
> >>
> >>
> >> Â /* Sufficiently stupid default function when pinctrl is not in use */
> >> -static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
> >> +static inline bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
> >> Â {
> >> Â  Â  Â  return pin >= 0;
> >> Â }
> >
> >
> > So this would just become return true, right?
>
> Right I've overlooked it. Will send update version.

I wonder if the type shouldn't be signed consistently rather than unsigned,
since a signed value, -1, is typically used to indicate "invalid pin".

I wonder if the dummy pin_is_valid() should actually return false rather
than true; that's what <linux/gpio.h> does, but asm-generic/gpio.h always
returns true, like your updated pinctrl patch would.

Looking at include/linux/gpio.h, gpiolib has the same issue with signed/
unsigned inconsistency. Whatever solution we pick for pinctrl should be
consistent with gpiolib; Grant should comment here.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
