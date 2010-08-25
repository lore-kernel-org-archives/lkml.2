Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0HYQGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:06:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0HYQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:06:38 -0400
Date: Wed, 25 Aug 2010 08:57:16 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100825155716.GB16284@suse.de>
References: <20100824211016.GA7176@suse.de>
 <1282687797.8020.108.camel@itpsd6lap>
 <20100824222035.GA10625@suse.de>
 <1282690232.8020.116.camel@itpsd6lap>
 <20100824225703.GA5913@suse.de>
 <20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
 <20100824231241.GA6971@suse.de>
 <20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
 <20100825004134.GA28884@suse.de>
 <20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 11:08:13AM +0100, Alan Cox wrote:
> > > Do you want to be able to flip between a real debug interface and a
> > > logging device on the same software set without risking changing behaviour
> > 
> > I don't understand this point.
> 
> A tty has a very specific set of behaviours simply by being a tty. Some
> applications rely upon them so being able to flip between the two
> interfaces is useful.

Would that work for this driver in use as a console?

> > Seriously, look at how Fedora 14 handles this, why can't you do the same
> > for embedded systems all from userspace, no additional code needed
> > anywhere.
> 
> Its a whole set of extra processes and daemons and stuff, and
> minimally uses something like 70K even if its very compact (8K stack, 40K+
> page tables, 16K of buffers, code, data) - oh and I forgot the fifo
> buffering and pty cost - so its near 100K. 1.5K v 100K - for something
> 1.5K of kernel code that anyone else can turn off and would be off by
> default ?

  exec < /dev/console > /dev/kmsg 2>&1

That's one extra process, not that much, right?

> On a lot of embedded systems you don't have all the stuff Fedora carts
> around. No modules, initrds, magic front end processes, graphical startup
> daemons etc, all of which work to produce that feature IFF you have pty
> support in your kernel, and for the current code also glibc.

It sounded like they had an initrd that they cared about here.

> You also want errors to get out (or stored) even if there are crashes -
> which the Fedora one is not very good at. To be fair in the Fedora world
> its not a big deal to say 'Oh dear, boot with ....'. Embedded isn't the
> same, and you want to capture the odd rare error reliably.

again, the above exec line should work for what the embedded people
want, right?

thanks,

greg k-h
