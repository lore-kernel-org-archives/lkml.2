Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0KYU2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 15:28:06 -0500
Received: from nm11.bullet.mail.ac4.yahoo.com ([98.139.52.208]:41556 "HELO
	nm11.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751801Ab0KYU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 15:28:04 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 15:28:04 EST
X-Yahoo-Newman-Id: 149879.99103.bm@omp1015.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=aq4vOOIlLuryd4JSScabidIXJcnYjgSgxSH7lnTSKs8eCYVrK2SOQhIIa2ewqwZ3wSqXAeZ4hvbU91GAE1ZOkqN1/pVLeq4SHBqWGm52rYjKL7kyz2Xtp60dMfzNcg8DWSqf0wH2DQiFNPzUQHuIFJmCCKzW/4JzthvdqGwFvX8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Q0mx7KIVM1mqXSlYxOZzB8eL5AgvXNYs3gQX2.JHHSsdXGU
 pBefui4Nb.4E.Gz5_hxmQVO.XcG6fBMg7WCkAsurF1cNxTMU1864kywqz8Qh
 QZqR_I25J4DJKKVN.HgUyH8jhOkP4sj0mdovn.96yiqOdLRAsJOsqY44PqIq
 InhIgitX2GAFFIH97TqgV13s2K7oENzdrNj294_rjO9noAeWoDdrYc__e4vx
 zJPCC6byUud0TXa9zfMhEhjLWpYZ3Wqyn72l2aTAPrhnTNWBrZkviWbzmYNp
 RrdBk6GgDRUVHobkgPS_fFf7lfDNB7a_3oaxKTVmxs.AmffP9RJsrDkDMzna
 2AYze2brQmIaVTU91gRl1mswx05jzcz1zrsmJY.bE
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
From: David Brownell <david-b@pacbell.net>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: MugdhaKamoolkar <mugdha@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        BenoitCousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        HariKanigeri <h-kanigeri2@ti.com>, SumanAnna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <AANLkTinQdNC0XaOqNyDbdYE6ZcP0QyzpN492j=Kovuea@mail.gmail.com>
References: <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com>
	 <536589.12568.qm@web180310.mail.gq1.yahoo.com>
	 <AANLkTinQdNC0XaOqNyDbdYE6ZcP0QyzpN492j=Kovuea@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 25 Nov 2010 12:22:28 -0800
Message-ID: <1290716548.2529.136.camel@helium>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 08:40 +0200, Ohad Ben-Cohen wrote:
> On Thu, Nov 25, 2010 at 5:59 AM, David Brownell <david-b@pacbell.net> wrote:
> > My rule of thumb is that nothing is "generic"
> > until at least three whatever-it-is instances
> > plug in to it.  Sometimes this is called
> > the "Rule of Three".
> >
> > Other than OMAP, what's providing hardware
> > spinlocks that plug into this framework?
> 
> We are not aware of any.

So there's no strong reason to think this is
actually "ggeneric".  Function names no longer
specify OMAP, but without other hardware under
the interface, calling it "generic" reflects
more optimism than reality.  (That was the
implication of my observations...)

To find other hardware spinlocks, you might be
able to look at fault tolerant multiprocessors.
Ages ago I worked with one of those, where any
spinlock failures integrated with CPU/OS fault
detection; HW cwould yank (checkpointed) CPU boards
off the bus so they could be recovered (some
might continue later from checkpoints, etc.)...

> This way platforms [2] can easily plug into the framework anything
> they need to achieve multi-core synchronization. E.g., even in case a
> platform doesn't have dedicated silicon, but still need this
> functionality, it can still plug in an implementation which is based
> on Peterson's shared memory mutual exclusion algorithm 

And maybe also standard Linux spinlocks?

I seem to recall some iterations of the real-time patches doing a lot of
work to generalize spinlocks, since they needed multiple variants.  It
might be worth following in those footsteps.  (Though I'm not sure they
were thinking much about hardware support .

- Dave


