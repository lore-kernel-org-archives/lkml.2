Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1JJMUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:20:49 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:37939
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab1JJMUs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:20:48 -0400
X-SpamScore: -18
X-BigFish: VS-18(zz9371K1432Nea8N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Mon, 10 Oct 2011 20:30:19 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
Message-ID: <20111010123018.GD24198@S2100-06.ap.freescale.net>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
 <20111009093651.GC24198@S2100-06.ap.freescale.net>
 <CACRpkdbdz0FE57TdVryKD+X2=1sf-M9NgiZzm+Sm+WYhU6n_bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CACRpkdbdz0FE57TdVryKD+X2=1sf-M9NgiZzm+Sm+WYhU6n_bQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:23:53AM +0200, Linus Walleij wrote:
> On Sun, Oct 9, 2011 at 11:36 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> >> + * @hog_on_boot: if this is set to true, the regulator subsystem will itself
> >                                                ^^^^^^^^^
> > s/regulator/pinmux?
> 
> Yep!
> 
> >> +#endif /* !CONFIG_PINCTRL */
> >
> > s/!CONFIG_PINCTRL/CONFIG_PINMUX?
> 
> Yep!
> 
> Foldes into original patch with a fixup comment.
> 
> Can I have your Reviewed-by: tag on this subsystem?
> 
Sorry, not yet.  This is not a full review.  I'm trying to migrate imx
pinctrl to the subsystem.  And all these are just some random spotting.

Another couple of typo on pinctrl.txt?

> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> new file mode 100644
> index 0000000..2915fea
> --- /dev/null
> +++ b/Documentation/pinctrl.txt
> @@ -0,0 +1,951 @@

[...]

> +The example 8x8 PGA package above will have pin numbers 0 thru 63 assigned to
> +its physical pins. It will name the pins { A1, A2, A3 ... H6, H7, H8 } using
> +pinctrl_register_pins_[sparse|dense]() and a suitable data set as shown

It should just be pinctrl_register_pins()?

> +earlier.

[...]

> +System pinmux hogging
> +=====================
> +
> +A system pinmux map entry, i.e. a pinmux setting that does not have a device
> +associated with it, can be hogged by the core when the pin controller is
> +registered. This means that the core will attempt to call regulator_get() and
> +regulator_enable() on it immediately after the pin control device has been
> +registered.

s/regulator_get/pinmux_get, and s/regulator_enable/pinmux_enable

-- 
Regards,
Shawn

