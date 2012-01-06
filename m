Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab2AFKvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:51:31 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:33950 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2AFKv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:51:29 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371I148cM1447M542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hbe9k61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIAB+HxAgBCkJsCAALzAkA==
Date: Fri, 6 Jan 2012 10:51:10 +0000
Message-ID: <7FE21149F4667147B645348EC605788507F615@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F1887@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17761F1887@HQMAIL01.nvidia.com>
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
> Sent: Friday, January 06, 2012 7:38 AM
> To: Dong Aisheng-B29396; linux-kernel@vger.kernel.org
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; cjb@laptop.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
> mappings
> Importance: High
> 
> Dong Aisheng-B29396 wrote at Tuesday, December 27, 2011 7:41 AM:
> > Stephen Warren wrote at Sunday, December 25, 2011 11:37 AM:
> > > Dong Aisheng-B29396 wrote at Thursday, December 22, 2011 1:18 AM:
> > > > Stephen Warren wrote at Wednesday, December 21, 2011 8:39 AM:
> > > > > Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> > > > > > This patch provies a common API for driver to use to register
> > > > > > pinmux mappings from dts file. It is needed for dt support.
> > > > >
> > > > > Dong,
> > > > >
> > > > > Thanks for providing a concrete binding to get discussion
> > > > > started. I had intended to do this myself, but got side-tracked on other
> things.
> > > > >
> > > > > I'll comment exclusively on the documentation in this patch,
> > > > > since any changes there will require the code to be changed.
> ...
> > > > > b) The top-level node ("imx6q-sabreauto-map" below) is not tied
> > > > > to any particular piece of hardware (no compatible flag, not reg
> > > > > property etc.)
> > > >
> > > > My original purpose was that it was not a hw device node, it was
> > > > just created for containing pin map information and referenced by
> > > > a phandle in iomuxc deivce node
> > > > like:
> > > >
> > > > iomuxc@020e0000 {
> > > >         compatible = "fsl,imx6q-iomuxc";
> > > >         reg = <0x020e0000 0x4000>;
> > > >         fsl,pinmux-map = <&pinmux>;
> > > > 	  ...
> > > > }
> > > >
> > > > I could also make it as a sub node of iomuxc, but original design
> > > > is that sub nodes of Ioxmuc are already representing each pinmux functions.
> > > > To avoid conflict, I put the imx6q-sabreauto-map node out of
> > > > iomuxc since a phandle (fsl,pinmux-map ) does the same work well.
> > >
> > > You could have nested sub-nodes, say something like:
> > >
> > > iomuxc@020e0000 {
> > >     compatible = "fsl,imx6q-iomuxc";
> > >     reg = <0x020e0000 0x4000>;
> > >     fsl,pins {
> > >         ... // fsl-specific pin properties
> > >     };
> > >     fsl,groups {
> > >         ... // fsl-specific group properties
> > >     };
> > >     fsl,functions {
> > >         ... // fsl-specific mux function properties
> > >     };
> > >     pinmux-usage {
> > >         // standardized pinmux "table" properties
> > >         sd4 { // pin group name
> > >             function = "sdio4"; // this function active on it
> > >             ...
> > >         };
> > >         ...
> > >     }
> > >     ...
> > > }
> > >
> > Yes, I could do that.
> > The extra effort is that we have to manually exclude one pinmux-usage
> > node in pinmux driver since originally i take the child node count of
> > iomuxc as the function count since all child nodes are functions, that
> > why I firstly took the mapping node out of iomuxc, in addition the old
> > way i used seems to be more brief and clear.
> >
> > I tried adding pinmux-usage as a sub node of iomuxc and got two issues:
> > Taking imx6q as an example:
> >
> > iomuxc@020e0000 {
> >         uart4 {
> >                 func-name = "uart4";
> >                 grp-name = "uart4grp";
> >                 grp-pins = <107 108>;
> >                 num-pins = <2>;
> >                 grp-mux = <4 4>;
> >                 num-mux = <2>;
> >         };
> >
> >         sd4 {
> >                 func-name = "sd4";
> >                 grp-name = "sd4grp";
> >                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
> >                 num-pins = <10>;
> >                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
> >                 num-mux = <10>;
> >         };
> >
> >         pinmux-mapping {
> >                 uart4 {
> >                         function = "uart4";
> >                         dev = <&uart4>;
> >                 };
> >
> >                 usdhc4 {
> > /*			    ctrl-dev-name = "20e0000.iomuxc"; */
> >                         function = "sd4";
> >                         dev = <&usdhc4>;
> >                 };
> >         };
> > };
> >
> > If we remove ctrl-dev-name and get it from its parent node in drivers
> > as you suggested, first, since this work will be done in the common
> > API (pinmux_of_register_mappings Requires pass the pinmux mapping node
> > to it for construct the mapping table) It will introduce a restriction
> > that all platforms should define this node under their pinctrl device
> > node.
> 
> This seems reasonable to me; the pinmux controller would be defining the mux
> options/... that it's providing to the rest of the DT.
> 
> > Second, it seems we cannot get its parent node device or device name
> > in driver (can only get node Name which is not sufficient for
> > construct the pin map table required by pinctrl core) and current
> > device tree subsystem seems do not support get its associated device from a
> device node.
> > We may not be able to construct ctrl-dev-name or ctrl-dev for struct
> pinmux_map.
> > I'm not sure if I missed something, if missed please let me know.
> > To support it, we may need to add support for converting device node
> > to device. Not sure it's applicable since I still have not tried it.
> 
> That functionality is pretty easy to implement; it already exists for other
> subsystems that refer to parent/controller/... nodes using phandles.
> for example, take a look at the implementation of of_node_to_gpiochip() in
> drivers/of/gpio.c, which calls gpiochip_find() with a custom match function that
> simply compares the gpio_chip's of_node field. Once you have the chip, you have
> the device, and can store that in the constructed mapping table, or call
> dev_name() on it. I assume there's something similar for interrupts.
> 
Yes, that's indeed a way.
Thanks for the info.

