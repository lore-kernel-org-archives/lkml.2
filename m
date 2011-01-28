Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1A1Ein (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:38:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:57865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab1A1Eim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:38:42 -0500
Date: Thu, 27 Jan 2011 20:21:25 -0800
From: Greg KH <gregkh@suse.de>
To: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Message-ID: <20110128042125.GA1844@suse.de>
References: <20110120174910.GA30124@kroah.com>
 <1295546625-30681-1-git-send-email-gregkh@suse.de>
 <20110127182916.GA4688@amit-x200.redhat.com>
 <201101272253.29223.arnd@arndb.de>
 <20110128025725.GA2822@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128025725.GA2822@amit-x200.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 08:27:25AM +0530, Amit Shah wrote:
> On (Thu) Jan 27 2011 [22:53:29], Arnd Bergmann wrote:
> > On Thursday 27 January 2011 19:29:44 Amit Shah wrote:
> > > On (Thu) Jan 20 2011 [10:03:43], Greg Kroah-Hartman wrote:
> > > > As requested by Arnd Bergmann, the hvc drivers are now
> > > > moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
> > > > was also moved, as it required the hvc_console.h file to be able to be
> > > > built, and it really is a hvc driver.
> > > 
> > > I just saw this now as a result of this patch entering mainline.  I
> > > would have liked to be CC'ed to the patches.  Also, I don't like the
> > > move of the virtio_console.c file to drivers/tty/hvc.  virtio_console.c
> > > is not only an hvc driver; one of its functions is to hook some ports to
> > > hvc, but it's mostly a generic driver these days.
> > 
> > Sorry about this, the idea to move this file was mine and my original
> > patch did this as well. I remembered the code from when it was a simple
> > console driver based on hvc and never noticed that it had evolved into
> > a generic host/guest communication stack.
> > 
> > > Can you please move it back?
> > 
> > No objection from me here in general, though as Greg writes above, it's
> > a bit ugly when hvc_console.h is in a different directory.
> 
> Greg, can you do this please?  (A way to do it with preservig git
> history of the file would be great as well, but I think only a revert
> will do that?)

So just move the one file, virtio_console.c?  If so, yes, I can move it
back.

> > > I could perhaps think of a way of splitting the file so the hvc bits can
> > > be moved to drivers/tty/hvc/ and having the core stay in drivers/char/,
> > > but that'll have to wait for the next cycle.

That would be great, care to send me those patches now so I can queue it
up for .39?

thanks,

greg k-h
