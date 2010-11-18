Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab0KRLA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:00:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:42552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab0KRLA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:00:26 -0500
Date: Thu, 18 Nov 2010 12:00:21 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118110020.GA13871@boole.suse.de>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
 <20101116213622.GA17824@tango.0pointer.de>
 <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
 <20101116231023.GB27594@tango.0pointer.de>
 <25482.1290031268@localhost>
 <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
 <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
 <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101118015310.GA30480@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:53:10PM -0800, Greg KH wrote:
> On Thu, Nov 18, 2010 at 02:48:48AM +0100, Lennart Poettering wrote:
> > On Wed, 17.11.10 17:27, Greg KH (greg@kroah.com) wrote:
> > 
> > > I can do any one, or multiple things from the following options:
> > > 
> > > 	- disable the existing ioctl to return an error so that no new
> > > 	  userspace program starts to use it thinking it is valid
> > > 	- accept Werner's patch for those who like proc files
> > > 	- accept Kay's patch
> > > 
> > > Any suggestions?
> > 
> > Maybe this is not so surprising, but I definitely want item #3 from the
> > list. 
> > 
> > I am against #2, since #1 is a much nicer solution, and having both
> > would be needlessly redundant.
> 
> I think you mean s/1/3/ here, right?
> 
> And yes, having both will be redundant, and Werner seems to not be
> responding anymore as to why he feels his patch is somehow still needed
> given that Kay's patch accomplishes the same thing from what I can tell.

I'm still reading and I'm wondering about this discussion.  The only
thing I'd like to be able is to detect all ttys used for the system
console even if not a VT (not having a VT but several other consoles
is the most pressing case e.g. on s390 or zSeries) and this without
forcing (and maybe stealing) the controlling tty on the system console
to be able to detect the primary tty/console.

The primary tty marked with CON_CONSDEV and normally the first in
console_drivers.  This can be done with Kay's patch as well as with
my approach.  And both approaches do have the advantage to become
the full list of consoles which will help me to extend e.g. sulogin ...

The only advantage of my approache in comparision to Kay's one is that
the remaining console flags become visible for normal user space.
This was an idea of Randy Dunlap otherwise my patch would provide
the same information as the patch of Kay.

Maybe Kay could extend his patch in that way that the flags and the
facilities (having device, read, write, and unblank) are also shown
in the new file /sys/class/tty/console/active ... but maybe Randy
could says a few words for what this is usable.

     Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/
