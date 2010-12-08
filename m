Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0LHP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:57:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36405 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756014Ab0LHP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:57:50 -0500
Date: Wed, 8 Dec 2010 10:57:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@suse.de>
cc: Greg KH <greg@kroah.com>, Luben Tuikov <ltuikov@yahoo.com>,
        Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
In-Reply-To: <1291823012.24312.52.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.1012081054160.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, James Bottomley wrote:

> On Wed, 2010-12-08 at 10:16 -0500, Alan Stern wrote:
> > On Tue, 7 Dec 2010, James Bottomley wrote:
> > 
> > > Well, not other than I've already said:  I think it looks OK, so I
> > > marked it for my merge window queue.  I'd still rather like USB people
> > > to confirm that the original reason why this was done (to prevent device
> > > crashes on the mode sense) is no longer an issue
> > 
> > The original reason for adding the skip_ms_page_8 flag still applies.  
> > To assume it is no longer an issue would not be safe -- there's no 
> > reason to believe that the buggy devices it was meant for have all been 
> > retired.
> > 
> > >  ... but it's only USB
> > > stuff, so suppose I'm OK with finding out in the field.
> > 
> > With USB there's often no other choice.
> 
> So the translation is that there's a possibility it will crash USB
> devices but the only way to find out is to release it and see.

In the strictest sense, there's always a possibility that any change
will crash _some_ device somewhere.  In this case I believe the
probability is very low.  Luben's patch does not change the commands
sent to a USB device; it only changes the kernel's interpretation of
the data sent back.  Unless things are terribly badly broken, this 
won't hurt.

> My problem is that it only takes one bug report from one failing device
> (which I'm sure some kind soul will dig out of the attic or wherever
> they threw it) for this to be a regression and then I get to revert the
> patch ... unless we have a working backup plan?
> 
> I think it's easy to put in and easy to revert ... we'll pick up a bit
> of flack if the failing device doesn't appear for some time, but I'm OK
> with risking that.

IMO the risk is extremely small.

Alan Stern

