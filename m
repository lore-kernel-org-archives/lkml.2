Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1ERVV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:21:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45947 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1ERVV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:21:57 -0400
Date: Wed, 18 May 2011 22:21:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kyungmin Park <kmpark@infradead.org>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110518212154.GA20909@sirena.org.uk>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com> <20110503172712.GE6538@lunn.ch> <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com> <20110515133312.GM4071@lunn.ch> <BANLkTi=O_mZEqMhOS_Fz0vAYCQ-XpyG4UA@mail.gmail.com> <BANLkTi=TDiAziQU0fYBiK_Npk0x50av7tA@mail.gmail.com> <BANLkTikUbxHQH-sAP+uOy7bnpZcyN_GHxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikUbxHQH-sAP+uOy7bnpZcyN_GHxQ@mail.gmail.com>
X-Cookie: Forgive and forget.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:02:47PM +0200, Linus Walleij wrote:
> 2011/5/17 Kyungmin Park <kmpark@infradead.org>:

> > In this case we only need to set the function at interrupt by like
> > s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
> > So pinmux function provides this feature also.

> This function:
> s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));

> Isn't part of the gpiolib I can see, I am discussing with Grant
> how to handle custom GPIO configuration. Looking in
> archa/arm/plat-samsung/include/plat/gpio-core.h

> it looks like you have your own reimplementation of the
> entire gpiolib in order to get these special configuration
> functions... (So hopefully if I can add custom GPIO
> configs to gpiolib, all of this can move to drivers/gpio/*)

This API predates the generic GPIO API - it's a reimplementation because
at that time the various platforms all had their own custom APIs.  The
Samsung specific API is pretty much only used for the pin mux and mode
configuration these days.
