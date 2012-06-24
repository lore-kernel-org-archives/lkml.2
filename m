Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2FXOn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 10:43:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2FXOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 10:43:24 -0400
Date: Sun, 24 Jun 2012 16:43:20 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, kernel@pengutronix.de,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH RESEND] of: add const to struct of_device_id.data
Message-ID: <20120624144320.GB28001@pengutronix.de>
References: <1335171381-24869-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120607102014.GI22191@pengutronix.de>
 <20120622055613.GL5642@pengutronix.de>
 <201206221726.22285.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201206221726.22285.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On Fri, Jun 22, 2012 at 05:26:22PM +0000, Arnd Bergmann wrote:
> On Friday 22 June 2012, Uwe Kleine-König wrote:
> > On Thu, Jun 07, 2012 at 12:20:14PM +0200, Uwe Kleine-König wrote:
> > > Drivers should never need to modify the data of a device id. So it can
> > > be const which in turn allows more consts in the driver.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > > (Cc += lkml + Grant)
> > > 
> > > Hello,
> > > 
> > > this might introduce warnings in drivers that access the data member
> > > without using const, so this is definitly merge window material if it is
> > > considered at all.
> >
> > ping
> 
> Sorry for the delayed response. I think the approach is right, but I
> am a bit worried about adding warnings for legit code.
> 
> A quick test with the defconfigs gave me this error for prima2_defconfig
> and kzm9g_defconfig:
> 
> /home/arnd/linux-arm/arch/arm/mm/cache-l2x0.c: In function 'l2x0_of_init':
> /home/arnd/linux-arm/arch/arm/mm/cache-l2x0.c:573:7: error: assignment discards 'const' qualifier from pointer target type [-Werror]
I already sent a patch for that to rmk's patch system:

	http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7429/1

Russell commented: 
Sigh, a gmane.org URL.  Which is difficult to dig the thread out of.
Eventually you can.  And I see nothing which suggests that the series
will be applied or, more importantly when it is going to be applied.
Punting this patch until there's better communication.

Russell, I didn't completely get your problem about gmane here. If you
follow the link in the Subject: line, you get a thread view. Does this
address your concerns?

And even without the of: add const to struct of_device_id.data patch
patch using more consts is IMHO nice.

> and this one with at91sam9263_defconfig:
> /home/arnd/linux-arm/drivers/misc/atmel_tclib.c: In function 'tc_probe':
> /home/arnd/linux-arm/drivers/misc/atmel_tclib.c:170:19: error: assignment discards 'const' qualifier from pointer target type [-Werror]
> 
> I haven't checked all the defconfigs yet, but I think we should at least
> make sure they build fine before applying your patch.
Fine for me, I will come up with a series next week.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
