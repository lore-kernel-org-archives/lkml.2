Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1HRNFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:05:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab1HRNFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:05:12 -0400
Date: Thu, 18 Aug 2011 09:04:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pstore: change mutex locking to spin_locks
Message-ID: <20110818130447.GA1972@redhat.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
 <20110817142225.8645fff7.akpm@linux-foundation.org>
 <1313617679.2212.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313617679.2212.4.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:47:59PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-17 at 14:22 -0700, Andrew Morton wrote:
> > It's still bad if lockdep is enabled.  See
> > kernel/lockdep.c:lock_acquire() and lock_release().  They aren't
> > NMI-safe. 
> 
> Good thing nmi_enter() does lockdep_disable() and makes lock_acquire()
> bail on if (current->lockdep_recursion).
> 
> Still the fact that pstore needs locks from NMI context (let alone tried
> to use a mutex) makes one think one should avoid it like the plague.

Unfortunately, this plague is called ACPI4 (well APEI).  It's an attempt
to provide a coherent strategy for platform errors.  It needs a lot of
love to make it work, so we can't just avoid it (well us distro folks have
customers who want this). :-(

I have been having conversations with Matthew and Vivek Goyal about how to
simplify kmsg_dump, which might allow us to make some of the pstore paths
lockless, simplifying the solution.  We'll see how that goes.

Cheers,
Don
