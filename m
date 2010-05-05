Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab0EETME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:12:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab0EETL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:11:59 -0400
Subject: Re: [PATCH 1/2] mm,migration: Prevent rmap_walk_[anon|ksm] seeing
 the wrong VMA information
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20100505161319.GQ5835@random.random>
References: <1273065281-13334-1-git-send-email-mel@csn.ul.ie>
	 <1273065281-13334-2-git-send-email-mel@csn.ul.ie>
	 <alpine.LFD.2.00.1005050729000.5478@i5.linux-foundation.org>
	 <20100505145620.GP20979@csn.ul.ie>
	 <alpine.LFD.2.00.1005050815060.5478@i5.linux-foundation.org>
	 <20100505155454.GT20979@csn.ul.ie>  <20100505161319.GQ5835@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 21:11:25 +0200
Message-ID: <1273086685.1642.252.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 18:13 +0200, Andrea Arcangeli wrote:
> On Wed, May 05, 2010 at 04:54:54PM +0100, Mel Gorman wrote:
> > I'm still thinking of the ordering but one possibility would be to use a mutex
> 
> I can't take mutex in split_huge_page... so I'd need to use an other solution.

So how's that going to work out for my make anon_vma->lock a mutex
patches?

