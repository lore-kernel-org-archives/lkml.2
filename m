Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2HDMnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:43:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45635 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2HDMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:43:46 -0400
Date: Sat, 4 Aug 2012 13:43:42 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regmap: Add regmap dummy driver
Message-ID: <20120804124342.GA7700@opensource.wolfsonmicro.com>
References: <1343397500-31283-1-git-send-email-dp@opensource.wolfsonmicro.com> <20120804100522.GC9248@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120804100522.GC9248@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 11:05:23AM +0100, Mark Brown wrote:
> On Fri, Jul 27, 2012 at 02:58:20PM +0100, Dimitris Papastamos wrote:
> > Add a pseudo-driver for debugging and stress-testing the
> > regmap/regcache APIs.  A standard set of tools for working
> 
> Overall this looks good, most of the stuff below is fairly small.  As a
> very high level comment it'd be really helpful to split this into a
> series of commits, for example adding just the dummy device then
> building out the functionality.  It'd make review much easier.
> 
> > with this driver (mainly sh scripts) will be put in a repo
> > at https://github.com/quantumdream/regmap-tools
> 
> Any reason not to put this in the tools directory?

At the moment the repo is very bare bones.  I was thinking more of
an automated testing framework written in sh or similar.  So it might
grow out into its own repository anyhow.

> > Some of these tests will require one to build with
> > REGMAP_ALLOW_WRITE_DEBUGFS defined.
> 
> Can we add a write mechanism specifically for this dummy driver?

Sure yes.

> > +	/* Set when regdummy defaults have been modified.
> > +	 * This is useful to know so we don't reinit the
> > +	 * cache if there is no reason to do so. */
> > +	unsigned int dirty:1;
> 
> Should we perhaps just reinit anyway?  It's not like this is performance
> critical...

Yea will remove it for simplicity.

> > +/* Default volatile register callback, this should
> > + * normally be configured by the user via a debugfs
> > + * entry */
> > +static bool regdummy_volatile_reg(struct device *dev,
> > +				  unsigned int reg)
> > +{
> > +	return false;
> > +}
> 
> All these functions just seem to be implementing the default behaviour,
> why are they needed?

Hm will remove them for now but it would be useful for these to be set by
the user via debugfs or similar.  These were mainly stubs for that sort
of thing.

> > +		/* If we're in the region the user is trying to read */
> > +		if (p >= *ppos) {
> > +			/* ...but not beyond it */
> > +			if (buf_pos >= count - 1 - tot_len)
> > +				break;
> 
> Any potential for code reuse?  This stuff does look awfully familiar!

Might factor some of these things into a separate regmap-utils.c.

> > +	/* Allocate the new register defaults */
> > +	regdef_num_new = rdevp->regs_size_new / config->reg_stride;
> > +	regdef_num_raw_new = regdef_num_new * sizeof(*regdef_new);
> > +	regdef_new = kzalloc(regdef_num_raw_new, GFP_KERNEL);
> 
> Can we factor this stuff out - there's a lot of overlap with the vanilla
> init?

Sure.

> > +static struct platform_device regdummy_device = {
> > +	.name = "regdummy",
> > +	.id = 0,
> > +};
> 
> Set id to -1 if there's only one of them.

Ok.
