Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0GHFqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 01:46:04 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48638 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0GHFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 01:46:00 -0400
Date: Thu, 8 Jul 2010 14:44:26 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
Message-ID: <20100708054426.GA19906@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100707092719.GA3900@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:27:19AM +0200, Andi Kleen wrote:
> > I see.  I understood we should work on locking problem in now.
> > I digged and learned hugepage IO can happen in direct IO from/to
> > hugepage or coredump of hugepage user.
> >
> > We can resolve race between memory failure and IO by checking
> > page lock and writeback flag, right?
>
> Yes, but we have to make sure it's in the same page.
>
> As I understand the IO locking does not use the head page, that
> means migration may need to lock all the sub pages.
>
> Or fix IO locking to use head pages?
> >
> > BTW I surveyed direct IO code, but page lock seems not to be taken.
> > Am I missing something?
>
> That's expected I believe because applications are supposed to coordinate
> for direct IO (but then direct IO also drops page cache).
>
> But page lock is used to coordinate in the page cache for buffered IO.

This page cache is located on non-hugepage, isn't it?
If so, buffered IO is handled in the same manner as done for non-hugepage.
I think "hugepage under IO" is realized only in direct IO for now.

Direct IO is issued in page unit even if the target page is in hugepage,
so locking each subpages separately looks natural for me than auditing
head page.
