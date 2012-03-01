Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2CAMHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:07:21 -0500
Received: from trinity.fluff.org ([89.16.178.74]:39630 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab2CAMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:07:20 -0500
X-Greylist: delayed 2394 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 07:07:20 EST
Date: Thu, 1 Mar 2012 11:27:24 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Zhao Chenhui <chenhui.zhao@freescale.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
	sleep
Message-ID: <20120301112724.GE8441@trinity.fluff.org>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com> <20120229183436.GA30545@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229183436.GA30545@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 07:45:23PM +0100, Wolfram Sang wrote:
> Hi,
> 
> On Wed, Feb 29, 2012 at 06:39:21PM +0800, Zhao Chenhui wrote:
> > When entering deep sleep, the value in the registers I2CFDR and
> > I2CDFSRR are lost. This causes I2C access to fail after resuming.
> > 
> > Add suspend/resume routines to save/restore the registers
> > I2CFDR and I2CDFSRR.
> > 
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> >  drivers/i2c/busses/i2c-mpc.c |   34 +++++++++++++++++++++++++++++++++-
> >  1 files changed, 33 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> > index a8ebb84..f95a647 100644
> > --- a/drivers/i2c/busses/i2c-mpc.c
> > +++ b/drivers/i2c/busses/i2c-mpc.c
> > @@ -1,7 +1,9 @@
> >  /*
> >   * (C) Copyright 2003-2004
> >   * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
> > -
> > + *
> > + * Copyright 2012 Freescale Semiconductor, Inc.
> > + *
> 
> I'd think the change is too trivial to claim copyright on the file.

I agree with that.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

