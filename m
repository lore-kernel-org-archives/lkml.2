Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1LHWbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:31:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1LHWbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:31:52 -0500
Date: Thu, 8 Dec 2011 23:31:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Documentation/pinctrl: various minor fixes
Message-ID: <20111208223144.GQ4585@pengutronix.de>
References: <1323382892-28298-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77B9F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1750B77B9F@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 02:24:46PM -0800, Stephen Warren wrote:
> Uwe Kleine-König wrote at Thursday, December 08, 2011 3:22 PM:
> > - add some consts
> > - don't use the group index alone to determine the value to write to
> >   foo's mux register. For spi and i2c the group index is always 0.
> >   Additionally using the function index makes much more sense as it
> >   generates a different value for each function/group pair.
> > - fix a few syntax errors
> 
> > @@ -600,7 +600,7 @@ static int foo_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
> >  int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
> >  		unsigned group)
> >  {
> > -	u8 regbit = (1 << group);
> > +	u8 regbit = (1 << selector + group);
> > 
> >  	writeb((readb(MUX)|regbit), MUX)
> >  	return 0;
> > @@ -609,7 +609,7 @@ int foo_enable(struct pinctrl_dev *pctldev, unsigned selector,
> >  int foo_disable(struct pinctrl_dev *pctldev, unsigned selector,
> >  		unsigned group)
> >  {
> > -	u8 regbit = (1 << group);
> > +	u8 regbit = (1 << selector);
> > 
> >  	writeb((readb(MUX) & ~(regbit)), MUX)
> >  	return 0;
> 
> Shouldn't those two regbit calculations match?
Yes, of course. (Well, it depends on the register model ...)

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
