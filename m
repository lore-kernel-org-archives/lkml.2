Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2F0HXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:23:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48060 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753634Ab2F0HXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:23:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/4oG5lzcH44PSmz0NiGRyo9uVCGIHSh4C/1TakT1
	yagOw4Zdugwi2s
Message-ID: <1340781811.10881.70.camel@marge.simpson.net>
Subject: Re: Attaching a process to cgroups
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Alexey Vlasov <renton@renton.name>, linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 09:23:31 +0200
In-Reply-To: <20120626180620.GK2397@linux.vnet.ibm.com>
References: <20120619185856.GC31797@beaver>
	 <1340195298.15707.3.camel@marge.simpson.net>
	 <20120621075428.GE31797@beaver>
	 <1340266982.29752.37.camel@marge.simpson.net>
	 <20120626180620.GK2397@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 11:06 -0700, Paul E. McKenney wrote: 
> On Thu, Jun 21, 2012 at 10:23:02AM +0200, Mike Galbraith wrote:
> > On Thu, 2012-06-21 at 11:54 +0400, Alexey Vlasov wrote: 
> > > On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> > > > 
> > > > kernel/cgroup.c::cgroup_attach_task()
> > > > {
> > > > ...
> > > > 	synchronize_rcu();
> > > > ...
> > > > }
> > > 
> > > So nothing can be done here? (I mean if only I knew how to fix it I
> > > wouldn't ask about it ;)
> > 
> > Sure, kill the obnoxious thing, it's sitting right in the middle of the
> > userspace interface.
> > 
> > I banged on it a while back (wrt explosive android patches), extracted
> > RCU from the userspace interface.  It seemed to work great, much faster,
> > couldn't make it explode.  I wouldn't bet anything I wasn't willing to
> > immediately part with that the result was really really safe though ;-)
> 
> Or replace it with synchronize_rcu_expedited().  You can "get lucky"
> for quite some time removing synchronize_rcu() calls!

s/remove/replace, but yup.  A company that wanted to use the android
patches plus my tinkering showed a fix they needed on top to close a
race discovered in their testing.  So yeah, even when all seems fine,
extracting synchronize_rcu() may expose evils you couldn't encounter
before, and didn't happen to encounter afterward.

-Mike

