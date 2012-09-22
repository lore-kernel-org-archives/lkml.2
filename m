Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2IVULx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 16:11:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45791 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2IVULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 16:11:51 -0400
Date: Sun, 23 Sep 2012 00:11:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120922201144.GD11610@moon>
References: <20120913095623.GB28508@moon>
 <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922200731.GD14004@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 01:07:31PM -0700, Greg Kroah-Hartman wrote:
> >  drivers/tty/pty.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> > 
> > Index: tty.git/drivers/tty/pty.c
> > ===================================================================
> > --- tty.git.orig/drivers/tty/pty.c
> > +++ tty.git/drivers/tty/pty.c
> > @@ -283,6 +283,46 @@ done:
> >  	return 0;
> >  }
> >  
> > +static ssize_t pty_show_state(struct device *dev,
> > +			      struct device_attribute *attr,
> > +			      char *buf)
> > +{
> > +	struct tty_struct *tty = dev_get_drvdata(dev);
> > +	int locked, exclusive, packet;
> > +
> > +	tty_lock(tty);
> > +	locked = test_bit(TTY_PTY_LOCK, &tty->flags);
> > +	exclusive = test_bit(TTY_EXCLUSIVE, &tty->flags);
> > +	packet = tty->packet;
> > +	tty_unlock(tty);
> > +
> > +	return snprintf(buf, PAGE_SIZE, "locked: %d exclusive: %d packet: %d\n",
> > +			locked, exclusive, packet);
> > +}
> 
> Sysfs is one value per file, you have three values here, please make 3
> files.
> 
> And document them in Documentation/ABI/.

Hmm, sure Greg, I'll update. Thanks!
