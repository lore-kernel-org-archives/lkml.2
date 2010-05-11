Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0EKOlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:41:07 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:57755 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0EKOlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:41:05 -0400
Date: Tue, 11 May 2010 08:59:12 -0500 (CDT)
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
In-Reply-To: <20100510175654.GL26611@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1005110857350.1500@router.home>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1005012055010.2663@router.home> <20100504094522.GA20979@csn.ul.ie> <alpine.DEB.2.00.1005101239400.13652@router.home>
 <20100510175654.GL26611@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Mel Gorman wrote:

> > A simple way to disallow migration of pages is to increment the refcount
> > of a page.
> I guess it could be done by walking the page-tables in advance of the move
> and elevating the page count of any pages faulted and then finding those
> pages afterwards.  The fail path would be a bit of a pain though if the page
> tables are partially moved though. It's unnecessarily complicated when the
> temporary stack can be easily avoided.

Faulting during exec? Dont we hold mmap_sem for write? A get_user_pages()
or so on the range will increment the refcount.
