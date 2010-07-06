Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0GFHNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:13:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57576 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0GFHNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:13:42 -0400
Date: Tue, 6 Jul 2010 09:13:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] hugetlb: hugepage migration core
Message-ID: <20100706071337.GA20403@basil.fritz.box>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-7-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100705095927.GC8510@basil.fritz.box>
 <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100706033342.GA10626@spritzera.linux.bs1.fc.nec.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 12:33:42PM +0900, Naoya Horiguchi wrote:
> > There's more code that handles LRU in this file. Do they all handle huge pages
> > correctly?
> > 
> > I also noticed we do not always lock all sub pages in the huge page. Now if
> > IO happens it will lock on subpages, not the head page. But this code
> > handles all subpages as a unit. Could this cause locking problems?
> > Perhaps it would be safer to lock all sub pages always? Or would 
> > need  to audit other page users to make sure they always lock on the head
> > and do the same here.
> > 
> > Hmm page reference counts may have the same issue?
> 
> If we try to implement paging out of hugepage in the future, we need to
> solve all these problems straightforwardly. But at least for now we can
> skirt them by not touching LRU code for hugepage extension.

We need the page lock to avoid migrating pages that are currently
under IO. This can happen even without swapping when the process 
manually starts IO. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
