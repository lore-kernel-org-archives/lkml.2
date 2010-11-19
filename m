Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0KSNVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:21:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0KSNVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:21:51 -0500
Date: Fri, 19 Nov 2010 14:21:45 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101119132145.GA22883@boole.suse.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
 <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
 <20101118131420.GA23872@boole.suse.de>
 <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:41:23PM +0000, Alan Cox wrote:
> > How can I detect the major and minor of the primary console device
> > of /dev/console without controlling tty?  Even if my old blogd
> 
> In the general case you can't - because a console may not have a tty.
> Quite a few don't. For the cases where one has a device I can't see a
> clean way to do it as an fstat on the console device will give you the
> console major/mninor and some code depends upon that.

ACK ... nevertheless sometime it could be very useful to be able to
debug the user space boot process on e.g. big irons aka mainframes.

> The iniability to get it is clearly a flaw and you need the sysfs link or
> a sysfs list of consoles (again remembering many of them won't have a tty
> bound).

Even with this case and IMHO a copy of all system console messages
would be sometimes useful for debugging.

> > and the bootlogd(8) of SysInitV using TIOCCONS are outdated by SystemD
> > the question before doing the TIOCCONS is which is the primary console
> > device to e.g. create the device node in initrd or for bootlogd(8)
> > to write a copy of the console messages back to the original
> > primary console (and the other console devices).
> 
> For init it is /dev/console as opened at boot time and passed to the
> initial user init task but with no nice way to work back to a device node.

Currently the bootlogd(8) or blogd(8) parse the kernels command line
and if available do an ioctl TIOCGDEV (not supported by the upstream
kernel), then create a pty/tty pair, do an ioctl TIOCCONS to forward
the system console to the created tty, now both daemons can parse
all console messages to write out logs and write all copies to the
former devices node(s) (compare with http://lkml.org/lkml/2000/12/15/160
and http://lkml.org/lkml/1998/3/21/57).

> Incidentally the primary console (as in printk) can be accessed as a tty
> via the ttyprintk driver which got added recently because embedded people
> wanted to use the printk interface as a (write only) tty console as well.

I've seen that in the changelog of the kernel ... maybe this would
a good replacment for the /dev/kmsg redirect of stdout/stderr in initrd.


     Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/
