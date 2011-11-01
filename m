Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1KAS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:27:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57923 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab1KAS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:27:24 -0400
Date: Tue, 1 Nov 2011 18:27:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Paul Mundt <lethal@linux-sh.org>, Tony Lindgren <tony@atomide.com>,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] regulator: Provide dummy supply support
Message-ID: <20111101182720.GH10029@opensource.wolfsonmicro.com>
References: <1319833618-25190-1-git-send-email-s.hauer@pengutronix.de>
 <20111028215931.GA30366@opensource.wolfsonmicro.com>
 <20111028224757.GG23421@pengutronix.de>
 <201111011350.17425.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111011350.17425.vapier@gentoo.org>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 01:50:14PM -0400, Mike Frysinger wrote:
> On Friday 28 October 2011 18:47:57 Sascha Hauer wrote:

> > > We already have a dummy regulator driver and a fixed voltage regulator
> > > driver, we shouldn't be adding a third implementation of the same thing.
> > > Just use the fixed voltage regulator for this.

> > I explained in my mail why I think that the current implementation of
> > the dummy regulator is not suitable for things apart from debugging.

> your complaints seem to be specific to how the dummy regulator gets hooked in 
> and not in the specific regulator implementation.  so it seems like the right 
> thing would be to split the kconfig knobs:

Quite.  Sascha, your mail doesn't refer to the implementation of the
regulator itself at all.  Nothing in your changelog even mentions that
you're introducing a new regulator driver.

I think there's a big abstraction understanding failure here, reading
your changelog I'm not sure you understand the existing mechainsms that
are in place.  You say:

| This patch allows a board to register dummy supplies for devices
| which need a regulator but which is not software controllable
| on this board.

but this is exactly the use case the fixed voltage regulator is there
for.

>  config REGULATOR_DUMMY
> -	bool "Provide a dummy regulator if regulator lookups fail"
> +	bool "Provide a dummy regulator"
> +config REGULATOR_DUMMY_FALLBACK
> +	bool "Fallback to dummy regulator if lookup fails"
> +	depends on REGULATOR_DUMMY

As I think I said earlier I'd use the fixed regulator for this, all
Sascha's actually doing here is adding a wrapper to simplify
registration of that.
