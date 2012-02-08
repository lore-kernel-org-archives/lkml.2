Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2BHBvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:51:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38634 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2BHBvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:51:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F31D03B.9040707@openvz.org>
References: <20120207074905.29797.60353.stgit@zurg> <CA+55aFy3NZ2sWX0CNVd9FnPSx0mUKSe0XzDWpDsNfU21p6ebHQ@mail.gmail.com>
 <4F31D03B.9040707@openvz.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 17:50:59 -0800
X-Google-Sender-Auth: iQqrPLGLAbPwiCIWiVqcz8YzPMg
Message-ID: <CA+55aFx24n-W4-wTtrfbt9PNvVd7n+SvThnO6OQ74uW4yNrGxw@mail.gmail.com>
Subject: Re: [PATCH 0/4] radix-tree: iterating general cleanup
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 5:30 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
>
> If do not count comments here actually is negative line count change.

Ok, fair enough.

> And if drop (almost) unused radix_tree_gang_lookup_tag_slot() and
> radix_tree_gang_lookup_slot() total bloat-o-meter score becomes negative
> too.

Good.

> There also some simple bit-hacks: find-next-bit instead of dumb loops in
> tagged-lookup.
>
> Here some benchmark results: there is radix-tree with 1024 slots, I fill and
> tag every <step> slot,
> and run lookup for all slots with radix_tree_gang_lookup() and
> radix_tree_gang_lookup_tag() in the loop.
> old/new rows -- nsec per iteration over whole tree.
>
> tagged-lookup
> step    1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16
> old     7035    5248    4742    4308    4217    4133    4030    3920    4038    3933    3914    3796    3851    3755    3819    3582
> new     3578    2617    1899    1426    1220    1058    936     822     845     749     695     679     648     575     591     509
>
> so, new tagged-lookup always faster, especially for sparse trees.

Do you have any benchmarks when it's actually used by higher levels,
though? I guess that will involve find_get_pages(), and we don't have
all that any of them, but it would be lovely to see some real load
(even if it is limited to one of the filesystems that uses this)
numbers too..

> New normal lookup works faster for dense trees, on sparse trees it slower.

I think that should be the common case, so that may be fine. Again, it
would be nice to see numbers that are for something else than just the
lookup - an actual use of it in some real context.

Anyway, the patches themselves looked fine to me, modulo the fact that
I wasn't all that happy with the new __find_next_bit, and I think it's
better to not expose it in a generic header file. But I would really
like to see more "real" numbers for the series

Thanks,

                   Linus
