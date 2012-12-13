Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab2LMSLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:11:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36589 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755844Ab2LMSLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:11:00 -0500
Date: Thu, 13 Dec 2012 13:10:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: prasannatsmkumar <prasannatsmkumar@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <nautilus-list@gnome.org>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
In-Reply-To: <CANc+2y5pJzda_Rafunn9rFZSgH_Dyq5+rer3rss1=5E7QxqZ6Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212131307250.1415-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012, prasannatsmkumar wrote:

> On Wed, Dec 12, 2012 at 2:07 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > STOP UNIT means spin down the disk or eject the disc.  Since your phone
> > doesn't have a disk drive or an optical disc, no wonder this step
> > failed.
> 
> Yes of course it does not have a optical disc or disk drive. But I
> thought if there is no such thing nautilus should not try to spin
> down. Linux kernel has nothing to do with this problem though.

Right.  Bear in mind that nautilus may not have any way of finding out
whether the device has removable media, other than requesting for the
media to be ejected.  But if it doesn't know then failure of the 
request shouldn't be reported as an error.

> > No, neither option cuts power.  The main difference is that "safely
> > remove" disables the USB connection, so that if the device has an "okay
> > to unplug now" light, the light will turn on.
> 
> I have seen lights going off in my pen drive, so naturally as an user
> I assumed that nautilus request the kernel to cut down the power and
> kernel did that. After choosing "Safely Remove" option my device node
> (/dev/sdb or whatever) still exists?

No, it is gone.  At least, I think so -- I'm not sure exactly what 
nautilus does when you select "Safely Remove".  The kernel's USB stack 
has a "remove" interface that is meant for this sort of thing; I've 
been assuming that this is what nautilus uses.

Alan Stern

