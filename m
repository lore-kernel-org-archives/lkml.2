Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab0LNS0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:26:45 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:55743 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0LNS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:26:44 -0500
Date: Tue, 14 Dec 2010 19:26:40 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: Greg KH <gregkh@suse.de>
cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
In-Reply-To: <20101213193617.GA18262@suse.de>
Message-ID: <alpine.LFD.2.02.1012141918520.1988@localhost6.localdomain6>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6> <20101207162755.GA32328@suse.de> <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6> <20101207183305.GA21802@suse.de> <AANLkTinmuxDYU9-zGvWB0mDDuXZEfZnuVxtSYGk62c8P@mail.gmail.com>
 <alpine.LFD.2.02.1012081116530.1909@localhost6.localdomain6> <20101208160255.GB10313@suse.de> <alpine.LFD.2.02.1012132026430.2013@localhost6.localdomain6> <20101213193617.GA18262@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 13 Dec 2010, Greg KH wrote:
> On Mon, Dec 13, 2010 at 08:27:45PM +0100, Sebastian Ott wrote:
> > On Wed, 8 Dec 2010, Greg KH wrote:
> > > On Wed, Dec 08, 2010 at 11:18:27AM +0100, Sebastian Ott wrote:
> > > > On Tue, 7 Dec 2010, Kay Sievers wrote:
> > > > > On Tue, Dec 7, 2010 at 19:33, Greg KH <gregkh@suse.de> wrote:
> > > > > > On Tue, Dec 07, 2010 at 06:29:37PM +0100, Sebastian Ott wrote:
> > > > > 
> > > > > >> So I'm searching for a trigger when these attributes are created, or
> > > > > >> in other words when the device is useable, which I think translates to
> > > > > >> when a driver is bound to this device.
> > > > > >
> > > > > > Again, KOBJ_ADD is the correct one.
> > > > > >
> > > > > > If your driver is creating sysfs attributes on its own, that's a bug and
> > > > > > should be fixed.
> > > > > 
> > > > > Sounds a bit like the driver should create its own child device with
> > > > > its own properties, instead of mangling around with attributes at a
> > > > > device it binds to.
> > > > 
> > > > Yes, I get that feeling too. But I'm talking about existing drivers
> > > > and I don't think I can change their whole structure.
> > > 
> > > It's just a matter of putting the attributes in a table and passing that
> > > to the bus code the driver registers with.  Only a minor change in the
> > > driver is needed to resolve this.
> > 
> > I don't get it. The current situation is, that our drivers
> > add attributes to the device they are about to bind with, in
> > the probe function.
> 
> Don't do that, have your _driver_ register the attributes with the bus
> it is on, then when the binding happens, the attributes will
> automatically get created for the device before the notification is sent
> to userspace.  That is the proper proceedure here.

are you suggesting that these driver specific device attributes should be
created by the bus code which registers the device?
at this time it is not determinable which driver will bind to the device
(and therefore which attributes to create), also driver specific data may 
not be initialized.

> 
> > I think we agree that it would be better
> > if those drivers would register a child device and add attributes
> > to this one. But my concern is that this would break userspace
> > which walks the sysfs tree and changes attributes, since it changed
> > from:
> > /sys/devices/$DEV/$ATTR
> > to:
> > /sys/devices/$DEV/$CHILD/$ATTR
> 
> Ick, no, you don't have to do that, just use the functionality the
> driver core provides for you already.
> 
> thanks,
> 
> greg k-h
> 
