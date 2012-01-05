Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2AEFmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:42:46 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:34080 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2AEFmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:42:44 -0500
Date: Thu, 5 Jan 2012 06:42:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
	tty/serial/
Message-ID: <20120105054240.GA9093@merkur.ravnborg.org>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com> <4F04BFA8.9010100@windriver.com> <20120104220332.GA22985@suse.de> <201201042327.33739.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201042327.33739.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 11:27:33PM +0000, Arnd Bergmann wrote:
> On Wednesday 04 January 2012, Greg KH wrote:
> > > 
> > > My thinking was that having a drivers/tty/serial dir and then
> > > not having all the serial drivers in that dir violated the
> > > principle of least surprise.  Is there a reason why the dir should
> > > be the exclusive domain of drivers with a dependency on SERIAL_CORE?
> > 
> > Because that is what the directory is for?  :)
> > 
> > We have other "serial" like drivers all over the kernel, this was for
> > the SERIAL_CORE drivers only at the moment.
> 
> My initial plan when moving some files to drivers/tty was to have a separate
> directory for the non-SERIAL_CORE serial drivers next to drivers/tty/serial.
> 
> I would still prefer this solution, but I think we never agreed on a good
> name for that directory. IIRC, I had suggested drivers/tty/legacy believing
> that SERIAL_CORE was the modern way to implement a serial driver, but that
> turned out not to be true and at lease one of these (bfin_jtag) is not
> a legacy driver in practice.
> 
> Maybe drivers/tty/hw? I think that one has been suggested before, too.
> I don't remember any argument against it and I think it would be nice
> to separate the core implementation from actual device drivers.

How about:

drivers/tty/serial_core  <= drivers based on SERIAL_CORE
drivers/tty/serial       <= the rest

This makes it obvious that one directory is for drivers based on
SERIAL_CORE - and the other is sort of the "rest".

I know this imply moving files around again :-(

	Sam