> ...
> > > > The same question applies to clock and regulator: does each device
> > > > need Define its clock and regulator properties?
> > >
> > > Yes, in those cases I believe each device does contain a phandle to
> > > the resources it uses.
> >
> > I was ever thought putting a phandle of pinmux function in each
> > device, Then pinmux mapping table seems not need anymore. Like:
> >
> > usdhc4: usdhc@0219c000 { /* uSDHC4 */
> >         compatible = "fsl,imx6q-usdhc";
> > 	....
> >         pinmux = <&pinmux-sd4>;
> > };
> >
> > iomuxc@020e0000 {
> >         pinmux-sd4 : sd4 {
> >                 func-name = "sd4";
> >                 grp-name = "sd4grp";
> >                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
> >                 num-pins = <10>;
> >                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
> >                 num-mux = <10>;
> >         };
> >
> > It is a pure hw point of view to define node.
> > And it may need to implement a of_pinmux_get.
> 
> > But what about the pin maps without device associated?
> 
> Indeed; that's why I'd tend towards defining a table of pinmux usage in the
> pinmux node, and having other devices refer to that table.
>
Currently we still prefer to use device node relationship to reflect the pinmux
map if we can since as you said pinmux map is little depending on the pinctrl
subsystem implementation.
And I'm trying to do it now.
 
> Still, if the pinmux definitions are in the device nodes, we could simply make
> the pinmux controller have such a definition itself too, for the "system hog"
> case.
> 
Yes, that way I think is like:
iomuxc@020e0000 {
        pinctrl_uart4: uart4 {
                grp-pins = <107 108>;
                grp-mux = <4 4>;
		   hog_on_boot;
        };
}
I'm still trying to find a way to support it in pinctrl core.
Maybe we could do it in the next step and we want to implement pinmux binding first.

Regards
Dong Aisheng

