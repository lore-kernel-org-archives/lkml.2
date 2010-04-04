Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0DDN1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 09:27:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50041 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753255Ab0DDN1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 09:27:47 -0400
Date: Sun, 4 Apr 2010 15:27:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100404132734.GB1346@ucw.cz>
References: <20100317061952.GA19789@core.coreip.homeip.net> <20100319000043.GC12017@khazad-dum.debian.net> <20100319000931.GA5671@core.coreip.homeip.net> <20100319160641.GC16743@khazad-dum.debian.net> <20100319180314.GB12143@core.coreip.homeip.net> <20100320025329.GA2468@khazad-dum.debian.net> <20100322045910.GE31621@core.coreip.homeip.net> <20100401133454.GA1291@ucw.cz> <20100401154212.GA7900@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401154212.GA7900@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If userspace disables sysrq during normal operation, that makes it
> > useless.
> > 
> > If normal user could do that, that's a security problem.
> > 
> 
> Yes, and...? This patch does not change the way one enables, disables,
> intercepts, etc. SysRq and SAK compared to how it was handled when SysRq
> was part of keyboard _input handler_. The only thisng this patch does is
> moving the code into a _separate_ input handler.

Yep, that was just a note.

> > > The problem is that device does not know what SysRq and especially SAK are.
> > > User can reassign key codes and key symbols easily.
> > 
> > That was not case in original implementation; it had hardcoded keymap.
> 
> The earth was also flat back then and the only keyboard was AT one. SAK
> was always part of keymap so could be reassinged at any time.

Well, there are two SAKs.

One SAK -- in keymap, is remappable and always was.

Second, sysrq-saK -- is (was?) hardcoded and not affected by
keymap. Please don't change that.

> > > I don't think we had any issues like this since 2.5 so I would not worry
> > > about userspace too much. If anything we just need to review what stuff
> > > we run as root (we do that anyway, right?).
> > 
> > Hehe. If X can break sysrq, that's both X and sysrq problem.
> 
> Root can disable Sysrq... News at 11.

Root *does* disable sysrq is indeed news ... and problem.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
