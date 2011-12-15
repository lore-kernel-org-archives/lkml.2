Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1LOG4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:56:34 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:34129
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab1LOG4d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:56:33 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 15:05:08 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Dong Aisheng <b29396@freescale.com>,
        <linus.walleij@stericsson.com>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [RFC PATCH v2 4/4] mmc: sdhci-esdhc-imx: using pinmux subsystem
Message-ID: <20111215070505.GA22541@S2101-09.ap.freescale.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-5-git-send-email-b29396@freescale.com>
 <20111214211152.GM27267@pengutronix.de>
 <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CACRpkdYHtgx3Qgx4QRdgOahQXjvSWE_iogWCZjaYQ-VnyS62uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:15:53PM +0100, Linus Walleij wrote:
> On Wed, Dec 14, 2011 at 10:11 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Thu, Dec 15, 2011 at 12:03:42AM +0800, Dong Aisheng wrote:
> 
> >> +     pmx = pinmux_get(&pdev->dev, NULL);
> >> +     if (IS_ERR(pmx)) {
> >> +             err = PTR_ERR(pmx);
> >> +             goto err_pmx_get;
> >> +     }
> >> +     err = pinmux_enable(pmx);
> >> +     if (err)
> >> +             goto err_pmx_enable;
> >> +     imx_data->pmx = pmx;
> >> +
> >
> > Won't this break every i.MX except i.MX6?
> 
It will not if we do not compile other imx together with imx6, because
there are a set of empty functions defined in
include/linux/pinctrl/pinmux.h for those builds without pinctrl enabled.
But yes, it's actually broken since we are on the way to compile imx3,
imx5 and imx6 as single image.

> Not this patch on its own, first the machines have to
> select PINCTRL
> select PINMUX_FOO
> 
> *Then* it will break :-D
> 
> So if you want to do this for i.MX you need something like
> selectable dummy pinmuxes, i.e. pinmux_get() to return something
> that just say "OK" to everything like the dummy regulators.
> 
> Shall I try to create something like that?
> 
Isn't the empty functions defined in include/linux/pinctrl/pinmux.h
for this purpose?  It does not solve the problem with single image.
You might probably mean that we create a dummy_pinctrl_desc and register
it to pinctrl core with pinctrl_register() if we detect that the kernel
is running on a soc that has no pinctrl support?

This is not a problem to pinctrl migration only.  We have the same
problem with common clk migration.  Unless we migrate imx3, imx5 and
imx6 to common clk at the same time, single image build just does not
cope with clk_* api.

-- 
Regards,
Shawn

