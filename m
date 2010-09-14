Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0INIMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 04:12:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:52352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0INIMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 04:12:49 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Tue, 14 Sep 2010 10:13:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        pingc@wacom.com, "linux-pm" <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <Pine.LNX.4.44L0.1009131600230.1315-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131600230.1315-100000@iolanthe.rowland.org>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141013.19704.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. September 2010, 22:02:16 schrieb Alan Stern:
> > > Is there any point in resuming the device during close() just in order
> > > to kill the interrupt URB?  It seems counterproductive -- if the device 
> > > had been suspended then there wouldn't be any interrupt URB to kill in 
> > > the first place.
> > 
> > Suppose the device does not support remote wakeup. It would never
> > be autosuspended while it is open, but simply resetting the flag
> > would never reach the PM layer.
> 
> Whoops, that's right.  I didn't see the assignment to 
> needs_remote_wakeup.

Should I have used usb_autopm_get_interface_no_resume()?

	Regards
		Oliver
