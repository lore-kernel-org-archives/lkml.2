Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0FHJKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:10:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0FHJKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:10:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: suspend blockers & Android integration
Date: Tue, 8 Jun 2010 11:11:39 +0200
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
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <201006061555.38526.rjw@sisk.pl> <AANLkTilwE8-9yi6gTI-Cx8etIX1Q6kzKobiIxtSW2Sb9@mail.gmail.com>
In-Reply-To: <AANLkTilwE8-9yi6gTI-Cx8etIX1Q6kzKobiIxtSW2Sb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006081111.39333.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 June 2010, Arve Hjønnevåg wrote:
> 2010/6/6 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Sunday 06 June 2010, Arve Hjønnevåg wrote:
... 
> If individual processes are frozen, we run into problems that we
> cannot run into if we freeze and thaw all processes.

Not individual processes, but the processes that don't use wakelocks in the
Android world all together.  And of course the approach has to be different,
because it's a different design, but I don't think there are any fundamental
issues you can't solve within this approach.

> >> The app that reads this event blocks suspend before reading it. If it was
> >> busy talking to a less trusted app when the event happened it still works
> >> since all apps are running at this point.
> >
> > And how is this different from an approach with cgroup freezing?  Apps that
> > use wakelock within the current framework would use "freeze locks" to prevent
> > the "untrusted" part of user space from being frozen or to thaw it.  Where's
> > the problem, then?
> >
> 
> They will not be able to get wakeup events directly from the kernel.
> If the kernel does not thaw processes when a wakeup event happens, the
> app may never get to the point where it grabs its wakelock.

The apps that use "freeze locks" (or wakelocks) are never frozen, so I don't
think this would be a problem.

Rafael
