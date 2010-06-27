Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0F0DHG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 23:07:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57977 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754352Ab0F0DHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 23:07:00 -0400
Date: Sat, 26 Jun 2010 23:06:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <640e9920@gmail.com>,
       Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       <linux-pci@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <323677.5124.qm@web180313.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1006262254060.28065-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010, David Brownell wrote:

> > > basically, I think the notion of counting wakeup
> > > events seems dubious on common hardware, ...
> > I disagree. 
> > 
> > The "counting" isn't meant as a way of keeping track of the absolute
> > number of these events.  It's more like a technique  for seeing how many
> > remain outstanding at any time.
> 
> But if you can't count them with any
> reliability, you can't know *that* either... so
> there must be a a problem with that model.

Why do you say we can't count them with any reliability?

Or, let's put it another way: You'll grant that we can count _some_ set
of events.  Given that, you'll probably also grant that we can keep
track of their number reliably enough to know when the count has
dropped to 0.  Then this becomes a question of how closely does the set
of events we can count match up with the set of "wakeup" events?

In fact, it doesn't have to match up perfectly.  There may be a few
wakeup events where we don't really care if one of them occurs while
the system is going to sleep and the sleep isn't delayed or aborted.  
(Although by definition this is never _supposed_ to happen, there may
be cases where we just don't care.)  The other possibility is
relatively harmless too: an event that wouldn't wake up a sleeping
system nevertheless can delay or abort a suspend-in-progress.

So overall I don't see a problem with this.  Do you have any especially
pernicious failure modes in mind?

Alan Stern

