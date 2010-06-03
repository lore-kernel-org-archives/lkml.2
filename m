Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0FCRxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:53:31 -0400
Received: from kroah.org ([198.145.64.141]:58945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab0FCRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:53:10 -0400
Date: Thu, 3 Jun 2010 10:45:58 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/11] drivers/usb/serial: Eliminate a NULL pointer
 dereference
Message-ID: <20100603174558.GA3834@kroah.com>
References: <Pine.LNX.4.64.1005271437200.5422@ask.diku.dk>
 <20100527131539.GA26198@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527131539.GA26198@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 03:15:39PM +0200, Johan Hovold wrote:
> Hi Julia, 
> 
> On Thu, May 27, 2010 at 02:37:39PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The assignment seems completely unnecessary if mos7840_port is NULL.
> > 
> [...]
> > ---
> >  drivers/usb/serial/mos7840.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
> > index f8424d1..585b7e6 100644
> > --- a/drivers/usb/serial/mos7840.c
> > +++ b/drivers/usb/serial/mos7840.c
> > @@ -730,7 +730,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
> >  	mos7840_port = urb->context;
> >  	if (!mos7840_port) {
> >  		dbg("%s", "NULL mos7840_port pointer");
> > -		mos7840_port->read_urb_busy = false;
> >  		return;
> >  	}
> 
> I stumbled over this one a couple of weeks ago. There a patch sitting in
> Greg's queue already:
> 
> 	http://thread.gmane.org/gmane.linux.usb.general/31668

Which is now in my tree.

thanks,

greg k-h
