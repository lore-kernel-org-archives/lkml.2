Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337Ab2JYU7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:59:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59736 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2JYU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:59:09 -0400
Date: Thu, 25 Oct 2012 21:59:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121025205901.GA3827@sirena.org.uk>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
 <20121024185818.GB772@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024185818.GB772@arwen.pp.htv.fi>
X-Cookie: Oh Dad!  We're ALL Devo!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:58:19PM +0300, Felipe Balbi wrote:

> need a way to tell drivers/base "hey, don't touch pinctrl at all because
> I know what I'm doing" and that has to happen before probe() too,
> otherwise it's already too late and, according to what you suggest,
> drivers/base will already have touched pinctrl. The only way I see would
> be to add an extra "dont_touch_my_pins" field to every driver structure
> in the kernel. Clearly what you say is nonsense.

I suspect that's not actually a big deal and that if we went down this
route we'd have the driver take over control from the core code during
probe() with the core still setting up the default state.

Personally I do think we want to be factoring bolierplate out of
drivers, if they're not doing anything constructive with pinctrl they
should be able to avoid having code for it.  There definitely are issues
to work through but it seems like we ought to be able to do something.
