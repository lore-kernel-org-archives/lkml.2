Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0ENAJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:09:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47432 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0ENAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:09:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 14 May 2010 09:04:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/5] track the root (oldest) anon_vma
Message-Id: <20100514090458.acaedb48.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BEB630B.8070805@redhat.com>
References: <20100512133815.0d048a86@annuminas.surriel.com>
	<20100512133958.3aff0515@annuminas.surriel.com>
	<20100513093828.1cd022db.kamezawa.hiroyu@jp.fujitsu.com>
	<4BEB630B.8070805@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 22:25:15 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 05/12/2010 08:38 PM, KAMEZAWA Hiroyuki wrote:
> > On Wed, 12 May 2010 13:39:58 -0400
> > Rik van Riel<riel@redhat.com>  wrote:
> >
> >> Subject: track the root (oldest) anon_vma
> >>
> >> Track the root (oldest) anon_vma in each anon_vma tree.   Because we only
> >> take the lock on the root anon_vma, we cannot use the lock on higher-up
> >> anon_vmas to lock anything.  This makes it impossible to do an indirect
> >> lookup of the root anon_vma, since the data structures could go away from
> >> under us.
> >>
> >> However, a direct pointer is safe because the root anon_vma is always the
> >> last one that gets freed on munmap or exit, by virtue of the same_vma list
> >> order and unlink_anon_vmas walking the list forward.
> >>
> >> Signed-off-by: Rik van Riel<riel@redhat.com>
> >
> >
> > Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> >
> > I welcome this. Thank you!
> >
> > Reading 4/5, I felt I'm grad if you add a Documentation or very-precise-comment
> > about the new anon_vma rules and the _meaning_ of anon_vma_root_lock.
> > I cannot fully convice myself that I understand them all.
> 
> Please send me a list of all the questions that come up
> when you read the patches, and I'll prepare a patch 6/5
> with just documentation :)
> 

0. Why it's dangerous to take vma->anon_vma->lock ?

1. What kinds of anon_vmas we'll found in
     page->mapping => anon_vma->head and avc->same_anon_vma ?
   IOW, what kinds of avc->vmas will see when we walk anon_vma->head.

2. Why we have to walk from the root ?

3. What anon_vma_lock guards, actually ?


etc....the facts which is unclear for guys who are not involved in this fix.
Preparing some explanation seems to be kindly rather than "plz ask google"

Bye.
-Kame


