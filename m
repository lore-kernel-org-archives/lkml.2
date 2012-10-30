Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab2J3Lek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:34:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34365 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2J3Lej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:34:39 -0400
Date: Tue, 30 Oct 2012 11:34:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030113407.GA24335@sirena.org.uk>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
X-Cookie: I have many CHARTS and DIAGRAMS..
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 09:12:52PM +0100, Linus Walleij wrote:

> The answer is that it does not know. Because drivers have
> different needs. Depending on how the hardware and
> system is done.

...

> I'm not making this up, it is a very real phenomenon on the
> Ux500 and I don't think we are unique.

> Moving this handling to bus code or anywhere else
> invariably implies that resource acquisition/release order
> does not matter, and my point is that it does.

Doing this in the buses is definitely wrong, as you say it's not bus
specific.  I do however think we can usefully do this stuff in a SoC
specific place like a power domain, keeping the SoC integration code
together and out of the drivers.  IME the SoCs where you need to do
different things for different IPs shoudl mostly still get some reuse
out of such an approach.
