Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1L0Old (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:41:33 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9367
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab1L0Olc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:41:32 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I148cM542M1432N1418Mzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
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
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIAB+HxA
Date: Tue, 27 Dec 2011 14:41:25 +0000
Message-ID: <7FE21149F4667147B645348EC6057885077F82@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
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
> Sent: Sunday, December 25, 2011 11:37 AM
> To: Dong Aisheng-B29396; linux-kernel@vger.kernel.org
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; cjb@laptop.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
> mappings
> Importance: High
> 
> Dong Aisheng-B29396 wrote at Thursday, December 22, 2011 1:18 AM:
> > Stephen Warren wrote at Wednesday, December 21, 2011 8:39 AM:
> > > Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> > > > This patch provies a common API for driver to use to register
> > > > pinmux mappings from dts file. It is needed for dt support.
> > >
> > > Dong,
> > >
> > > Thanks for providing a concrete binding to get discussion started. I
> > > had intended to do this myself, but got side-tracked on other things.
> > >
> > > I'll comment exclusively on the documentation in this patch, since
> > > any changes there will require the code to be changed.
> >
> > First, thanks for such a long and detailed comments.
> > I spent some time to read and understood.
> >
> > > > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
> > > > +The pin control subsystem
> > > > +
> > > > +The pin control subsystem provides a common API to support
> > > > +parsing pinmux mappings data from device tree. Each board dts
> > > > +file should provide a device node of which all the child nodes
> > > > +are the corresponding
> > > pinmux mappings.
> > >
> > > So, the binding you propose seems very reasonable from the
> > > point-of-view of the Linux pinctrl subsystem. However, it violates
> > > basic device tree philosophy in a few ways. Some background:
> > >
> > > Device tree is supposed to be a pure representation of hardware, not
> > > the software that runs on it. This means a couple of things: (a) the
> > > nodes in the DT generally match 1:1 with specific HW on the board
> > > (b) the design of the bindings should be justifiable given HW
> > > datasheets without any reference to specific operating systems or
> > > software driver design
> > > (c) the DT should be useful to all operating systems that run on the
> > > HW; there should be no "DT for Linux", "DT for FreeBSD", "DT for Windows".
> >
> > I'm not DT expert, but it looks reasonable and correct.
> 
> I'm not sure if you're saying that the original binding seems reasonable or my
> comments seem reasonable.
> 
I mean your comments on DT background seems reasonable.

> > > Hence, I see a few problems with this binding:
> > >
> > > a) The binding is documented as being for the pinctrl subsystem,
> > > rather than for pinmux hardware.
> >
> > Seems yes.
> >
> > > b) The top-level node ("imx6q-sabreauto-map" below) is not tied to
> > > any particular piece of hardware (no compatible flag, not reg
> > > property etc.)
> >
> > My original purpose was that it was not a hw device node, it was just
> > created for containing pin map information and referenced by a phandle
> > in iomuxc deivce node
> > like:
> >
> > iomuxc@020e0000 {
> >         compatible = "fsl,imx6q-iomuxc";
> >         reg = <0x020e0000 0x4000>;
> >         fsl,pinmux-map = <&pinmux>;
> > 	  ...
> > }
> >
> > I could also make it as a sub node of iomuxc, but original design is
> > that sub nodes of Ioxmuc are already representing each pinmux functions.
> > To avoid conflict, I put the imx6q-sabreauto-map node out of iomuxc
> > since a phandle (fsl,pinmux-map ) does the same work well.
> 
> You could have nested sub-nodes, say something like:
> 
> iomuxc@020e0000 {
>     compatible = "fsl,imx6q-iomuxc";
>     reg = <0x020e0000 0x4000>;
>     fsl,pins {
>         ... // fsl-specific pin properties
>     };
>     fsl,groups {
>         ... // fsl-specific group properties
>     };
>     fsl,functions {
>         ... // fsl-specific mux function properties
>     };
>     pinmux-usage {
>         // standardized pinmux "table" properties
>         sd4 { // pin group name
>             function = "sdio4"; // this function active on it
>             ...
>         };
>         ...
>     }
>     ...
> }
> 
Yes, I could do that.
The extra effort is that we have to manually exclude one pinmux-usage
node in pinmux driver since originally i take the child node count of
iomuxc as the function count since all child nodes are functions,
that why I firstly took the mapping node out of iomuxc, in addition
the old way i used seems to be more brief and clear.

I tried adding pinmux-usage as a sub node of iomuxc and got two issues:
Taking imx6q as an example:
iomuxc@020e0000 {
        uart4 {
                func-name = "uart4";
                grp-name = "uart4grp";
                grp-pins = <107 108>;
                num-pins = <2>;
                grp-mux = <4 4>;
                num-mux = <2>;
        };

        sd4 {
                func-name = "sd4";
                grp-name = "sd4grp";
                grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                num-pins = <10>;
                grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                num-mux = <10>;
        };

        pinmux-mapping {
                uart4 {
                        function = "uart4";
                        dev = <&uart4>;
                };

                usdhc4 {
/*			    ctrl-dev-name = "20e0000.iomuxc"; */
                        function = "sd4";
                        dev = <&usdhc4>;
                };
        };
};

