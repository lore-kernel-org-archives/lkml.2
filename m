Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1J2K0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 06:26:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1J2K0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 06:26:52 -0400
Date: Sat, 29 Oct 2011 12:26:46 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio: pca953x: remove unneeded check for chip type
Message-ID: <20111029102646.GA20132@ponder.secretlab.ca>
References: <1318599120-413-1-git-send-email-w.sang@pengutronix.de>
 <20111029065820.GA2111@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111029065820.GA2111@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 08:58:20AM +0200, Wolfram Sang wrote:
> On Fri, Oct 14, 2011 at 03:31:59PM +0200, Wolfram Sang wrote:
> > We can assume our own device_id table is correct, so remove checking if
> > the chip type is valid. (The check was bogus anyway: If it found an
> > invalid entry, it returned with 0!) This is in preparation for further
> > cleanups.
> > 
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> 
> Ping for this mini-series.

Merged and I'll push out for 3.2, thanks.

g.

> 
> > ---
> >  drivers/gpio/gpio-pca953x.c |    4 +---
> >  1 files changed, 1 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> > index c43b8ff..45de6a4 100644
> > --- a/drivers/gpio/gpio-pca953x.c
> > +++ b/drivers/gpio/gpio-pca953x.c
> > @@ -673,10 +673,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
> >  
> >  	if (chip->chip_type == PCA953X_TYPE)
> >  		device_pca953x_init(chip, invert);
> > -	else if (chip->chip_type == PCA957X_TYPE)
> > -		device_pca957x_init(chip, invert);
> >  	else
> > -		goto out_failed;
> > +		device_pca957x_init(chip, invert);
> >  
> >  	ret = pca953x_irq_setup(chip, id, irq_base);
> >  	if (ret)
> > -- 
> > 1.7.6.3
> > 
> 
> -- 
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |


