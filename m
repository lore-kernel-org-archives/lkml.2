Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1IOJfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:35:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47954 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932088Ab1IOJfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:35:42 -0400
Date: Thu, 15 Sep 2011 10:35:38 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/6] regmap: Add the LZO cache support
Message-ID: <20110915093538.GA8631@opensource.wolfsonmicro.com>
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com> <1315230662-12401-5-git-send-email-dp@opensource.wolfsonmicro.com> <4E64F656.3040009@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E64F656.3040009@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 06:18:30PM +0200, Lars-Peter Clausen wrote:
> On 09/05/2011 03:51 PM, Dimitris Papastamos wrote:
> > This patch adds support for LZO compression when storing the register
> > cache.
> > 
> > For a typical device whose register map would normally occupy 25kB or 50kB
> > by using the LZO compression technique, one can get down to ~5-7kB.  There
> > might be a performance penalty associated with each individual read/write
> > due to decompressing/compressing the underlying cache, however that should not
> > be noticeable.  These memory benefits depend on whether the target architecture
> > can get rid of the memory occupied by the original register defaults cache
> > which is marked as __devinitconst.  Nevertheless there will be some memory
> > gain even if the target architecture can't get rid of the original register
> > map, this should be around ~30-32kB instead of 50kB.
> > 
> > Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> > ---
> >  drivers/base/regmap/Makefile       |    2 +-
> >  drivers/base/regmap/internal.h     |    2 +
> >  drivers/base/regmap/regcache-lzo.c |  361 ++++++++++++++++++++++++++++++++++++
> >  drivers/base/regmap/regcache.c     |    1 +
> >  include/linux/regmap.h             |    1 +
> >  5 files changed, 366 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/base/regmap/regcache-lzo.c
> > 
> 
> Fails to compile due to CONFIG_LZO_{COMPRESS,DECOMPRESS} not being selected.
> Also it will have issues, with caches where we don't use raw cache defaults.

Yes, the LZO code will need to use cache_defaults instead of
cache_defaults_raw.  Since there are no users at the moment and since
most of the potential users do actually use cache_defaults_raw, I think
I can fix this incrementally.

Thanks,
Dimitris
