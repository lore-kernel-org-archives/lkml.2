Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0EJR5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:57:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50792 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0EJR5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:57:14 -0400
Date: Mon, 10 May 2010 18:56:55 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
	and rmap_walk() during migration by not migrating temporary stacks
Message-ID: <20100510175654.GL26611@csn.ul.ie>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home> <20100504094522.GA20979@csn.ul.ie> <alpine.DEB.2.00.1005101239400.13652@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005101239400.13652@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:41:07PM -0500, Christoph Lameter wrote:
> On Tue, 4 May 2010, Mel Gorman wrote:
> 
> > On Sat, May 01, 2010 at 08:56:18PM -0500, Christoph Lameter wrote:
> > > On Thu, 29 Apr 2010, Mel Gorman wrote:
> > >
> > > > There is a race between shift_arg_pages and migration that triggers this bug.
> > > > A temporary stack is setup during exec and later moved. If migration moves
> > > > a page in the temporary stack and the VMA is then removed before migration
> > > > completes, the migration PTE may not be found leading to a BUG when the
> > > > stack is faulted.
> > >
> > > A simpler solution would be to not allow migration of the temporary stack?
> > >
> >
> > The patch's intention is to not migrate pages within the temporary
> > stack. What are you suggesting that is different?
> 
> A simple way to disallow migration of pages is to increment the refcount
> of a page.
> 

I guess it could be done by walking the page-tables in advance of the move
and elevating the page count of any pages faulted and then finding those
pages afterwards.  The fail path would be a bit of a pain though if the page
tables are partially moved though. It's unnecessarily complicated when the
temporary stack can be easily avoided.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
