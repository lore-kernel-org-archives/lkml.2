Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2JaRbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:31:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40459 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2JaRbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:31:10 -0400
Date: Wed, 31 Oct 2012 10:31:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Zhouping Liu <zliu@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 00/31] numa/core patches
In-Reply-To: <50912478.2040403@redhat.com>
Message-ID: <alpine.LNX.2.00.1210311005220.5685@eggly.anvils>
References: <20121025121617.617683848@chello.nl> <508A52E1.8020203@redhat.com> <1351242480.12171.48.camel@twins> <20121028175615.GC29827@cmpxchg.org> <508F73C5.7050409@redhat.com> <20121031004838.GA1657@cmpxchg.org> <alpine.LNX.2.00.1210302350140.5084@eggly.anvils>
 <50912478.2040403@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Zhouping Liu wrote:
> On 10/31/2012 03:26 PM, Hugh Dickins wrote:
> > 
> > There's quite a few put_page()s in do_huge_pmd_numa_page(), and it
> > would help if we could focus on the one which is giving the trouble,
> > but I don't know which that is.  Zhouping, if you can, please would
> > you do an "objdump -ld vmlinux >bigfile" of your kernel, then extract
> > from bigfile just the lines from "<do_huge_pmd_numa_page>:" to whatever
> > is the next function, and post or mail privately just that disassembly.
> > That should be good to identify which of the put_page()s is involved.
> 
> Hugh, I didn't find the next function, as I can't find any words that matched
> "do_huge_pmd_numa_page".
> is there any other methods?

Hmm, do_huge_pmd_numa_page does appear in your stacktrace,
unless I've made a typo but am blind to it.

Were you applying objdump to the vmlinux which gave you the
BUG at mm/memcontrol.c:1134! ?

Maybe just do "objdump -ld mm/huge_memory.o >notsobigfile"
and mail me an attachment of the notsobigfile.

I did try building your config here last night, but ran out of disk
space on this partition, and it was already clear that my gcc version
differs from yours, so not quite matching.

> also I tried to use kdump to dump vmcore file,
> but unluckily kdump didn't
> work well, if you think it useful to dump vmcore file, I can try it again and
> provide more info.

It would take me awhile to get up to speed on using that,
I'd prefer to start with just the objdump of huge_memory.o.

I forgot last night to say that I did try stress (but not on a kernel
of your config), but didn't see the BUG: I expect there are too many
differences in our environments, and I'd have to tweak things one way
or another to get it to happen - probably a waste of time.

Thanks,
Hugh
