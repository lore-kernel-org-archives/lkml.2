Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0KUInD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:43:03 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:34112 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0KUInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:43:00 -0500
Date: Sun, 21 Nov 2010 09:42:48 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tilman Schmidt <tilman@imap.cc>, linux-doc@vger.kernel.org
Message-ID: <20101121084248.GQ13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tilman Schmidt <tilman@imap.cc>, linux-doc@vger.kernel.org
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <74f895fecc315f781a97b12d7feba3d6c4053195.1290087480.git.lasaine@lvk.cs.msu.su>
 <20101120162304.GE13356@enneenne.com>
 <20101121034402.273f7ac9@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121034402.273f7ac9@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 12/17] pps: timestamp is always passed to dcd_change()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 03:44:02AM +0300, Alexander Gordeev wrote:
> ?? Sat, 20 Nov 2010 17:23:04 +0100
> Rodolfo Giometti <giometti@enneenne.com> ??????????:
> 
> > On Thu, Nov 18, 2010 at 07:01:05PM +0300, Alexander Gordeev wrote:
> > > Remove the code that gatheres timestamp in pps_tty_dcd_change() in case
> > > passed ts parameter is NULL because it never happens in the current
> > > code. Fix comments as well.
> > > 
> > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > > ---
> > >  Documentation/serial/tty.txt    |    2 +-
> > >  drivers/pps/clients/pps-ldisc.c |    8 --------
> > >  include/linux/tty_ldisc.h       |    2 +-
> > >  3 files changed, 2 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
> > > index 7c90050..540db41 100644
> > > --- a/Documentation/serial/tty.txt
> > > +++ b/Documentation/serial/tty.txt
> > > @@ -107,7 +107,7 @@ write_wakeup()	-	May be called at any point between open and close.
> > >  
> > >  dcd_change()	-	Report to the tty line the current DCD pin status
> > >  			changes and the relative timestamp. The timestamp
> > > -			can be NULL.
> > > +			cannot be NULL.
> > 
> > Can you please explain why it cannot be null? O_o
> > 
> > Who does supply the timestamp to dcd_change?
> 
> dcd_change() is called only from one place - uart_handle_dcd_change() -
> which always obtains and passes timestamps to the former. So no need to
> check if ts is NULL and obtain ts again.

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
