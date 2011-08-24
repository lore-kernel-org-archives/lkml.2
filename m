Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1HXXea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:34:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58699 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1HXXe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:34:29 -0400
Date: Thu, 25 Aug 2011 01:34:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Boyer <jwboyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110824233422.GD26417@somewhere.redhat.com>
References: <20110817224916.GO2419@linux.vnet.ibm.com>
 <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818215540.GA14098@linux.vnet.ibm.com>
 <20110824224454.GB26417@somewhere.redhat.com>
 <20110824231255.GZ2417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824231255.GZ2417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 04:12:55PM -0700, Paul E. McKenney wrote:
> Indeed, this was a bogus patch.  The version I posted on the -rcu git
> tree a few days ago has the correct "rdp->qs_pending = 0".  I thought
> that I had chased down all the bogus copies, but obviously not.  :-(

Ah ok.
 
> > Should it perhaps set it to 1 only if we have rnp->gpnum > rnp->completed ?
> 
> I would rather keep it simple.  If rnp->gpnum > rnp->completed, then
> the newly onlined CPU will notice and adjust appropriately soon enough.

Ah, just to ensure I understood well is that because rcu_pending() (called
from tick) would detect rnp->gpnum != rdp->gpnum and thus trigger the softirq
that notes the new gpnum and toggles  qs_pending?

> 							Thanx, Paul
> 
> > >  			rdp->passed_quiesc_completed = rnp->completed - 1;
> > >  		}
> > >  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
