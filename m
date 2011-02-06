Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1BFDT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 22:19:28 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52073 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752087Ab1BFDT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 22:19:27 -0500
Date: Sat, 5 Feb 2011 22:19:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Minchan Kim <minchan.kim@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] usb_set_device_state
In-Reply-To: <201102060006.45175.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1102052211040.9798-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Feb 2011, Rafael J. Wysocki wrote:

> On Saturday, February 05, 2011, Alan Stern wrote:
> > On Sun, 6 Feb 2011, Minchan Kim wrote:
> > 
> > > I got following message during booting mmotm-02-04.
...
> > > It seems usb_set_device_state disable irq by spin_lock_irqsave.
> > > But it calls device_set_wakeup_capable which ends up calling sysfs_merge_group.
> > > It calls mutex_lock. :(
> > > 
> > > Is it already known BUG?
> > 
> > No, it was newly introduced by changes to the 
> > device_set_wakeup_capable() routine.  Rafael, this sort of problem may 
> > occur in other places too, since previously there was no requirement 
> > that device_set_wakeup_capable() be called in process context.
> 
> I'm aware of that, but it's only happend in a handful of network drivers so far.
> 
> I think this is a new case in -mm, though, isn't it?

I'm not sure.  The USB core does call device_set_wakeup_capable()  
while holding one or more spinlocks in usb_set_device_state(), and that
routine is called in several places.  You ought to be able to duplicate 
the error on your own system simply by plugging in a USB hub.

Alan Stern

