Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0CXLQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:16:13 -0400
Received: from www.tglx.de ([62.245.132.106]:39218 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab0CXLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:16:11 -0400
Date: Wed, 24 Mar 2010 12:15:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robin Holt <holt@sgi.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
In-Reply-To: <20100324085511.GJ4920@sgi.com>
Message-ID: <alpine.LFD.2.00.1003241214370.3147@localhost.localdomain>
References: <20100324003608.811051277@gulag1.americas.sgi.com> <87wrx2for5.fsf@basil.nowhere.org> <20100324085511.GJ4920@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Robin Holt wrote:
> On Wed, Mar 24, 2010 at 03:16:14AM +0100, Andi Kleen wrote:
> > holt@sgi.com writes:
> > 
> > > Tracking memtype on x86 uses a single global spin_lock for either reading
> > > or changing the memory type.  This includes changes made to page flags
> > > which is perfectly parallel.
> > >
> > > Part one of the patchset makes the page-based tracking use cmpxchg
> > > without a need for a lock.
> > >
> > > Part two of the patchset converts the spin_lock into a read/write lock.
> > 
> > I'm curious: in what workloads did you see contention?
> > 
> > For any scalability patches it would be always good to have a description
> > of the workload.
> 
> It was a job using xpmem (an out of tree kernel module) which uses
> vm_insert_pfn to establish ptes.  The scalability issues were shown
> in the first patch.  I do not have any test which shows a performance
> difference  with the spin_lock to rw_lock conversion.

And what's exactly the point of converting it to a rw_lock then ?

Thanks,

	tglx
