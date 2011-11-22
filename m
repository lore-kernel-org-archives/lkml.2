Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1KVJ2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:28:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab1KVJ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:28:38 -0500
Date: Tue, 22 Nov 2011 10:28:36 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: Fix build failure with CONFIG_DEBUG_FS=n
Message-ID: <20111122092836.GD19986@pengutronix.de>
References: <1321950260-22193-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4ECB6992.5020804@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ECB6992.5020804@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:21:22AM +0100, Marc Kleine-Budde wrote:
> On 11/22/2011 09:24 AM, Uwe Kleine-König wrote:
> > This fixes:
> > 
> > 	drivers/base/regmap/regcache-rbtree.c: In function 'regcache_rbtree_init':
> > 	drivers/base/regmap/regcache-rbtree.c:197: error: 'struct regmap' has no member named 'debugfs'
> > 	drivers/base/regmap/regcache-rbtree.c:197: error: 'rbtree_fops' undeclared (first use in this function)
> > 	drivers/base/regmap/regcache-rbtree.c:197: error: (Each undeclared identifier is reported only once
> > 	drivers/base/regmap/regcache-rbtree.c:197: error: for each function it appears in.)
> > 
> > which was introduced by commit
> > 
> > 	bad2ab4 (regmap: Provide debugfs dump of the rbtree cache data)
> > 
> > currently in next-20111122.
> > 
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/base/regmap/regcache-rbtree.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
> > index 7767cbb..270ad65 100644
> > --- a/drivers/base/regmap/regcache-rbtree.c
> > +++ b/drivers/base/regmap/regcache-rbtree.c
> > @@ -194,7 +194,9 @@ static int regcache_rbtree_init(struct regmap *map)
> >  			goto err;
> >  	}
> >  
> > +#ifdef CONFIG_DEBUG_FS
> >  	debugfs_create_file("rbtree", 0400, map->debugfs, map, &rbtree_fops);
> > +#endif
> 
> What about introducing a debugfs_create_file() noop if debug-fs is not
> compiled in?
There is one, but that doesn't help map->debugfs or rbtree_fops being
available. Ah, unless the debugfs_create_file stub would be a macro but
currently it's a static inline.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
