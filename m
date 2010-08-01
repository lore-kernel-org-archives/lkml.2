Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0HAXaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:30:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:34786 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0HAXav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:30:51 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: James Bottomley <James.Bottomley@suse.de>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, peterz@infradead.org,
        swetland@google.com, linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20100801204026.GH31324@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	 <20100731215214.2543c07e@infradead.org>
	 <20100801054816.GI2470@linux.vnet.ibm.com>
	 <20100731230101.7cc1d8c7@infradead.org>
	 <20100801191228.GL2470@linux.vnet.ibm.com>
	 <20100801204026.GH31324@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 18:30:44 -0500
Message-ID: <1280705444.25620.62.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-01 at 16:40 -0400, Ted Ts'o wrote:
> This brings me back to a major problem I have with the pm_qos approach
> to power management.  It assumes that applications know best, and that
> they should be free to tell pm_qos subsystem whether they need 0ms
> latency for wireless.

Um, so this behaviour is isomorphic to the suspend block case for the
applications.  I think everyone agrees that suspend block isn't optimal,
but we were prepared to use it as a starting point given the lack of
enthusiasm in android for the more innovative approaches that have been
proposed.

>   Right now, I can't even query the pm_qos
> subsystem to see which application is responsible for keeping the
> wireless on 100% of the time!

That's hardly a fair criticism: this is easily fixable but the people
looking into it have other calls on their time. At least you got some of
the basic problems (like init from atomic context and sort efficiency)
fixed this time around.  If some large organisation actually cared
enough to contribute code, we might be moving faster ....

>   And even if I could find out, maybe
> some power management framework should be allowed to give a override
> to the application's wishes.  OK, maybe the Opera web browser is
> requesting the very best wireless QOS because it wants to beat Chrome
> on some silly potato benchmark --- well, it's ***stupid*** to say that
> my power management should be a one-size-fits all because applications
> should be always as power efficient as possible whether they are
> connected to AC mains or I have a 800mWh cell phone battery.  Worse
> yet, it's stupid to say that the application should have the last
> word.  Darn it, *I* own the mobile device, and I (or my proxy, which
> might be the Android OS, or some power manage daemon) should be able
> to say, "I don't care what the application claimed it wanted for power
> QOS --- it's not getting more than 100ms wireless latency, and that's
> final."

That's why you present the user with choices and report on the outcomes.
At the end of the day the choice becomes binary: if the mobile optimised
browser burns you battery on the power meter, users will either
uninstall and move on to the next browser or deny the current browser
the ability to block suspend.

> And note that this is something that might even change over time, or
> depending on circumstances.  Maybe normally I might be willing to let
> the application be profilgate with power, so that web pages render a
> bit faster than they might otherwise --- but if I'm on an American
> Airlines flight which has retrofitted its power jacks to use an AC
> plug, and I only have a DC adaptor, and my laptop batteries are worn
> out and only have half their endurance as they used to, I might want
> to use a more stringent pm_qos than I might otherwise normally allow.

Right, but this comes back to the axes of control.  They have to be
presented to the user in a simple but meaningful manner.

James


