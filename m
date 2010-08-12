Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767Ab0HLSke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:40:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45564 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0HLSkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:40:33 -0400
Date: Thu, 12 Aug 2010 11:38:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100812183851.GH2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100809181638.GI3026@linux.vnet.ibm.com>
 <20100809201822.441905f7@lxorguk.ukuu.org.uk>
 <20100810044541.GA2817@linux.vnet.ibm.com>
 <20100810093849.138e2318@lxorguk.ukuu.org.uk>
 <20100811004223.GH2379@linux.vnet.ibm.com>
 <AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
 <20100811221258.GI2516@linux.vnet.ibm.com>
 <AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
 <20100812161935.GC2524@linux.vnet.ibm.com>
 <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 08:52:22PM +0300, Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 7:19 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:

[ . . . ]  (For now, anyway. I might respond to the rest later.)

> >> My point is that suspend-blockers don't magically reduce power usage,
> >> just like dynamic PM, it depends on what user-space actually does. You
> >> made it look as it *always* reached better energy efficiency.
> >
> > I do?  Really???  Exactly what did I say to give you that impression?
> 
> Here's your point 4 again:
> 
> > >> > 4.      Suspend generally forces devices to go into their low-power
> > >> >        states immediately.  In contrast, idle generally leaves unused
> > >> >        devices at full power, relying on timers to shut down these
> > >> >        devices.  Idle thus has shorter average wakeup latencies, but
> > >> >        worse energy efficiency.
> 
> Remove "but worse energy efficiency" and I think that point would be
> correct,

Now this is much more like it!!!  Thank you!!!

You are quite correct, my last sentence does in fact assume that suspend
will always have lower power consumption than does the deepest idle state.
This of course sentence must be fixed.  How about the following, which
makes this assumption explicit, and adds words ("often", "might") that
indicate that one's mileage might vary?

	4.	Suspend generally forces devices to go into their
		low-power states immediately.  In contrast, idle generally
		leaves unused devices at full power, relying on timers
		to shut down these devices.  Idle thus often has shorter
		average wakeup latencies, but on systems where suspend
		can use deeper sleep states than can idle, idle might
		have worse energy efficiency.

>          albeit it's not really an argument in favor of opportunistic
> suspend.

It never was intended to be an argument of any kind.  It was instead
supposed to help clarify the difference between idle and suspend, in
response to people stating that there is no difference between suspend
and idle.  If my mistake in the wording of the last sentence made you
think otherwise, please accept my apologies.

[ . . . ]  (For now, anyway. I might respond to the rest later.)

							Thanx, Paul
