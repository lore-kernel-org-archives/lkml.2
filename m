Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0FXPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:07:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0FXPHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:07:37 -0400
Date: Fri, 25 Jun 2010 01:07:06 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 24/52] fs: dcache reduce d_parent locking
Message-ID: <20100624150706.GF10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030729.395195069@suse.de>
 <1277369062.1875.928.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277369062.1875.928.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 10:44:22AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> > Use RCU property of dcache to simplify locking in some places where we
> > take d_parent and d_lock.
> > 
> > Comment: don't need rcu_deref because we take the spinlock and recheck it.
> 
> But does the LOCK barrier imply a DATA DEPENDENCY barrier? (It does on
> x86, and the compiler barrier implied by spin_lock() suffices to replace
> ACCESS_ONCE()).

Well the dependency we care about is from loading the parent pointer
to acquiring its spinlock. But we can't possibly have stale data given
to the spin lock operation itself because it is a RMW.

