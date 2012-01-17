Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2AQToR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:44:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1098 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2AQToP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:44:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jan 2012 11:44:12 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <dongas86@gmail.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
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
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>
Date: Tue, 17 Jan 2012 11:44:11 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczS5hDwh9ZqPthfRcu9iR87HHD1dgCaZLYA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D2304@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
	<CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
	<CAA+hA=RCmctmQJU4-k7YhzQDMi8KuyisBqOFhuMd3RV4_E=gCA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com>
 <CAA+hA=TKNS+rYZ34Ev9ebRF12CEfBQQY71E+GUKNJoWHZTgLWw@mail.gmail.com>
In-Reply-To: <CAA+hA=TKNS+rYZ34Ev9ebRF12CEfBQQY71E+GUKNJoWHZTgLWw@mail.gmail.com>
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

Dong Aisheng wrote at Saturday, January 14, 2012 10:58 AM:
> On Sat, Jan 14, 2012 at 2:33 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Dong Aisheng wrote at Friday, January 13, 2012 10:12 AM:
> >> On Thu, Jan 12, 2012 at 4:17 AM, Stephen Warren <swarren@nvidia.com> wrote:
> >> ...
> >> >> To keep consistency as the currently design of pinctrl subsystem and also meet
> >> >> the dt design philosophy, we still do not introduce a pinmux map in dt.
> >> >> Instead, we choose to scan all the device node with a 'pinmux' phandle to construct
> >> >> a pinmux map table before register the pin controller device(here we may also scan
> >> >> the hog_on_boot node) and I guess it's easy to do that.
> >> > ...
> >> >> (Without scan the device node to construct the pinmux map table, we can only get the map
> >> >> Information when we run the pinmux_get.
> >> >> See: https://lkml.org/lkml/2012/1/5/153
> >> >> So no pinmux map table exists and we surely do not want to see that the sysfs exporting
> >> >> pinmux map information works in dt but unwork in non-dt)
...
> >> And i'm not sure it's the right place for of_platform.c to handle
> >> pinmux things when create new devices.
> >
> > So of_device_alloc(), which is called by of_platform_populate() for each
> > device, already parses basic DT content such as reg and interrupts, and
> > converts them to Linux resources. I'd consider parsing any pinmux properties
> > and registering them with the pinctrl subsystem to be of a similar nature,
> > so adding some code to of_device_alloc() that calls a core pinmux function
> > to parse the DT node seems reasonable to me.
> >
> It's not perfect to me since pinmux map looks not the pure hw
> conception like reg/int.
> but i wonder if we can find a better way, (scanning?)

I suppose up-front scanning might work. To be fully safe, I think you'd
need to:

Enumerate all nodes with a compatible property (for anything without,
it won't be a device node, so who knows what it is).

In those nodes, look for pinctrl and pinctrl-names properties. If they're
present, process them.

For each phandle, make sure the referenced "pin configuration node" has
a specific pinctrl compatible flag (just to make sure it really is pin
control data, not some random other thing that happens to be pointed at
by a property named pinctrl from some random binding developed by some
3rd-party without review.)

I propose for this:

    compatible = "pinctrl-configuration";

Now, you know the device node and the pin configuration, so you can create
the pinctrl mapping table entries.

-- 
nvpublic

