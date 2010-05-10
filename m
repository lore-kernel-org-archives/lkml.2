Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0EJBfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:35:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160Ab0EJBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:35:49 -0400
Date: Sun, 9 May 2010 18:32:32 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.00.1005091827500.3711@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005091831140.3711@i5.linux-foundation.org>
References: <1273188053-26029-1-git-send-email-mel@csn.ul.ie> <1273188053-26029-3-git-send-email-mel@csn.ul.ie> <alpine.LFD.2.00.1005061836110.901@i5.linux-foundation.org> <20100507105712.18fc90c4.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1005061905230.901@i5.linux-foundation.org> <20100509192145.GI4859@csn.ul.ie> <alpine.LFD.2.00.1005091245000.3711@i5.linux-foundation.org> <20100510094050.8cb79143.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LFD.2.00.1005091827500.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 May 2010, Linus Torvalds wrote:
> 
> So I never disliked that patch. I'm perfectly happy with a "don't migrate 
> these pages at all, because they are in a half-way state in the middle of 
> execve stack magic".

Btw, I also think that Mel's patch could be made a lot _less_ magic by 
just marking that initial stack vma with a VM_STACK_INCOMPLETE_SETUP bit, 
instead of doing that "maybe_stack" thing. We could easily make that 
initial vma setup very explicit indeed, and then just clear that bit when 
we've moved the stack to its final position.

		Linus
