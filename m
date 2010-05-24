Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0EXTeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646Ab0EXTeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:34:03 -0400
Date: Mon, 24 May 2010 12:32:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/13] mm: Revalidate anon_vma in page_lock_anon_vma()
Message-Id: <20100524123200.23e23fd2.akpm@linux-foundation.org>
In-Reply-To: <1270802693.20295.3272.camel@laptop>
References: <20100409150335.80E3.A69D9226@jp.fujitsu.com>
	<20100409154730.e9945cbc.kamezawa.hiroyu@jp.fujitsu.com>
	<20100409160252.80E6.A69D9226@jp.fujitsu.com>
	<1270802693.20295.3272.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 10:44:53 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2010-04-09 at 16:29 +0900, KOSAKI Motohiro wrote:
> > 
> > 
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 8b088f0..b4a0b5b 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -295,7 +295,7 @@ struct anon_vma *page_lock_anon_vma(struct page
> > *page)
> >         unsigned long anon_mapping;
> >  
> >         rcu_read_lock();
> > -       anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> > +       anon_mapping = (unsigned long) rcu_dereference(page->mapping);
> >         if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
> >                 goto out;
> >         if (!page_mapped(page)) 
> 
> Yes, I think this is indeed required.
> 
> I'll do a new version of the patch that includes the comment updates
> requested by Andrew.

Either this didn't happen or I lost the patch.

I parked mm-revalidate-anon_vma-in-page_lock_anon_vma.patch for now. 
Hopefully everything still works without it..

