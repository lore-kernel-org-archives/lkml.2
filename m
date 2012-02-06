Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab2BFTYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:24:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35641 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2BFTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:24:08 -0500
Date: Mon, 6 Feb 2012 20:24:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why are not processes HUPped when they open /dev/console?
Message-ID: <20120206192406.GB28687@atrey.karlin.mff.cuni.cz>
References: <4F207660.500@suse.cz>
 <20120125214522.7a49cf39@pyramind.ukuu.org.uk>
 <4F2151FD.4050101@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2151FD.4050101@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 01/25/2012 10:45 PM, Alan Cox wrote:
> > On Wed, 25 Jan 2012 22:38:40 +0100
> > Jiri Slaby <jslaby@suse.cz> wrote:
> > 
> >> Hello,
> >>
> >> don't you remember by a chance the reason for this test in __tty_hangup:
> >>   if (filp->f_op->write != tty_write)
> >>
> >> The logic there is not to HUP processes that have this tty open via
> >> /dev/console.
> > 
> > Because if you hang up the console the machine crashes ?
> >
> > At least that's what used to happen.
> 
> It does not crash anymore. However the system (systemd more precisely)
> is confused a bit (well, a huge). So I suppose the test has its meaning.
> 
> The whole exercise was about how to fix the userspace issue introduced
> by the added infinite timeout.

> I think the proper solution here is just not to call vhangup in
> userspace for the device which is /dev/console. It never worked anyway.
> Because the HUP signal was never sent and it always timed out.

Perhaps the "infinite timeout" should be reverted, then? It sounds
like a regression...



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
