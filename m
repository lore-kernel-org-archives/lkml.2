Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab0INOD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:03:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0INOD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:03:28 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Tue, 14 Sep 2010 16:03:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        pingc@wacom.com, "linux-pm" <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <Pine.LNX.4.44L0.1009140954180.1648-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009140954180.1648-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141603.59338.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. September 2010, 16:01:14 schrieb Alan Stern:
> On Tue, 14 Sep 2010, Oliver Neukum wrote:
> 
> > Am Montag, 13. September 2010, 22:02:16 schrieb Alan Stern:
> > > > > Is there any point in resuming the device during close() just in order
> > > > > to kill the interrupt URB?  It seems counterproductive -- if the device 
> > > > > had been suspended then there wouldn't be any interrupt URB to kill in 
> > > > > the first place.
> > > > 
> > > > Suppose the device does not support remote wakeup. It would never
> > > > be autosuspended while it is open, but simply resetting the flag
> > > > would never reach the PM layer.
> > > 
> > > Whoops, that's right.  I didn't see the assignment to 
> > > needs_remote_wakeup.
> > 
> > Should I have used usb_autopm_get_interface_no_resume()?
> 
> That actually would work.  It's a good idea.  The only drawback (not a
> big one) is that if the device _was_ suspended with remote wakeup
> enabled, doing this wouldn't turn off remote wakeup.  I think that
> doesn't matter.

I am afraid it does matter as devices whose remote wakeup is enabled
may draw more power.

	Regards
		Oliver
