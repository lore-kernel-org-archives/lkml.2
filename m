Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2G2U1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:27:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2G2U1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:27:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
Date: Sun, 29 Jul 2012 20:27:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de> <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
In-Reply-To: <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207292027.34157.arnd@arndb.de>
X-Provags-ID: V02:K0:sKVr8GDFRSOmQyO8KPJn68nrWx9UNIiwlgqmT9MWt22
 BGNHDGlqn2DRC3bwN8B33iLpDTEKhAyFfkLNvP8QQzYsift9rt
 3W3B0HyxAYK6v2cY4OJeu64GdBkoF3asfk7zhRxpmPGrL8bxbv
 DtS82Y+FPom0ZSKustwR5vpD5mLg55iOP933K/Z9f5Y8+HDzDy
 dUIdJ1UOTlw5cOsuvDsXzrwru/OqkWuMBpZgUkXGE6lkgloocE
 w3Tw8xBeEhPhoEhR4nLRfeMj0FzkiYu3IhpNbNIZOMn9PtjhOc
 v1URfqT5LIMy7GwqfGlw5fZdpnyHnOoXJ6Yul7o5r3lCkqiOYL
 /SXNOM9SipXSINdTktcc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 July 2012, Linus Walleij wrote:
> > +- #interrupt-cells: Should be 2. The first cell contains the GPIO number,
> > +  whereas the second cell is used to specify flags:
> > +    bits[3:0] trigger type and level flags
> > +      1 = low-to-high edge triggered
> > +      2 = high-to-low edge triggered
> > +      4 = active high level-sensitive
> > +      8 = active low level-sensitive
> 
> Why on earth would a bunch of flags be an "interrupt cell"?
> 
> Maybe there is something about DT bindings I don't get so
> please educate me.
> 
> I can see that OMAP is doing this, but is it a good idea?
> I really need Rob/Grant to comment on this.

It is in fact a good idea, and it's very common to have it. The point is that
the interrupt controller requires this setting in order to configure that IRQ
for use, so putting it into a property of the device that triggers the IRQ
is the right place to have it.

> > +- interrupt-controller: Marks the device as an interrupt controller.
> > +- nr-gpios: The number of pins supported by the controller.
> 
> These two last things look very generic, like something every GPIO
> driver could want to expose.
> 
> I'd really like to have Grant's word on GPIO DT bindings and how these
> should look, I had some discussion with Wolfram (the I2C maintainer)
> about bindings turning out less generic than they ought to be, so we
> need some discussion on this.
> 
> Arnd recently consolidated some MMC props, maybe we need to do
> the same for GPIO drivers.

The "interrupt-controller" property is standardized by IEEE. Not sure 
about what specifies the "nr-gpios" one, but it seems to be a good idea
to have everyone do the same thing here.

	Arnd
