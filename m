Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1HXX5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:57:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53821 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1HXX5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:57:05 -0400
Date: Wed, 24 Aug 2011 16:57:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Boyer <jwboyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110824235702.GC2417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818215540.GA14098@linux.vnet.ibm.com>
 <20110824224454.GB26417@somewhere.redhat.com>
 <20110824231255.GZ2417@linux.vnet.ibm.com>
 <20110824233422.GD26417@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824233422.GD26417@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:34:24AM +0200, Frederic Weisbecker wrote:
> On Wed, Aug 24, 2011 at 04:12:55PM -0700, Paul E. McKenney wrote:
> > Indeed, this was a bogus patch.  The version I posted on the -rcu git
> > tree a few days ago has the correct "rdp->qs_pending = 0".  I thought
> > that I had chased down all the bogus copies, but obviously not.  :-(
> 
> Ah ok.
> 
> > > Should it perhaps set it to 1 only if we have rnp->gpnum > rnp->completed ?
> > 
> > I would rather keep it simple.  If rnp->gpnum > rnp->completed, then
> > the newly onlined CPU will notice and adjust appropriately soon enough.
> 
> Ah, just to ensure I understood well is that because rcu_pending() (called
> from tick) would detect rnp->gpnum != rdp->gpnum and thus trigger the softirq
> that notes the new gpnum and toggles  qs_pending?

Yep, that is the theory, anyway.  ;-)

							Thanx, Paul

> > > >  			rdp->passed_quiesc_completed = rnp->completed - 1;
> > > >  		}
> > > >  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
