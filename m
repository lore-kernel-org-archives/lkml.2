Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2DNFnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:43:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45383 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751828Ab2DNFnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:43:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/XbiR8dI7XDoEPmniUm+nSmLrMFiJJGbPJa1kDnZ
	V80GqOZtITJegI
Message-ID: <1334382175.5561.49.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Date: Sat, 14 Apr 2012 07:42:55 +0200
In-Reply-To: <20120413184228.GC2402@linux.vnet.ibm.com>
References: <20120315175933.GB8705@sgi.com>
	 <1331882861.11010.13.camel@marge.simpson.net>
	 <1331885384.11010.15.camel@marge.simpson.net>
	 <1331887535.11010.18.camel@marge.simpson.net>
	 <20120316172850.GC31290@sgi.com>
	 <1332430533.11517.75.camel@marge.simpson.net>
	 <20120322202418.GA8569@sgi.com>
	 <1332478086.5721.17.camel@marge.simpson.net>
	 <20120323192335.GZ2450@linux.vnet.ibm.com>
	 <1334142276.5826.22.camel@marge.simpson.net>
	 <20120413184228.GC2402@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 11:42 -0700, Paul E. McKenney wrote: 
> On Wed, Apr 11, 2012 at 01:04:36PM +0200, Mike Galbraith wrote:

> > Hi Paul (and Dimitri),
> > 
> > Just got back to this.  I changed the patch around to check for a
> > hotplug event in force_qs_rnp(), and should that happen, process any
> > freshly added CPUs immediately rather than tell the caller to restart
> > from scratch.  The rest of the delta is cosmetic, and there should be
> > zero performance change.
> > 
> > Does this change address any of your concerns? 
> 
> Apologies for being slow to respond...

Hey, I'm grateful for any time you have to share.

> One of my main concerns was present in my original patch:  I now believe
> that a given grace period needs to operate on the set of rcu_node
> structures (and CPUs) that were present at the beginning of the grace
> period.  Otherwise, things could get confused if a given CPU participated
> in an later force_quiescent_state() state, but not in an earlier one.
> 
> I believe that the correct way to handle this is to squirrel the maximum
> number of CPUs away in the rcu_state structure at the beginning of each
> grace period and use that as the limit.
> 
> I call out a few more below.

Read it, got it.  The last node being partially initialized still causes
some head scratching, I'll ponder that more between explosions.  Thanks.

-Mike

