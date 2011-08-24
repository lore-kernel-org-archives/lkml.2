Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1HXTRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:17:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56267 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab1HXTRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:17:47 -0400
Date: Wed, 24 Aug 2011 12:16:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110824191621.GL2417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <20110824170411.GI2417@linux.vnet.ibm.com>
 <20110824174456.GN2067@redhat.com>
 <1314208261.6925.51.camel@twins>
 <20110824181643.GP2067@redhat.com>
 <1314209995.6925.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314209995.6925.59.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 08:19:54PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-24 at 14:16 -0400, Don Zickus wrote:
> > On Wed, Aug 24, 2011 at 07:51:00PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2011-08-24 at 13:44 -0400, Don Zickus wrote:
> > > > > > +   rcu_read_lock();
> > > > > > +   a = rcu_dereference_raw(*ap);
> > > > > 
> > > > > The reason for rcu_dereference_raw() is to prevent lockdep from choking
> > > > > due to being called from an NMI handler, correct?  If so, please add a
> > > > > comment to this effect on this and similar uses.
> > > > 
> > > > That sounds right.  But honestly, I just copied what notifier_call_chain
> > > > had.  Regardless, I will make sure to document that in my next version.
> > > > Thanks! 
> > > 
> > > Not quite right, nmi_enter() does lockdep_disable() and makes
> > > lock_is_held() return always true.
> > > 
> > > I think this (and the other sites) could do with rcu_dereference_check(,
> > > lockdep_is_held(&desc->lock)); not that it wouldn't be anything but
> > > documentation since the actual test isn't working from NMI context but I
> > > do think its worth it for that alone.
> > 
> > So you want me to remove the _raw part of the dereference?  I can test
> > that with lockdep enabled to verify things don't go splat.
> 
> Ah, right, its never used from the desc->lock context and we always hold
> rcu_read_lock(), so a simple rcu_dereference() should indeed suffice. 

Even better!  ;-)

							Thanx, Paul
