Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1LTBhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:37:04 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1LTBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <20111220011923.GS2860@opensource.wolfsonmicro.com>
References: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
	<1324343717-7292-4-git-send-email-felipe.contreras@gmail.com>
	<20111220011923.GS2860@opensource.wolfsonmicro.com>
Date: Tue, 20 Dec 2011 03:36:59 +0200
Message-ID: <CAMP44s1XFo0_O-pGMNO7m=weXuCpXzS8oH6m6PaPNzLGRQpDgA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] regulator: simplify twl4030 config
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 3:19 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Dec 20, 2011 at 03:15:16AM +0200, Felipe Contreras wrote:
>> If we have TWL4030_CORE and REGULATOR, we *obviously* want
>> REGULATOR_TWL4030 by default. But can be disabled if somebody wants for
>> some strange reason.
>
> No, this is the wrong way to go about this - why are you making this
> change for this one driver only?

Because that's the only one I care about. I can try to do the same for
all the others if you wish.

> Exactly the same argument would apply
> to all the other MFD regulators and to all the other MFD subdrivers in
> the various subsystems.

Yes, the ones that closely related to certain architectures or chips.

And this is already done:

REGULATOR_AB3100:
	depends on AB3100_CORE
	default y if AB3100_CORE

(if AB3100_CORE is redundant BTW)

REGULATOR_TPS6105X:
	depends on TPS6105X
	default y if TPS6105X

ditto

And in mfd:

config TPS65010
	default y if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_OSK

config ABX500_CORE
	default y if ARCH_U300 || ARCH_U8500

config AB3100_CORE
	default y if ARCH_U300

config AB3100_OTP
	default y if AB3100_CORE

These 3 seem to be linked, but the same logic applies; most people
should say 'y', so make it the default.

-- 
Felipe Contreras
