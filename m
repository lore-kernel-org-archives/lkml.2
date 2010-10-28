Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab0J1S0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:26:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934088Ab0J1S0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:26:12 -0400
Date: Thu, 28 Oct 2010 14:26:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: v2.6.36-rc8..v2.6.36 regression on NULL pointer deference at
 disk_replace_part_tbl+0x32
In-Reply-To: <AANLkTin9k=nM8N5FB7gnpXfRhU2axYKZx=rELEppqY_a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1010281423540.1601-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Luis R. Rodriguez wrote:

> On Thu, Oct 28, 2010 at 10:25 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > I've filled out a bug report for a regression when I enable USB tether
> > on my Nexus One when hooked up to my laptop. I get a NULL pointer
> > dereference. This is a regression between v2.6.36-rc8 and v2.6.36. I
> > will bisect when I get a chance.

> Odd, I get 0 results with a:
> 
> git log v2.6.36-rc8..v2.6.36 scsiglue.c protocol.c transport.c usb.c
> initializers.c sierra_ms.c option_ms.c
> 
> So the issue must be elsewhere unless there was a subsystem change
> that triggered a new issue on usb-storage.

What makes you think this bug has anything at all to do with 
usb-storage?  The fact that you saw it with a USB drive has very little 
to do with anything.

With a problem like this, which crosses so many subsystem boundaries 
(USB, storage, SCSI, block), you shouldn't make any assumptions.  Just 
do a complete bisection.

Alan Stern

