Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2BQT2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:28:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60708 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2BQT2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:28:31 -0500
Date: Fri, 17 Feb 2012 20:28:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Egmont Koblinger <egmont@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Data corruption when pasting large data to terminal
Message-ID: <20120217192825.GE2707@elf.ucw.cz>
References: <CAGWcZkJs2uQHM=7wmf1JOLmUeS3Mxo5L4arMuMQSez1mvJLKQA@mail.gmail.com>
 <CAGWcZkKV1vc47zB_d0e+Q3+XG08mDt6TfzQ3d0p4=wswKN3ePg@mail.gmail.com>
 <20120215233002.GB20816@kroah.com>
 <CAGWcZkJHCRppjONbHuNop2r2X=n7efK94dQMXrA2=0Ou39bOAg@mail.gmail.com>
 <20120216005437.GA22858@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216005437.GA22858@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Sorry, I didn't emphasize the point that makes me suspect it's a kernel issue:
> > 
> > - strace reveals that the terminal emulator writes the correct data
> > into /dev/ptmx, and the kernel reports no short writes(!), all the
> > write(..., ..., 68) calls actually return 68 (the length of the
> > example file's lines incl. newline; I'm naively assuming I can trust
> > strace here.)
> > - strace reveals that the receiving application (bash) doesn't receive
> > all the data from /dev/pts/N.
> > - so: the data gets lost after writing to /dev/ptmx, but before
> > reading it out from /dev/pts/N.
> 
> Which it will, if the reader doesn't read fast enough, right?  Is the
> data somewhere guaranteed to never "overrun" the buffer?  If so, how do
> we handle not just running out of memory?

Start blocking the writer?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
