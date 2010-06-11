Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab0FKBoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:44:10 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41651 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754052Ab0FKBoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:44:09 -0400
Date: Thu, 10 Jun 2010 21:44:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTiniGxuHLeTyxBe7zZxOdYJEkFcl3akR2E_aLDi3@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1006102126220.2585-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Arve Hjønnevåg wrote:

> >> For that to work the wakeup events would have to be reported to the
> >> power manager in a reliable way in the first place. Passing the file
> >> descriptor that the app uses to the power manager does not work for
> >> this, since the app could read the event while the power manager was
> >> not in the poll call and the power manager would never see it.
> >
> > If the app activates a suspend blocker before reading the event, this
> > doesn't matter.  If the app doesn't activate a suspend blocker then it
> > risks being suspended after it has read the event but before it has
> > handled the event.  This is equally true with wakelocks.
> >
> 
> It is not the same. Using a wakelock with a timeout only has a problem
> if the app did not get a change to run and block suspend before the
> timeout expires. With the timeout values we use there is only a
> problem if the system is already unresponsive. If the driver does not
> block suspend but instead a power manager calls select or poll on a
> file descriptor while the app does a blocking read, the power manager
> can easily miss the event and suspend before the app blocks suspend.

You've lost me.  If the power manager is sitting inside a select/poll, 
how can it miss the event (given that the event will make data 
available to be read on one of the descriptors being polled)?

Or put it another way: With wakelocks, if the app doesn't use a suspend
blocker then once it reads the event data and the timed wakelock is
deactivated, there is nothing to prevent the system from immediately
going into opportunistic suspend.  My scheme can fail in the same way.  
Is that what you meant?

> >> The suspend blocker approach is more generally useful since it
> >> supports hardware where suspend is needed. Why this argument is being
> >> ignored is very puzzling.
> >
> > Probably because people doesn't envision system suspend being used for
> > dynamic power management on that kind of hardware.
> >
> 
> I'm not sure what you mean by dynamic power management here (frequency
> of suspends?), but auto suspend is already in use on x86 desktops and
> laptops. Suspend blockers can fix the race with some wakeup events
> there.

You should stress this point more strongly when conversing with others.  
I doubt it will be enough to change anybody's mind, but it can't hurt.  
Indeed, if you propose suspend blockers as a way to fix a lost-wakeup 
bug in existing distributions, rather than as something needed to 
support Android, people might view it more favorably.


There's one question that I don't remember ever seeing answered.  To
which kernel drivers do you intend to add suspend blockers?

Alan Stern

