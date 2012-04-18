Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2DRHJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:09:13 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:25417
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab2DRHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:09:12 -0400
X-SpamScore: -24
X-BigFish: VS-24(zzbb2dI9371I146fI179dN1102I1432N98dK1447Mzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 18 Apr 2012 15:19:20 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120418071920.GC18021@shlinux2.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
 <4F8DD986.9080702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F8DD986.9080702@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Firstly, thanks for the detailed review. :-)

On Wed, Apr 18, 2012 at 04:58:46AM +0800, Stephen Warren wrote:
> On 04/13/2012 10:18 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > The driver has mux and config support while the gpio is still
> > not supported.
> > For select input setting, the driver will handle it internally
> > and do not need user to take care of it.
> > 
> > The pinctrl-imx core driver will parse the dts file and dynamically
> > create the pinmux functions and groups.
> > 
> > Each IMX SoC pinctrl driver should register pins with a pin register map
> > including mux register and config register and select input map to core
> > for proper operations.
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,imx6q-pinctrl.txt
> 
> > +* Freescale IOMUX Controller (IOMUXC) for i.MX
> > +
> > +The IOMUX Controller (IOMUXC), together with the IOMUX, enables the IC
> > +to share one PAD to several functional blocks. The sharing is done by
> > +multiplexing the PAD input/output signals. For each PAD there are up to
> > +8 muxing options (called ALT modes). Since different modules require
> > +different PAD settings (like pull up, keeper, etc) the IOMUXC controls
> > +also the PAD settings parameters.
> > +
> > +Required properties:
> > +
> > +- compatible: "fsl,imx6q-iomuxc"
> > +- fsl,pins : An array of strings. Each string represents the name of a pin.
> > +  Refer to the following table for the availabe pins of imx6q to use.
> > +- fsl,function: A string containing the name of the function to mux to the pin.
> 
> This document should really distinguish between required properties for
> the top-level controller node ("compatible") and in the pin
> configuration nodes ("fsl,pins", "fsl,function", and all the optional
> properties below). As written, the documentation says I need "fsl,pins"
> at the top-level.
> 
Yes, it's true.
I should distinguish them in doc.

> Note that the documentation for fsl,function talks about a single
> string, whereas the example below and the patch 3 in this series contain
> an fsl,mux property that contains integers.
> 
Sorry, this one is dropped.
I missed delete it in the doc.

> > +Requirements to use pinctrl-imx driver based on dt:
> > +1. The pinmux function nodes should be defined under iomux controller node
> > +2. The pin group nodes should be defined under function node which this group
> > +   is intend to work on.
> > +
> > +The hierarchy is:
> > +iomuxc@020e0000 {
> > +	func-a {
> > +		group-a {
> > +			fsl,pins = "PIN_A",
> > +				   "PIN_B",
> > +				   ....
> > +			fsl,mux = <...>,
> > +			fsl,pull = <..>;
> > +			fsl,drive-strength = <..>;
> > +			...
> > +		};
> > +
> > +		group-b {
> > +			...
> > +		};
> > +		...
> > +	};
> > +
> > +	func-b {
> > +		...
> > +	};
> > +	...
> > +};
> 
> I'd like to see some more explanation in the above part of the document.
> In particular, what is the motivation for having a two-level binding
> structure (group-a within func-a) rather than just having func-a
> directly underneath the pin controller's node. How is a device tree
> author supposed to know what to name the "func-a" and "group-a" nodes,
> and how many "group-a"/"group-b" nodes should be inside a single
> "func-a" node and why?
> 
Yes, i will rich the document.

> > +The function node name will be parsed as the pinmux function node, the group
> > +node name will be parsed as the group name.
> 
> I don't understand that sentence. As far as I can tell, the names of the
> function/group nodes aren't used for anything, at least according to the
> binding documentation.
> 
They're used to name the function name and group name.
I will update the doc.

> > diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> 
> >  obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
> >  obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
> >  obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
> > +obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
> 
> It might be nice to keep this list sorted as possible (admittedly COH901
> isn't). Same goes for Kconfig.
> 
Yes, will do it.

> > diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
> 
> > +static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
> > +				       unsigned selector)
> > +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	if (selector >= info->ngroups)
> > +		return NULL;
> 
> I think we decided to remove this error-checking from the drivers and
> rely on the pinctrl core not to be bad to drivers. Certainly, a patch
I guess pinctrl core can't guarantee it.
The group count is returned by driver, core uses the count to find group
name, If the count returned is not the correct one, without checking,
the kernel may get oops here, right?
Anyway, i think the driver can guarantee it, so it's ok for me to remove
it.

