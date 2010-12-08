Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0LHKQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:16:53 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:32971 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0LHKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:16:51 -0500
Date: Wed, 8 Dec 2010 11:16:46 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: Greg KH <gregkh@suse.de>
cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
In-Reply-To: <20101207183305.GA21802@suse.de>
Message-ID: <alpine.LFD.2.02.1012081115250.1909@localhost6.localdomain6>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6> <20101207162755.GA32328@suse.de> <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6> <20101207183305.GA21802@suse.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Greg KH wrote:
> On Tue, Dec 07, 2010 at 06:29:37PM +0100, Sebastian Ott wrote:
> > 
> > On Tue, 7 Dec 2010, Greg KH wrote:
> > > On Tue, Dec 07, 2010 at 05:18:27PM +0100, Sebastian Ott wrote:
> > > > Hi,
> > > > 
> > > > There is currently no generic trigger for userspace to know when a driver
> > > > is bound to a device.
> > > 
> > > Not true at all, you get one when a device is attached to a bus.  What's
> > > wrong with that notification?
> > we get a KOBJ_ADD if a device is attached to a bus, but this does not
> > imply that a device driver is bound to this device
> 
> You can get that information from that uevent, it's all there for you to
> listen to.
> 
> > > > Such a trigger may be required in cases where setup
> > > > steps must be performed in userspace after the device is bound, e.g.
> > > > because the driver adds sysfs attributes in its probe function.
> > > 
> > > A driver should not add sysfs attributes in its probe function as that
> > > is racy as you have noticed.  Add the attributes in the bus functions
> > > for that driver and it should be fine.
> > sry..I was not clear on this one. I was talking driver specific
> > attributes per device.
> 
> No, I understand.
> 
> > So I'm searching for a trigger when these attributes are created, or
> > in other words when the device is useable, which I think translates to
> > when a driver is bound to this device.
> 
> Again, KOBJ_ADD is the correct one.
> 
> If your driver is creating sysfs attributes on its own, that's a bug and
> should be fixed.

Ok, understood. The sad part is, that virtually all s390 device drivers
do this. I've not checked the archives, but i guess this is the status
since the 2.6 release. I don't think that changing all those drivers (not
to mention userspace relying on the structure) is an option here.

Regards,
Sebastian
