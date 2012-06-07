Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab2FGO2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:28:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38925 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760760Ab2FGO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:28:06 -0400
Date: Thu, 7 Jun 2012 10:28:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
In-Reply-To: <1339069895.12066.10.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206071026160.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, Stefani Seibold wrote:

> I tried to implement your idea to kick away the usb_device pointer, but
> i think it is impossible. The skel_delete() function needs the
> usb_device pointer for calling usb_put, which is called from
> skel_disconnect() or skel_release().
  
Does skel_delete() really need to call usb_put_dev()?  I suspect that  
the driver doesn't need to take a reference to either the device or the
interface.
  
> A call of interface_to_usbdev(dev->intf) results in a udev pointer, but
> this pointer is only valid if it was called trough kref_put() from
> skel_disconnect().
> 
> For an already opened devices, the call will come from skel_release()
> and in this case the interface pointer could be already owned by an
> other driver and no more longer handle by the skeleton driver.
> 
> So i think we need both.

If skel_delete is changed then we don't need the usb_device pointer.

Alan Stern

