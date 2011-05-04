Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1EDMLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:11:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1235 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1EDMLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:11:44 -0400
Subject: Re: [PATCH 2/2] usbnet: Convert dbg to dev_dbg and neatening
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Oliver Neukum <oneukum@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DC13A1B.8020004@ru.mvista.com>
References: <cover.1304445019.git.joe@perches.com>
	 <f86364fbdc335fadad003081d010843579e95765.1304445019.git.joe@perches.com>
	 <4DC13A1B.8020004@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 05:11:42 -0700
Message-ID: <1304511102.1788.91.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 15:35 +0400, Sergei Shtylyov wrote:
> Hello.

And hello to you Sergei.

On 03-05-2011 22:17, Joe Perches wrote:
> > Use the more standard logging form.
> > Add a bit more tidying style.
>     Style changes look rather doubtful to me...
> >   drivers/net/usb/usbnet.c |   23 +++++++++++------------
> > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
[]
> > @@ -192,8 +192,8 @@ static int init_status(struct usbnet *dev, struct usb_interface *intf)
> >   		return 0;
> >
> >   	pipe = usb_rcvintpipe(dev->udev,
> > -			      dev->status->desc.bEndpointAddress
> > -			& USB_ENDPOINT_NUMBER_MASK);
> > +			      (dev->status->desc.bEndpointAddress
> > +			& USB_ENDPOINT_NUMBER_MASK));
> 
>     Why add parens?

Leading & uses are almost always addressof.
This makes it easier for me to see that it's not an addressof use.

> > @@ -1345,8 +1346,9 @@ usbnet_probe(struct usb_interface *udev, const struct usb_device_id *prod)
> >   	dev->intf = udev;
> >   	dev->driver_info = info;
> >   	dev->driver_name = name;
> > -	dev->msg_enable = netif_msg_init(msg_level, NETIF_MSG_DRV
> > -					 | NETIF_MSG_PROBE | NETIF_MSG_LINK);
> > +	dev->msg_enable = netif_msg_init(msg_level, (NETIF_MSG_DRV |
> > +						     NETIF_MSG_PROBE |
> > +						     NETIF_MSG_LINK));
> 
>     Why add parens?

I think it's neater.
Or's are almost always placed at EOL.
It also makes alignment easier in emacs.
It could otherwise be a #define on a single line
like several other uses of netif_msg_init.

> > @@ -1485,16 +1486,14 @@ int usbnet_suspend(struct usb_interface *intf, pm_message_t message)
> >   			set_bit(EVENT_DEV_ASLEEP,&dev->flags);
> >   			spin_unlock_irq(&dev->txq.lock);
> >   		}
> > -		/*
> > -		 * accelerate emptying of the rx and queues, to avoid
> > +		/* accelerate emptying of the rx and queues, to avoid
> 
>     Why?

It's the style David Miller prefers for drivers/net/...
I don't care either way.

http://www.spinics.net/lists/netdev/msg139647.html

cheers, Joe

