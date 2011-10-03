Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1JCQew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:34:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55285 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1JCQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:34:48 -0400
Date: Mon, 3 Oct 2011 17:34:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Artamonow <mad_soft@inbox.ru>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/6] ASoC: codecs: AK4641 depends on
 GPIOLIB
Message-ID: <20111003163441.GH23811@sirena.org.uk>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
 <1343003.MpQlxoEPa6@wuerfel>
 <20111003152002.GP3731@opensource.wolfsonmicro.com>
 <9353092.2X2OeIUYGE@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9353092.2X2OeIUYGE@wuerfel>
X-Cookie: Batteries not included.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 06:19:48PM +0200, Arnd Bergmann wrote:

> When the GPIO API is stubbed out, the definition of struct gpio
> is empty, so you cannot access the members, which seems to be
> intentional behavior.

That doesn't seem terribly helpful, it means drivers either need to
ifdef or not use the bulk functions.

>  struct device;
> -struct gpio;
> +struct gpio {
> +       unsigned        gpio;
> +       unsigned long   flags;
> +       const char      *label;
> +};

This looks much more sensible to me.

>  	select SND_SOC_WL1273 if MFD_WL1273_CORE
> -	select SND_SOC_WM1250_EV1 if I2C
> +	select SND_SOC_WM1250_EV1 if I2C && GENERIC_GPIO

Or ifdefs in the driver.
