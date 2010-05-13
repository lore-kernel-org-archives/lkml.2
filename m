Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0EMRW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:22:56 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34889 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0EMRWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:22:55 -0400
Date: Thu, 13 May 2010 12:22:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <20100513091930.9b42e3b8.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1005131219190.20037@router.home>
References: <20100511085752.GM26611@csn.ul.ie> <20100512092239.2120.A69D9226@jp.fujitsu.com> <20100512125427.d1b170ba.akpm@linux-foundation.org> <alpine.DEB.2.00.1005121627020.1273@router.home> <20100513091930.9b42e3b8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, KAMEZAWA Hiroyuki wrote:

> > Would it not be possible to do something similar for the temporary stack?
> >
>
> Problem here is unmap->remap. ->migratepage() function is used as
>
> 	unmap
> 	   -> migratepage()
> 	      -> failed
> 		-> remap
>
> Then, migratepage() itself is no help. We need some check-callback before unmap
> or lock to wait for an event we can make remapping progress.

We could check earlier if the migrate function points to
fail_migrate_page()? Where we check for PageKsm() in unmap_and_move f.e.?


