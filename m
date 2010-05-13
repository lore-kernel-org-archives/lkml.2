Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0EMXzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:55:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59080 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0EMXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:55:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 14 May 2010 08:51:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
Message-Id: <20100514085135.cfb5ba17.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1005131219190.20037@router.home>
References: <20100511085752.GM26611@csn.ul.ie>
	<20100512092239.2120.A69D9226@jp.fujitsu.com>
	<20100512125427.d1b170ba.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1005121627020.1273@router.home>
	<20100513091930.9b42e3b8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1005131219190.20037@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 12:22:01 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 13 May 2010, KAMEZAWA Hiroyuki wrote:
> 
> > > Would it not be possible to do something similar for the temporary stack?
> > >
> >
> > Problem here is unmap->remap. ->migratepage() function is used as
> >
> > 	unmap
> > 	   -> migratepage()
> > 	      -> failed
> > 		-> remap
> >
> > Then, migratepage() itself is no help. We need some check-callback before unmap
> > or lock to wait for an event we can make remapping progress.
> 
> We could check earlier if the migrate function points to
> fail_migrate_page()?

If you mean checking before unmap, yes. we can avoid the race.
Unmapping itself is dangerous in this case.

> Where we check for PageKsm() in unmap_and_move f.e.?
> 

I'm not sure about KSM.

Thanks,
-Kame

