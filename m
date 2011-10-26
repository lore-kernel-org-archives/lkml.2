Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1JZJkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 05:40:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61408 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab1JZJkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 05:40:05 -0400
X-AuditID: cbfee61b-b7b7fae000005864-b9-4ea7d5737a56
From: Chanho Park <chanho61.park@samsung.com>
To: "'Stephen Warren'" <swarren@nvidia.com>, linus.walleij@linaro.org,
        Baohua.Song@csr.com, linux-kernel@vger.kernel.org
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
Subject: RE: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Date: Wed, 26 Oct 2011 18:39:22 +0900
Message-id: <008201cc93c3$24867880$6d936980$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyTlt07UXZp9UagRbu8use0Yme9FAAEBtnAAAcAaWA=
Content-language: ko
X-OriginalArrivalTime: 26 Oct 2011 09:39:51.0370 (UTC)
 FILETIME=[359402A0:01CC93C3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Wednesday, October 26, 2011 3:21 PM
> To: Chanho Park; linus.walleij@linaro.org; Baohua.Song@csr.com; linux-
> kernel@vger.kernel.org
> Cc: Kyungmin Park
> Subject: RE: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-
> ranges
> 
> Chanho Park wrote at Tuesday, October 25, 2011 10:22 PM:
> > This patch enables mapping a base offset of gpio ranges with
> > a pin offset even if does'nt matched. A base of pinctrl_gpio_range
> > means a base offset of gpio. However, we cannot convert gpio to pin
> > number for sparse gpio ranges just only using a gpio base offset.
> > We can convert a gpio to real pin number(even if not matched) using
> > a new pin_base which means a base pin offset of requested gpio range.
> ...
> > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> ...
> > @@ -289,38 +291,12 @@ So this complex system has one pin controller
> handling two different
> >  GPIO chips. Chip a has 16 pins and chip b has 8 pins. They are mapped
> in
> >  the global GPIO pin space at:
> >
> > -chip a: [32 .. 47]
> > -chip b: [48 .. 55]
> > -
> > -When GPIO-specific functions in the pin control subsystem are called,
> these
> > -ranges will be used to look up the apropriate pin controller by
> inspecting
> > -and matching the pin to the pin ranges across all controllers. When a
> > -... [ quit a few lines of documentation removed]
> > -(If the GPIO subsystem is ever refactored to use a local per-GPIO
> controller
> > -pin space, this mapping will need to be augmented accordingly.)
> > -
> > +chip a:
> > +	gpio-range : [32 .. 47]
> > +	pin-range  : [32 .. 47]
> > +chip b:
> > +	gpio-range : [48 .. 55]
> > +	pin-range  : [64 .. 71]
> 
> I'm all for replacing the example here with something more complete, but
> removing all that text from the documentation doesn't seem right.

OK. I'll modify this part of the documentation.

> 
> ...
> > diff --git a/include/linux/pinctrl/pinctrl.h
> b/include/linux/pinctrl/pinctrl.h
> > index 90dd28b..7768e44 100644
> > --- a/include/linux/pinctrl/pinctrl.h
> > +++ b/include/linux/pinctrl/pinctrl.h
> > @@ -127,6 +127,7 @@ struct pinctrl_pin_desc {
> >   * @name: a name for the chip in this range
> >   * @id: an ID number for the chip in this range
> >   * @base: base offset of the GPIO range
> > + * @pin_base: base pin offset of the GPIO range
> 
> This may be bike-shedding, but I'd tend to call this "gpio_base", since
> it's the first "gpio" number of this range, not the first "pin" number
> ("pins" are used in the pinctrl subsystem, but "gpios" by the GPIO
> Subsystem)

A "base" means first "gpio" number of the range.
And a "pin_base" means first "pin" number.
Do you want to replace the "base" to the "gpio_base"?

> 
> --
> nvpublic

