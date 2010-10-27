Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab0J0NWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:22:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59668 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177Ab0J0NWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:22:18 -0400
Date: Wed, 27 Oct 2010 15:22:13 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        valentin.longchamp@epfl.ch, daniel@caiaq.de,
        amit.kucheria@canonical.com
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027132213.GJ6017@pengutronix.de>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de> <20101027102253.GA7822@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101027102253.GA7822@angua.secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:09:34 up 116 days,  4:20, 50 users,  load average: 0.10, 0.31,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 11:22:53AM +0100, Grant Likely wrote:
> On Wed, Oct 27, 2010 at 11:09:21AM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Wed, Oct 27, 2010 at 09:29:59AM +0100, Grant Likely wrote:
> > > > ---
> > > >  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  301 +++++++++++++++++++
> > > >  arch/arm/plat-mxc/include/mach/mx53.h       |  433 +++++++++++++++++++++++++++
> > > 
> > > Hi Dinh.
> > > 
> > > In general, these definitions should not be added until they are
> > > actually needed by driver code.
> > ack.
> > 
> > > Also, from my understanding, the mx53 is very similar to the mx51.
> > > If I'm correct, then they should be sharing the same set of #defines.
> > Note, I asked for a seperate header file.  See
> > http://thread.gmane.org/gmane.linux.kernel/1051001/focus=1051352
> 
> For the record, I disagree with that approach.  The approach I would
> take is for the imx53 code to use the imx51 defines by default, and to
> only define imx53 variants where there are differences.  Otherwise the
> code to support imx53 has to be completely divergent from imx51
> because the defines are different symbols.

That's a way we can go but only if the common name is not MX5 or MX5x.
We've done it with the mx21/27 and it failed when the mx25 came out
which was completely incompatible. Since then everybody looking at
the code must know that mx2x is mx21/27 but not mx25. I suggest
something like MX513 instead.

On the other hand I think there won't be much divergency. The way
devices are registered won't produce much overhead in sourcecode
and none in binary size.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
