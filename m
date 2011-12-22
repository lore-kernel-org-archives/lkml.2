Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1LVISV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:18:21 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:46856
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab1LVISU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:18:20 -0500
X-SpamScore: -16
X-BigFish: VS-16(zz9371I148cM1521M542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
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
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlA=
Date: Thu, 22 Dec 2011 08:18:13 +0000
Message-ID: <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
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

Hi Stephen,

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Wednesday, December 21, 2011 8:39 AM
> To: Dong Aisheng-B29396; linux-kernel@vger.kernel.org
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; cjb@laptop.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
> mappings
> Importance: High
> 
> Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> > This patch provies a common API for driver to use to register pinmux
> > mappings from dts file. It is needed for dt support.
> 
> Dong,
> 
> Thanks for providing a concrete binding to get discussion started. I had
> intended to do this myself, but got side-tracked on other things.
> 
> I'll comment exclusively on the documentation in this patch, since any changes
> there will require the code to be changed.
> 
First, thanks for such a long and detailed comments.
I spent some time to read and understood.

> > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl.txt
> > +The pin control subsystem
> > +
> > +The pin control subsystem provides a common API to support parsing
> > +pinmux mappings data from device tree. Each board dts file should
> > +provide a device node of which all the child nodes are the corresponding
> pinmux mappings.
> 
> So, the binding you propose seems very reasonable from the point-of-view of the
> Linux pinctrl subsystem. However, it violates basic device tree philosophy in a
> few ways. Some background:
> 
> Device tree is supposed to be a pure representation of hardware, not the
> software that runs on it. This means a couple of things: (a) the nodes in the DT
> generally match 1:1 with specific HW on the board (b) the design of the bindings
> should be justifiable given HW datasheets without any reference to specific
> operating systems or software driver design
> (c) the DT should be useful to all operating systems that run on the HW; there
> should be no "DT for Linux", "DT for FreeBSD", "DT for Windows".
>
I'm not DT expert, but it looks reasonable and correct.

> Hence, I see a few problems with this binding:
> 
> a) The binding is documented as being for the pinctrl subsystem, rather than for
> pinmux hardware.
>
Seems yes.

> b) The top-level node ("imx6q-sabreauto-map" below) is not tied to any
> particular piece of hardware (no compatible flag, not reg property etc.)
>
My original purpose was that it was not a hw device node, it was just created for
containing pin map information and referenced by a phandle in iomuxc deivce node
like:
iomuxc@020e0000 {
        compatible = "fsl,imx6q-iomuxc";
        reg = <0x020e0000 0x4000>;
        fsl,pinmux-map = <&pinmux>;
	  ...
}
I could also make it as a sub node of iomuxc, but original design is that sub nodes of
Ioxmuc are already representing each pinmux functions.
To avoid conflict, I put the imx6q-sabreauto-map node out of iomuxc since a phandle
(fsl,pinmux-map ) does the same work well.

For it's not a real hw device node, I was not aware of that DT has such restriction
Before. So I may use it wrongly.
But I have question that I did some research that it seemed not all the nodes in
dts file are pure hw device node
Like:
Sound in arch/arm/boot/dts/tegra-harmony.dts.
        sound {
                compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";

                spkr-en-gpios = <&codec 2 0>;
                hp-det-gpios = <&gpio 178 0>;
                int-mic-en-gpios = <&gpio 184 0>;
                ext-mic-en-gpios = <&gpio 185 0>;
        };
I did not know how asoc to handle differenct devices binding like soc dai, pcm and machines,
But machine device seems not a real hw device.

Or even the chosen node:
chosen {
       bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/mmcblk0p2 rw rootwait";
};
And I guess chosen is also Linux specific, right?

I don't know how DT define such restrictions or if there's an exception?

> c) The design of the binding is very much derived from the design of the pinctrl
> subsystem's internal data structures. This isn't necessarily bad, since in
> general SW data structures might be very closely related to how HW is put
> together. In this case though, the binding seems very SW oriented.
> 
I have the same doubt that some properties of a device node are not pure hw properties
and they're a little depending on the driver design.
Like atmel,use-dma-rx in arch/arm/boot/dts/at91sam9g20.dtsi
                        usart0: serial@fffb0000 {
                                compatible = "atmel,at91sam9260-usart";
                                reg = <0xfffb0000 0x200>;
                                interrupts = <6>;
                                atmel,use-dma-rx;
                                atmel,use-dma-tx;
                                status = "disabled";
                        };
And flash for partitions binding in arch/powerpc/boot/dts/mpc8378_mds.dts,
                flash@0,0 {
                        #address-cells = <1>;
                        #size-cells = <1>;
                        compatible = "cfi-flash";
                        reg = <0 0x0 0x2000000>;
                        bank-width = <2>;
                        device-width = <1>;

                        u-boot@0 {
                                reg = <0x0 0x100000>;
                                read-only;
                        };

                        fs@100000 {
                                reg = <0x100000 0x800000>;
                        };

                        kernel@1d00000 {
                                reg = <0x1d00000 0x200000>;
                        };

                        dtb@1f00000 {
                                reg = <0x1f00000 0x100000>;
                        };
                };
