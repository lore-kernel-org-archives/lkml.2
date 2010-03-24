Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab0CXUtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:49:07 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:57161 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932998Ab0CXUtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:49:01 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2010 16:49:00 EDT
From: "Rafael J. Wysocki" <rjw@novell.com>
Organization: SUSE Labs
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/2] x86,pat: Reduce contention on the memtype_lock -V4
Date: Wed, 24 Mar 2010 21:32:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Robin Holt <holt@sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Takashi Iwai <tiwai@suse.de>
References: <20100324003608.811051277@gulag1.americas.sgi.com> <alpine.LFD.2.00.1003241214370.3147@localhost.localdomain> <1269447737.2881.13.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1269447737.2881.13.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003242132.11642.rjw@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Suresh Siddha wrote:
> On Wed, 2010-03-24 at 04:15 -0700, Thomas Gleixner wrote:
> > On Wed, 24 Mar 2010, Robin Holt wrote:
> > > On Wed, Mar 24, 2010 at 03:16:14AM +0100, Andi Kleen wrote:
> > > > holt@sgi.com writes:
> > > > 
> > > > > Tracking memtype on x86 uses a single global spin_lock for either reading
> > > > > or changing the memory type.  This includes changes made to page flags
> > > > > which is perfectly parallel.
> > > > >
> > > > > Part one of the patchset makes the page-based tracking use cmpxchg
> > > > > without a need for a lock.
> > > > >
> > > > > Part two of the patchset converts the spin_lock into a read/write lock.
> > > > 
> > > > I'm curious: in what workloads did you see contention?
> > > > 
> > > > For any scalability patches it would be always good to have a description
> > > > of the workload.
> > > 
> > > It was a job using xpmem (an out of tree kernel module) which uses
> > > vm_insert_pfn to establish ptes.  The scalability issues were shown
> > > in the first patch.  I do not have any test which shows a performance
> > > difference  with the spin_lock to rw_lock conversion.
> > 
> > And what's exactly the point of converting it to a rw_lock then ?
> 
> Thomas, As I mentioned earlier I am ok in not doing this conversion. If
> we see any performance issues with this spinlock, we can use RCU based
> logic to address that.
> 
> For now, first patch in this series (which avoid the lock for RAM pages)
> is good to go. Thanks Rafael for spotting the page flags bit
> manipulation issue.

In fact Takashi did that, to put the record straight. :-)

Thanks,
Rafael
