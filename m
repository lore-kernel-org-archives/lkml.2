Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab0FEXhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:37:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55668 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933664Ab0FEXhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:37:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: suspend blockers & Android integration
Date: Sun, 6 Jun 2010 01:39:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <20100603193045.GA7188@elte.hu> <alpine.LFD.2.00.1006052348200.2933@localhost.localdomain> <AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com>
In-Reply-To: <AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006060139.03585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> > On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> >> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> >> > B1;2005;0cOn Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
...
> > So taking your example:
> >
> > Event happens and gets delivered to the framework
> >
> >      framework selects A because it is in the foreground
> >
> >      if (A is frozen)
> >         unfreeze(A)
> >
> >      deliver_event_to(A)
> >
> > It's that simple.
> >
> 
> That is too simple. You also have to prevent A from being frozen while
> it is processing the event or the result would be the same as if it
> was frozen beforehand.

Well, the freezing of the "untrusted" part of user space needs to be triggered
somehow in the first place.  Whatever mechanism is used for that, there should
be a way to tell it to not to freeze the "untrusted" part of user space for a
while.  Yes, it is similar to wakelocks, but I think it can be implemented
entirely in user space.

So, in general, the "trusted" app that needs an "untrusted" one to handle stuff
will take a "freeze lock" to prevent the power manager from freezing the
"untrusted" part of user space (that will also cause it to thaw these tasks if
they are frozen at the moment) and will release the "freeze lock" when it's
done with its job.  You can use timeouts and whatever you like with that and
the kernel doesn't have to participate in that (except for carrying out the
low-level freezing and thawing of the "untrusted" tasks at the power manager's
request).

Rafael
