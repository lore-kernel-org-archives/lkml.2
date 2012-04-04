Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2DDLN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:13:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36109 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab2DDLN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:13:28 -0400
Date: Wed, 4 Apr 2012 12:13:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH] gpio: Device tree support for LPC32xx
Message-ID: <20120404111323.GA9457@sirena.org.uk>
References: <1333407513-18231-1-git-send-email-stigge@antcom.de>
 <20120403150430.EBA423E0436@localhost>
 <4F7B8A39.5000701@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7B8A39.5000701@antcom.de>
X-Cookie: hangover, n.:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 01:39:37AM +0200, Roland Stigge wrote:
> On 03/04/12 17:04, Grant Likely wrote:

> >> +postcore_initcall(lpc32xx_gpio_init);

> ===============================================================
> Error requesting gpio 50
> ...
> gpiochip_add: registered GPIOs 0 to 7 on device: gpio_p0

> Are you sure that module_platform_driver() can already handle
> this in v3.4-rc1?

For the present moment it needs explicit handling in each GPIO user to
translate a failure to get a GPIO into -EPROBE_DEFER.  I sent a patch
which would change the default return code for failed GPIO lookups to
that which should get most users doing the right thing but I've had no
response to that patch so far so it's not in any tree.
