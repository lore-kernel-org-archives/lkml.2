Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1I1R2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:28:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1302 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab1I1R2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:28:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 28 Sep 2011 10:28:44 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Date: Wed, 28 Sep 2011 10:28:43 -0700
Subject: RE: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Topic: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Thread-Index: Acx91f3nm4PhNBOsRiqLDwWncbVLMgALbJ+g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17395557FD@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
	<CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1738180164@HQMAIL01.nvidia.com>
	<CACRpkdbiWUFPfF9vKV5YpSW68ZTdjwb8NhWZ_9WDoY5Q+aVfvQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17395556DC@HQMAIL01.nvidia.com>
 <CACRpkdYx-iKPJisP7PgNynu9z3tu7s6KieFAoAOU2YO_5X2iqA@mail.gmail.com>
In-Reply-To: <CACRpkdYx-iKPJisP7PgNynu9z3tu7s6KieFAoAOU2YO_5X2iqA@mail.gmail.com>
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

Linus Walleij wrote at Wednesday, September 28, 2011 5:59 AM:
> On Wed, Sep 28, 2011 at 2:15 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > But can't debugfs just get its information from the device name field in
> > the mapping table? I'm not sure why the need to use that information for
> > debugfs prevents the having entries with both the hog flag set and a
> > device name set?
> 
> That feels unsafe - then you have some string claiming to represent the
> device for that pinmux, but the system has not matched that string
> against dev_name() for any real device, so it could be a lie, any string
> like "foo" would do.
> 
> What I do now for U300 is complete resolution by matching dev_name
> in the mapping to dev_name(device) on the struct device * actually
> instantiated, which means you're 100% sure it is really mapped
> to that very device.
> 
> I like this since it's much more stringent...

OK, I can see the advantage, and I suppose one could still move
u300_pinmux_fetch() into the pinmux core as a helper function in the
future if needed without too much issue. If it's hard for some other
machine to set up the .dev entries in the table the function uses, one
can always fall back on system/non-device hog entries in the main
mapping table.

So I'll drop my objection to this.

-- 
nvpublic

