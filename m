Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0HAFsX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 01:48:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39838 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0HAFsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 01:48:22 -0400
Date: Sat, 31 Jul 2010 22:48:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801054816.GI2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100731215214.2543c07e@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 09:52:14PM -0700, Arjan van de Ven wrote:
> On Sat, 31 Jul 2010 10:58:42 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > o	"Power-aware application" are applications that are permitted
> > 	to acquire suspend blockers on Android.  Verion 8 of the
> > 	suspend-blocker patch seems to use group permissions to
> > determine which applications are classified as power aware.
> > 
> > 	More generally, power-aware applications seem to be those that
> > 	have permission to exert some control over the system's
> > 	power state.
> 
> I don't like the term "Power aware application". An application is well
> behaved or it isn't. "aware" has nothing to do with it.

Applications are often complex enough to be aware of some things, naive
about others, well behaved in some ways, and ill-behaved in others.
This has been the case for some decades now, so it should not come as
a surprise.

I am of course open to suggestions for alternatives to the term "power
aware application", but most definitely not to obfuscating the difference
between power awareness (or whatever name one wishes to call it) and
the overall quality of the application, whatever "quality" might mean
in a given context.

> > REQUIREMENTS
> > 
> > o	Reduce the system's power consumption in order to (1) extend
> > 	battery life and (2) preserve state until AC power can be
> > obtained.
> 
> AC power is not relevant in discussions around power: Applications MUST
> behave well, AC or DC both. Just ask any data center operator on how
> much they run on DC and if he cares about power consumption.
> Conversely, most mobile usages (both phone, tablet or netbook) are "DC
> only"....

Alan Stern suggested "external power" in place of "AC", which makes sense
to me.  His suggestion does have the virtue of rendering irrelevant the
difference between an AC adapter and a DC adapter for use in automobiles.

And in my experience, people working with mobile devices care -much- more
about energy efficiency than do data-center operators.

> > o	It is necessary to be able to use power-naive applications.
> > 	Many of these applications were designed for use in PC
> > platforms where power consumption has historically not been of great
> > 	concern, due to either (1) the availability of AC power or (2)
> > 	relatively undemanding laptop battery-lifetime expectations.
> > The system must be capable of running these power-naive applications
> > 	without requiring that these applications be modified, and
> > must be capable of reasonable power efficiency even when power-naive
> > 	applications are available.
> 
> I don't buy this argument as is.
> 
> I do buy that there are many sloppy applications; mostly written quickly
> for <appstore of the month>.  But most if not all of these are written
> for the device in question (at least that is true for Apple and Android)

Making an application power-aware or power-naive is a choice, similar to
the choice between making an application SMP-aware or single-threaded.
This sort of choice is completely orthogonal to ill-behavior, sloppiness,
or whatever the pejorative of the day might be.

The choice between power-aware and power-naive will depend on who is
available to do the programming and how valuable power-awareness is
for the application in question.  Given that people who program PC-class
applications are much more common than are people who program with
energy efficiency in mind, the power-naive choice will be attractive
in many cases.

Or do you have some other interpretation of what the Android guys are
looking for?

							Thanx, Paul
