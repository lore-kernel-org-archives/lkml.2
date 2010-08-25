Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0HYJzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:55:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696Ab0HYJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:55:42 -0400
Date: Wed, 25 Aug 2010 11:08:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100825110813.5f7d7ac8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100825004134.GA28884@suse.de>
References: <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	<1282683470.8020.66.camel@itpsd6lap>
	<20100824211016.GA7176@suse.de>
	<1282687797.8020.108.camel@itpsd6lap>
	<20100824222035.GA10625@suse.de>
	<1282690232.8020.116.camel@itpsd6lap>
	<20100824225703.GA5913@suse.de>
	<20100825002221.68fc09a4@lxorguk.ukuu.org.uk>
	<20100824231241.GA6971@suse.de>
	<20100825005152.40ba2f12@lxorguk.ukuu.org.uk>
	<20100825004134.GA28884@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Do you want to be able to flip between a real debug interface and a
> > logging device on the same software set without risking changing behaviour
> 
> I don't understand this point.

A tty has a very specific set of behaviours simply by being a tty. Some
applications rely upon them so being able to flip between the two
interfaces is useful.

> > Do you want to load a 70K daemon and an initrd or burn about 1.5K on a
> > kernel interface ?
> 
> I'd rather burn 0K on the one we have today :)

So say "N" when configuring

> Seriously, look at how Fedora 14 handles this, why can't you do the same
> for embedded systems all from userspace, no additional code needed
> anywhere.

Its a whole set of extra processes and daemons and stuff, and
minimally uses something like 70K even if its very compact (8K stack, 40K+
page tables, 16K of buffers, code, data) - oh and I forgot the fifo
buffering and pty cost - so its near 100K. 1.5K v 100K - for something
1.5K of kernel code that anyone else can turn off and would be off by
default ?

On a lot of embedded systems you don't have all the stuff Fedora carts
around. No modules, initrds, magic front end processes, graphical startup
daemons etc, all of which work to produce that feature IFF you have pty
support in your kernel, and for the current code also glibc.

You also want errors to get out (or stored) even if there are crashes -
which the Fedora one is not very good at. To be fair in the Fedora world
its not a big deal to say 'Oh dear, boot with ....'. Embedded isn't the
same, and you want to capture the odd rare error reliably.

Alan


