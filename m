Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0KRNO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:14:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:46255 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0KRNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:14:26 -0500
Date: Thu, 18 Nov 2010 14:14:20 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118131420.GA23872@boole.suse.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <25482.1290031268@localhost>
 <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
 <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
 <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
 <20101118121256.GA19884@boole.suse.de>
 <20101118125822.16718289@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101118125822.16718289@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:58:22PM +0000, Alan Cox wrote:
> > Example: running a boot script on /dev/console and after fsck
> > sulogin has to called to be able to asked the system admin.
> > Now the question is which console device the system admin is
> > waiting in front of (before /dev/ttyS0 or /dev/tty3270 or whatever).
> 
> Ok that is a rather nebulous concept for embedded. The answer probably
> being that the true console device has no input facility.
> 
> > I'm aware of.  For using tty devices of the system console it requires
> > to have e.g. with my patch:
> > 
> >   bash> cat /proc/tty/consoles 
> >   tty0                 -WU (ECp)       4:7
> > 
> > the `W' flag for write and the major:minor pair, beside this the `U'
> > flag indicates the tty can do an unblank operation, the `-' shows that
> > there is no read operation (never seen such a console tty).  On an other
> 
> Try the lp printer console if you want a test case
> 
> > to detect the primary console device here.
> 
> Why not just open /dev/console ?

How can I detect the major and minor of the primary console device
of /dev/console without controlling tty?  Even if my old blogd
and the bootlogd(8) of SysInitV using TIOCCONS are outdated by SystemD
the question before doing the TIOCCONS is which is the primary console
device to e.g. create the device node in initrd or for bootlogd(8)
to write a copy of the console messages back to the original
primary console (and the other console devices).

   Werner

-- 
  "Having a smoking section in a restaurant is like having
          a peeing section in a swimming pool." -- Edward Burr
