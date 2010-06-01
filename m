Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0FAQbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:31:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab0FAQbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:31:08 -0400
Date: Wed, 2 Jun 2010 02:31:03 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
Message-ID: <20100601163103.GB9453@laptop>
References: <20100601073343.GQ9453@laptop>
 <87wruiycsl.fsf@basil.nowhere.org>
 <20100601155943.GA9453@laptop>
 <20100601162024.GC30556@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601162024.GC30556@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 06:20:25PM +0200, Andi Kleen wrote:
> On Wed, Jun 02, 2010 at 01:59:43AM +1000, Nick Piggin wrote:
> > On Tue, Jun 01, 2010 at 05:48:10PM +0200, Andi Kleen wrote:
> > > Nick Piggin <npiggin@suse.de> writes:
> > > 
> > > > This isn't really a new problem, and I don't know how important it is,
> > > > but I recently came across it again when doing some aim7 testing with
> > > > huge numbers of tasks.
> > > 
> > > Seems reasonable. Of course you need to at least 
> > > save/restore the old CPU policy, and use a subset of it.
> > 
> > The mpolicy? My patch does that (mpol_prefer_cpu_start/end). The real
> > problem is that it can actually violate the parent's mempolicy. For
> > example MPOL_BIND and cpus_allowed set on a node outside the mempolicy.
> 
> I don't see where you store 'old', but maybe I missed it.

It's the argument returned by mpol_prefer_cpu_start. Yes this also
opens races for lost-write when we have concurrent mpol changes. So
I'm not claiming the code is right.

 
> > > slightly more difficult. The advantage would be that on multiple
> > > migrations it would follow. And it would be a bit slower for
> > > the initial case.
> > 
> > Migrate what on touch? Talking mainly about kernel memory structures,
> > task_struct, mm, vmas, page tables, kernel stack, etc.
> 
> Migrate task_struct, mm, vmas, page tables, kernel stack
> on reasonable touch. As long as they are not shared it shouldn't
> be too difficult.

Possible but that's a lot further off (considering we don't even migrate
user memory) and is complimentary to this patch.

