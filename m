Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1HXVXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:23:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60652 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753335Ab1HXVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:23:09 -0400
Date: Wed, 24 Aug 2011 17:23:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hans de Goede <hdegoede@redhat.com>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Add USBDEVFS_TRY_DISCONNECT ioctl
In-Reply-To: <4E556743.4000106@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1108241719540.1643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Hans de Goede wrote:

> Hi,
> 
> First of all: A big thanks to Alan for working on this. From my POV
> the code looks good, but I'm only familiar with the usb parts
> and not with the scsi parts.
> 
> One generic concern is the use of scsi_lock(host) in the
> scsi_device_open / close callbacks. We need to be sure non
> of the callers of these can already be holding the lock.

The callers always runs in process context (because file open/close
always uses process context) and the lock is a spinlock.  So no, the
lock can't be held at the wrong time.


> On 08/24/2011 10:45 PM, Greg KH wrote:

> > I don't like the fact that if a driver doesn't contain check_busy() then
> > it will automatically fall back to looking like it was a DISCONNECT
> > call, which could give userspace a false sense of "everything was fine"
> > when trying this out.
> 
> I've to agree with Greg here, what to do in case of a driver not
> implementing check_busy and thus not really offering USBDEVFS_TRY_DISCONNECT
> is policy and thus should be left to userspace. I suggest we just return
> -ENOTTY in case of USBDEVFS_TRY_DISCONNECT and the bound driver does not
> have checkbusy, then userspace can decide wether to fallback to a regular
> disconnect, or to give up.

Okay, I'll change the patch.  But the real question is whether the 
basic idea is acceptable.

Alan Stern

