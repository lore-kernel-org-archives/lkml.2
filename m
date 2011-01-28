Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1A1C5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1A1C5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:57:40 -0500
Date: Fri, 28 Jan 2011 08:27:25 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Message-ID: <20110128025725.GA2822@amit-x200.redhat.com>
References: <20110120174910.GA30124@kroah.com>
 <1295546625-30681-1-git-send-email-gregkh@suse.de>
 <20110127182916.GA4688@amit-x200.redhat.com>
 <201101272253.29223.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101272253.29223.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Jan 27 2011 [22:53:29], Arnd Bergmann wrote:
> On Thursday 27 January 2011 19:29:44 Amit Shah wrote:
> > On (Thu) Jan 20 2011 [10:03:43], Greg Kroah-Hartman wrote:
> > > As requested by Arnd Bergmann, the hvc drivers are now
> > > moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
> > > was also moved, as it required the hvc_console.h file to be able to be
> > > built, and it really is a hvc driver.
> > 
> > I just saw this now as a result of this patch entering mainline.  I
> > would have liked to be CC'ed to the patches.  Also, I don't like the
> > move of the virtio_console.c file to drivers/tty/hvc.  virtio_console.c
> > is not only an hvc driver; one of its functions is to hook some ports to
> > hvc, but it's mostly a generic driver these days.
> 
> Sorry about this, the idea to move this file was mine and my original
> patch did this as well. I remembered the code from when it was a simple
> console driver based on hvc and never noticed that it had evolved into
> a generic host/guest communication stack.
> 
> > Can you please move it back?
> 
> No objection from me here in general, though as Greg writes above, it's
> a bit ugly when hvc_console.h is in a different directory.

Greg, can you do this please?  (A way to do it with preservig git
history of the file would be great as well, but I think only a revert
will do that?)

> > I could perhaps think of a way of splitting the file so the hvc bits can
> > be moved to drivers/tty/hvc/ and having the core stay in drivers/char/,
> > but that'll have to wait for the next cycle.
> 
> I think that's a really good idea. The main reason for moving the tty
> drivers from drivers/char to drivers/tty was to separate the everything
> related to tty from everything else. The common part should IMHO then not
> be named "console", "tty" os similar but indicate that it's more generic
> than that. Maybe virtio-pipe?

Rusty has suggested virtio-ports in the past.

		Amit
