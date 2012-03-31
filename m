Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2CaVJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:09:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45139 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2CaVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:09:23 -0400
Date: Sat, 31 Mar 2012 22:09:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Geon Si Jeong <gshark.jeong@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] leds: Add LED driver for lm3556 chip
Message-ID: <20120331210913.GA19965@sirena.org.uk>
References: <1333089508-8501-1-git-send-email-gshark.jeong@gmail.com>
 <1333089508-8501-2-git-send-email-gshark.jeong@gmail.com>
 <20120330185634.GB3384@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330185634.GB3384@pengutronix.de>
X-Cookie: No alcohol, dogs or horses.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 08:56:34PM +0200, Wolfram Sang wrote:
> On Fri, Mar 30, 2012 at 03:38:28PM +0900, Geon Si Jeong wrote:

> > +EXPORT_SYMBOL_GPL(lm3556_write_bits);

> Seeing all these functions it may be worth converting to REGMAP.
> Then you already have regmap_update_bits and the like.

Plus cache and debug infrastructure if that's useful.

> > +static ssize_t lm3556_indicator_pattern_store(struct device *dev,
> > +					      struct device_attribute *devAttr,
> > +					      const char *buf, size_t size)

> > +static DEVICE_ATTR(pattern, 0644, NULL, lm3556_indicator_pattern_store);

> I don't know the LED subsytsem very well. Is it that specific to the chip so we
> need a DEVICE_ATTR? Or can this be generalized in the core?

Alternatively some documentation indicating what the userspace ABI is
might help someone identify if there's a relevant feature more easily :)
If it's periodic blinking then there's definitely a core feature for
that.

> > +	chip = kzalloc(sizeof(struct lm3556_chip_data), GFP_KERNEL);

devm_kzalloc()