> from Viresh was committed to the Tegra driver to do that.
> 
> > +static int imx_pinconf_group_set(struct pinctrl_dev *pctldev,
> > +				   unsigned group, unsigned long config)
> 
> > +	/* save the current group config value */
> > +	info->groups[group].config = config;
> 
> This is only so imx_pinconf_group_get() can return it right? Why not
Yes.
> just read the value back from the register of the first pin in the group?
Yes, will do like that.

> 
> > +struct pinconf_ops imx_pinconf_ops = {
> > +	.pin_config_get = imx_pinconf_get,
> > +	.pin_config_set = imx_pinconf_set,
> 
> Given that the DT parsing code only generates group config, I'm not sure
> you need to implement the per-pin config get/set; I don't think it will
> ever get used?
> 
Hmm, i guess i implemented it for two reasons:
1) there're pin config APIs for other driver to call and imx does support
config per pin.
2) sysfs debug information

> > +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> > +			struct imx_pinctrl_info *info, u32 index)
> 
> Oh, I see.
> 
> You're defining the set of functions exported from the driver based on
> the content of the pin configuration nodes in device tree. I must admit,
> I don't like that much, and I didn't get that impression at all from
> reading the binding document.
> 
I will rich the document but i'm not sure i should talk too much about the
driver specific things in binding doc.
It seems the binding doc should represents more hw things, right?

> I know that there's some disagreement over whether the groups that a pin
> controller driver exposes should be limited to groups that actually
> exist in HW registers or not, but surely at least the functions that the
> driver exposes should actually correspond directly to the function in
> the HW registers?
> 
I have slightly different opinions, they're related.
As GROUP, FUNCTION is also an abstract idea.
(some SoCs may not have hw pin GROUP like IMX)
People use GROUP since we can group a set of pins for one device/FUNCTION to use.
If we exposes functions per pin based on hw registers, then the GROUP idea may not
suitable for pin based SoC.
(Thinking current pinctrl subsystem only enables functions per GROUP)
The only way is as you did for tegra3, one pin is a group.
This is option and it works. But i think, in the future, we may be better
make the pinctrl subsystem also supports mux per pin since the idea of one
pin GROUP is a little not very suitable for the GROUP idea from literal meaning.

For IMX, we may not choose one pin based group since it's not easy to use
and will make the driver much bigger.

As we already agree that we do not limit people to define GROUP which
should only exist in HW register(hw GROUP), IOW we allow to use 'virtual' group,
then we should not force people to define FUNCTION per hw GROUP too, right?

So IMX defines FUNCTION per device or 'virtual' group(a set of pins for that device)
since IMX does not have hw pin GROUP.

> > +#else
> > +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> > +				struct imx_pinctrl_info *info)
> > +{
> > +	return -ENODEV;
> > +}
> > +#endif
> 
> Hmm. If this driver is device-tree-only, shouldn't it depend on
> CONFIG_OF in the Kconfig file? Then, you could remove all the "ifdef
Yes, i think i should start with dt only and add non-dt support when it
really happens.

> CONFIG_OF" from this file. The rest of my comments assume you do want to
> support CONFIG_OF-vs-not.
> 
> > +static const struct of_device_id imx_pmx_dt_ids[] = {
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
> 
> Other parts of the driver say "ifdef CONFIG_OF". You might want to here too.
> 
Yes, correct.

> > +static int __init imx_pmx_probe(struct platform_device *pdev)
> 
> > +	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
> 
> > +	ipmx->base = devm_ioremap_nocache(dev, res->start, res_size);
> 
> You can combine those two into devm_request_and_ioremap() if you want.
> 
Yes, will switch to it.

> > +static int __exit imx_pmx_remove(struct platform_device *pdev)
> 
> > +	platform_set_drvdata(pdev, NULL);
> 
> There's no need to clear the drvdata.
> 
will remove.

> > +static struct platform_driver imx_pmx_driver = {
> > +	.driver = {
> > +		.name = DRIVER_NAME,
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = imx_pmx_dt_ids,
> 
> Perhaps = of_match_ptr(imx_pmx_dt_ids)?
> 
Yes, will use it.

Regards
Dong Aisheng

