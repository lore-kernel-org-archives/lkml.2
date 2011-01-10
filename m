Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1AJNbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:31:02 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:37942 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1AJNa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:30:59 -0500
Date: Mon, 10 Jan 2011 14:30:55 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20110110133055.GM23771@enneenne.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Randy Dunlap <randy.dunlap@oracle.com>
References: <1294664819-17960-1-git-send-email-giometti@linux.it>
 <1294664819-17960-2-git-send-email-giometti@linux.it>
 <20110110131332.622e8a0d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110131332.622e8a0d@lxorguk.ukuu.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] char nvtty: Network Virtual Terminal support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 01:13:32PM +0000, Alan Cox wrote:
> > By using these devices and a proper compatible server (not included
> > here but you can use sredird) you can get access to a remote tty
> > device as the tty device itself was conneted with your local host.
> > All data and settings are sent and received through the network.
> 
> And this is still something that should be done in userspace if necessary
> by fixing up the tty layer to support pty/tty pair modem lines and
> termios change reporting, or some kind of *generic* vt that can also
> expose all the config other net protocols might need.

If I well understood the pty/tty pair modem lines they can be used to
send receive serial data but they cannot be used to set the serial
parameters since the slave doesn't send to the master the serial
settings a userland application does on it, doesn't it?

> > +	default:
> > +		tty->termios->c_cflag = B0;
> 
> This btw is wrong - if you don't recognize the baud rate you want to
> force a new one. Also you shouldn't be writing all of c_cflag here just
> the baud bits, also you shouldn't in fact ever be hand mangling the baud
> bits but using the helpers.

Ok.

> 
> > +	}
> > +}
> > +#undef TEST_SET_BAUDRATE
> > +
> > +#define TEST_SET_DATASIZE(b)	case b: tty->termios->c_cflag |= CS ## b ; break
> > +static void nvtty_set_datasize(struct nvtty_serial *info, unsigned int datasize)
> > +{
> > +	struct tty_struct *tty = info->tty;
> > +
> > +	nvtty_dbg(info, "datasize=%d", datasize);
> > +
> > +	tty->termios->c_cflag &= ~CSIZE;
> > +	switch (datasize) {
> > +	TEST_SET_DATASIZE(5);
> > +	TEST_SET_DATASIZE(6);
> > +	TEST_SET_DATASIZE(7);
> > +	TEST_SET_DATASIZE(8);
> > +	default:
> > +		tty->termios->c_cflag = CS5;
> 
> Should be |=

Ok.

> > +static void nvtty_set_parity(struct nvtty_serial *info, unsigned int parity)
> > +{
> > +	struct tty_struct *tty = info->tty;
> > +
> > +	nvtty_dbg(info, "parity=%d", parity);
> > +
> > +	tty->termios->c_cflag &= ~(PARENB | PARODD);
> 
> Needs to consider the CMSPAR bit.

Ok.

I'm going to fix these issues ASAP.

> Otherwise its a very nice implementation of something I don't think we
> should have implemented in the kernel.

Thanks, but I still don't understand how I can set the serial settings
without a specific tty driver and just using the pty/tty pair modem
lines... :'(

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
