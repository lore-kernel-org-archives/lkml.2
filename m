Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1J0QLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:11:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9622 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1J0QLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:11:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 27 Oct 2011 09:10:43 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Chanho Park <chanho61.park@samsung.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "'Kyungmin Park'" <kyungmin.park@samsung.com>
Date: Thu, 27 Oct 2011 09:10:42 -0700
Subject: RE: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Thread-Topic: [PATCH] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Thread-Index: AcyTlt07UXZp9UagRbu8use0Yme9FAAEBtnAAAcAaWAAP9p+AA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B48B4@HQMAIL01.nvidia.com>
References: <1319602943-17946-1-git-send-email-chanho61.park@samsung.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173E1B452D@HQMAIL01.nvidia.com>
 <008201cc93c3$24867880$6d936980$%park@samsung.com>
In-Reply-To: <008201cc93c3$24867880$6d936980$%park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanho Park wrote at Wednesday, October 26, 2011 3:39 AM:
> Stephen Warren wrote at Wednesday, October 26, 2011 3:21 PM:
> > Chanho Park wrote at Tuesday, October 25, 2011 10:22 PM:
> > > This patch enables mapping a base offset of gpio ranges with
> > > a pin offset even if does'nt matched. A base of pinctrl_gpio_range
> > > means a base offset of gpio. However, we cannot convert gpio to pin
> > > number for sparse gpio ranges just only using a gpio base offset.
> > > We can convert a gpio to real pin number(even if not matched) using
> > > a new pin_base which means a base pin offset of requested gpio range.
> > ...
> > > diff --git a/include/linux/pinctrl/pinctrl.h
> > b/include/linux/pinctrl/pinctrl.h
> > > index 90dd28b..7768e44 100644
> > > --- a/include/linux/pinctrl/pinctrl.h
> > > +++ b/include/linux/pinctrl/pinctrl.h
> > > @@ -127,6 +127,7 @@ struct pinctrl_pin_desc {
> > >   * @name: a name for the chip in this range
> > >   * @id: an ID number for the chip in this range
> > >   * @base: base offset of the GPIO range
> > > + * @pin_base: base pin offset of the GPIO range
> >
> > This may be bike-shedding, but I'd tend to call this "gpio_base", since
> > it's the first "gpio" number of this range, not the first "pin" number
> > ("pins" are used in the pinctrl subsystem, but "gpios" by the GPIO
> > Subsystem)
> 
> A "base" means first "gpio" number of the range.
> And a "pin_base" means first "pin" number.
> Do you want to replace the "base" to the "gpio_base"?

Ah OK. I guess I misunderstood this slightly, since "base" was both a
pin and GPIO number before, or something like that.

Anyway, I certainly see value in s/base/gpio_base/ to make this all
explicit. Hopefully that doesn't cause the patch to grow too big and
churn the code too much.

-- 
nvpublic

