Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2BXF0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 00:26:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10840 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2BXF0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 00:26:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 23 Feb 2012 21:26:16 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 21:26:14 -0800
Subject: RE: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Topic: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Thread-Index: Aczyotgy4t3h5LsZRXaxMeiBy5AKRAAEQyzQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC1F@HQMAIL01.nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <20120224032451.GA25789@shlinux2.ap.freescale.net>
In-Reply-To: <20120224032451.GA25789@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Thursday, February 23, 2012 8:25 PM:
> On Fri, Feb 24, 2012 at 08:04:38AM +0800, Stephen Warren wrote:
> > This provides a single centralized name for the default state.
> >
> > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > user to pass a state name in.
...
> > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
...
> > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
>
> To keep align with the following
> PIN_MAP_SYS_HOG("pinmux-u300", "power"),
> Maybe PIN_MAP("pinctrl-foo", "i2c0", "foo-i2c.0") is better, right?
> 
> And we may want to add a PIN_MAP_STAT macro, as well as PIN_MAP_SYS_HOG_STAT.

I don't think so.

PIN_MAP_SYS_HOG hard-codes the state name inside the macro because its
sole purpose is to support drivers/pinctrl/core.c's pinctrl_get() call
for pin hogging purposes, so that state name is always "default", or
rather, PINCTRL_STATE_DEFAULT.

The same isn't true of PIN_MAP; it's a general purpose macro intended for
any device/situation/... I'd rather not keep inventing tons of macros in
consumer.h and clutter it up.

I guess if you really want, you can submit a patch to add a macro e.g.
PIN_MAP_MUX_GROUP_DEFAULT() which hard-codes the default state name if
you wish, following on from my patch to extend the mapping table to
support pin config.

BTW, did you have any further thoughts on (not) allowing NULL state names?
I'd like to repost the final version of that patch, or rework it so that
the code actually does allow NULL state names ASAP (i.e. early Friday for
me), since it blocks some of the later patches in the series. Thanks.

-- 
nvpublic

