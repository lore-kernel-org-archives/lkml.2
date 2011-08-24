Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HXSRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1HXSRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:17:02 -0400
Date: Wed, 24 Aug 2011 14:16:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110824181643.GP2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <20110824170411.GI2417@linux.vnet.ibm.com>
 <20110824174456.GN2067@redhat.com>
 <1314208261.6925.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314208261.6925.51.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 07:51:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-24 at 13:44 -0400, Don Zickus wrote:
> > > > +   rcu_read_lock();
> > > > +   a = rcu_dereference_raw(*ap);
> > > 
> > > The reason for rcu_dereference_raw() is to prevent lockdep from choking
> > > due to being called from an NMI handler, correct?  If so, please add a
> > > comment to this effect on this and similar uses.
> > 
> > That sounds right.  But honestly, I just copied what notifier_call_chain
> > had.  Regardless, I will make sure to document that in my next version.
> > Thanks! 
> 
> Not quite right, nmi_enter() does lockdep_disable() and makes
> lock_is_held() return always true.
> 
> I think this (and the other sites) could do with rcu_dereference_check(,
> lockdep_is_held(&desc->lock)); not that it wouldn't be anything but
> documentation since the actual test isn't working from NMI context but I
> do think its worth it for that alone.

So you want me to remove the _raw part of the dereference?  I can test
that with lockdep enabled to verify things don't go splat.

Cheers,
Don
