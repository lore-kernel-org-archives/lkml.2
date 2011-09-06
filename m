Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1IFB1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 21:27:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52977 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752580Ab1IFB1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 21:27:45 -0400
Date: Mon, 5 Sep 2011 18:27:34 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6] regmap: Incorporate the regcache core into regmap
Message-ID: <20110906012733.GD31600@opensource.wolfsonmicro.com>
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1315230662-12401-7-git-send-email-dp@opensource.wolfsonmicro.com>
 <4E64F74C.1010606@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64F74C.1010606@metafoo.de>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 06:22:36PM +0200, Lars-Peter Clausen wrote:
> On 09/05/2011 03:51 PM, Dimitris Papastamos wrote:

> > +#ifdef CONFIG_REGCACHE
> > +	if (!map->cache_bypass) {
> > +		ret = regcache_read(map, reg, val);
> > +		if (!ret) {
> > +			mutex_unlock(&map->lock);
> > +			return 0;
> > +		}
> > +	}

> I think this will need tighter integration. For example do we want to fallback
> to a hw read when the cached read fails? And also regcache_read will return for
> REGCACHE_NONE, which means we neither do a cached read nor a hw read.

I think falling through to hardware is sensible - if nothing else we've
got to do that for uncached registers.  Though if we're in cache only
mode we probably don't want to do that as the hardware may be powered
off.  But in general it does make sense to me.
