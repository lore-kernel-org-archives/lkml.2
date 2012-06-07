Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2FGTuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:50:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:45897 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2FGTuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:50:02 -0400
Message-ID: <1339098621.13885.13.camel@wall-e>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        oneukum@suse.de, alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 21:50:21 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206071118310.1185-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1206071118310.1185-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.06.2012, 11:27 -0400 schrieb Alan Stern:
> On Thu, 7 Jun 2012, Stefani Seibold wrote:
> > I think it will be needed, since usb core will decrement the reference
> > when the device go away.
> 
> But before it decrements the reference, it will unbind the driver.  As 
> long as usb-skeleton is careful not to access the device or the 
> interface after the disconnect routine returns, it doesn't need to keep 
> a reference.
> 
> >  Lock every access to the usb core if a tedious
> > thing and will waste a lot of code.
> 
> With proper design, it's not necessary to lock every access.
> > 
> > BTW: An interface have no reference count.
> 
> Sure it does.  Look at the definitions of usb_get_intf() and 
> usb_put_intf() in drivers/usb/core/usb.c.
> 

That what i am looking for. If we do an usb_get_intf() in the
skel_probe() function and an usb_put_intf() in skel_delete() function at
the end, then it should be save to access the usb_device pointer by
interface_to_usbdev() in the skel_delete() function. Right?

Greetings,
Stefani


