Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2IMIga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:36:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60087 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2IMIg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:36:27 -0400
Date: Thu, 13 Sep 2012 10:36:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] gpiolib: add another might_sleep
Message-ID: <20120913083623.GH19497@pengutronix.de>
References: <1297977533-17794-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110829190142.GA17354@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110829190142.GA17354@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 29, 2011 at 01:01:42PM -0600, Grant Likely wrote:
> On Thu, Feb 17, 2011 at 10:18:53PM +0100, Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Applied, thanks.
I cannot see it in Linus' tree?!

> > ---
> >  drivers/gpio/gpiolib.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 5fc5e2d..2c9f814 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -1207,6 +1207,7 @@ int gpio_request(unsigned gpio, const char *label)
> >  	if (chip->request) {
> >  		/* chip->request may sleep */
> >  		spin_unlock_irqrestore(&gpio_lock, flags);
> > +		might_sleep_if(chip->can_sleep);
> >  		status = chip->request(chip, gpio - chip->base);
> >  		spin_lock_irqsave(&gpio_lock, flags);
> >  
> > -- 
> > 1.7.2.3
> > 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
