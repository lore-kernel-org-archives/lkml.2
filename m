Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2BWDyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:54:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9796 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2BWDyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:54:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Feb 2012 19:53:47 -0800
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
Date: Wed, 22 Feb 2012 19:53:44 -0800
Subject: RE: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Topic: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Index: Aczx3hTobxBxog5GR/WRMJ5+F6iueAAADUPQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8EE@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
 <20120222063440.GB11087@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
 <20120223033510.GA9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8E3@HQMAIL01.nvidia.com>
 <20120223035640.GC9141@shlinux2.ap.freescale.net>
In-Reply-To: <20120223035640.GC9141@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Wednesday, February 22, 2012 8:57 PM:
> On Wed, Feb 22, 2012 at 07:39:42PM -0800, Stephen Warren wrote:
> > Dong Aisheng wrote at Wednesday, February 22, 2012 8:35 PM:
> > > On Wed, Feb 22, 2012 at 10:05:20AM -0800, Stephen Warren wrote:
...
> > > > regulator_get(dev, id) requires id != NULL.
> > > >
> > > > clk_get(dev, con_id) requires con_id != NULL in order to match a clock
> > > > that has a non-NULL con_id defined (although clocks with a NULL con_id
> > > > are also legal, in which case, the con_id parameter to clk_get is
> > > > ignored)
> > > >
> > > > So pinctrl_get(dev, state) requiring state != NULL seems consistent
> > > > with existing practice.
> > >
> > > Yes, it's true if given all map entries have a name.
> > >
> > > Now i'm intend to the way you mentioned at:
> > > https://lkml.org/lkml/2012/2/21/213
> > >
> > > And i agree with the way you said:
> > > If we continue to allow NULL names, I think we should change that to:
> > > if name:
> > >     match = map->name && !strcmp(name, map->name)
> > > else:
> > >     match = !map->name
> > >
> > > And i think allowing map name to be NULL will make life easy for those
> > > devices who do not support multi states.
> >
> > It does make it a little convenient for board files, but isn't really
> > practical to implement for device-tree unless we modify the binding to
> > have something that means "no name". I'd rather not allow more options
> > in the binding though.
> >
> > What's wrong with writing e.g. PINCTRL_DEFAULT instead of NULL when calling
> > pinctrl_get() or pinctrl_lookup_state() though? Given pinctrl.h having:
> >
> > #define PINCTRL_DEFAULT "default"
>
> First, map writer needs know this logic.

Sure, but that's always true; you need to know the state name in all cases.
And this requirement seems extremely trivial for a map writer to implement.

> Second, all as you said:
>
> > > > every mapping table entry has a name and drivers (or device tree bindings)
> > > > define what that name must be, so why shouldn't drivers be required to
> > > > request that specific name, and experience an error if the mapping table
> > > > author didn't create that name?
>
> if want to keep align with regulator and clock,
> i just feel a little that it does not make too much sense to
> internally convert NULL to "default", right?

I'm hoping that we don't do this internal conversion. The rules I'd like are:

* Every mapping table entry must include a non-NULL name field.

* Every call to pinctrl_get()/pinctrl_lookup_state() must pass a non-NULL name
----------==========----------==========----------==========----------==========-- 
nvpublic

