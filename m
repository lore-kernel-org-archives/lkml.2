Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab0E1Ebk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:31:40 -0400
Received: from thunk.org ([69.25.196.29]:59846 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab0E1Ebi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:31:38 -0400
Date: Fri, 28 May 2010 00:31:14 -0400
From: tytso@mit.edu
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528043114.GC26177@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux PM <linux-pm@lists.linux-foundation.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
 <20100527220949.GB10602@srcf.ucam.org>
 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
 <20100527223605.GB11364@srcf.ucam.org>
 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:55:46PM +0100, Alan Cox wrote:
> 
> This started because the Android people came to a meeting that was put
> together of various folks to try and sort of the big blockage in getting
> Android and Linux kernels back towards merging.
> 
> I am interested right now in finding a general solution to the Android
> case and the fact it looks very similar to the VM, hard RT, gamer and
> other related problems although we seem to have diverged from that logic.

Keep in mind, though, that a solution which is acceptable for Android
has to include making sure that crappy applications don't cause the
battery to get drained.  There seem to be some people who seem
adamently against this requirement.  From the Android folks'
perspective, this is part of what is required to have an open app
store, as opposed to one where each application has to be carefully
screened and approved ala the Apple iPhone App Store.

Maybe it would be acceptable if there were an easy way THAT A USER AND
NOT A DEVELOPER COULD USE ON A SMART PHONE to find the bad
application, but realistically, it's much better if the solution can
work well even in the face of crappy application.  Having interacted
with application programmers, I can assure you there are a lot of
crappy application programmers out there, and they vastly outnumber us
kernel developers.  (See as exhibit A all of the application programs
who refuse to use fsync, even though it's going to wipe them out on
all new modern file systems, including btrfs.)

We need to agree on the requirements up front, because otherwise this
is going to be a waste of everyone's time.

And if we can't get agreement on requirements, I'd suggest appealing
this whole thing to Linus.  Either he'll agree to the requirements
and/or the existing implementation, in which case we can move on with
our lives, or he'll say no, in which case it will be blately obvious
that it was Linux developer community who rejected the Android
approach, despite a fairly large amount of effort trying to get
something that satisfies *all* of the various LKML developers who have
commented on this patch, and we can continue with Android having
kernel which is different from mainline --- just as many other
embedded companies have patches which are utterly required by their
products, but which have been judged Too Ugly To Live In Mainline ---
and we can also move on and get on with our lives.

						- Ted

P.S.  Keep in mind how this looks from an outsider's perspective; an
embedded manufacturer spends a fairly large amount of time answering
one set of review comments, and a few weeks later, more people pop up,
and make a much deeper set of complaints, and request that the current
implementation be completely thrown out and that someone new be
designed from scratch --- and the new design isn't even going to meet
all of the requirements that the embedded manufacturer thought were
necessary.  Is it any wonder a number of embedded developers have
decided it's Just Too Hard to Work With the LKML?
