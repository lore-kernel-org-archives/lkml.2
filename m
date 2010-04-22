Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0DVX4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 19:56:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53460 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0DVX4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 19:56:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 23 Apr 2010 08:52:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache pages
Message-Id: <20100423085203.b43d1cb3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1004221439040.5023@router.home>
References: <20100421153421.GM30306@csn.ul.ie>
	<alpine.DEB.2.00.1004211038020.4959@router.home>
	<20100422092819.GR30306@csn.ul.ie>
	<20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
	<x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
	<20100422193106.9ffad4ec.kamezawa.hiroyu@jp.fujitsu.com>
	<20100422195153.d91c1c9e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100422141404.GA30306@csn.ul.ie>
	<p2y28c262361004220718m3a5e3e2ekee1fef7ebdae8e73@mail.gmail.com>
	<20100422154003.GC30306@csn.ul.ie>
	<20100422192923.GH30306@csn.ul.ie>
	<alpine.DEB.2.00.1004221439040.5023@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 14:40:46 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 22 Apr 2010, Mel Gorman wrote:
> 
> > vma_adjust() is updating anon VMA information without any locks taken.
> > In constract, file-backed mappings use the i_mmap_lock. This lack of
> > locking can result in races with page migration. During rmap_walk(),
> > vma_address() can return -EFAULT for an address that will soon be valid.
> > This leaves a dangling migration PTE behind which can later cause a
> > BUG_ON to trigger when the page is faulted in.
> 
> Isnt this also a race with reclaim /  swap?
> 
Yes, it's also race in reclaim/swap ...
  page_referenced()
  try_to_unmap().
  rmap_walk()  <==== we hit this case.

But above 2 are not considered to be critical.

I'm not sure how this race affect KSM.

Thanks,
-Kame

