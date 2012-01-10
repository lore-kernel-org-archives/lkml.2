Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2AJIVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:21:11 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:49405
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab2AJIVK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:21:10 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz9371I146fK1447M168aJ542M1432N1414J98dKzz1202hzz8275bh8275dhz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIASXrkAgAC9bACAAEFboIAAbmbAgAWY2cA=
Date: Tue, 10 Jan 2012 08:21:05 +0000
Message-ID: <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-3-git-send-email-b29396@freescale.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
	<7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
	<74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Saturday, January 07, 2012 2:03 AM
> To: Dong Aisheng-B29396; Dong Aisheng
> Cc: linux-kernel@vger.kernel.org; linus.walleij@stericsson.com;
> s.hauer@pengutronix.de; rob.herring@calxeda.com; linux-arm-
> kernel@lists.infradead.org; kernel@pengutronix.de; cjb@laptop.org; devicetree-
> discuss@lists.ozlabs.org; Simon Glass (sjg@chromium.org)
> Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
> mappings
> Importance: High
> 
> Dong Aisheng-B29396 wrote at Friday, January 06, 2012 4:34 AM:
> > Stephen Warren wrote at Friday, January 06, 2012 9:06 AM:
> > > Dong Aisheng wrote at Thursday, January 05, 2012 6:48 AM:
> > > > On Sun, Dec 25, 2011 at 11:37 AM, Stephen Warren <swarren@nvidia.com>
> wrote:
> > > > > Dong Aisheng-B29396 wrote at Thursday, December 22, 2011 1:18 AM:
> > > ...
> > > > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
> > > ...
> > > > +Examples:
> > > > +soc {
> > > > +	aips-bus@02000000 { /* AIPS1 */
> > > > +		iomuxc@020e0000 {
> > > > +			pinctrl_uart4: uart4 {
> > > > +				func-name = "uart4";
> > > > +				grp-name = "uart4grp";
> > > > +				grp-pins = <107 108>;
> > > > +				num-pins = <2>;
> > > > +				grp-mux = <4 4>;
> > > > +				num-mux = <2>;
> > > > +			};
> > >
> > > Before I get too far into reviewing this path, could you explain the
> > > above node in a little more detail; what it is and what the properties
> define?
> > >
> > grp-pins is the group of pins for this function.
> > grp-mux is the corresponding mux setting of each pin in that group for
> > this specific function.
> > num-pins and num-mux are the number of pins and mux. They're mainly
> > used for sanity Checking in driver since it's easy to make a mistake
> > when write too many pins for a function. These two could be removed finally.
> 
> I see now.
> 
> I'd definitely be inclined to drop the num-pins and num-mux properties; The
> values are just len(grp-pins)/4. You can still check that
> len(grp-pins)==len(grp-mux) if you want to catch typos etc.
> 
Yes, that's right. Thanks for the suggestion.

> So, this does appear to be conflating the two things: The definition of what
> pins are in a pingroup, and the mux function for a particular setting of that
> pingroup. I think you need separate nodes for this.
> 
As shawn said, here the mux for IMX is tightly for each individuals pins rather
than groups.
Since the pins are grouped in functions, the mux for each pin is also fixed for
That function, We prefer to put mux together with pins of group.

> Without separate nodes, there will eventually be a lot of duplication.
> A made-up example of the same uart4grp allowing either of two functions uart3,
> uart4 to be muxed out onto it:
> 
> aips-bus@02000000 { /* AIPS1 */
> 	iomuxc@020e0000 {
> 		pinctrl_uart4_3: uart4@option_3 {
> 			func-name = "uart3";
> 			grp-name = "uart4grp";
> 			grp-pins = <107 108>;
> 			num-pins = <2>;
> 			grp-mux = <3 3>;
> 			num-mux = <2>;
> 		};
> 		pinctrl_uart4_4: uart4@option_4 {
> 			func-name = "uart4";
> 			grp-name = "uart4grp";
> 			grp-pins = <107 108>;
> 			num-pins = <2>;
> 			grp-mux = <3 3>;
> 			num-mux = <2>;
> 		};
> 	}
> };
> 
> Now I understand that initially you aren't going to type out the complete list
> of every available option into imx6q.dtsi because it's probably huge, but the
> binding does need to allow you to do so without duplicating a lot of data,
> because eventually you'll get boards that use a larger and larger subset of all
> the options, so the number you need to represent at once in imx6q.dtsi will grow.
> 
> So I think you need to model the IMX pinmux controller's bindings more on how
> the pinctrl subsystem represents objects; separate definitions of pins, groups
> of pins, functions, and board settings. Something more like:
> 
You're right.
To keep consistency with the current design of pinctrl subsystem,
I think we should do like that.

> imx6q.dtsi:
> 
> aips-bus@02000000 { /* AIPS1 */
> 	iomuxc@020e0000 {
> 		/* FIXME: Perhaps need pin nodes here to name them too */
> 
We did it in pinctrl driver.
I have not seen any strong reason up till now that we should put pin defines
In dts file.

> 		/* A node per group of pins. Each lists the group name, and
> 		 * the list of pins in the group */
> 		foogrp: group@100 {
> 			grp-name = "foogrp";
> 			grp-pins = <100 101>;
> 		};
> 		bargrp: group@102 {
> 			grp-name = "bargrp";
> 			grp-pins = <102 103>;
> 		};
> 		bazgrp: group@104 {
> 			grp-name = "bargrp";
> 			grp-pins = <104 105>;
> 		};
> 		/* A node per function that can be muxed onto pin groups,
> 		 * each listing the function name, the set of groups it can
> 		 * be muxed onto, and the mux selector value to program into
> 		 * the groups' mux control register to select it */
> 		uart3func: func@0 {
> 			func-name = "uart3";
> 			/* Length of locations and mux-value must match */
> 			locations = <&foogrp &bargrp>;
> 			mux-value = <0 4>;
> 		};
> 		uart4func: func@1 {
> 			func-name = "uart4";
> 			locations = <&bargrp &bazgrp>;
> 			mux-value = <6 3>;
> 		};
> 	}
> };
> 
> Or, instead of separate locations and mux-value properties with matching lengths,
> perhaps a node for each location:
> 
> 		uart3func: func@0 {
> 			func-name = "uart3";
> 			location@0 {
> 				location = <&foogrp>;
> 				mux-value = <0>;
> 			};
> 			location@1 {
> 				location = <&bargrp>;
> 				mux-value = <4>;
> 			};
> 		};
> 
> That's more long-winded, but might be more easily extensible if we need to add
> more properties later.
> 
Your example are right for us and also meet our ideas.
And I'm going to do like that.

> Now in the board's .dts file, you need to specify for each device the list of
> pinmux groups the device needs to use, and the function to select for each group.
> Perhaps something like:
> 
> board.dts:
> 
> usdhc@0219c000 { /* uSDHC4 */
>         fsl,card-wired;
>         status = "okay";
>         pinmux = <&foogrp &uart3func &bazgrp &uart4func>; };
> 
> I haven't convinced myself that's actually a good binding, but I think it does
> represent the data required for muxing. Some potential issues as before:
> 
Here is what we should discuss exactly.
Since 'pinmux' phandle will be parsed in pinctrl core, we should try to find and 
define a common and standardized pinmux property for all platforms.
>From the pinctrl subsystem point of view, specifying the function name and group
name is sufficient for construct a pinmux map for this device.
We can get the two info from the phandle.
So what you describe here seems correct for me.

Pinctrl core can get the function name from the phandle.
Here what I wonder is that do we need to allow the platform to use a func-name
property in their pinmux func node or pinmux group node to specify the name.
If it is allowed, then it could be flexible for soc to define their names.
If not there may be limitations on their node names since we can only get it from
the node name.
Another option is that we could assume each platform may have a func-name property
in their each pinmux function node. If it exists we get the name from func-name
property, if not, we get the name from the pinmux function node name.
For group name it could be in the same way.

Without the func name and group name, pinctrl do not have other special requirements
to for the func node and group node (just like what the pinctrl subsystem does now
in non-dt). It's very flexible and up to each SoC.

To keep consistency as the currently design of pinctrl subsystem and also meet
the dt design philosophy, we still do not introduce a pinmux map in dt.
Instead, we choose to scan all the device node with a 'pinmux' phandle to construct
a pinmux map table before register the pin controller device(here we may also scan
the hog_on_boot node) and I guess it's easy to do that.

After that, we have pinmux map, plus the pinmux function list and group list
(we already have function list and group list defined in the way as Stephen described).
So everything is here and it then can work exacty as the same way as non-dt pinctrl
subsystem works.
Another important thing is that we can still use the sysfs interface exported to user
space for pinctrl subsystem used via dt.
(Without scan the device node to construct the pinmux map table, we can only get the map
Information when we run the pinmux_get.
See: https://lkml.org/lkml/2012/1/5/153
So no pinmux map table exists and we surely do not want to see that the sysfs exporting
pinmux map information works in dt but unwork in non-dt)

BTW it seems you want to support multi pin groups(foogrp and bazgrp) for one device,
do we have such using case?
I guess usually one pin group already contains all the pins of device.
Anyway, just from flexibility view, it's good for me.

> * Do we need to add flags to each entry in the list; GPIO/interrupt do?
> 
We can add it when we have the real needs.

> * Should "pinmux" be a node, and the configuration of each group be a separate
> sub-node, so we can add more properties to each "table" entry in the future, e.g.
> pin config parameters?
> 
Currently no drivers are using pinctrl subsystem via dt.
So I think we can easy to make changes to improve the design if we really want to.
But before that we should get it running first.

> * For Tegra, I elected to put the definitions of pins, groups, and functions
> into the driver rather than in the device tree. This avoids parsing a heck of a
> lot of data from device tree. That means there isn't any per-function node that
> can be referred to by phandle. Does it make sense to refer to groups and
> functions by string name or integer ID instead of phandle? Perhaps:
> 
> usdhc@0219c000 { /* uSDHC4 */
> 	fsl,card-wired;
> 	status = "okay";
> 	pinmux = {
> 		group@0 {
> 			group = "foo";
> 			function = "uart3";
> 			/* You could add pin config options here too */
> 		};
> 		group@1 {
> 			group = "baz";
> 			function = "uart4";
> 		};
> 	};
> };
> 
> I guess referring to things by name isn't that idiomatic for device tree.
> Using integers here would be fine too, so long as dtc gets support for named
> constants:
> 
> imx6q.dtsi:
> 
> /define/ IMX_PINGRP_FOO 0
> /define/ IMX_PINGRP_BAR 1
> /define/ IMX_PINGRP_BAZ 2
> /define/ IMX_PINFUNC_UART3 0
> /define/ IMX_PINFUNC_UART4 1
> ...
> 
> board .dts:
> 
> usdhc@0219c000 { /* uSDHC4 */
> 	fsl,card-wired;
> 	status = "okay";
> 	pinmux = {
> 		group@0 {
> 			group = <IMX_PINGRP_FOO>;
> 			function = <IMX_PINFUNC_UART3>;
> 			/* You could add pin config options here too */
> 		};
> 		group@1 {
> 			group = <IMX_PINGRP_BAZ>;
> 			function = <IMX_PINFUNC_UART4>;
> 		};
> 	};
> };
> 
> > > I'm confused because the node has properties for function name and
> > > group name which make sense to define the mux setting for that group.
> > > However, I'm not sure what the grp-pins/num-pins/grp-mux/num-mux
> > > properties are for; if those properties define the available mux
> > > options and for the group and set of pins included in the group, I
> > > think the node is representing too many things in one place. I'd expect to
> see:
> > >
> > > a) Either data in the pinctrl driver or separate DT nodes to define
> > > each available pin group, mux function, etc.; the definition of what
> > > the SoC itself can do.
> > >
> > > b) The configuration of each pin group that's used by the particular board.
> > > All that's relevant here is the mux selection for each pin groups;
> > > things like which pins are included in each group are defined by the
> > > SoC not the board and hence wouldn't be included in a per-board node.
> >
> > We still have not started pin config work.
> > For pinmux, one way we thought is trying to define pin groups in soc
> > dts file and reference that pin group by a phandle in board dts file.
> > It could be:
> > In the soc dts file arch/arm/boot/dts/imx6q.dtsi:
> >
> > iomuxc@020e0000 {
> >         reg = <0x020e0000 0x4000>;
> >         pinmux-groups {
> >                 pingrp_uart4: uart4 {
> >                         grp-pins = <107 108>;
> >                         grp-mux = <4 4>;
> >                 };
> >
> >                 pingrp_sd4: sd4 {
> >                         grp-pins = <170 171 180 181 182 183 184 185 186 187>;
> >                         grp-mux = <0 0 1 1 1 1 1 1 1 1>;
> >                 }
> >         }
> > };
> >
> > In board dts file:
> > usdhc@0219c000 { /* uSDHC4 */
> >         fsl,card-wired;
> >         status = "okay";
> >         pinmux = <&pinctrl_sd4>;
> > };
> >
> > uart3: uart@021f0000 { /* UART4 */
> >         status = "okay";
> >         pinmux = <&pinctrl_uart4>;
> > };
> >
> > iomuxc@020e0000 {
> >         pinctrl_uart4: uart4 {
> >                 group = <&pingrp_uart4>;
> >                 pinconfig = ....;
> >         };
> >
> >         pinctrl_sd4: sd4 {
> >                 group = <&pingrp_sd4>;
> >                 pinconfig = ....;
> >         };
> > };
> >
> > Then we know the whole map information for a specific device without a pinmux
> map.
> > Do you think if it's ok?
> >
> > BTW, for imx we won't define all possible groups since most are
> > useless and It's hard to cover all cases due to the issue raised by Sascha
> before.
> > We only define what we're most using firstly.
> 
> --
> nvpublic
> 

Regards
Dong Aisheng

