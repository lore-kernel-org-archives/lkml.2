Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0D1BJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:09:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab0D1BJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:09:57 -0400
Date: Wed, 28 Apr 2010 03:09:20 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] mm,migration: Remove straggling migration PTEs
 when page tables are being moved after the VMA has already moved
Message-ID: <20100428010920.GK510@random.random>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
 <1272403852-10479-4-git-send-email-mel@csn.ul.ie>
 <20100427223004.GF8860@random.random>
 <20100427225852.GH8860@random.random>
 <20100428093948.c4e6faa1.kamezawa.hiroyu@jp.fujitsu.com>
 <20100428010543.GJ510@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428010543.GJ510@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 03:05:43AM +0200, Andrea Arcangeli wrote:
> 1) adjusting page->index atomically with the pte updates inside pt
>    lock (while it moves from one pte to another)

actually no need of this at all! of course the dst vma will have
vma->vm_pgoff adjusted instead... never mind. So I don't see a problem
there.

I think this is very special of how exec.c abuses move_page_tables by
passing vma as src and dst, when it obviously cannot be indexed in two
anon-vmas because there's a single vma and a single vma->anon_vma, and
src and dst obviously cannot have two different vm_pgoff again because
there's a single vma and there can't be two different vma->vm_pgoff.

So I'm very hopeful do_mremap is already fully safe...
