Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0EKROA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:14:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab0EKRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:13:59 -0400
Date: Tue, 11 May 2010 10:11:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <20100511085752.GM26611@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.1005111009500.3711@i5.linux-foundation.org>
References: <20100511085752.GM26611@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 May 2010, Mel Gorman wrote:
> 
> This patch closes the most important race in relation to exec and
> migration. With it applied, the swapops bug is no longer triggering for
> known problem workloads. If you pick it up, it should go with the other
> mmmigration-* fixes in mm.

Ack. _Much_ better and clearer.

I'm not entirely sure we need that "maybe_stack" (if we need it, that 
would sound like a problem anyway), but I guess it can't hurt either.

		Linus
