Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2BVSFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:05:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15585 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2BVSFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:05:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 22 Feb 2012 10:05:21 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 22 Feb 2012 10:05:20 -0800
Subject: RE: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Topic: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Index: AczxKvQefBYof+w8S+m62eOAH1MUzQAXygHg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
 <20120222063440.GB11087@shlinux2.ap.freescale.net>
In-Reply-To: <20120222063440.GB11087@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Tuesday, February 21, 2012 11:35 PM:
> On Tue, Feb 21, 2012 at 09:46:01AM -0800, Stephen Warren wrote:
> ....
> > > we might just
> > >
> > > #define PIN_MAP_NAME_DEFAULT "default"
> > > In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
> > > maybe in some <linux/pinctrl/mapnames.h> that both of these
> > > include?
> > >
> > > the have the driver ask for:
> > >
> > > sirfport->p = pinctrl_get(&pdev->dev, PIN_MAP_NAME_DEFAULT);
> > >
> > > (Similar changes can be done for U300, naming all its map
> > > "default".)
> >
> > I guess we could just modify pinmux_get() such that if NULL is passed as
> > the state name, it uses "default" instead internally. The disadvantage I
> > see here is that someone reading the client driver and writing the mapping
> > table then has to know that pinmux_get() does that internally, rather than
> > it being obvious right in the client driver code.
>
> It looks like a way out.

> The left problem seems to be that we may force the mapping table writer to
> specify "default" name for map at least.
> Is there any way to avoid it?

That specific restriction has been present since the very first patch
that created the pinctrl subsystem.

> I just think it may be better if we do not have such restriction.

Given that all map entries have a name, I'd really prefer that all drivers
had to request a specific matching name, rather than saying "just give me
whatever is in the mapping table".

I don't see this as a restriction, but more of a correctness issue;
every mapping table entry has a name and drivers (or device tree bindings)
define what that name must be, so why shouldn't drivers be required to
request that specific name, and experience an error if the mapping table
author didn't create that name?

regulator_get(dev, id) requires id != NULL.

clk_get(dev, con_id) requires con_id != NULL in order to match a clock
that has a non-NULL con_id defined (although clocks with a NULL con_id
are also legal, in which case, the con_id parameter to clk_get is
ignored)

So pinctrl_get(dev, state) requiring state != NULL seems consistent
with existing practice.

-- 
nvpublic

