Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0EJRmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:42:08 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:54615 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0EJRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:42:05 -0400
Date: Mon, 10 May 2010 12:41:07 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <20100504094522.GA20979@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1005101239400.13652@router.home>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home> <20100504094522.GA20979@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010, Mel Gorman wrote:

> On Sat, May 01, 2010 at 08:56:18PM -0500, Christoph Lameter wrote:
> > On Thu, 29 Apr 2010, Mel Gorman wrote:
> >
> > > There is a race between shift_arg_pages and migration that triggers this bug.
> > > A temporary stack is setup during exec and later moved. If migration moves
> > > a page in the temporary stack and the VMA is then removed before migration
> > > completes, the migration PTE may not be found leading to a BUG when the
> > > stack is faulted.
> >
> > A simpler solution would be to not allow migration of the temporary stack?
> >
>
> The patch's intention is to not migrate pages within the temporary
> stack. What are you suggesting that is different?

A simple way to disallow migration of pages is to increment the refcount
of a page.

