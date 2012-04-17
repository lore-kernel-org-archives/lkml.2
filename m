Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2DQVRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:17:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2DQVRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:17:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sven Joachim <svenjoac@gmx.de>
Subject: Re: kernel panic after suspend/resume (was: Linux 3.4-rc3)
Date: Tue, 17 Apr 2012 23:21:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com> <87pqb6fkji.fsf@turtle.gmx.de> <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
In-Reply-To: <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204172321.41095.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 17, 2012, Linus Torvalds wrote:
> On Tue, Apr 17, 2012 at 8:24 AM, Sven Joachim <svenjoac@gmx.de> wrote:
> >
> > With Linux 3.4-rc3, I'm experiencing crashes after resuming from
> > suspend, not immediately but after a few minutes.  This has happened
> > three times so far, note that 3.4-rc2 worked fine.
> 
> Hmm. Looks like "global_clock_event->event_handler" is NULL. Which
> doesn't make any sense what-so-ever, but clearly it is.
> 
>  Added Ingo and Thomas to the cc, since that's a very x86
> timer-looking thing. And Rafael since it's about suspend/resume. I do
> wonder if it's some odd memory corruption due to a wild pointer. Of
> course, if it's somewhat repeatable, that's some *seriously* odd
> corruption, though. So that sounds unlikely too - but that
> global_clock_event thing looks odd.
> 
> Oh: guys, one thing to look at is that "lapic_cal_handler" thing.
> Weren't there some changes to timer calibration wrt SMP lately? Not in
> -rc3, but we had some calibrate_delay() changes - skipping them on
> other CPU's when the TSC was reliable, and irq disable things.
> 
> Maybe the calibration at resume now does something different?
> 
> Two questions:
> 
>  - if it is reasonably repeatable, can you try to bisect it? There's
> just under 400 commits in between rc2 and rc3, and you don't really
> need to do a full bisect, but if you do just four bisections, it
> should narrow it down to just 25 commits or so.
> 
>  - how sure are you that rc2 is fine? I don't see anything suspicious
> in this area since rc2, so I would ask you to really test it very well
> to make sure it really was introduced after rc2.
> 
> Thomas, Ingo, Rafael - any ideas?

Well, commit fa4da365bc7772c kind of looks like it might be the source of
this trouble.  Sven, can you try to revert it, please?

Rafael
