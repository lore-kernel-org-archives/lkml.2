Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2BWVNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:13:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5347 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2BWVNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:13:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 23 Feb 2012 13:13:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 13:13:13 -0800
Subject: RE: [PATCH 20/20] pinctrl: Enhance mapping table to support pin
 config operations
Thread-Topic: [PATCH 20/20] pinctrl: Enhance mapping table to support pin
 config operations
Thread-Index: Aczx8ZTr0108S81NQBC8o/dSco+xUgAfgikg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCACE@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-21-git-send-email-swarren@nvidia.com>
 <CACRpkdZshQqM5ZZj21gXMZ6xZCUsdEvDDDyzvhFJTjnuZ2=twg@mail.gmail.com>
In-Reply-To: <CACRpkdZshQqM5ZZj21gXMZ6xZCUsdEvDDDyzvhFJTjnuZ2=twg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Wednesday, February 22, 2012 11:09 PM:
> On Mon, Feb 20, 2012 at 7:46 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > The pinctrl mapping table can now contain entries to:
> > * Set the mux function of a pin group
> > * Apply a set of pin config options to a pin or a group
> >
> > This allows pinctrl_select_state() to apply pin configs settings as well
> > as mux settings.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
...
> >        /* First sanity check the new mapping */
> >        for (i = 0; i < num_maps; i++) {
> > +               if (!maps[i].dev_name) {
> > +                       pr_err("failed to register map %s (%d): no device given\n",
> > +                              maps[i].name, i);
> > +                       return -EINVAL;
> > +               }
> > +
> 
> Hm should this not be done earlier in the patch series?

This patch isn't adding that check, it's just moving it a little earlier
in the same block.

The old code checked everything required for "MUX_GROUP" type mapping
table entries, but in the new code not all those same checks exist for
every type of mapping entry. I just moved all the common stuff to the
top of the block in one common place, followed by the stuff that varies.

So, I think that chunk is OK.

-- 
nvpublic

