Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab2BBTMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:12:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52619 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647Ab2BBTMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:12:22 -0500
Date: Thu, 2 Feb 2012 11:11:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rcu warnings cause stack overflow
Message-ID: <20120202191116.GF2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201100652.GA2922@osiris.boeblingen.de.ibm.com>
 <20120201151445.GA6731@somewhere.redhat.com>
 <20120202122742.GA2745@osiris.boeblingen.de.ibm.com>
 <20120202145219.GD9071@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202145219.GD9071@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020219-9360-0000-0000-0000030AED48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:52:20PM +0100, Frederic Weisbecker wrote:
> On Thu, Feb 02, 2012 at 01:27:42PM +0100, Heiko Carstens wrote:
> > On Wed, Feb 01, 2012 at 04:14:48PM +0100, Frederic Weisbecker wrote:
> > > > Removing the WARN_ON_ONCE will fix this and, if lockdep is turned on, still
> > > > will find illegal uses. But it won't work for lockdep off configs...
> > > > So we probably want something better than the patch below.
> > > 
> > > Ah ok. Hmm, but why are you using an exception to implement WARN_ON()
> > > in s390? Is it to have a whole new stack for the warning path in order
> > > to avoid stack overflow from the place that called the WARN_ON() ?
> > 
> > The reason was to reduce the code footprint of the WARN_ON() and also
> > be able to print the register contents at the time the warning happened.
> 
> Ah ok, makes sense.

So Frederic should push his anti-recursion patch, then?

							Thanx, Paul

> > All architectures which define __WARN_TAINT implement warnings with
> > exceptions. Currently that are parisc, powerpc, s390 and sh.
> > 
> 

