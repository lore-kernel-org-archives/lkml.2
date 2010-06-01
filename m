Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0FAQU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:20:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35428 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab0FAQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:20:27 -0400
Date: Tue, 1 Jun 2010 18:20:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lee@firstfloor.org,
       Schermerh@firstfloor.org
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
Message-ID: <20100601162024.GC30556@basil.fritz.box>
References: <20100601073343.GQ9453@laptop> <87wruiycsl.fsf@basil.nowhere.org> <20100601155943.GA9453@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601155943.GA9453@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:59:43AM +1000, Nick Piggin wrote:
> On Tue, Jun 01, 2010 at 05:48:10PM +0200, Andi Kleen wrote:
> > Nick Piggin <npiggin@suse.de> writes:
> > 
> > > This isn't really a new problem, and I don't know how important it is,
> > > but I recently came across it again when doing some aim7 testing with
> > > huge numbers of tasks.
> > 
> > Seems reasonable. Of course you need to at least 
> > save/restore the old CPU policy, and use a subset of it.
> 
> The mpolicy? My patch does that (mpol_prefer_cpu_start/end). The real
> problem is that it can actually violate the parent's mempolicy. For
> example MPOL_BIND and cpus_allowed set on a node outside the mempolicy.

I don't see where you store 'old', but maybe I missed it.

> > slightly more difficult. The advantage would be that on multiple
> > migrations it would follow. And it would be a bit slower for
> > the initial case.
> 
> Migrate what on touch? Talking mainly about kernel memory structures,
> task_struct, mm, vmas, page tables, kernel stack, etc.

Migrate task_struct, mm, vmas, page tables, kernel stack
on reasonable touch. As long as they are not shared it shouldn't
be too difficult.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
