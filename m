Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1KDVqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:46:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37561 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854Ab1KDVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:46:53 -0400
Date: Fri, 4 Nov 2011 21:46:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111104214650.GC8266@opensource.wolfsonmicro.com>
References: <1319721864-30067-1-git-send-email-rnayak@ti.com>
 <20111104202905.GA3918@quad.lixom.net>
 <20111104211447.GC2541@opensource.wolfsonmicro.com>
 <20111104212216.GA5756@quad.lixom.net>
 <20111104212910.GB8266@opensource.wolfsonmicro.com>
 <CAOesGMgA7UayF9SJUP0YLnj86GmKBrajsBxv4_kRNNqCsvKTYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgA7UayF9SJUP0YLnj86GmKBrajsBxv4_kRNNqCsvKTYg@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:34:35PM -0700, Olof Johansson wrote:
> On Fri, Nov 4, 2011 at 2:29 PM, Mark Brown

> > I think it's useful to define how consumers are supposed to do this
> > somewhere - it is actually part of the core binding how consumers are
> > supposed to do this.

> Yeah, ok, but it shouldn't be part of the description of regulator
> properties per se. See how gpio does it, defining how a gpio-specifier
> is crafted. The equivalent should be done for regulators.

That seems to be pretty much exactly what's being done here, and like
the GPIO bindings it's specified in the core document.  Though perhaps
there's some aspect of how the document is written that's missing.

If you're talking about the specifics of the binding the GPIO bindings
do suffer from the whole magic indexes into arrays problem that makes a
lot of the older device tree bindings quite hard to read.

> > There's also a bit of magic here for chained supplies with one regulator
> > supplying another (eg, using a DCDC to drop the system supply down to a
> > lower voltage to supply a bunch of LDOs for improved efficiency).

> Describing that in the device tree using regulator-specifiers
> shouldn't be too bad? The LDO will reference the DCDC as the parent
> supply (or input or whatever language you prefer). They don't have to
> be in the same topology, they will instead be under whatever
> controller/bus they are on for control -- i2c, etc.

That's not great as it means you've got a separate binding for supplies
that happen to be connected to another regulator from that used for
other supplies on the device which is particularly confusing in the
fairly common case where a regulator chip has multiple supplies.  Using
the same method for binding all supplies seems much neater.
