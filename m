Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0FAWCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:02:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317Ab0FAWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:02:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Wed, 2 Jun 2010 00:03:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005312159420.9148-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005312159420.9148-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006020003.58899.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 June 2010, Alan Stern wrote:
> On Tue, 1 Jun 2010, Neil Brown wrote:
> 
> > > As I said before, we generally can't prevent such things from happening,
> > > because even if we handle the particular race described above, it still is
> > > possible that the event will be "lost" if it arrives just a bit later (eg.
> > > during a suspend-toggle switch).  So the PRE_SUSPEND thing won't really
> > > solve the entire problem while increasing complexity.
> > > 
> > > > My freerunner has a single core so without CONFIG_PREEMPT it may be that
> > > > there is no actual race-window - maybe the PRE_SUSPENDs will all run before a
> > > > soft_irq thread has a chance to finish handling of the interrupt (my
> > > > knowledge of these details is limits).  But on a muilti-core device I think
> > > > there would definitely be a race-window.
> > > 
> > > Yes, there always will be a race window.  The only thing we can do is to
> > > narrow it, but we cannot really close it (at least not on a PC, but I'm not
> > > really sure it can be closed at all).
> > 
> > Well you are the expert so I assume you are right, but I would really like to
> > understand why this is.
> > 
> > I guess that if the event was delivered as an edge-triggered interrupt which
> > the interrupt controller couldn't latch, then it might get lost.  Is that
> > what happens?
> 
> You're barking up the wrong tree.  If I understand correctly, Rafael is
> saying that there's a race involving events which are not _wakeup_
> events.  If a non-wakeup event arrives shortly before a suspend, it can
> have its normal effect.  If it arrives while a suspend is in progress,
> its delivery may be delayed until the system resumes.  And if it
> arrives after the system is fully suspended, it may never be noticed at
> all.
> 
> With wakeup events the problem isn't so bad.  Wakeup events are always
> noticed, and if the system is designed properly they will either abort
> a suspend-in-progress or else cause the system to resume as soon as the
> suspend is complete.  (Linux is not yet properly designed in this
> sense.)
> 
> Or maybe I'm misunderstanding also, and Rafael is saying that there's 
> a race involving events whose meaning changes depending on whether or 
> not the system is asleep.  This is obviously true and clearly 
> unavoidable.

In fact I was referring to both in different places.  That's why what I said
wasn't too clear, sorry about that.

Rafael
