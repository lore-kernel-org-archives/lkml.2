Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1LOHfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:35:08 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:28473
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751752Ab1LOHfH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:35:07 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz9371I1447M542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
Thread-Topic: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
Thread-Index: AQHMunjd/61Fyc2SoU2quzVm3Ah6epXcBDGAgAB8FkA=
Date: Thu, 15 Dec 2011 07:35:03 +0000
Message-ID: <7FE21149F4667147B645348EC605788505626C@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-3-git-send-email-b29396@freescale.com>
 <CACRpkdY=Zerp+ULAdv4PHD+u-65PrAci7rQRbkso5KE05UqdOA@mail.gmail.com>
In-Reply-To: <CACRpkdY=Zerp+ULAdv4PHD+u-65PrAci7rQRbkso5KE05UqdOA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Linus Walleij
> Sent: Thursday, December 15, 2011 2:01 AM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; Guo Shawn-R65073;
> kernel@pengutronix.de; grant.likely@secretlab.ca; rob.herring@calxeda.com
> Subject: Re: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
> Importance: High
> 
> On Wed, Dec 14, 2011 at 5:03 PM, Dong Aisheng <b29396@freescale.com>
> wrote:
> 
> > The driver contains the initial support for imx53 and imx6q.
> 
> Cool! Comments below...
> 
>
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinmux-imx-core.c
> 
> We should start naming these pinctrl-* rather than pinmux-* so just
> rename it.
> 
> Until here it looks like business as usual..
> 
Sure, will rename in next version.

> > +#ifdef CONFIG_OF
> > +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> > +                       struct imx_pinctrl_info *info, u32 num) {
> > +       struct imx_pmx_func *function;
> > +       struct imx_pin_group *group;
> > +       int ret, len;
> > +
> > +       dev_dbg(info->dev, "parse function %d\n", num);
> > +
> > +       group = &info->groups[num];
> > +       function = &info->functions[num];
> > +
> > +       /* Initialise group */
> > +       ret = of_property_read_string(np, "grp_name", &group->name);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get grp_name\n");
> > +               return ret;
> > +       }
> > +
> > +       ret = of_property_read_u32(np, "num_pins", &group->num_pins);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get num_pins\n");
> > +               return ret;
> > +       }
> > +
> > +       ret = of_property_read_u32(np, "num_mux", &group->num_mux);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get num_mux\n");
> > +               return ret;
> > +       }
> > +
> > +       if (group->num_pins != group->num_mux)
> > +               return -EINVAL;
> > +
> > +       group->pins = devm_kzalloc(info->dev, group->num_pins *
> > + sizeof(unsigned int),
> > +                               GFP_KERNEL);
> > +       group->mux_mode = devm_kzalloc(info->dev, group->num_mux *
> > + sizeof(unsigned int),
> > +                               GFP_KERNEL);
> > +       if (!group->pins || !group->mux_mode)
> > +               return -ENOMEM;
> > +
> > +       /* sanity check */
> > +       if (of_get_property(np, "grp_pins", &len) &&
> > +               len != group->num_pins * sizeof(unsigned int)) {
> > +               dev_err(info->dev, "wrong pins number?\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (of_get_property(np, "grp_mux", &len) &&
> > +               len != group->num_mux * sizeof(unsigned int)) {
> > +               dev_err(info->dev, "wrong pin mux number?\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       ret = of_property_read_u32_array(np, "grp_pins",
> > +                       group->pins, group->num_pins);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get grp_pins\n");
> > +               return ret;
> > +       }
> > +
> > +       ret = of_property_read_u32_array(np, "grp_mux",
> > +                       group->mux_mode, group->num_mux);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get grp_mux\n");
> > +               return ret;
> > +       }
> > +
> > +       /* Initialise function */
> > +       ret = of_property_read_string(np, "func_name",
> > + &function->name);
> > +       if (ret) {
> > +               dev_err(info->dev, "failed to get func_name\n");
> > +               return ret;
> > +       }
> > +
> > +       function->groups = devm_kzalloc(info->dev, sizeof(char **),
> > + GFP_KERNEL);
> > +       function->num_groups = 1;
> > +       function->groups[0] = group->name;
> > +
> > +       dev_dbg(info->dev, "func_name %s grp_name %s num_groups %d\n",
> > +                               function->name, function->groups[0],
> > +                               function->num_groups);
> > +
> > +       return 0;
> > +}
> > +
> > +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> > +                               struct imx_pinctrl_info *info) {
> > +       struct device_node *np = pdev->dev.of_node;
> > +       struct device_node *child = NULL;
> > +       int ret, i;
> > +       u32 nfuncs = 0;
> > +
> > +       if (!np)
> > +               return -ENODEV;
> > +
> > +       nfuncs = of_get_child_number(np);
> > +       if (nfuncs <= 0) {
> > +               dev_err(&pdev->dev, "no functions defined\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       info->nfunctions = nfuncs;
> > +       info->functions = devm_kzalloc(&pdev->dev, nfuncs *
> > + sizeof(struct imx_pmx_func),
> > +                                       GFP_KERNEL);
> > +       if (!info->functions)
> > +               return -ENOMEM;
> > +
> > +       /* DT file only passes one group per one function */
> > +       info->ngroups = nfuncs;
> > +       info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct
> > + imx_pin_group),
> > +                                       GFP_KERNEL);
> > +       if (!info->groups)
> > +               return -ENOMEM;
> > +
> > +       child = NULL;
> > +       i = 0;
> > +       for_each_child_of_node(np, child) {
> > +               ret = imx_pmx_parse_functions(child, info, i++);
> > +               if (ret) {
> > +                       dev_err(&pdev->dev, "failed to parse
> > + function\n");
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +#else
> > +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> > +                               struct imx_pinctrl_info *info) {
> > +       return -ENODEV;
> > +}
> > +#endif
> 
> Looks clever to me! And I think we have agreed that this probing must be
> inside each driver.
> 
Yes.

> Can we have a look at the corresponding device tree?
> (...)
> 
> > +++ b/drivers/pinctrl/pinmux-imx-core.h
> 
> Name this pinctrl-* too for consistency.
> 
> (...)
> > +#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
> 
> Now I start to think about the range generators I discussed with
> Haojian... but there doesn't seem to be very many ranges in this driver
> so I guess it would only confuse things.
> 
Yes, I was once also thinking about it when I first looked at the pinctrl,
one concern is that we have to use the id for pin group defines,
So not sure if it's suitable to generate pin id dynamically.

> > +#define IMX_PIN_GROUP(n, p, m)  \
> > +       {                       \
> > +               .name = n,      \
> > +               .pins = p,      \
> > +               .num_pins = ARRAY_SIZE(p),      \
> > +               .mux_mode = m,  \
> > +               .num_mux = ARRAY_SIZE(m),       \
> > +       }
> > +
> > +#define IMX_PMX_FUNC(n, g)  \
> > +       {                       \
> > +               .name = n,      \
> > +               .groups = g,    \
> > +               .num_groups = ARRAY_SIZE(g),    \
> > +       }
> 
> This looks pretty smart!
> 
> > +++ b/drivers/pinctrl/pinmux-imx53.c
> 
> Name this pinctrl-*
> 
> > diff --git a/drivers/pinctrl/pinmux-imx6q.c
> > b/drivers/pinctrl/pinmux-imx6q.c
> 
> This too.
> 
> This patch is overall very good, we're quickly approaching merge quality.
>
Will fix them all.
Thanks for the review.

Regards
Dong Aisheng 

> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


