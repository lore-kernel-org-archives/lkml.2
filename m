Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0HBMMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:12:53 -0400
Received: from thunk.org ([69.25.196.29]:55061 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0HBMMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:12:51 -0400
Date: Mon, 2 Aug 2010 08:12:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, peterz@infradead.org,
        swetland@google.com, linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802121241.GE27573@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	James Bottomley <James.Bottomley@suse.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	peterz@infradead.org, swetland@google.com,
	linux-kernel@vger.kernel.org, florian@mickler.org,
	linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
	alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@infradead.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801204026.GH31324@thunk.org>
 <1280705444.25620.62.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280705444.25620.62.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 06:30:44PM -0500, James Bottomley wrote:
> On Sun, 2010-08-01 at 16:40 -0400, Ted Ts'o wrote:
> > This brings me back to a major problem I have with the pm_qos approach
> > to power management.  It assumes that applications know best, and that
> > they should be free to tell pm_qos subsystem whether they need 0ms
> > latency for wireless.
> 
> Um, so this behaviour is isomorphic to the suspend block case for the
> applications.  I think everyone agrees that suspend block isn't optimal,
> but we were prepared to use it as a starting point given the lack of
> enthusiasm in android for the more innovative approaches that have been
> proposed.

Um, yes, that was deliberate.  For some people I think people have
gotten hypersensitive about suspend blockers, to the point that I
think sometimes minds get closed automatically to say that suspend
blockers or their requirements are evil/not really a requirement, so I
decided to use another example other than scheduler control in the
hopes of pointing out (a) there is a more general problem, and (b)
application knows best is not enough, and (c) Arjan's claim that we
don't need to do anything because all applications should be written
to be "power optimized" and it shouldn't matter whether they are
connected to the AC mains or not is a vast oversimplification.

> That's why you present the user with choices and report on the outcomes.
> At the end of the day the choice becomes binary: if the mobile optimised
> browser burns you battery on the power meter, users will either
> uninstall and move on to the next browser or deny the current browser
> the ability to block suspend.

Or they may decide to drop the device which has much worse battery
lifetime in favor of the hardware that seems to do a much better job
of controlling power overall... which is why if the Nokia folks want
to claim that suspend blockers are no good, it's probably not going to
change what ships with Android, and may be better power management
strategy win.  :-)

> Right, but this comes back to the axes of control.  They have to be
> presented to the user in a simple but meaningful manner.

In the general case, at least for today, I think it's useful if
applications are told, "you are on AC mains", "you are on cell phone
battery", "you are on a laptop battery".  And from a user's
perspective, I suspect if you are wanting something simple but
meaningful, it's probably a single linear scale ranging between
"performance optimized" and "power optimized", with maybe 1-3
points in between.

Advanced users will want a much finer level of control, though --- I
can imagine having a number of different sliders that control the
tradeoff between power vs. performance on a number of different
scales: networking, GPS performance, scheduler control, schreen
brightness, etc.

Android phones have a very simplified version of this widget, which
allows you to toggle GPS on/off, bluetooth on/off, etc.  And the GPS
toggle is a good example of what I'm talking about.  If you disable
the GPS, then even if the application wants to use GPS, tough luck; it
will have to settle for the less precise cell tower triangulation
method.  Again, it's the _user_ who gets the final say, not the
application --- and that's as it should be.

						- Ted
