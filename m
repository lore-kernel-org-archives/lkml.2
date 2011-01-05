Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1AEOsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:48:14 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:43709 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1AEOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:48:13 -0500
Date: Wed, 5 Jan 2011 15:48:00 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <20110105144758.GB3937@enneenne.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1294067735-21466-1-git-send-email-giometti@linux.it>
 <1294067735-21466-2-git-send-email-giometti@linux.it>
 <20110103153231.ce70dbb5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103153231.ce70dbb5.randy.dunlap@oracle.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] char nvtty: Network Virtual Terminal support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 03:32:31PM -0800, Randy Dunlap wrote:
> On Mon,  3 Jan 2011 16:15:35 +0100 Rodolfo Giometti wrote:
> 
> > A Network Virtual terminal (NVT tty) is a software device consisting
> > of one halves: a client device, which is identical to a physical
> > terminal, who, is turn, get connected with a remote server where real
> > tty devices are located.
> > 
> > These devices are specified by RFC 854 and RFC 2217 and ther name into
> > the system is /dev/nvttyX (by default you have 4 devices).
> > 
> > By using these devices and a proper compatible server (not included
> > here but you can use sredird) you can get access to a remote tty
> > device as the tty device itself was conneted with your local host.
> > All data and settings are sent and received through the network.
> > 
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> > ---
> >  Documentation/ABI/testing/sysfs-nvtty |   35 +
> >  drivers/char/Kconfig                  |   22 +
> >  drivers/char/Makefile                 |    1 +
> >  drivers/char/nvtty.c                  | 1557 +++++++++++++++++++++++++++++++++
> >  4 files changed, 1615 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-nvtty
> >  create mode 100644 drivers/char/nvtty.c
> > 
> 
> > diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> > index 43d3395..13775be 100644
> > --- a/drivers/char/Kconfig
> > +++ b/drivers/char/Kconfig
> > @@ -451,6 +451,28 @@ config UNIX98_PTYS
> >  	  All modern Linux systems use the Unix98 ptys.  Say Y unless
> >  	  you're on an embedded system and want to conserve memory.
> >  
> > +config NVT_TTY
> > +	tristate "Network Virtual Terminal"
> > +	default m
> 
> Don't enable random drivers, please.

Ok, moved to 'n'.

> > +	---help---
> > +	  A Network Virtual terminal (NVT tty) is a software device
> > +	  consisting of one halves: a client device, which is
> 
> 	"one" and "halves" do not go together.

Fixed.

> > +	  identical to a physical terminal, who, is turn, get
> 
> 	                                         in turn, gets

Fixed.

> > +	  connected with a remote server where real tty devices are
> 
> 	            to a remote server

Fixed.

> > +	  located.
> > +
> > +	  These devices are specified by RFC 854 and RFC 2217 and ther
> 
> 	                                                          the ?? or their ??

Fixed.

> > +	  name into the system is /dev/nvttyX (by default you have 4
> 
> 	                                      (by default there are 4

Fixed.

> > +	  devices).
> > +
> > +	  By using these devices and a proper compatible server (not
> > +	  included here but you can use sredird) you can get access to
> > +	  a remote tty device as the tty device itself was conneted
> 
> 	                      as though the tty device itself was connected

Fixed.

> > +	  with your local host.  All data and settings are sent and
> > +	  received through the network.
> > +
> > +	  If unsure, say M.
> > +
> >  config DEVPTS_MULTIPLE_INSTANCES
> >  	bool "Support multiple instances of devpts"
> >  	depends on UNIX98_PTYS

Thanks a lot, I'm going to repropose a new patch ASAP.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
