Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1ISQg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:36:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49013 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756479Ab1ISQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:36:25 -0400
Date: Mon, 19 Sep 2011 17:36:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v5] regmap: Incorporate the regcache core into regmap
Message-ID: <20110919163623.GB540@opensource.wolfsonmicro.com>
References: <1316439245-26221-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1316439245-26221-7-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E77667D.8030404@metafoo.de>
 <20110919161358.GA540@opensource.wolfsonmicro.com>
 <4E776DAF.2050204@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E776DAF.2050204@metafoo.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 06:28:31PM +0200, Lars-Peter Clausen wrote:

Please delete unneeded context from mails and configure your MUA to wrap
early enough to allow for at least one level of quoting.

> On 09/19/2011 06:13 PM, Mark Brown wrote:
> > On Mon, Sep 19, 2011 at 05:57:49PM +0200, Lars-Peter Clausen wrote:

> >         if (!map->cache_bypass) {
> >                 ret = regcache_write(map, reg, val);
> > -               if (!ret || map->cache_only)
> > +               if (ret != 0)
> > +                       return ret;

> Hm... last time we said we want to fallback to hw read/write even if the cache
> operation has failed. The issue is that regcache_write will check for
> regmap_writeable, so you'll get different behaviour if caching is enabled for
> registers where regmap_writeable returns false.

I'd expect regcache_write() to silently eat such updates, though I see
it doesn't at the minute.

> >> Btw. what should happen if both cache_bypass and cache_only are set? Or is that
> >> an invalid configuration?

> > That's not sensible.  Probably BUG_ON().

> BUG_ON might be a bit to strict, if we wanted to allow cache_only to be enabled
> through debugfs like it is done for ASoC right now.

If we're going to allow those to be writable (I'm not convinced that's
sane) then it seems better that the write should enforce basic sanity.
