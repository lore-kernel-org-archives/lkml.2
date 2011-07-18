Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1GRAAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 20:00:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56924 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab1GRAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 20:00:16 -0400
Date: Sun, 17 Jul 2011 18:00:11 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <greg@kroah.com>,
        Grant Likely <grant@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110718000011.GA13563@ponder.secretlab.ca>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
 <1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715123121.735688a6@endymion.delvare>
 <20110715121646.GA10026@opensource.wolfsonmicro.com>
 <20110715145848.750a85aa@endymion.delvare>
 <20110715131748.GD10026@opensource.wolfsonmicro.com>
 <20110717175344.1d1bf16a@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110717175344.1d1bf16a@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 05:53:44PM +0200, Jean Delvare wrote:
> Hi Mark,
> 
> On Fri, 15 Jul 2011 22:17:51 +0900, Mark Brown wrote:
> > On Fri, Jul 15, 2011 at 02:58:48PM +0200, Jean Delvare wrote:
> > > On Fri, 15 Jul 2011 21:16:50 +0900, Mark Brown wrote:
> > 
> > > > Does that sound reasonable to you?
> > 
> > > Yes, no objection.
> > 
> > BTW, if this does sound reasonable are you OK with adding your ack for
> > the I2C bus interface patch or are there any updates you want me to do?
> 
> I did not review the patch carefully, so I can't ask for updates. As
> none of "my" drivers will use it, I don't really feel qualified (nor
> interested, honestly) to review it.
> 
> I don't quite get why you put the i2c bindings into
> drivers/i2c/i2c-regmap.c. This means that Ben and I end up being the
> maintainers of that file, while it's your thing. And this module is a
> user of i2c, not a provider, so it doesn't really belong there anyway.
> Same goes with spi. And what's the rationale for putting the regmap core
> under drivers/base?
> 
> What's wrong with the more direct approach:
> drivers/regmap/regmap-core.c
> drivers/regmap/regmap-i2c.c
> drivers/regmap/regmap-spi.c
> ?
> 
> At least you would have everything in one place and under your control.
> With your current plan, every update is likely to spawn
> cross-subsystems, which always results in delays and conflicts.
> 
> Now if you have a good reason for the current design, that's OK with
> me, I can live with that. Simply it seems more complex than needed.

Hahaha.  Mark *did* do it that way and I suggested splitting up into
the i2c and spi directories to keep bus specific infrastructure
together.  Very well, if you feel strongly about it then I withdraw my
comment.

g.

> Also, your Kconfig setup is such that all bindings will be selected as
> soon as any driver needs one. And the selection (module vs. built-in)
> will be aligned on the core setting (e.g. CONFIG_I2C) rather than the
> drivers which use it. I'd rather have e.g. REGULATOR_TPS65023 select
> REGMAP_I2C, and in turn have REGMAP_I2C select REGMAP. This should
> address the issues I pointed out.
> 
> -- 
> Jean Delvare
