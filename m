Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501Ab2KAN6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:58:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761460Ab2KAN6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:58:17 -0400
Date: Thu, 1 Nov 2012 13:58:13 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 20/31] sched, numa, mm/mpol: Make mempolicy home-node
 aware
Message-ID: <20121101135813.GX3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124834.012980641@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124834.012980641@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:37PM +0200, Peter Zijlstra wrote:
> Add another layer of fallback policy to make the home node concept
> useful from a memory allocation PoV.
> 
> This changes the mpol order to:
> 
>  - vma->vm_ops->get_policy	[if applicable]
>  - vma->vm_policy		[if applicable]
>  - task->mempolicy
>  - tsk_home_node() preferred	[NEW]
>  - default_policy
> 
> Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
> facilitate efficient on-demand memory migration.
> 

Makes sense and it looks like a VMA policy, if set, will still override
the home_node policy as you'd expect. At some point this may need to cope
with node hot-remove. Also, at some point this must be dealing with the
case where mbind() is called but the home_node is not in the nodemask.
Does that happen somewhere else in the series? (maybe I'll see it later)

-- 
Mel Gorman
SUSE Labs
