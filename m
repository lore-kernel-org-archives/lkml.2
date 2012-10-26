Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2JZKYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:24:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39033 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2JZKYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:24:21 -0400
Date: Fri, 26 Oct 2012 12:24:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Zhouping Liu <zliu@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 00/31] numa/core patches
Message-ID: <20121026102415.GA3382@gmail.com>
References: <20121025121617.617683848@chello.nl>
 <508A52E1.8020203@redhat.com>
 <1351242480.12171.48.camel@twins>
 <20121026092048.GA628@gmail.com>
 <508A63D7.1000704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508A63D7.1000704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhouping Liu <zliu@redhat.com> wrote:

> On 10/26/2012 05:20 PM, Ingo Molnar wrote:
> >* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> >>On Fri, 2012-10-26 at 17:07 +0800, Zhouping Liu wrote:
> >>>[  180.918591] RIP: 0010:[<ffffffff8118c39a>]  [<ffffffff8118c39a>] mem_cgroup_prepare_migration+0xba/0xd0
> >>>[  182.681450]  [<ffffffff81183b60>] do_huge_pmd_numa_page+0x180/0x500
> >>>[  182.775090]  [<ffffffff811585c9>] handle_mm_fault+0x1e9/0x360
> >>>[  182.863038]  [<ffffffff81632b62>] __do_page_fault+0x172/0x4e0
> >>>[  182.950574]  [<ffffffff8101c283>] ? __switch_to_xtra+0x163/0x1a0
> >>>[  183.041512]  [<ffffffff8101281e>] ? __switch_to+0x3ce/0x4a0
> >>>[  183.126832]  [<ffffffff8162d686>] ? __schedule+0x3c6/0x7a0
> >>>[  183.211216]  [<ffffffff81632ede>] do_page_fault+0xe/0x10
> >>>[  183.293705]  [<ffffffff8162f518>] page_fault+0x28/0x30
> >>Johannes, this looks like the thp migration memcg hookery gone bad,
> >>could you have a look at this?
> >Meanwhile, Zhouping Liu, could you please not apply the last
> >patch:
> >
> >   [PATCH] sched, numa, mm: Add memcg support to do_huge_pmd_numa_page()
> >
> >and see whether it boots/works without that?
> 
> Hi Ingo,
> 
> your supposed is right, after reverting the 31st patch(sched, numa,
> mm: Add memcg support to do_huge_pmd_numa_page())
> the issue is gone, thank you.

The tested bits you can find in the numa/core tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/core

It includes all changes (patches #1-#30) except patch #31 - I 
wanted to test and apply that last patch today, but won't do it 
now that you've reported this regression.

Thanks,

	Ingo
