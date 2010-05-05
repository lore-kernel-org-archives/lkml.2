Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0EEWxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:53:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0EEWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:53:18 -0400
Date: Wed, 5 May 2010 15:51:39 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Message-ID: <20100505225139.GA19163@suse.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
 <1273012433-6125-11-git-send-email-arnd@arndb.de>
 <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:59:05PM +0100, Alan Cox wrote:
> > Some wait_until_sent versions require the big
> > tty mutex, others don't and some callers of
> > wait_until_sent already hold it while other don't.
> > That leads to recursive use of the BTM in these
> > functions, which we're trying to get rid of.
> 
> I don't believe any of the currently live ones do.
> 
> >  drivers/char/amiserial.c      |    6 +++---
> >  drivers/char/generic_serial.c |    2 +-
> 
> Both ex drivers
> 
> >  drivers/char/hvc_console.c    |    2 +-
> >  drivers/char/hvcs.c           |    2 +-
> 
> Doesn't seemn to need it
> 
> >  drivers/char/ip2/ip2main.c    |   20 +++++++++++++++++---
> 
> I don't think we care - the driver is a mess, its probably not been used
> in years
> 
> >  drivers/char/serial167.c      |    6 +++---
> 
> Historical value only and broken
> 
> >  drivers/char/specialix.c      |    2 +-
> 
> Broken
> 
> >  drivers/serial/68328serial.c  |    2 +-
> >  drivers/serial/68360serial.c  |    5 ++---
> 
> Both defunct
> 
> >  drivers/serial/crisv10.c      |   12 +++++++-----
> 
> Defunct
> 
> >  net/irda/ircomm/ircomm_tty.c  |    2 +-
> 
> Semi-defunct at best
> 
> This makes me think that now might be a good time to consign the broken
> crap to the bitbucket unless someone stands up with hardware and who
> wants to maintain it.

I will be glad to do this, moving these drivers to the staging tree so
that they can be removed in 6-8 months, much like some wireless drivers
are about to have happen to them.

So, which ones should I move?  How about to start with the ones you
listed above:
	drivers/char/amiserial.c
	drivers/char/generic_serial.c
	drivers/char/ip2/ip2main.c
	drivers/char/serial167.c
	drivers/char/specialix.c
	drivers/serial/68328serial.c
	drivers/serial/68360serial.c
	drivers/serial/crisv10.c

Any others you want to see move out of the tree?

thanks,

greg k-h
