Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0JALCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:02:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41406 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0JALCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:02:44 -0400
Date: Fri, 1 Oct 2010 13:02:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Message-ID: <20101001110233.GG784@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de> <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de> <20101001104250.GB3064@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101001104250.GB3064@sortiz-mobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 12:42:51PM +0200, Samuel Ortiz wrote:
> Hi Uwe,
> 
> On Wed, Sep 29, 2010 at 06:23:46PM +0200, Uwe Kleine-König wrote:
> > mc13892 is the companion PMIC for Freescale's i.MX51.  It's similar enough
> > to mc13782 to support it in a single driver.
> > 
> > This patch introduces enough compatibility cruft to keep all users of the
> > superseded mc13783 driver unchanged.
> All 4 patches applied, thanks.
Thanks.
 
> I have one comment though:
> 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index db51ea1..1868d9b 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -408,11 +408,16 @@ config MFD_PCF50633
> >  	  so that function-specific drivers can bind to them.
> >  
> >  config MFD_MC13783
> > -	tristate "Support Freescale MC13783"
> > +	tristate
> > +
> I don't think it's worth keeping this symbol around.
That's part of the compatibility cruft because some drivers depend on
it.  This will be removed when all other drivers are converted together
with (e.g.) include/mfd/mc13783.h.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
