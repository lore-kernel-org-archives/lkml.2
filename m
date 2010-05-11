Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0EKPME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:12:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58722 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab0EKPMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:12:01 -0400
Date: Tue, 11 May 2010 16:11:42 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
	and rmap_walk() during migration by not migrating temporary stacks
Message-ID: <20100511151142.GS26611@csn.ul.ie>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home> <20100504094522.GA20979@csn.ul.ie> <alpine.DEB.2.00.1005101239400.13652@router.home> <20100510175654.GL26611@csn.ul.ie> <alpine.DEB.2.00.1005110857350.1500@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005110857350.1500@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:59:12AM -0500, Christoph Lameter wrote:
> On Mon, 10 May 2010, Mel Gorman wrote:
> 
> > > A simple way to disallow migration of pages is to increment the refcount
> > > of a page.
> > I guess it could be done by walking the page-tables in advance of the move
> > and elevating the page count of any pages faulted and then finding those
> > pages afterwards.  The fail path would be a bit of a pain though if the page
> > tables are partially moved though. It's unnecessarily complicated when the
> > temporary stack can be easily avoided.
> 
> Faulting during exec?

Copying in arguments and the like

> Dont we hold mmap_sem for write? A get_user_pages()
> or so on the range will increment the refcount.
> 

Or just identify the temporary stack from the migration side instead of
adding to the cost of exec?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
