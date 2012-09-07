Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab2IGVj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:39:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14017 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757072Ab2IGVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:39:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WnGpzwFXFnlXZpXhxNVSX
Date: Fri, 7 Sep 2012 14:39:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-single: Make sure we do not
 change bits outside of mask
Message-ID: <20120907213922.GN1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <1346835718-21325-2-git-send-email-peter.ujfalusi@ti.com>
 <20120906185937.GY1303@atomide.com>
 <CACRpkdY8PLQxP85hBo4-s8hYGxQH_hKD_YwzBc6m4gnkGBknmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY8PLQxP85hBo4-s8hYGxQH_hKD_YwzBc6m4gnkGBknmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120907 14:13]:
> On Thu, Sep 6, 2012 at 8:59 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Peter Ujfalusi <peter.ujfalusi@ti.com> [120905 02:02]:
> >> Use the pcs->fmask to make sure that the value is not changing (setting)
> >> bits in areas where it should not.
> >> To avoid situations like this:
> >>
> >> pmx_dummy: pinmux@4a100040 {
> >>       compatible = "pinctrl-single";
> >>       reg = <0x4a100040 0x0196>;
> >>       #address-cells = <1>;
> >>       #size-cells = <0>;
> >>       pinctrl-single,register-width = <16>;
> >>       pinctrl-single,function-mask = <0x00ff>;
> >> };
> >>
> >> &pmx_dummy {
> >>       pinctrl-names = "default";
> >>       pinctrl-0 = <&board_pins>;
> >>
> >>       board_pins: pinmux_board_pins {
> >>               pinctrl-single,pins = <
> >>                       0x6c 0xf0f
> >>                       0x6e 0x10f
> >>                       0x70 0x23f
> >>                       0x72 0xa5f
> >>               >;
> >>       };
> >> };
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >
> > Thanks this is a valid fix:
> >
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Since nothing in v3.6 is using pinctrl-simple yet, it's not a regression
> right?

Right.
 
> So can you just group this with the other pinctrl things you are
> harvesting in the OMAP tree? I was going to push it for
> the v3.7 cycle otherwise.

You can take this for v3.7, the changes I have are just adding .dts
entries to use the driver. The driver related changes are being
merged by the related driver lists.

Regards,

Tony
