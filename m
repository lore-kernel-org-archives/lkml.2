Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2ALVKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:10:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5158 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2ALVKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:10:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 12 Jan 2012 13:10:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>
Date: Thu, 12 Jan 2012 13:10:04 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczQ2lam2hqddaL6RqmSWGKbU+6VvgAivNIQAAI4VDA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D1DE3@HQMAIL01.nvidia.com>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <20120107135445.GI4790@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
 <20120112033941.GH20968@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D1DCC@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D1DCC@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Thursday, January 12, 2012 1:47 PM:
> Shawn Guo wrote at Wednesday, January 11, 2012 8:40 PM:
> > On Wed, Jan 11, 2012 at 10:17:40AM -0800, Stephen Warren wrote:
> ...
> > > So, my position is that:
> > >
> > > * Something (either the pinctrl driver, or the SoC .dtsi file) should
> > > enumerate all available muxable entities that exist in the SoC (pins for
> > > IMX, groups for Tegra).
> >
> > Yes, we enumerate all available pins in pinctrl driver for imx.
> >
> > > * Something (either the pinctrl driver, or the SoC .dtsi file) should
> > > enumerate all the available functions that can be assigned to a muxable
> > > entity.
> >
> > In theory, yes.  But I hope you would agree we do not need to
> > necessarily do this for case like imx.
> 
> Discussing just the Linux driver internals right now; ignoring device
> tree:
> 
> Pinctrl won't let you use a function on a pin/group if that function
> isn't enumerated and doesn't list that pin/group as a valid location
> for that function. Given that, I'm not sure how you can avoid enumerating
> all functions and their legal locations?

Or you can cheat a little:

Define 8 functions named func0, func1, func2, ... func7. Tell pinctrl
that each function is a legal option on every pin. That way, you've
enumerated all the valid functions, and so satisfied pinctrl's error-
checking, yet kept a tiny list of functions. That'd have the bonus side-
effect that the function IDs map very directly to what I assume is in
your HW manuals too!

I wonder if I shouldn't have done that for Tegra. The main reason I didn't
is because the old Tegra pinmux driver didn't.

-- 
nvpublic

