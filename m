Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0GGJ1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 05:27:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0GGJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 05:27:28 -0400
Date: Wed, 7 Jul 2010 11:27:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
Message-ID: <20100707092719.GA3900@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-7-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100705095927.GC8510@basil.fritz.box>
 <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
 <20100706071337.GA20403@basil.fritz.box>
 <20100707060513.GA20221@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707060513.GA20221@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see.  I understood we should work on locking problem in now.
> I digged and learned hugepage IO can happen in direct IO from/to
> hugepage or coredump of hugepage user.
> 
> We can resolve race between memory failure and IO by checking
> page lock and writeback flag, right?

Yes, but we have to make sure it's in the same page.

As I understand the IO locking does not use the head page, that
means migration may need to lock all the sub pages.

Or fix IO locking to use head pages? 

> 
> BTW I surveyed direct IO code, but page lock seems not to be taken.
> Am I missing something?

That's expected I believe because applications are supposed to coordinate
for direct IO (but then direct IO also drops page cache). 

But page lock is used to coordinate in the page cache for buffered IO.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
