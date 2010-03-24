Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0CXQXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:23:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:33591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0CXQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:23:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,301,1267430400"; 
   d="scan'208";a="551746662"
Subject: Re: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, Rafael Wysocki <rjw@novell.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.LFD.2.00.1003241214370.3147@localhost.localdomain>
References: <20100324003608.811051277@gulag1.americas.sgi.com>
	 <87wrx2for5.fsf@basil.nowhere.org> <20100324085511.GJ4920@sgi.com>
	 <alpine.LFD.2.00.1003241214370.3147@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 24 Mar 2010 09:22:17 -0700
Message-Id: <1269447737.2881.13.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 04:15 -0700, Thomas Gleixner wrote:
> On Wed, 24 Mar 2010, Robin Holt wrote:
> > On Wed, Mar 24, 2010 at 03:16:14AM +0100, Andi Kleen wrote:
> > > holt@sgi.com writes:
> > > 
> > > > Tracking memtype on x86 uses a single global spin_lock for either reading
> > > > or changing the memory type.  This includes changes made to page flags
> > > > which is perfectly parallel.
> > > >
> > > > Part one of the patchset makes the page-based tracking use cmpxchg
> > > > without a need for a lock.
> > > >
> > > > Part two of the patchset converts the spin_lock into a read/write lock.
> > > 
> > > I'm curious: in what workloads did you see contention?
> > > 
> > > For any scalability patches it would be always good to have a description
> > > of the workload.
> > 
> > It was a job using xpmem (an out of tree kernel module) which uses
> > vm_insert_pfn to establish ptes.  The scalability issues were shown
> > in the first patch.  I do not have any test which shows a performance
> > difference  with the spin_lock to rw_lock conversion.
> 
> And what's exactly the point of converting it to a rw_lock then ?

Thomas, As I mentioned earlier I am ok in not doing this conversion. If
we see any performance issues with this spinlock, we can use RCU based
logic to address that.

For now, first patch in this series (which avoid the lock for RAM pages)
is good to go. Thanks Rafael for spotting the page flags bit
manipulation issue.

thanks,
suresh

