Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2BVRVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:21:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8241 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2BVRVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:21:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 22 Feb 2012 09:21:27 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 22 Feb 2012 09:21:25 -0800
Subject: RE: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no
 maps are found
Thread-Topic: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no
 maps are found
Thread-Index: AczxLgjtjbx6E38BS06w5KCUrkpBWQAV9h2A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC66B@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-12-git-send-email-swarren@nvidia.com>
 <CACRpkdbpBZqUUwxwF8o8P1P9yknY7SRSzGmYsa3kQ1JH=QNJ7A@mail.gmail.com>
 <20120222065647.GE11087@shlinux2.ap.freescale.net>
In-Reply-To: <20120222065647.GE11087@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Tuesday, February 21, 2012 11:57 PM:
> On Tue, Feb 21, 2012 at 02:51:55PM +0100, Linus Walleij wrote:
> > On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> >
> > > This may be perfectly legitimate. An IP block may get re-used
> > > across SoCs. Not all of those SoCs may need pinmux settings for the
> > > IP block, e.g. if one SoC dedicates pins to that function but
> > > another doesn't. The driver won't know this, and will always
> > > attempt to set up the pinmux. The mapping table defines whether any
> > > HW programming is actually needed.
> > >
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >
> > This is equivalent to providing dummy pincontrollers as was on my
> > TODO for a while admittedly.
> >
> > For consistency with regulators it would maybe be better to have
> > optional dummy pin controllers but after thinking a bit about it
> > I think this is more helpful, so I applied it anyway.
> >
> > However I would invite more opinions...
>
> I'm afraid this is a little error-prone, that means even we specifed
> the wrong map name or state name, the pinctrl_get still does not get
> failed and it is a little different as what we want in this patch.

Yes, this does open up a small opportunity for an undetected error at
this stage in the patch series.

However, this is closed later by the final patch that enhances the mapping
table to represent pin config data, and "dummy" states.

I wrote/posted this patch to highlight that this code should be checking
for non-existent states, rather than states which match no mapping table
entries. Admittedly, there's no way to represent the difference at this
point in the patch series. Once the final patch is applied, there's an
explicit way to represent a state that exists, but has no mapping table
entries, so the opportunity for error then no longer exists.

-- 
nvpublic

