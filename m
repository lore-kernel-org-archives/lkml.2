Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HRVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:01:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab1HRVBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:01:11 -0400
Date: Thu, 18 Aug 2011 14:00:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Boyer <jwboyer@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-Id: <20110818140034.668e8dea.akpm@linux-foundation.org>
In-Reply-To: <20110818183523.GD2325@linux.vnet.ibm.com>
References: <20110809113514.GA27301@somewhere.redhat.com>
	<20110810124528.GC2566@zod.bos.redhat.com>
	<20110814230453.GP2650@linux.vnet.ibm.com>
	<20110815140416.GB2227@zod.bos.redhat.com>
	<20110815152052.GA2389@linux.vnet.ibm.com>
	<20110817223735.GI2227@zod.bos.redhat.com>
	<20110817224916.GO2419@linux.vnet.ibm.com>
	<20110817230219.GJ2227@zod.bos.redhat.com>
	<20110817230641.GA7837@somewhere.redhat.com>
	<20110817231750.GK2227@zod.bos.redhat.com>
	<20110818183523.GD2325@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 11:35:23 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Aug 17, 2011 at 07:17:50PM -0400, Josh Boyer wrote:
> > On Thu, Aug 18, 2011 at 01:06:44AM +0200, Frederic Weisbecker wrote:
> > > On Wed, Aug 17, 2011 at 07:02:19PM -0400, Josh Boyer wrote:
> > > > On Wed, Aug 17, 2011 at 03:49:16PM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Aug 17, 2011 at 06:37:35PM -0400, Josh Boyer wrote:
> > > > > > On Mon, Aug 15, 2011 at 08:20:52AM -0700, Paul E. McKenney wrote:
> > > > > > > On Mon, Aug 15, 2011 at 10:04:17AM -0400, Josh Boyer wrote:
> > > > > > > > > Please see the attached.
> > > > > > > > 
> > > > > > > > Fixed it up quickly to apply on top of -rc2 and it seems to solve the
> > > > > > > > problem nicely.  Thanks for the patch.
> > > > > > > 
> > > > > > > Good to hear!  I guess I should keep it, then.  ;-)
> > > > > > 
> > > > > > Hey Paul, were you going to send this to Linus for -rc3?  I haven't seen
> > > > > > it come across LKML yet.
> > > > > 
> > > > > I might...  But does it qualify as a regression?  That part of the
> > > > > code hasn't changed for some time now.
> > > > 
> > > > It's a fix for a problem that is newly surfaced in 3.1.  A regression,
> > > > likely not since it's been there forever, but new debugging options
> > > > uncovered it.  I'm pretty sure the -rc stage takes fixes even if they
> > > > aren't regressions.
> > > 
> > > Nope, after -rc1 only regressions fixes are taken (most of the time).
> > 
> > Sigh.
> > 
> > Look, either way I'm carrying this patch in Fedora because it fixes
> > a bug that is actually being reported by users (and by abrtd as well).
> > If you both want to wait until 3.2 to actually submit it to Linus,
> > then OK.
> > 
> > Honestly, I'm just glad we actually run with the debug options enabled
> > (which seems to be a rare thing) so bugs like this are actually found.
> > Thanks for the fix.
> 
> I am sorry, but I didn't make the rules!  And I must carry the fix
> longer as well, if that makes you feel any better.
> 

bah, we're not that anal.  The patch fixes a bug and prevents a nasty
warning spew.  Please, send it to Linus.

We appear to be referring to the patch "rcu: Avoid having just-onlined
CPU resched itself when RCU is idle"?  If so, the changelog doesn't
even mention that the patch fixes a scheduling-while-atomic warning and
the changelog fails to refer to the redhat bug report.  These omissions
should be repaired, please.
