Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2FGUmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:42:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54948 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753703Ab2FGUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:42:08 -0400
Date: Thu, 7 Jun 2012 16:42:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
In-Reply-To: <1339098621.13885.13.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206071640031.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012, Stefani Seibold wrote:

> That what i am looking for. If we do an usb_get_intf() in the
> skel_probe() function and an usb_put_intf() in skel_delete() function at
> the end, then it should be save to access the usb_device pointer by
> interface_to_usbdev() in the skel_delete() function. Right?

Safe, yes, but unnecessary.  Just get rid of the usb_put_dev() in 
skel_delete and the usb_get_dev in skel_probe.

Alan Stern

