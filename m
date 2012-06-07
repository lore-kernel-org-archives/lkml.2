Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986Ab2FGPDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:03:24 -0400
Received: from www84.your-server.de ([213.133.104.84]:50022 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2FGPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:03:23 -0400
Message-ID: <1339081423.13015.8.camel@wall-e>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        oneukum@suse.de, alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 17:03:43 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206071026160.1311-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1206071026160.1311-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.06.2012, 10:28 -0400 schrieb Alan Stern:
> On Thu, 7 Jun 2012, Stefani Seibold wrote:
> 
> > I tried to implement your idea to kick away the usb_device pointer, but
> > i think it is impossible. The skel_delete() function needs the
> > usb_device pointer for calling usb_put, which is called from
> > skel_disconnect() or skel_release().
>   
> Does skel_delete() really need to call usb_put_dev()?  I suspect that  
> the driver doesn't need to take a reference to either the device or the
> interface.
>  

I think it will be needed, since usb core will decrement the reference
when the device go away. Lock every access to the usb core if a tedious
thing and will waste a lot of code.

The problem with hotpluging is not the plug, it is the unplug, which can
happen any time.

BTW: An interface have no reference count.

> > A call of interface_to_usbdev(dev->intf) results in a udev pointer, but
> > this pointer is only valid if it was called trough kref_put() from
> > skel_disconnect().
> > 
> > For an already opened devices, the call will come from skel_release()
> > and in this case the interface pointer could be already owned by an
> > other driver and no more longer handle by the skeleton driver.
> > 
> > So i think we need both.
> 
> If skel_delete is changed then we don't need the usb_device pointer.
> 

I have no idea how to do this. Every USB driver i know stores the
usb_device pointer.

Maybe you have an idea?

Steffi


