Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0GHG7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:59:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0GHG7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:59:12 -0400
Date: Thu, 8 Jul 2010 08:49:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
Message-ID: <20100708064951.GA15950@basil.fritz.box>
References: <20100707092719.GA3900@basil.fritz.box>
 <20100708054426.GA19906@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708054426.GA19906@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This page cache is located on non-hugepage, isn't it?

Yes.

> If so, buffered IO is handled in the same manner as done for non-hugepage.
> I think "hugepage under IO" is realized only in direct IO for now.
> 
> Direct IO is issued in page unit even if the target page is in hugepage,
> so locking each subpages separately looks natural for me than auditing
> head page.

Ok. Would need to make sure lock ordering is correctly handled all the time.

If there's any code that locks multiple pages "backwards" and the migration
code locks it forward there might be a problem. Maybe it's not a problem
though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
