Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0HAXQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:16:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:34269 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0HAXQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:16:40 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: James Bottomley <James.Bottomley@suse.de>
To: paulmck@linux.vnet.ibm.com
Cc: Arjan van de Ven <arjan@infradead.org>, peterz@infradead.org,
        swetland@google.com, linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20100801054816.GI2470@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	 <20100731215214.2543c07e@infradead.org>
	 <20100801054816.GI2470@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 18:16:33 -0500
Message-ID: <1280704593.25620.48.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 22:48 -0700, Paul E. McKenney wrote:
> On Sat, Jul 31, 2010 at 09:52:14PM -0700, Arjan van de Ven wrote:
> > On Sat, 31 Jul 2010 10:58:42 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > o	"Power-aware application" are applications that are permitted
> > > 	to acquire suspend blockers on Android.  Verion 8 of the
> > > 	suspend-blocker patch seems to use group permissions to
> > > determine which applications are classified as power aware.
> > > 
> > > 	More generally, power-aware applications seem to be those that
> > > 	have permission to exert some control over the system's
> > > 	power state.
> > 
> > I don't like the term "Power aware application". An application is well
> > behaved or it isn't. "aware" has nothing to do with it.
> 
> Applications are often complex enough to be aware of some things, naive
> about others, well behaved in some ways, and ill-behaved in others.
> This has been the case for some decades now, so it should not come as
> a surprise.
> 
> I am of course open to suggestions for alternatives to the term "power
> aware application", but most definitely not to obfuscating the difference
> between power awareness (or whatever name one wishes to call it) and
> the overall quality of the application, whatever "quality" might mean
> in a given context.

So the reason everyone's having trouble with this definition is that it
actually conflates two separate axes of power management.

There are good and bad applications in the power sense ... burns less vs
burns more.

And there are user mandated vs user optional processes ...
necessary/wanted vs unnecessary/unwanted.

What android actually does is reward well written applications because
they "just work" and they don't have to be power aware at all ...
they're usually event driven and split into the android
provider/consumer model.

Badly written applications that are not suspend block aware get shut
down (by system suspend) when the screen turns off, so they're also
power/suspend unaware.

Applications that want to present the user with a choice in android are
power/suspend aware because the only way they get to present the choice
is via suspend blockers.

The "power problem" always devolves to resolving a set of choices around
a given set of control axes.  The problem is that the set of control
axes isn't unique and doesn't have a well agreed upon selection.  This
makes it hard to make definitive terminology because you have to pick
the set of axes (implicitly or explicitly) before defining terms ...

James


