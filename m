Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1JCOgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 10:36:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34002 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1JCOf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 10:35:58 -0400
Date: Mon, 3 Oct 2011 15:35:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Artamonow <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/6] ASoC: codecs: AK4641 depends on
 GPIOLIB
Message-ID: <20111003143553.GG23811@sirena.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1317587284-2776-3-git-send-email-arnd@arndb.de>
 <20111002204106.GB5811@opensource.wolfsonmicro.com>
 <20111003134527.GF11710@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003134527.GF11710@n2100.arm.linux.org.uk>
X-Cookie: Batteries not included.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 02:45:27PM +0100, Russell King - ARM Linux wrote:
> On Sun, Oct 02, 2011 at 09:41:07PM +0100, Mark Brown wrote:

> > No, gpiolib is one implementation of the GPIO API but if platforms want
> > to go and define their own that's currently OK (personally I think at
> > this point we should just be converting all the stragglers over to
> > gpiolib).  As things stand we shouldn't have dependencies on a
> > particular implementation of the API.

> Then it should depend on GENERIC_GPIO (not to be confused with GPIO_GENERIC,
> the generic gpiolib driver), which is the symbol meaning that the GPIO API
> is provided by something.

Not for devices like this where the GPIOs are an optional thing the
driver can use, a dependency is far too strong.  Devices like that
should be able to rely on the stubs.
