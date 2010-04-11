Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0DKPHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 11:07:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032Ab0DKPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 11:07:30 -0400
Date: Sun, 11 Apr 2010 17:07:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernie Thompson <bernie@plugable.com>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: udlfb -- staging version does not work, external does
Message-ID: <20100411150718.GA1401@ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz> <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks for the bug report!

You are welcome :-).

> > I tried getting udlfb to work in 2.6.34-rc*, and could not.
> 
> What CPU arch are you on, and is it 32 or 64?

32bit Intel Core Duo.

> > 1) it hates vga console. If text-mode vga console is used (not
> > vesafb), system dies immeditaly during insmod or during boot if
> > monolithic kernel is used.
> 
> It is a kernel oops? Where does the crash happen?  Can you email any
> udlfb-specific output in logs (especially /var/log/kern.log)?

It just locks :-(.

> > 2) it does not display anything. With vesafb, it will not lockup the
> > system, and /dev/fb1 is created... Unfortunately, all I get is green
> > screen.
> 
> The green screen means udlfb has initialized device and started
> rendering.   So what this likely means is everything is fine -- just
> fbcon has matched against fb0, which is why it's not using the fb1
> udlfb screen.

Yep, but I still should be able to produce output on it.

> > (I tried testing with cat /bin/bash > /dev/fb1 and cat /dev/fb0 >
> > /dev/fb1).
> 
> I don't think redirects like that will work.  The fbcon module loads
> against one fb, and can only be switch with utilities like "fbset"

IMO they should work. First one should fill the screen with ~random
noise, and second should copy graphical representation on fb0 to
fb1. If they have same resolution and color depth, I should be looking
at copy of my console...

(And it does work with this driver:

> > So I tried
> >
> >    Roberto De Ioris roberto at unbit.it
> >    Wed Jun 10 08:00:07 PDT 2009 

).

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
