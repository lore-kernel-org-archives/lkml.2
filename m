Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0HAXAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:00:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:33377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0HAXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:00:13 -0400
Date: Sun, 1 Aug 2010 16:00:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801160022.43b39fff@infradead.org>
In-Reply-To: <20100801204026.GH31324@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Aug 2010 16:40:26 -0400

> 
> There is however a much bigger point, which is that it's unfortunately
> black and white to talk about applications being "good" and "bad". 

I'll agree with this.

this is extremely situational.. not only where things run, but also,
which part of the application you're talking about. If your application
has 3 features (a $0.99 app store app) it's not too burdensome to make
all 3 features work well for "power on a phone".
If your app has 5000 features... what do you do when 4500 are behaving
well, and the other 500 are somewhat obscure?


> In
> fact, it's a continuing point of concern I have with the whole qos
> approach to power management.  In fact, power is often something that
> needs to trade off against performance.  For example, an application
> could aggressively prefetch e-mail messages or web pages that a user
> _might_ view --- or it could aggressively pre-resolve DNS queries,
> etc, which might make perfect sense when the device is hooked up to AC
> mains, but which I might not want to do on when I only have 800mWh
> worth of battery --- however, if I'm using a laptop with 94,000mWh,
> maybe I'd be happy if the application was a bit more profligate.

this is a very tricky area; because prefetching may well be good for
power as well.... but "it depends"...

getting DNS ahead of time when you're doing other network stuff anyway?
probably a good idea for power, at least when done in moderation. It
might save a modem wakeup two seconds down the road.

excessively prefetching DNS all the time? probably not a good idea for
power.



> This brings me back to a major problem I have with the pm_qos approach
> to power management.  It assumes that applications know best, and that
> they should be free to tell pm_qos subsystem whether they need 0ms
> latency for wireless.  Right now, I can't even query the pm_qos
> subsystem to see which application is responsible for keeping the
> wireless on 100% of the time! 

yes if we allowed apps to do this, we absolutely need
accountability/diagnostics into it.

> And even if I could find out, maybe
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

QOS also should be a request.. and depend on who's asking.
If you run as root with realtime privileges, the kernel should probably
just give you what you asked for.
If you run as UID 500.... there needs to be either a static rlimit kind
of thing, or an intelligent dynamic "clip" to what you ask versus what
the system administrator (or his delegate in the form of some policy
daemon) wants you to do.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
