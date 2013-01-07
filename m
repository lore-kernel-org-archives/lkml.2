Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3AGNVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:21:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3AGNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:21:28 -0500
Date: Mon, 7 Jan 2013 14:21:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-media@vger.kernel.org,
        mchehab@infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
Message-ID: <20130107132122.GV14860@pengutronix.de>
References: <1357553025-21094-1-git-send-email-s.hauer@pengutronix.de>
 <CAOMZO5Cpa2OYd+v=wE4hbw=sjmQk+bP1HrY49PEWmwRyiVD1dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5Cpa2OYd+v=wE4hbw=sjmQk+bP1HrY49PEWmwRyiVD1dg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fabio,

On Mon, Jan 07, 2013 at 08:16:02AM -0200, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Mon, Jan 7, 2013 at 8:03 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> > location of iram.h, which causes the following build error when building the coda
> > driver:
> >
> > drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> > drivers/media/platform/coda.c: In function 'coda_probe':
> > drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> > drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> > drivers/media/platform/coda.c: In function 'coda_remove':
> > drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free'
> >
> > Since the content of iram.h is not imx specific, move it to
> > include/linux/platform_data/imx-iram.h instead. This is an intermediate solution
> > until the i.MX iram allocator is converted to the generic SRAM allocator.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >
> > Based on an earlier version from Fabio Estevam, but this one moves iram.h
> > to include/linux/platform_data/imx-iram.h instead of include/linux/iram.h
> > which is a less generic name.
> >
> >  arch/arm/mach-imx/iram.h               |   41 --------------------------------
> >  arch/arm/mach-imx/iram_alloc.c         |    3 +--
> >  drivers/media/platform/coda.c          |    2 +-
> >  include/linux/platform_data/imx-iram.h |   41 ++++++++++++++++++++++++++++++++
> >  4 files changed, 43 insertions(+), 44 deletions(-)
> >  delete mode 100644 arch/arm/mach-imx/iram.h
> >  create mode 100644 include/linux/platform_data/imx-iram.h
> 
> It would be better to use git mv /git format-patch -M, so that git can
> detect the file rename.
Note that git-mv is not needed here. Using it doesn't change anything
and you can use git-format-patch -M independant of it.

Best regards
Uwe
