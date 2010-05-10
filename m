Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0EJTHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab0EJTHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:07:43 -0400
Date: Mon, 10 May 2010 21:05:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
Message-ID: <20100510190559.GD22632@random.random>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
 <1272529930-29505-3-git-send-email-mel@csn.ul.ie>
 <alpine.DEB.2.00.1005012055010.2663@router.home>
 <20100504094522.GA20979@csn.ul.ie>
 <alpine.DEB.2.00.1005101239400.13652@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005101239400.13652@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:41:07PM -0500, Christoph Lameter wrote:
> A simple way to disallow migration of pages is to increment the refcount
> of a page.

Ok for migrate but it won't prevent to crash in split_huge_page rmap
walk, nor the PG_lock. Why for a rmap bug have a migrate specific fix?
The fix that makes execve the only special place to handle in every
rmap walk, is at least more maintainable than a fix that makes one of
the rmap walk users special and won't fix the others, as there will be
more than just 1 user that requires this. My fix didn't make execve
special and it didn't require execve knowledge into the every rmap
walk like migrate (split_huge_page etc...) but as long as the kernel
doesn't crash I'm fine ;).
