Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0EGCB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:01:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40171 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0EGCBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:01:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 May 2010 10:57:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mm,migration: Fix race between shift_arg_pages and
 rmap_walk by guaranteeing rmap_walk finds PTEs created within the temporary
 stack
Message-Id: <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie>
	<1273188053-26029-3-git-send-email-mel@csn.ul.ie>
	<alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 18:40:39 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 7 May 2010, Mel Gorman wrote:
> > 
> > Page migration requires rmap to be able to find all migration ptes
> > created by migration. If the second rmap_walk clearing migration PTEs
> > misses an entry, it is left dangling causing a BUG_ON to trigger during
> > fault. For example;
> 
> So I still absolutely detest this patch.
> 
> Why didn't the other - much simpler - patch work? The one Rik pointed to:
> 
> 	http://lkml.org/lkml/2010/4/30/198
> 
> and didn't do that _disgusting_ temporary anon_vma?
> 
I vote for simple one rather than temporal anon_vma. IIUC, this patch is selected
for not to leak exec's problem out to mm/ by magical check.


> Alternatively, why don't we just take the anon_vma lock over this region, 
> so that rmap can't _walk_ the damn thing?
> 

IIUC, move_page_tables() may call "page table allocation" and it cannot be
done under spinlock.

Thanks,
-Kame

