Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0FAP7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:59:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab0FAP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:59:49 -0400
Date: Wed, 2 Jun 2010 01:59:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lee@firstfloor.org,
       Schermerh@firstfloor.org
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
Message-ID: <20100601155943.GA9453@laptop>
References: <20100601073343.GQ9453@laptop>
 <87wruiycsl.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wruiycsl.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 05:48:10PM +0200, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > This isn't really a new problem, and I don't know how important it is,
> > but I recently came across it again when doing some aim7 testing with
> > huge numbers of tasks.
> 
> Seems reasonable. Of course you need to at least 
> save/restore the old CPU policy, and use a subset of it.

The mpolicy? My patch does that (mpol_prefer_cpu_start/end). The real
problem is that it can actually violate the parent's mempolicy. For
example MPOL_BIND and cpus_allowed set on a node outside the mempolicy.

What is needed is to execute with the existing mempolicy, but from
the point of view of the destination CPU. A bit more work on the
mpol code is required, but this is good enough for basic tests.
 

> Another approach would be to migrate this on touch, but that is probably
> slightly more difficult. The advantage would be that on multiple
> migrations it would follow. And it would be a bit slower for
> the initial case.

Migrate what on touch? Talking mainly about kernel memory structures,
task_struct, mm, vmas, page tables, kernel stack, etc.

