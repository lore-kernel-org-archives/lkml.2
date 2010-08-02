Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0HBEFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:05:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0HBEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:05:43 -0400
Date: Sun, 1 Aug 2010 21:05:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801210548.23f77ff6@infradead.org>
In-Reply-To: <20100802030304.GU2470@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<20100802030304.GU2470@linux.vnet.ibm.com>
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

On Sun, 1 Aug 2010 20:03:04 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > on application programmers to do the right thing.  That's not to
> > say that we shouldn't give up on trying to influence application
> > programmers --- but relying on that as the only strategy seems to
> > depart from the path of wisdom.
> 
> Unless someone can reliably automate whacking the moles, history is
> not on the side of the mole-whackers.  I won't say that such
> automation is impossible, but only because of all the "impossible"
> things in my lifetime that have turned out to be possible.

we have a few things going for us here though

1) It's easy to programatically detect the problems
  1a) so programmers can detect issues before they ship software,
  unlike the fsync() thing Ted mentions. History is showing this is at
  least relatively successful in open source, but not with Adobe's
  proprietary software such as Flash
2) Users can be made aware of what the bad guys are
3) The business models of many of the mobile apps gives programmers a
   strong incentive to ship well behaving. The moment your first and
   second review of your app read "this app was identified as reducing
   battery life a lot"... your revenues will not go beyond the $1.98..
   ... assuming these first two guys didn't refund their app.

Since we can detect who the bad guys are, we can also automatically
quarantine them for the common cases..... which is good news.


I'm a little worried that this whole "I need to block suspend" is
temporary. Yes today there is silicon from ARM and Intel where suspend
is a heavy operation, yet at the same time it's not all THAT heavy
anymore.... at least on the Intel side it's good enough to use pretty
much all the time (when the screen is off for now, but that's a memory
controller issue more than anything else). I'm pretty sure the ARM guys
will not be far behind.