It depends on driver to implement it.

It loos like a historical issue since we have platform data in old way
to tell the driver what features to be enabled or not like pio or dma.
And the platform data is easily to be driver specific.

> > +The required properties for pinmux mapping are:
> > +- map-name: the name of this specific map entry
> > +- clk-dev-name: the name of the device controlling this specific
> > +mapping
> > +- funcion: a function in the driver to use for this mapping
> > +
> > +Optional properties:
> > +- group: a certain specific pin group to activate for the function
> > +- dev-name: the name of the device using this specific mapping
> > +- hog-on-boot: indicate wether hog the mappings(do not need to
> > +specify value)
> > +
> > +Examples:
> > +
> > +pinmux: imx6q-sabreauto-map {
> 
> Here we have an all-encompassing standalone "pinctrl mapping table" node.
> If we continue to have such an all-encompassing table, it should really be part
> of (a child of) the pinmux HW's node in order to tie it directly to the HW,
> rather than standing out as a HW concept. So, perhaps something more like:
> 
> iomuxc@020e0000 {
>     compatible = "fsl,imx6-pinmux";
>     usage { // I can't think of a good name for the table right now
>         sd4 {
>         };
>         sd3 {
>         };
>         ...
>     };
> };
> 
I already define pinmux functions like this:
iomuxc@020e0000 {
        fsl,pinmux-map = <&pinmux>;
        pinmux-uart4 {
                func-name = "uart4";
                grp-name = "uart4grp";
                grp-pins = <107 108>;
                num-pins = <2>;
                grp-mux = <4 4>;
                num-mux = <2>;
        };

        pinmux-sd4 {
                func-name = "sd4";
                grp-name = "sd4grp";
                grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                num-pins = <10>;
                grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                num-mux = <10>;
        };
};
So I move the pinmux mapping node out as I said above.

> Others have suggested that having this all-encompassing table isn't the correct
> approach, and instead, it should be split into chunks that are co-located with
> the devices that use the pinmux:
> 
> sdhci@1000 {
>     compatible = "...";
>     regs = <...>;
>     pinmux = <&pmx>;
>     pinmux-usage = {
>         // Some representation of the pins/groups/functions used
>         // by just this HW block.
>     };
> };
> sdhci@2000 {
>     compatible = "...";
>     regs = <...>;
>     pinmux = <&pmx>;
>     pinmux-usage = {
>         // Some representation of the pins/groups/functions used
>         // by just this HW block.
>     };
> };
> 
> The latter probably is a little more idiomatic, although I haven't seen or
> thought through any details on what goes inside such a "pinmux-usage"
> node yet.
> 
> > +	map-sd4 {
> > +		map-name = "usdhc4";
> 
> I don't think that field is needed; I'd suggest just using the name of the DT
> node containing the entry (which could be renamed to your desired
> names)
> 
Yes, I agree, could remove it.

> > +		ctrl-dev-name = "20e0000.iomuxc";
> ...
> > +		dev-name = "219c000.usdhc";
> 
> That name is Linux-specific. Instead of using device names, we should use
> phandle references, e.g. see the "dev" property below:
> 
Yes, I agree, will consider to change it.

> sdhci1: sdhci@1000 {
> ...
> };
> sdhci2: sdhci@1000 {
> ...
> };
> iomuxc@020e0000 {
>     compatible = "fsl,imx6-pinmux";
>     usage {
>         sd4 {
>             dev = <&sdhci1>;
>         };
>         sd3 {
>             dev = <&sdhci2>;
>         };
>         ...
>     };
> };
> 
> (in the above, your ctrl-dev-name would be implied to be iomuxc@020e0000 since
> the table is part of that pinctrl device's node)
> 
> > +		function = "sd4";
> 
> Here it would be nice to use an integer instead. However, putting lots of opaque
The question is that pinctrl is using string to address the functions.
struct pinmux_map {
        const char *name;
        struct device *ctrl_dev;
        const char *ctrl_dev_name;
        const char *function;
        const char *group;
        struct device *dev;
        const char *dev_name;
        bool hog_on_boot;
};
I wonder if using integer, we may still need to convert it to string to construct
a pinmux map.

> integers in the device tree is going to be ripe for mistakes.
> It's a real pity that dtc doesn't have a way of doing named integer constants,
> so this could be re-written as e.g.:
> 
> SoC .dtsi file:
> 
> /define/ TEGRA_MUX_FUNC_SD4 234
>
Actually I was also thinking if we could use macro in dts file, that could make
life much Easier.
 
> Board .dts file:
> 
> function = <TEGRA_MUX_FUNC_SD4>;
> 
> Without that feature, using strings here seems the only reasonable thing to do.
> 

Up to here I understand that your propose is co-locate pinmux Resource within device
Node definitions and define pinmux maps in the iomuxc device node.
(If I understand wrongly, please let me know)
It's just like:
Sdhci1: sdhci@1000 {
    compatible = "...";
    regs = <...>;
    pinmux = <&pmx>;
    pinmux-usage = {
        // Some representation of the pins/groups/functions used
        // by just this HW block.
    };
};

iomuxc@020e0000 {
    compatible = "fsl,imx6-pinmux";
    usage {
        sd4 {
            dev = <&sdhci1>;
        };
        sd3 {
            dev = <&sdhci2>;
        };
        ...
    };
};
My concern is that would pass the effort to each driver to handle pinmux-usage.

Take mx6q as an example, it may be:
Usdhc4: usdhc@0219c000 { /* uSDHC4 */
        compatible = "fsl,imx6q-usdhc";
        reg = <0x0219c000 0x4000>;
        interrupts = <0 25 0x04>;
        status = "disabled";
        pinmux-sd4 : sd4{
                func-name = "sd4";
                grp-name = "sd4grp";
                grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                num-pins = <10>;
                grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                num-mux = <10>;
        };

};

iomuxc@020e0000 {
    compatible = "fsl,imx6-pinmux";
    usage {
        sd4 {
            dev = <&usdhc4>;
	     function = <&pinmux-sd4>;
        };
        sd3 {
            dev = <&usdhc3>;
        };
        ...
    };
};
And I don't think it follows original design purpose: tell me how you are
and I will handle you everything.
The same question applies to clock and regulator: does each device need
Define its clock and regulator properties?

> We also need to consider compatibility and extensibility. A DT binding is an ABI
> between the kernel and whatever is providing it, and so we need to be able to
> maintain and extend it in a compatible fashion, just like the user-space syscall
> ABI. Now it's true that the .dts files are currently part of the kernel source
> tree and can be rev'd in sync with kernel changes, but that may not always be
> the case moving forward.
> 
Great, i agree and it's an idea state.

> In other words, taking a board with an old device tree embedded into Flash and
> running a new kernel using that device tree should work just like running the
> original kernel did.
> 
> There are a couple of current active areas of change in the pinctrl subsystem
> that impact this:
> 
> * Pin configuration is being added. We probably need to add the data to
> configure pin config into the mapping table in the kernel, or some parallel
> table.
> 
> * Support for pins being in multiple states (active, suspend, unused,
> ...) is being added to pinctrl. We need to be able to represent this in DT too.
> 
> (and yes I know I wrote that from a Linux pinctrl SW perspective, but the
> concepts apply to HW!)
> 
> To support this, we may just be able to add more fields to any mapping table
> entries e.g. to describe pin config setup alongside mux setup.
> It'd probably be a good idea to add some kind of "type" field to the table
> entries though, so that we can transparently add new types in the future, much
> like compatible does for HW nodes.
> 
> iomuxc@020e0000 {
>     compatible = "fsl,imx6-pinmux";
>     usage {
>         sd4 {
>             type = <0>; // 0 == mux setting
>             dev = <&sdhci1>;
>         };
>         sd3 {
>             type = <0>; // 0 == mux setting
>             dev = <&sdhci2>;
>         };
>         foo {
>             type = <1>; // 1 == pin config?
>             dev = <&sdhci2>;
>             pull-up;
>             tri-state;
>             ...
>         };
>         ...
>     };
> };
> 
Basically this is a good idea, it's very easy to understand and to use.
The key problem is where we define the pin groups its related functions
I only see pin mappings and configs here.
Since we need to pass these data to pinctrl subsystem, i don't think
it would be good to let the device driver to handle that things.

As well as pinmux, for pin config, I would also split it into two parts,
whether it shoud be handled by each pinctrl driver or pinctrl core.
If it should be handled by pinctrl driver, then ok, let it handled by
Driver and it's driver owner's responsibility to define those properties
in dt since each soc iomux controller may have different properties and
pinctrl core does not need to be aware of such dt things.

If it should be handled by pinctrl core, we may need to define some common
Properties as it needs to be parsed by pinctrl core like pin mappings.

Based on your idea, for pinconfig, one simple approach I could think is that
for pinctrl driver to handle it.
The properties could be:
iomuxc@020e0000 {
        fsl,pinmux-map = <&pinmux>;
        pinmux-uart4 {
                func-name = "uart4";
                grp-name = "uart4grp";
                grp-pins = <107 108>;
                num-pins = <2>;
                grp-mux = <4 4>;
                num-mux = <2>;
            	   pull-up; /* for group setting */
                tri-state; /* for group setting */
        };

        pinmux-sd4 {
                func-name = "sd4";
                grp-name = "sd4grp";
                grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                num-pins = <10>;
                grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                num-mux = <10>;
		   /* individual setting for each pin; 0: pull-up 1: tri-state */
		   conf = <0, 1, 2 ...>;
        };
};

Maybe finally remove the name properties would be better, like:
        pinmux-uart4 {
                grp-pins = <107 108>;
                num-pins = <2>;
                grp-mux = <4 4>;
                num-mux = <2>;
            	   pull-up; /* for group setting */
                tri-state; /* for group setting */
        };

Regards
Dong Aisheng

