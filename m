Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0IMUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:02:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34549 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754959Ab0IMUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:02:16 -0400
Date: Mon, 13 Sep 2010 16:02:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        <pingc@wacom.com>, linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
In-Reply-To: <201009132105.38204.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1009131600230.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Oliver Neukum wrote:

> Am Montag, 13. September 2010, 17:17:54 schrieb Alan Stern:
> > On Mon, 13 Sep 2010, Oliver Neukum wrote:
> > 
> > > PM in this driver looks broken. Please try this.
> > > 
> > > In short you want to drop the PM reference and depend on remote
> > > wakeup and busy marking for this driver. Currently it gets a reference
> > > on every open() but never drops it.
> > > 
> > > For locking you depend on the PM core's internal lock. You simply
> > > make sure you have a PM reference during open() and close()
> > 
> > Is there any point in resuming the device during close() just in order
> > to kill the interrupt URB?  It seems counterproductive -- if the device 
> > had been suspended then there wouldn't be any interrupt URB to kill in 
> > the first place.
> 
> Suppose the device does not support remote wakeup. It would never
> be autosuspended while it is open, but simply resetting the flag
> would never reach the PM layer.

Whoops, that's right.  I didn't see the assignment to 
needs_remote_wakeup.

How come wacom_open doesn't check to see if wacom->open is already set?

Alan Stern

