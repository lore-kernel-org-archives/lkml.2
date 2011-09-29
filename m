Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1I2NY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:24:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54823 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073Ab1I2NY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:24:58 -0400
Date: Thu, 29 Sep 2011 14:24:55 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 8/8] regmap: Ensure we scream if we enable cache
	bypass/only at the same time
Message-ID: <20110929132455.GA10995@opensource.wolfsonmicro.com>
References: <1317289153-21123-1-git-send-email-dp@opensource.wolfsonmicro.com> <1317289153-21123-8-git-send-email-dp@opensource.wolfsonmicro.com> <20110929102530.GJ3697@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929102530.GJ3697@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 11:25:30AM +0100, Mark Brown wrote:
> On Thu, Sep 29, 2011 at 10:39:13AM +0100, Dimitris Papastamos wrote:
> 
> >  void regcache_cache_only(struct regmap *map, bool enable)
> >  {
> > +	BUG_ON(map->cache_bypass && enable);
> >  	mutex_lock(&map->lock);
> 
> I'd move these inside the lock otherwise there's an enable/enable race
> where two threads check that things are safe simultaneously.  I'd also
> change to WARN_ON(), if nothing else it's hard to see BUG_ON()s that
> occur prior to console output and PMICs are likely to trigger that sort
> of stuff.

Aw yes, of course :)
