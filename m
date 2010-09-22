Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0IVPGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:06:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0IVPGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:06:37 -0400
Date: Wed, 22 Sep 2010 07:56:07 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-serial device driver
Message-ID: <20100922145607.GB26309@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in>
 <20100913154843.GA27496@suse.de>
 <20100914060649.M96376@admin-gateway.ncra.tifr.res.in>
 <20100914131925.GC375@suse.de>
 <20100922052107.M44650@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922052107.M44650@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 11:02:46AM +0530, Raju Rameshwar Uprade wrote:
> 
> 
> Greg,
>       I am facing some problem in data copying.
> I am having a const unsigned char *buf which contains 02 08 00 00 00 00 00 00 f8.
> which is copied in port->write_urb->transfer_buffer and sent on ttyUSB0 using
> usb_submit_urb(port->write_urb, GFP_ATOMIC).

For what driver?

> But  I want to send the data bytes is a particular fashion.
> 
> 1. I want to Add Mark parity. 

That's a control signal and is independant of the data payload, right?

> 2. Send the data byte 02 ( Address of a device )

That means you need to modify the data.  Why not do that in userspace?

> 3. Add Space parity .

Again, control signal.

> 4. send the data byte 08 00 00 00 00 00 00 f8 ( Null cmd + check sum )

Should be fine.

> Kindly help me.I am facing the problem in separating the data bytes so
> that I can send the data bytes separately using usb_submit_urb.

It all depends on the driver you are using.  Why not do all of this from
userspace?  That way it works on any device you are talking to.

good luck,

greg k-h