If we remove ctrl-dev-name and get it from its parent node in drivers as
you suggested,
first, since this work will be done in the common API (pinmux_of_register_mappings
Requires pass the pinmux mapping node to it for construct the mapping table)
It will introduce a restriction that all platforms should define this node
under their pinctrl device node.
Second, it seems we cannot get its parent node device or device name in driver
(can only get node Name which is not sufficient for construct the pin map table
required by pinctrl core) and current device tree subsystem seems do not support
get its associated device from a device node.
We may not be able to construct ctrl-dev-name or ctrl-dev for struct pinmux_map.
I'm not sure if I missed something, if missed please let me know.
To support it, we may need to add support for converting device node
to device. Not sure it's applicable since I still have not tried it.

The same issue applies to dev using a phandle.

> > For it's not a real hw device node, I was not aware of that DT has
> > such restriction Before. So I may use it wrongly.
> > But I have question that I did some research that it seemed not all
> > the nodes in dts file are pure hw device node
> 
> Certainly there are exceptions; "describe only HW" is more of a general
> principle rather than a completely unbreakable rule I think.
> 
> I think that pinmux usage is a concept that's very HW oriented and can hopefully
> have a pure HW binding, rather than something too influenced by the pinctrl SW.
> 
> > Like:
> > Sound in arch/arm/boot/dts/tegra-harmony.dts.
> >         sound {
> >                 compatible = "nvidia,harmony-sound",
> > "nvidia,tegra-wm8903";
> >
> >                 spkr-en-gpios = <&codec 2 0>;
> >                 hp-det-gpios = <&gpio 178 0>;
> >                 int-mic-en-gpios = <&gpio 184 0>;
> >                 ext-mic-en-gpios = <&gpio 185 0>;
> >         };
> > I did not know how asoc to handle differenct devices binding like soc
> > dai, pcm and machines, But machine device seems not a real hw device.
> 
> I'd still classify this as a pure HW description. While there certainly isn't a
> single thing you can point at in the SoC or board that is the sound card, a
> description of the components and wiring that makes up the sound system
> certainly is a HW description. Note that the binding above also isn't finished,
> and has been reworked a bit since then, although the new one is conceptually
> very similar.
> 
I agree from that point of view.

> > Or even the chosen node:
> > chosen {
> >        bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8
> > root=/dev/mmcblk0p2 rw rootwait"; }; And I guess chosen is also Linux
> > specific, right?
> 
> Yes, that's certainly SW-specific and an exception, and as you pointed out below,
> there are some other exceptions.
> 
> My main point is that when we can design bindings that are purely HW oriented we
> should, and when we can't, we should get as close as we can.
> 
> ...
> > Up to here I understand that your propose is co-locate pinmux Resource
> > within device Node definitions and define pinmux maps in the iomuxc device
> node.
> > (If I understand wrongly, please let me know) It's just like:
> > Sdhci1: sdhci@1000 {
> >     compatible = "...";
> >     regs = <...>;
> >     pinmux = <&pmx>;
> >     pinmux-usage = {
> >         // Some representation of the pins/groups/functions used
> >         // by just this HW block.
> >     };
> > };
> >
> > iomuxc@020e0000 {
> >     compatible = "fsl,imx6-pinmux";
> >     usage {
> >         sd4 {
> >             dev = <&sdhci1>;
> >         };
> >         sd3 {
> >             dev = <&sdhci2>;
> >         };
> >         ...
> >     };
> > };
> > My concern is that would pass the effort to each driver to handle pinmux-usage.
> 
> See a little above for what I was thinking.
> 
> That said, we could  probably handle a standardized pinmux-usage property in
> each driver without impacting each driver too much; it's just that the core
> driver code, or the pinctrl code, would have to scan all device nodes for this
> property and act on it, rather than the drivers for each node, rather like
> regs/interrupts are handled by core code and converted to device resources.
> 
> ...
> > The same question applies to clock and regulator: does each device
> > need Define its clock and regulator properties?
> 
> Yes, in those cases I believe each device does contain a phandle to the
> resources it uses.
> 
I was ever thought putting a phandle of pinmux function in each device,
Then pinmux mapping table seems not need anymore. Like:

usdhc4: usdhc@0219c000 { /* uSDHC4 */
        compatible = "fsl,imx6q-usdhc";
	....
        pinmux = <&pinmux-sd4>;
};

iomuxc@020e0000 {
        pinmux-sd4 : sd4 {
                func-name = "sd4";
                grp-name = "sd4grp";
                grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                num-pins = <10>;
                grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                num-mux = <10>;
        };

It is a pure hw point of view to define node.
And it may need to implement a of_pinmux_get.
But what about the pin maps without device associated?

Regards
Dong Aisheng

