Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2F0RO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:14:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52528 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab2F0RO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:14:26 -0400
Date: Wed, 27 Jun 2012 10:10:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Alexey Vlasov <renton@renton.name>, linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120627171044.GF2418@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
 <20120621075428.GE31797@beaver>
 <1340266982.29752.37.camel@marge.simpson.net>
 <20120626180620.GK2397@linux.vnet.ibm.com>
 <1340781811.10881.70.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340781811.10881.70.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062717-3534-0000-0000-000009DA947C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 09:23:31AM +0200, Mike Galbraith wrote:
> On Tue, 2012-06-26 at 11:06 -0700, Paul E. McKenney wrote: 
> > On Thu, Jun 21, 2012 at 10:23:02AM +0200, Mike Galbraith wrote:
> > > On Thu, 2012-06-21 at 11:54 +0400, Alexey Vlasov wrote: 
> > > > On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> > > > > 
> > > > > kernel/cgroup.c::cgroup_attach_task()
> > > > > {
> > > > > ...
> > > > > 	synchronize_rcu();
> > > > > ...
> > > > > }
> > > > 
> > > > So nothing can be done here? (I mean if only I knew how to fix it I
> > > > wouldn't ask about it ;)
> > > 
> > > Sure, kill the obnoxious thing, it's sitting right in the middle of the
> > > userspace interface.
> > > 
> > > I banged on it a while back (wrt explosive android patches), extracted
> > > RCU from the userspace interface.  It seemed to work great, much faster,
> > > couldn't make it explode.  I wouldn't bet anything I wasn't willing to
> > > immediately part with that the result was really really safe though ;-)
> > 
> > Or replace it with synchronize_rcu_expedited().  You can "get lucky"
> > for quite some time removing synchronize_rcu() calls!
> 
> s/remove/replace, but yup.  A company that wanted to use the android
> patches plus my tinkering showed a fix they needed on top to close a
> race discovered in their testing.  So yeah, even when all seems fine,
> extracting synchronize_rcu() may expose evils you couldn't encounter
> before, and didn't happen to encounter afterward.

I really did mean "remove".  Removing a synchronize_rcu() does result
in a race, but often an extremely low-probability race.  So you can
remove a synchronize_rcu() and get lucky for a long time, but sooner
or later, something will explode.

							Thanx, Paul

