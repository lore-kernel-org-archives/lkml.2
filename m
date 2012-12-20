Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2LTWk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:40:57 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:40099 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2LTWkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:40:51 -0500
Date: Thu, 20 Dec 2012 14:40:59 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Petr Holasek <pholasek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] ksm: make rmap walks more scalable
In-Reply-To: <CA+55aFxfS0SBbRBRULX4Hm7a-xOY7ebJ=Ncu2cAdH2xvcZFO+Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1212201438190.977@eggly.anvils>
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils> <alpine.LNX.2.00.1212191742440.25409@eggly.anvils> <50D387FD.4020008@oracle.com> <CA+55aFxfS0SBbRBRULX4Hm7a-xOY7ebJ=Ncu2cAdH2xvcZFO+Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Linus Torvalds wrote:
> On Thu, Dec 20, 2012 at 1:49 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> > On 12/19/2012 08:44 PM, Hugh Dickins wrote:
> >> The rmap walks in ksm.c are like those in rmap.c:
> >> they can safely be done with anon_vma_lock_read().
> >>
> >> Signed-off-by: Hugh Dickins <hughd@google.com>
> >> ---
> >
> > Hi Hugh,
> >
> > This patch didn't fix the ksm oopses I'm seeing.
> >
> > This is with both patches applied:
> 
> Looks like another NULL mm pointer in ksmd.. Hugh fixed one in
> 2832bc19f666 ("sched: numa: ksm: fix oops in task_numa_placment()"),
> this looks like more of the same.
> 
> At a guess, it looks like get_mergeable_page() has a rmap_item with no
> mm. No idea how that happened. Hugh? Some race due to something that
> depended on the mmap_sem being exclusive, rather than for
> read-ownership?

No, it's just a misunderstanding: Sasha's problem is with a linux-next
that has Petr's NUMA KSM patch in, and we're still ironing known issues
out of that one.  Not a problem for 3.8-rc1.

Hugh
