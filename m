Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2EHRDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:03:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38283 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757552Ab2EHRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:03:18 -0400
Date: Tue, 8 May 2012 13:03:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-scsi@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
In-Reply-To: <1336491453.1933.67.camel@x61.thuisdomein>
Message-ID: <Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Paul Bolle wrote:

> On Tue, 2012-05-08 at 10:02 -0400, Alan Stern wrote:
> > On Tue, 8 May 2012, Paul Bolle wrote: 
> > > 1) These patches try to hide those errors by:
> > > - downgrading one error to a notice; and
> > 
> > That's a reasonable thing to do, IMO.
> > 
> > > - setting the NO_WP_DETECT quirk for these five devices.
> > 
> > But that isn't.  These quirks are intended for devices that crash when
> > they receive the command in question.
> 
> Yes, these USB memory sticks don't crash. (They actually seem to work
> just fine, something that I perhaps should have emphasized in the commit
> descriptions.)
> 
> > They aren't meant to suppress sending commands to devices that can
> > properly reject them.
> 
> Even the sticks that hit "bad_sense" (in sd_read_cache_type(), which I
> forgot to mention in the comment descriptions)? Is that not as severe as
> it suggests?

It means that the device either doesn't support the MODE SENSE command
or it returned useless data.  As a result, we will assume it has a
write-through cache when it might not.

For memory sticks this doesn't matter.  For other devices it might be 
more important (although anything with a working cache should not hit 
this error case).

> Of course, an easy way out would be to downgrade both the "Asking for
> cache data failed" and the "No Caching mode page present" errors to
> notices. But the SCSI people might disagree with that approach.

Well, let's see what they say.

Alan Stern

