Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1ATKnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:43:45 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46693 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1ATKnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:43:43 -0500
Subject: Re: [PATCH -v10 0/4] Lock-less list
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20110119165247.cca2f434.akpm@linux-foundation.org>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	 <20110119135546.bb7e8f62.akpm@linux-foundation.org>
	 <1295484358.15213.25.camel@yhuang-dev>
	 <20110119165247.cca2f434.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 Jan 2011 11:44:07 +0100
Message-ID: <1295520247.28776.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 16:52 -0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 08:45:58 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > On Thu, 2011-01-20 at 05:55 +0800, Andrew Morton wrote:
> > > I'm trying to remember why we're talking about this.
> > > 
> > > You had an ACPI-based "hardware error reporting" thing.  And that
> > > required an nmi-context memory allocator.  And that required a
> > > "lockless" list implementation.
> > > 
> > > Yes?
> > 
> > Yes.  But the "lockless" list implementation is general, it can be used
> > by other part of kernel too,  such as irq_work and xlist in
> > net/rds/xlist.h in the patchset.
> 
> Well.  Lots of things are general but that doesn't mean we toss them
> into the kernel when we already have plenty of infrastructure to handle
> that sort of thing.
> 
> otoh, hoisting xlist.h out of net/rds and making it generally available
> is a good thing.
> 
> otooh, net/rds/ probably didn't need xlist at all and could have used
> existing general code.
> 
> So...  I'd say that unless and until the NMI-context allocator is
> merged, the case for merging the lockless list code is a bit marginal? 
> Or have you identified other code sites which could use llist and which
> would gain some benefit from migrating?

In fact, I have a patch ready and waiting to revert the whole irq_work
stuff, that too seems to be a superfluous generalization.
