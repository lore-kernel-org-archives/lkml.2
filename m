Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0HCHlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:41:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59088 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0HCHlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:41:06 -0400
Date: Tue, 3 Aug 2010 09:40:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Julia Lawall <julia@diku.dk>,
        =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: don't save bind callback in struct
	usb_gadget_driver
Message-ID: <20100803074056.GB17297@pengutronix.de>
References: <op.vgs04dub7p4s8u@pikus> <1280752803-11441-1-git-send-email-u.kleine-koenig@pengutronix.de> <Pine.LNX.4.64.1008021446470.10662@ask.diku.dk> <20100802131248.GD13900@pengutronix.de> <20100802225440.GA9190@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100802225440.GA9190@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[stripped down Cc: list to annoy fewer people]

On Mon, Aug 02, 2010 at 03:54:40PM -0700, Greg KH wrote:
> On Mon, Aug 02, 2010 at 03:12:48PM +0200, Uwe Kleine-König wrote:
> > On Mon, Aug 02, 2010 at 02:51:36PM +0200, Julia Lawall wrote:
> > > > diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> > > > index 731150d..c266c1e 100644
> > > > --- a/drivers/usb/gadget/amd5536udc.c
> > > > +++ b/drivers/usb/gadget/amd5536udc.c
> > > > @@ -1954,13 +1954,14 @@ static int setup_ep0(struct udc *dev)
> > > >  }
> > > >  
> > > >  /* Called by gadget driver to register itself */
> > > > -int usb_gadget_register_driver(struct usb_gadget_driver *driver)
> > > > +int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
> > > > +		int (*bind)(struct usb_gadget *))
> > > >  {
> > > >  	struct udc		*dev = udc;
> > > >  	int			retval;
> > > >  	u32 tmp;
> > > >  
> > > > -	if (!driver || !driver->bind || !driver->setup
> > > > +	if (!driver || bind || !driver->setup
> > > 
> > > I have the impression that this should be !bind rather than bind.  
> > ah, now I see what you meant.  Obviously you're right.  I fixed it up
> > locally here for now.  Greg, just tell me when/if you need a fixed
> > patch.
> 
> Didn't you already post a "fixed" patch?
Yes, I did:

	http://article.gmane.org/gmane.linux.ports.arm.kernel/86640
	http://article.gmane.org/gmane.linux.kernel/1017575

If you append '/raw' to the URL they should be applicable by
git/quilt/whatever you use.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
