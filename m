Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0CXIzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:55:16 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42937 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751471Ab0CXIzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:55:13 -0400
Date: Wed, 24 Mar 2010 03:55:11 -0500
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: holt@sgi.com, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Rafael Wysocki <rjw@novell.com>
Subject: Re: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
Message-ID: <20100324085511.GJ4920@sgi.com>
References: <20100324003608.811051277@gulag1.americas.sgi.com>
 <87wrx2for5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrx2for5.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:16:14AM +0100, Andi Kleen wrote:
> holt@sgi.com writes:
> 
> > Tracking memtype on x86 uses a single global spin_lock for either reading
> > or changing the memory type.  This includes changes made to page flags
> > which is perfectly parallel.
> >
> > Part one of the patchset makes the page-based tracking use cmpxchg
> > without a need for a lock.
> >
> > Part two of the patchset converts the spin_lock into a read/write lock.
> 
> I'm curious: in what workloads did you see contention?
> 
> For any scalability patches it would be always good to have a description
> of the workload.

It was a job using xpmem (an out of tree kernel module) which uses
vm_insert_pfn to establish ptes.  The scalability issues were shown
in the first patch.  I do not have any test which shows a performance
difference  with the spin_lock to rw_lock conversion.

Robin
