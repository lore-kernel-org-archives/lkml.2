Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0IMTFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:05:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34714 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0IMTFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:05:10 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] wacom + runtime PM = AA deadlock
Date: Mon, 13 Sep 2010 21:05:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
        pingc@wacom.com, "linux-pm" <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
References: <Pine.LNX.4.44L0.1009131114050.1315-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009131114050.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009132105.38204.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. September 2010, 17:17:54 schrieb Alan Stern:
> On Mon, 13 Sep 2010, Oliver Neukum wrote:
> 
> > PM in this driver looks broken. Please try this.
> > 
> > In short you want to drop the PM reference and depend on remote
> > wakeup and busy marking for this driver. Currently it gets a reference
> > on every open() but never drops it.
> > 
> > For locking you depend on the PM core's internal lock. You simply
> > make sure you have a PM reference during open() and close()
> 
> Is there any point in resuming the device during close() just in order
> to kill the interrupt URB?  It seems counterproductive -- if the device 
> had been suspended then there wouldn't be any interrupt URB to kill in 
> the first place.

Suppose the device does not support remote wakeup. It would never
be autosuspended while it is open, but simply resetting the flag
would never reach the PM layer.

	Regards
		Oliver
