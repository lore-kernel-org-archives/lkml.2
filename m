Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab1LFJi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:38:28 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:1271
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932974Ab1LFJi0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:38:26 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Guo Shawn-R65073 <r65073@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Topic: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Index: AQHMsnlAdrguC9Qi5Ei/Yb1CNiu/O5XO9kEA//+YerA=
Date: Tue, 6 Dec 2011 09:38:20 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F772346A04@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <20111206094203.GC3864@S2100-06.ap.freescale.net>
In-Reply-To: <20111206094203.GC3864@S2100-06.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guo Shawn-R65073
> Sent: Tuesday, December 06, 2011 5:42 PM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
> 
> On Sun, Dec 04, 2011 at 07:49:42PM +0800, Dong Aisheng wrote:
> > +static struct pinmux_ops imx_pmx_ops = {
> > +	.list_functions = imx_pmx_list_funcs,
> > +	.get_function_name = imx_pmx_get_func_name,
> > +	.get_function_groups = imx_pmx_get_groups,
> > +	.enable = imx_pmx_enable,
> > +};
> 
> The pinmux core code will check the pinmux_ops as below.  !ops->disable
> is one of the checking, while you do not have .disable hook.
> 
Then I have to add a disable function.

> int pinmux_check_ops(const struct pinmux_ops *ops) {
>         /* Check that we implement required operations */
>         if (!ops->list_functions ||
>             !ops->get_function_name ||
>             !ops->get_function_groups ||
>             !ops->enable ||
>             !ops->disable)
Not sure if we must check !ops->disable here since some soc may not have
disable function.

>                 return -EINVAL;
> 
>         return 0;
> }
> 
> [...]
> 
> > +static int __init imx_pmx_probe(struct platform_device *pdev) {
> > +	struct device *dev = &pdev->dev;
> > +	struct imx_pmx *ipmx;
> > +	struct resource *res;
> > +	struct imx_pinctrl_info *info;
> > +	resource_size_t res_size;
> > +
> > +	info = (struct imx_pinctrl_info *)pdev->id_entry->driver_data;
> > +	if (!info || !info->pins || !info->groups || !info->functions
> > +		|| (info->maxpin > info->npins)) {
> 
> You must mean !(info->maxpin > info->npins) here?
> 
Yes, thanks for this finding.

> Regards,
> Shawn
> 
> > +		dev_err(&pdev->dev, "wrong pinctrl info\n");
> > +		return -EINVAL;
> > +	}

Regards
Dong Aisheng

