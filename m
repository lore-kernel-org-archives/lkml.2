Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0KRBdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:33:36 -0500
Received: from kroah.org ([198.145.64.141]:35503 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0KRBc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:32:56 -0500
Date: Wed, 17 Nov 2010 17:27:34 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118012734.GA8558@kroah.com>
References: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com> <20101116171447.29336514@lxorguk.ukuu.org.uk> <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com> <20101116195538.7fa66b97@lxorguk.ukuu.org.uk> <20101116213622.GA17824@tango.0pointer.de> <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk> <20101116231023.GB27594@tango.0pointer.de> <25482.1290031268@localhost> <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com> <20101117235647.00766e32@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117235647.00766e32@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:56:47PM +0000, Alan Cox wrote:
> > Brilliant conclusion. If you have mounted it, you own it. But you can
> > not make your inactive session mount another new one. It's like this
> > since ages. Hint: try stuff before hitting reply too fast. :)
> 
> Except during the window when screen switching, or of course you could
> just ssh in remotely and gdb or similar a process with it as controlling
> tty running on your console and issue a vt switch back, then mount it.
> Ironically the move from a root owned X server has made that much simpler
> to automate, although it was always possible.
> 
> Given you can often guess from the idle data if the victim has gone away
> from the box it's not ideal. Even better any mess will appear on my
> display and get hidden when I flip it back.
> 
> The only way to stop that is to make use of the display locking facility
> which takes us back where we began in saying that a usable interface is
> going to need to lock the display.
> 
> At that point the current console owner has to choose to allow the
> console to be switched which can be limited effectively to physical
> console access and done synchronously. In turn that means to abuse it I
> already have physical access to the other users key so could just as
> easily steal it and the software security is therefore sufficient.

Ok, we are way-off-topic here from the original points.

Which are:
	- the existing ioctl is broken and no userspace program can use
	  it properly, so it might as well be removed.
	- Kay's patch is one proposed solution for what userspace is
	  wanting to learn about ttys.  Werner's is another one.

So, what to do?

I can do any one, or multiple things from the following options:

	- disable the existing ioctl to return an error so that no new
	  userspace program starts to use it thinking it is valid
	- accept Werner's patch for those who like proc files
	- accept Kay's patch

Any suggestions?

thanks,

greg k-h
