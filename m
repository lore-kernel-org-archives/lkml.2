Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1ICBKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 21:10:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57613 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279Ab1ICBKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 21:10:36 -0400
Date: Sat, 3 Sep 2011 02:10:32 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
Message-ID: <20110903011032.GA10060@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com> <4E61363A.9050607@metafoo.de> <20110902234827.GA31813@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902234827.GA31813@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 03, 2011 at 12:48:27AM +0100, Mark Brown wrote:
> On Fri, Sep 02, 2011 at 10:02:02PM +0200, Lars-Peter Clausen wrote:
> > On 09/02/2011 05:46 PM, Dimitris Papastamos wrote:
> 
> > > +static const struct regcache_ops *cache_types[] = {
> > > +};
> 
> > I wonder if it makes sense to keep a list of regcache_ops this way, or whether
> > it is not better to just pass the ops we want to use to regcache_init directly.
> 
> Or have a function per cache type.  I'm keen to hide the ops from users
> because I don't want to have to worry about them peering inside the
> internals.
> 
> > > +	if (!map->cache_defaults_raw || !map->num_cache_defaults_raw) {
> > > +		dev_err(map->dev, "Client has not provided a defaults cache\n");
> > > +		return -EINVAL;
> > > +	}
> 
> > It should be OK to provide no default register values, in this case regmap
> > should assume that the default for all registers is 0.
> 
> Yes - Dimitris, as we discussed offline it's pretty much essential for
> things like PMICs where the defaults aren't meaningful and may even be
> unknowable.

That's implemented in patch 8/8.  I can of course squash that patch into
the other patch.

Thanks,
Dimitris
