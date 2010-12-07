Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0LGR3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 12:29:45 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:33899 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0LGR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 12:29:44 -0500
Date: Tue, 7 Dec 2010 18:29:37 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: Greg KH <gregkh@suse.de>
cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
In-Reply-To: <20101207162755.GA32328@suse.de>
Message-ID: <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6> <20101207162755.GA32328@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 7 Dec 2010, Greg KH wrote:
> On Tue, Dec 07, 2010 at 05:18:27PM +0100, Sebastian Ott wrote:
> > Hi,
> > 
> > There is currently no generic trigger for userspace to know when a driver
> > is bound to a device.
> 
> Not true at all, you get one when a device is attached to a bus.  What's
> wrong with that notification?
we get a KOBJ_ADD if a device is attached to a bus, but this does not
imply that a device driver is bound to this device

> 
> > Such a trigger may be required in cases where setup
> > steps must be performed in userspace after the device is bound, e.g.
> > because the driver adds sysfs attributes in its probe function.
> 
> A driver should not add sysfs attributes in its probe function as that
> is racy as you have noticed.  Add the attributes in the bus functions
> for that driver and it should be fine.
sry..I was not clear on this one. I was talking driver specific
attributes per device. So I'm searching for a trigger when these
attributes are created, or in other words when the device is useable,
which I think translates to when a driver is bound to this device.

> 
> > I can imagine 3 possible ways to solve this problem:
> > * add a bus specific change event (triggered by BUS_NOTIFY_BOUND_DRIVER)
> >   - this may result in duplicated code for each bus
> > * dissable autoprobing and "manually" probe the device from userspace
> >   triggered by the add event - this duplicates logic already implemented
> >   in the kernel
> > * add a generic bind/unbind uevent
> > 
> > Which one is preferred from a driver core perspective?
> 
> None, use the existing notifications like everyone else :)
> 
> thanks,
> 
> greg k-h
> 
