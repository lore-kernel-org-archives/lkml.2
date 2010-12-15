Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0LONVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:21:08 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:32948 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab0LONVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:21:06 -0500
Date: Wed, 15 Dec 2010 14:21:13 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101215142113.7d416d78@gondolin>
In-Reply-To: <20101214192952.GA9106@suse.de>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
	<20101207162755.GA32328@suse.de>
	<alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
	<20101207183305.GA21802@suse.de>
	<AANLkTinmuxDYU9-zGvWB0mDDuXZEfZnuVxtSYGk62c8P@mail.gmail.com>
	<alpine.LFD.2.02.1012081116530.1909@localhost6.localdomain6>
	<20101208160255.GB10313@suse.de>
	<alpine.LFD.2.02.1012132026430.2013@localhost6.localdomain6>
	<20101213193617.GA18262@suse.de>
	<alpine.LFD.2.02.1012141918520.1988@localhost6.localdomain6>
	<20101214192952.GA9106@suse.de>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Dirk
 Wittkopp Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 11:29:52 -0800,
Greg KH <gregkh@suse.de> wrote:

> On Tue, Dec 14, 2010 at 07:26:40PM +0100, Sebastian Ott wrote:
> > 
> > On Mon, 13 Dec 2010, Greg KH wrote:
> > > On Mon, Dec 13, 2010 at 08:27:45PM +0100, Sebastian Ott wrote:

> > > Don't do that, have your _driver_ register the attributes with the bus
> > > it is on, then when the binding happens, the attributes will
> > > automatically get created for the device before the notification is sent
> > > to userspace.  That is the proper proceedure here.
> > 
> > are you suggesting that these driver specific device attributes should be
> > created by the bus code which registers the device?
> 
> Yes.
> 
> > at this time it is not determinable which driver will bind to the device
> > (and therefore which attributes to create), also driver specific data may 
> > not be initialized.
> 
> {sigh}
> 
> Please go _look_ at how the driver model handles this type of thing.  It
> does _exactly_ what you want, as we have been doing it for _years_
> properly.
> 

I don't understand how this could work. All of the attribute (groups)
registered before the uevent are driver-ignorant. If the bus wants to
specify the attributes, it needs to know the driver the device will
bind to (regardless of whatever tables exist that show the driver <->
attribute relationship). But it cannot know the driver until after the
uevent. Or else it would need to create _all_ attributes for _all_
devices (surely you didn't mean that)? And what happens with drivers
that are loaded later on?

Could you please elaborate on how the attributes could be created in a
compatible way with today's driver core?

Cornelia
