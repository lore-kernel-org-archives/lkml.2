Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1GRJoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:44:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52849 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755182Ab1GRJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:44:09 -0400
Date: Mon, 18 Jul 2011 18:44:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
        Grant Likely <grant@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110718094402.GA423@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715123121.735688a6@endymion.delvare>
 <20110715121646.GA10026@opensource.wolfsonmicro.com>
 <20110715145848.750a85aa@endymion.delvare>
 <20110715131748.GD10026@opensource.wolfsonmicro.com>
 <20110717175344.1d1bf16a@endymion.delvare>
 <20110718000011.GA13563@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718000011.GA13563@ponder.secretlab.ca>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 06:00:11PM -0600, Grant Likely wrote:
> On Sun, Jul 17, 2011 at 05:53:44PM +0200, Jean Delvare wrote:

> > What's wrong with the more direct approach:
> > drivers/regmap/regmap-core.c
> > drivers/regmap/regmap-i2c.c
> > drivers/regmap/regmap-spi.c
> > ?

> > At least you would have everything in one place and under your control.
> > With your current plan, every update is likely to spawn
> > cross-subsystems, which always results in delays and conflicts.

This was exactly what the orginal patch set looked like, there have just
been a couple of git mvs since then.

> > Now if you have a good reason for the current design, that's OK with
> > me, I can live with that. Simply it seems more complex than needed.

> Hahaha.  Mark *did* do it that way and I suggested splitting up into
> the i2c and spi directories to keep bus specific infrastructure
> together.  Very well, if you feel strongly about it then I withdraw my
> comment.

Actually you weren't the only person to suggest this, but the other
suggestions were pretty weak and like you say all together was my
original preference.  Since we seem to have achieved consensus I'll flip
everything back.

The reason for drivers/base was that this is more utility code like the
firmware loader than it is an actual thing.  

> > Also, your Kconfig setup is such that all bindings will be selected as
> > soon as any driver needs one. And the selection (module vs. built-in)
> > will be aligned on the core setting (e.g. CONFIG_I2C) rather than the
> > drivers which use it. I'd rather have e.g. REGULATOR_TPS65023 select
> > REGMAP_I2C, and in turn have REGMAP_I2C select REGMAP. This should
> > address the issues I pointed out.

Yeah, the problem is that select doesn't actually work terribly well as
it causes dependencies of the selected thing to get ignored which is
annoying and means that the thing doing the selecting needs to select
them too.  The bus interfaces are small enough that I'm not really
worried about the extra size and if need be we can always sort it out
layer.
