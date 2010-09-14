Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0INOBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:01:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41182 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753292Ab0INOBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:01:15 -0400
Date: Tue, 14 Sep 2010 10:01:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        <pingc@wacom.com>, linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
In-Reply-To: <201009141013.19704.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.1009140954180.1648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Oliver Neukum wrote:

> Am Montag, 13. September 2010, 22:02:16 schrieb Alan Stern:
> > > > Is there any point in resuming the device during close() just in order
> > > > to kill the interrupt URB?  It seems counterproductive -- if the device 
> > > > had been suspended then there wouldn't be any interrupt URB to kill in 
> > > > the first place.
> > > 
> > > Suppose the device does not support remote wakeup. It would never
> > > be autosuspended while it is open, but simply resetting the flag
> > > would never reach the PM layer.
> > 
> > Whoops, that's right.  I didn't see the assignment to 
> > needs_remote_wakeup.
> 
> Should I have used usb_autopm_get_interface_no_resume()?

That actually would work.  It's a good idea.  The only drawback (not a
big one) is that if the device _was_ suspended with remote wakeup
enabled, doing this wouldn't turn off remote wakeup.  I think that
doesn't matter.

Alan Stern

