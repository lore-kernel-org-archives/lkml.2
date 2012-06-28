Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2F1TeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:34:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43773 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2F1TeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:34:13 -0400
Date: Thu, 28 Jun 2012 22:33:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jose Alberto Reguero <jareguero@telefonica.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -resend] [media] az6007: precedence bug in
 az6007_i2c_xfer()
Message-ID: <20120628193354.GL3007@mwanda>
References: <20120627090644.GP31212@elgon.mountain>
 <4FEB0664.3030408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEB0664.3030408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 10:11:00AM -0300, Mauro Carvalho Chehab wrote:
> Em 27-06-2012 06:06, Dan Carpenter escreveu:
> > The intent here was to test that the flag was clear but the '!' has
> > higher precedence than the '&'.  I2C_M_RD is 0x1 so the current code is
> > equivalent to "&& (!sgs[i].flags) ..."
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > I sent this originally on Wed, 25 Jan 2012 and Emil Goode sent the same
> > fix on Thu, May 3, 2012.
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
> > index 4008b9c..f6f0cf9 100644
> > --- a/drivers/media/dvb/dvb-usb/az6007.c
> > +++ b/drivers/media/dvb/dvb-usb/az6007.c
> > @@ -711,7 +711,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
> >   		addr = msgs[i].addr << 1;
> >   		if (((i + 1) < num)
> >   		    && (msgs[i].len == 1)
> > -		    && (!msgs[i].flags & I2C_M_RD)
> > +		    && (!(msgs[i].flags & I2C_M_RD))
> >   		    && (msgs[i + 1].flags & I2C_M_RD)
> >   		    && (msgs[i].addr == msgs[i + 1].addr)) {
> >   			/*
> > 
> 
> Dan,
> 
> Your logic is correct, however, I didn't apply this patch because it broke
> the driver.
> 
> I'll need to re-visit the driver when I have some time, in order to be
> able to apply this one, without breaking the driver. I'll likely need to
> change some other things on this routine.
> 
> (this has a low priority, as the driver is working properly the way it is).
> 
> So, I'm keeping your patch at patchwork, while I don't find some time for it.

We could just put a comment next to the code and forget about it.

               && (!(msgs[i].flags & I2C_M_RD)) /* the fix needs testing. */

Sparse complains about this so it people are going to keep sending
patches for it.  It's not like you should be stuck doing all the
work.

regards,
dan carpenter
