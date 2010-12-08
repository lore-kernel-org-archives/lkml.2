Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0LHKSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:18:31 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33229 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0LHKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:18:29 -0500
Date: Wed, 8 Dec 2010 11:18:27 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost6.localdomain6
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
In-Reply-To: <AANLkTinmuxDYU9-zGvWB0mDDuXZEfZnuVxtSYGk62c8P@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1012081116530.1909@localhost6.localdomain6>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6> <20101207162755.GA32328@suse.de> <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6> <20101207183305.GA21802@suse.de>
 <AANLkTinmuxDYU9-zGvWB0mDDuXZEfZnuVxtSYGk62c8P@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Kay Sievers wrote:
> On Tue, Dec 7, 2010 at 19:33, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Dec 07, 2010 at 06:29:37PM +0100, Sebastian Ott wrote:
> 
> >> So I'm searching for a trigger when these attributes are created, or
> >> in other words when the device is useable, which I think translates to
> >> when a driver is bound to this device.
> >
> > Again, KOBJ_ADD is the correct one.
> >
> > If your driver is creating sysfs attributes on its own, that's a bug and
> > should be fixed.
> 
> Sounds a bit like the driver should create its own child device with
> its own properties, instead of mangling around with attributes at a
> device it binds to.

Yes, I get that feeling too. But I'm talking about existing drivers
and I don't think I can change their whole structure.

> 
> Sebastian, care to be more specific about the problem and bus in
> question. We should avoid new generic events. In some special cases,
> sending out 'change' from the driver might be acceptable, but it's
> usually not what we would suggest.

The specific problem I'm facing is about network drivers on S390.
They don't have one network adaptor, but deal with multiple devices
(e.g. a read, write and a data channel). To handle this we create
a group device to combine these devices. Triggered from userspace,
a network driver will create a group device and wait for itself to
bind to it (and adds his attributes inside his probe function).

Now some udev scripts expect these attributes at the time they
receive the add event. I don't want each network driver to throw
their own change events. So I guess I should go for the bus specific
change event. An other option would be to delay the add event..
which would be ugly, but has the advantage that we don't need to
change the udev scripts (which are distributor specific).

Regards,
Sebastian
