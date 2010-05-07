Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0EGOWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:22:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209Ab0EGOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:22:08 -0400
Date: Fri, 7 May 2010 07:18:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
 rmap_walk by guaranteeing rmap_walk finds PTEs created within the temporary
 stack
In-Reply-To: <20100507131924.e75db6fc.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1005070715100.901@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org> <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1005061905230.901@i5.linux-foundation.org> <20100507131924.e75db6fc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 May 2010, KAMEZAWA Hiroyuki wrote:
> 
> Hmm, is this too slow ? This is the simplest one I have.

Well, it may be as slow (or slower) than Andrea's, but at least it is 
_clean_ and actually removes code. So if we can't do it better, I'd 
certainly prefer this to the horribly hacky one.

That said, I still think we could easily just split up 
"move_page_tables()" into two functions - one that just does the page 
table allocation, and one that actually moves the entries.

In fact, I think that would even clean up the error case for move_vma() 
too - the page table entry movement itself could never fail, so you never 
end up with that insane "move back" case.

		Linus
