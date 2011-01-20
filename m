Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1ATAxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:53:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782Ab1ATAxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:53:09 -0500
Date: Wed, 19 Jan 2011 16:52:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-Id: <20110119165247.cca2f434.akpm@linux-foundation.org>
In-Reply-To: <1295484358.15213.25.camel@yhuang-dev>
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
	<20110119135546.bb7e8f62.akpm@linux-foundation.org>
	<1295484358.15213.25.camel@yhuang-dev>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 08:45:58 +0800
Huang Ying <ying.huang@intel.com> wrote:

> On Thu, 2011-01-20 at 05:55 +0800, Andrew Morton wrote:
> > I'm trying to remember why we're talking about this.
> > 
> > You had an ACPI-based "hardware error reporting" thing.  And that
> > required an nmi-context memory allocator.  And that required a
> > "lockless" list implementation.
> > 
> > Yes?
> 
> Yes.  But the "lockless" list implementation is general, it can be used
> by other part of kernel too,  such as irq_work and xlist in
> net/rds/xlist.h in the patchset.

Well.  Lots of things are general but that doesn't mean we toss them
into the kernel when we already have plenty of infrastructure to handle
that sort of thing.

otoh, hoisting xlist.h out of net/rds and making it generally available
is a good thing.

otooh, net/rds/ probably didn't need xlist at all and could have used
existing general code.

So...  I'd say that unless and until the NMI-context allocator is
merged, the case for merging the lockless list code is a bit marginal? 
Or have you identified other code sites which could use llist and which
would gain some benefit from migrating?

