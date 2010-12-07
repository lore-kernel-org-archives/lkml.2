Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0LGSjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:39:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0LGSjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:39:13 -0500
Date: Tue, 7 Dec 2010 10:33:05 -0800
From: Greg KH <gregkh@suse.de>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101207183305.GA21802@suse.de>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
 <20101207162755.GA32328@suse.de>
 <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 06:29:37PM +0100, Sebastian Ott wrote:
> 
> On Tue, 7 Dec 2010, Greg KH wrote:
> > On Tue, Dec 07, 2010 at 05:18:27PM +0100, Sebastian Ott wrote:
> > > Hi,
> > > 
> > > There is currently no generic trigger for userspace to know when a driver
> > > is bound to a device.
> > 
> > Not true at all, you get one when a device is attached to a bus.  What's
> > wrong with that notification?
> we get a KOBJ_ADD if a device is attached to a bus, but this does not
> imply that a device driver is bound to this device

You can get that information from that uevent, it's all there for you to
listen to.

> > > Such a trigger may be required in cases where setup
> > > steps must be performed in userspace after the device is bound, e.g.
> > > because the driver adds sysfs attributes in its probe function.
> > 
> > A driver should not add sysfs attributes in its probe function as that
> > is racy as you have noticed.  Add the attributes in the bus functions
> > for that driver and it should be fine.
> sry..I was not clear on this one. I was talking driver specific
> attributes per device.

No, I understand.

> So I'm searching for a trigger when these attributes are created, or
> in other words when the device is useable, which I think translates to
> when a driver is bound to this device.

Again, KOBJ_ADD is the correct one.

If your driver is creating sysfs attributes on its own, that's a bug and
should be fixed.

thanks,

greg k-h
