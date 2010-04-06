Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab0DFQ6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:58:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756882Ab0DFQ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:58:10 -0400
Date: Tue, 6 Apr 2010 09:53:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <1270572327.1711.3.camel@barrios-desktop>
Message-ID: <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>   <1270568096.1814.145.camel@barrios-desktop> 
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>  <1270571019.1814.163.camel@barrios-desktop>  <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Minchan Kim wrote:
> 
> unmap_and_move
> 	remove_migration_ptes
> 		rmap_walk
> 			rmap_walk_anon
> 
> We always has rcu_read_lock about anon page in unmap_and_move.
> So I think it's not buggy. What am I missing?

Ok, in that case it's fine.

However, it does bring back my comment about all those anonvma changes: 
the locking is totally undocumented. 

Why isn't there a thing _saying_ that it's ok because of this?

Why is there no comment about the locking of that 'same_vma' / 
'vma->anon_vma_chain' except for the totally nonsensical one about 
page_table_lock (which doesn't protect _any_ of the other cases)?

		Linus
