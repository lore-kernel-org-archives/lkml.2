Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2BJUMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:12:41 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab2BJUMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:12:39 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/4i80/UsJQW9gzu3D5qdL2
Date: Fri, 10 Feb 2012 12:12:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Dong Aisheng <dongas86@gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: Add simple pinmux driver using device
 tree data
Message-ID: <20120210201234.GY1426@atomide.com>
References: <20120203205049.4089.74610.stgit@kaulin.local>
 <20120203205508.4089.35304.stgit@kaulin.local>
 <20120207014449.GA2424@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207014449.GA2424@r65073-Latitude-D630>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Sorry for the delay, some of this we already talked this week
at the conference.

* Shawn Guo <shawn.guo@linaro.org> [120206 17:13]:
> On Fri, Feb 03, 2012 at 12:55:08PM -0800, Tony Lindgren wrote:
> > 
> It's so great to eventually see some codes after such an extensive
> discussion on the binding.  The code looks nice to me except a few
> trivial comments below.  The only thing I'm concerned is the register
> level implementation is not so generic to cover controllers like imx
> one, where pinmux and pinconf have separate registers.  If we can make
> that part as generic as pin table creating, function/pingroup/mapping
> generating, the patch will be good for imx to migrate to.

OK, maybe let's see how far we can get by adding other #pinmux-cells
values to parse in addition to 2. And map some registers using
compatible + .data entry related to it.
 
> > +	/* board specific .dts file, such as omap4-sdp.dts */
> > +	pinmux@4a100040 {
> > +		pmx_uart3: pinconfig-uart3 {
> > +			mux = <0x0104 0x100
> > +			       0x0106 0x0>;
> > +                        };
> 
> The line is some leftover which should be deleted?

Thanks that looks wrong..
 
> > +config PINCTRL_SIMPLE
> > +	tristate "Simple device tree based pinmux driver"
> > +	depends on OF
> > +	help
> > +	  This selects the device tree based generic pinmux driver.
> > +
> 
> We would call it pinctrl instead pinmux driver?

Thanks, fixing.
 
> > +	smux->desc->pins = smux->pins.pa;
> > +	smux->desc->npins = smux->pins.max--;
> > +
> Hmm, why do you have pins.max minus 1 here and most of the places where
> it gets used plus 1?  Keep it as it is and use pins.max - 1 in that
> only place I have seen?

Makes sense.

> > +static int __init smux_register(struct smux_device *smux)
> > +{
> > +	int ret;
> > +
> > +	if (!smux->dev->of_node)
> > +		return -ENODEV;
> > +
> > +	smux->pctlops = &smux_pinctrl_ops;
> > +	smux->pmxops = &smux_pinmux_ops;
> 
> I do not see where these two pointers inside smux be used anywhere.
> And also they can be got from smux below anyway.  So why bothering?

Yes those are already gone in the second version I posted.

Regards,

Tony
