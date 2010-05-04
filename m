Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0EDJpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 05:45:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34259 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0EDJpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 05:45:41 -0400
Date: Tue, 4 May 2010 10:45:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
	and rmap_walk() during migration by not migrating temporary stacks
Message-ID: <20100504094522.GA20979@csn.ul.ie>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005012055010.2663@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 08:56:18PM -0500, Christoph Lameter wrote:
> On Thu, 29 Apr 2010, Mel Gorman wrote:
> 
> > There is a race between shift_arg_pages and migration that triggers this bug.
> > A temporary stack is setup during exec and later moved. If migration moves
> > a page in the temporary stack and the VMA is then removed before migration
> > completes, the migration PTE may not be found leading to a BUG when the
> > stack is faulted.
> 
> A simpler solution would be to not allow migration of the temporary stack?
> 

The patch's intention is to not migrate pages within the temporary
stack. What are you suggesting that is different?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
