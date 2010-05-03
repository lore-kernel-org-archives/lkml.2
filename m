Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0ECRTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0ECRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:19:49 -0400
Date: Mon, 3 May 2010 19:18:37 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
Message-ID: <20100503171837.GG19891@random.random>
References: <20100503121743.653e5ecc@annuminas.surriel.com>
 <20100503121847.7997d280@annuminas.surriel.com>
 <1272905712.1642.150.camel@laptop>
 <20100503170230.GF19891@random.random>
 <1272906679.1642.152.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272906679.1642.152.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 07:11:19PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-03 at 19:02 +0200, Andrea Arcangeli wrote:
> > On Mon, May 03, 2010 at 06:55:12PM +0200, Peter Zijlstra wrote:
> > > This does leave me worrying about concurrent faults poking at
> > > vma->vm_end without synchronization.
> > 
> > I didn't check this patch in detail yet. I agree it can be removed and
> > I think it can be safely replaced with the page_table_lock.
> 
> Sure, it could probably be replaced with the ptl, but a single
> anon_vma->lock would I think be better since there's more of them.

ptl not enough, or it'd break if stack grows fast more than the size
of one pmd, page_table_lock enough instead.

Keeping anon_vma lock is sure fine with me ;), I was informally asked
if it was a must have, and I couldn't foresee any problem in
_replacing_ it (not removing) with page_table_lock (which I hope I
mentioned in my answer ;). But I never had an interest to remove it,
just I couldn't find any good reason to keep it either other than
"paranoid just in case", which is good enough justification to me ;)
considering these archs are uncommon and by definition gets less
testing.
