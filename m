Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1CHN3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:29:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37244 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1CHN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:29:16 -0500
Date: Tue, 8 Mar 2011 13:29:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 2/3] regulator: add a subdriver for TI TPS6105x
	regulator portions
Message-ID: <20110308132912.GC5892@sirena.org.uk>
References: <1299577320-31389-1-git-send-email-linus.walleij@stericsson.com> <20110308115640.GC20944@opensource.wolfsonmicro.com> <AANLkTin7qD7O70u5HQVgWXQZTFR1O8dUOqyKWmn6sU1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin7qD7O70u5HQVgWXQZTFR1O8dUOqyKWmn6sU1b@mail.gmail.com>
X-Cookie: Star Trek Lives!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 02:26:14PM +0100, Linus Walleij wrote:
> On Tue, Mar 8, 2011 at 12:56 PM, Mark Brown

> >> + ? ? /* This instance is not set for regulator mode so bail out */
> >> + ? ? if (pdata->mode != TPS6105X_MODE_VOLTAGE)
> >> + ? ? ? ? ? ? return 0;

> > -ENODEV? ?Logging to explain why we're bombing out might be helpful too.

> Not in this case actually, the chip is configured by platform data to
> operate as regulator, LED or flashgun. All three drivers may be
> compiled in at some point, and a system may have three TPS chips
> performing each function. They will spawn three children each,
> but only one of them should probe.

> So the fact that the regulator driver doesn't probe doesn't mean any
> failure, some other driver will likely probe successfully for the chip.

The general approach other MFDs have taken to this is to pay attention
to the platform data when registering subdevices so that you don't get
inappropriate subdevices registered in the first place.
