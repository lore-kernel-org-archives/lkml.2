Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1LIRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:07:28 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14177 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619Ab1LIRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:07:27 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+D47kWAgiYskuh4Oue07Mu
Date: Fri, 9 Dec 2011 09:07:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC 1/3] pinctrl: add a driver for NVIDIA Tegra
Message-ID: <20111209170722.GO31337@atomide.com>
References: <1323382390-14892-1-git-send-email-swarren@nvidia.com>
 <1323382390-14892-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYDn0V7SeQuFiFDMxGkybvg6PGf7jxid8ECGB7Azkj3zw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [111209 05:29]:
> On Thu, Dec 8, 2011 at 11:13 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > This adds a driver for the Tegra pinmux, and required parameterization
> > data for Tegra20 and Tegra30.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> This is looking good from a framework point of view (obviously,
> since you've designed the framework with me you sure know what
> you're doing).
> 
> What we could worry about is the amount of hard-coded chip data
> which sort of correlates with the discussion with Tony on how to
> provide DT info for pin control drivers.
> 
> If say this same controller appear in Tegra 4 with no changes but
> different pin names, it makes sense to try to push this into the
> DT as soon as possible, so as to avoid the situation Tony is
> having with the OMAP muxes. If Tegra 4 will be all-new and not even
> related, it doesn't.
> 
> So, just think a bit about it.
> 
> It will fit way better here than any place under
> arch/arm/* in any case, so it's a great achievement!

Sorry I still need some more time with pinmux-simple.c, will have
to get pending omap patches merged first. Just want to recap the
findings so far:

- We can have automatically generated device to pinmux driver
  mapping from DT, so that's nice

- Describing pins for each driver in DT is still open.. And
  using mixed-property arrays in DT won't nicely as the data
  gets unaligned easily with string properties..

- We currently have hard time supporting pin groups with pins
  coming from multiple pinmux driver instances

- Mixing pinmux data from various sources is still open; Some
  pinmux data may need to be static, some come from DT, some
  come from loadable modules or even /lib/firmware if the data
  gets insanely big. Basically we may not always have a phandle
  in DT data for the pinmux function, and should somehow allow
  also using names there

Regards,

Tony
