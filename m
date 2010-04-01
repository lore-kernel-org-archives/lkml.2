Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0DANsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:48:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48056 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755817Ab0DANsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:48:16 -0400
Date: Thu, 1 Apr 2010 15:34:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100401133454.GA1291@ucw.cz>
References: <20100317061952.GA19789@core.coreip.homeip.net> <20100319000043.GC12017@khazad-dum.debian.net> <20100319000931.GA5671@core.coreip.homeip.net> <20100319160641.GC16743@khazad-dum.debian.net> <20100319180314.GB12143@core.coreip.homeip.net> <20100320025329.GA2468@khazad-dum.debian.net> <20100322045910.GE31621@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322045910.GE31621@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > root isn't really a problem from a security PoV (well, maybe it is if the
> > operation isn't constrained by capabilities).  SAK can't protect you from
> > root.
> > 
> > _Normal_ userspace behaviour running a root process is a problem if it
> > blocks these handles, though, both for SAK and regular SysRQ.  I have lost
> > count of how many times SysRQ+SUB delivered me from filesystem corruption
> > and very annoying problems, both at home and at work.
> > 
> > We are sort of trusting userspace to not break the one way out from severly
> > hung systems while doing its normal day-to-day operations (as opposed to
> > deliberately disabling SysRQ or remapping SAK, etc).

If userspace disables sysrq during normal operation, that makes it
useless.

If normal user could do that, that's a security problem.

> > > That would require moving "these things", including their state
> > > machines, into input core otherwise it would not know what events can be
> > > trappable and which should be passed through. Or we should get rid of
> > > EVIOCGRAB.
> > 
> > Maybe we can add a flags field to input devices and input handlers, to be
> > able to have the core behave differently when needed, without moving
> > everything into the input core?  Would that work, or would it need too much
> > churn in the core?
> 
> The problem is that device does not know what SysRq and especially SAK are.
> User can reassign key codes and key symbols easily.

That was not case in original implementation; it had hardcoded keymap.

> I don't think we had any issues like this since 2.5 so I would not worry
> about userspace too much. If anything we just need to review what stuff
> we run as root (we do that anyway, right?).

Hehe. If X can break sysrq, that's both X and sysrq problem.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
