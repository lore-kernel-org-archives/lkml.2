Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0INQF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:05:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43996 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753913Ab0INQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:05:24 -0400
Date: Tue, 14 Sep 2010 12:05:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        <pingc@wacom.com>, linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
In-Reply-To: <201009141730.38215.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.1009141203460.1648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Oliver Neukum wrote:

> Am Dienstag, 14. September 2010, 17:23:15 schrieb Alan Stern:
> > On Tue, 14 Sep 2010, Oliver Neukum wrote:
> > 
> > > > > Should I have used usb_autopm_get_interface_no_resume()?
> > > > 
> > > > That actually would work.  It's a good idea.  The only drawback (not a
> > > > big one) is that if the device _was_ suspended with remote wakeup
> > > > enabled, doing this wouldn't turn off remote wakeup.  I think that
> > > > doesn't matter.
> > > 
> > > I am afraid it does matter as devices whose remote wakeup is enabled
> > > may draw more power.
> > 
> > I doubt it, or at least, not very much more.  They are still limited by 
> > the USB spec as to the total amount of current they can draw while 
> > suspended.
> 
> 7.2.3 Sources of remote wakeup may draw 2.5mA when suspended
> as opposed to 0.5 mA

Okay, then we may as well wake it up in order to turn off remote 
wakeup.  For drivers that don't need remote wakeup, it's better to use 
the _no_resume form.

Alan Stern

