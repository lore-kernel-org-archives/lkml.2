Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0JEHzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:55:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56463 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab0JEHzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:55:54 -0400
Date: Tue, 5 Oct 2010 09:55:51 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        s.hauer@pengutronix.de, grant.likely@secretlab.ca,
        valentin.longchamp@epfl.ch, daniel@caiaq.de,
        xiao-lizhang@freescale.com, r.schwebel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] ARM: imx: Add iram allocator functions
Message-ID: <20101005075551.GJ11737@pengutronix.de>
References: <1286237007-8463-1-git-send-email-Dinh.Nguyen@freescale.com> <20101005074423.GI11737@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101005074423.GI11737@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:44:23AM +0200, Uwe Kleine-König wrote:
> On Mon, Oct 04, 2010 at 07:03:27PM -0500, Dinh.Nguyen@freescale.com wrote:
> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > 
> > Add iram allocation functions using GENERIC_ALLOCATOR. The
> > allocation size is 4KB multiples to guarantee alignment. The
> > idea for these functions is for i.MX platforms to use them
> > to dynamically allocate IRAM usage.
> > 
> > Applies on 2.6.36-rc6
> > 
> > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
> > ---
> >  arch/arm/plat-mxc/Kconfig                   |   10 ++++
> >  arch/arm/plat-mxc/Makefile                  |    1 +
> >  arch/arm/plat-mxc/include/mach/iram_alloc.h |   35 +++++++++++++++
> >  arch/arm/plat-mxc/iram.c                    |   62 +++++++++++++++++++++++++++
> >  4 files changed, 108 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/iram_alloc.h
> >  create mode 100644 arch/arm/plat-mxc/iram.c
> > 
> > diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> > index 6785db4..5e4ff93 100644
> > --- a/arch/arm/plat-mxc/Kconfig
> > +++ b/arch/arm/plat-mxc/Kconfig
> > @@ -57,6 +57,16 @@ source "arch/arm/mach-mx5/Kconfig"
> >  
> >  endmenu
> >  
> > +config IRAM_ALLOC
> > +	bool "Enable IRAM allocator"
> > +	default y
> The iram allocator isn't useful taken alone, no?  So I suggest to make
> it 
Hmm.  It seems I forgot to finish this sentence, sorry.

Unless IRAM_ALLOC is an optional feature for new features to come I'd
not make it user selectible, but let the new features select IRAM_ALLOC.
If it's optional I wonder if "default y" should really be done.

Maybe better call the symbol just IRAM?

> > +	iram_pool = gen_pool_create(12, -1);
> 	if (!iram_pool)
> 		...
After rereading the commit log I wondered where the 4 KB are enforced.
Maybe do

	s/12/PAGE_SHIFT/

to make it more obvious?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
