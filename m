Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0GEIuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:50:04 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56864 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab0GEIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:49:59 -0400
Date: Mon, 5 Jul 2010 17:44:37 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] hugetlb: add missing unlock in avoidcopy path in
 hugetlb_cow()
Message-ID: <20100705084437.GB29648@spritzera.linux.bs1.fc.nec.co.jp>
References: <1278049646-29769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1278049646-29769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100702083143.GC12221@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100702083143.GC12221@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 10:31:43AM +0200, Andi Kleen wrote:
> On Fri, Jul 02, 2010 at 02:47:20PM +0900, Naoya Horiguchi wrote:
> > This patch fixes possible deadlock in hugepage lock_page()
> > by adding missing unlock_page().
> > 
> > libhugetlbfs test will hit this bug when the next patch in this
> > patchset ("hugetlb, HWPOISON: move PG_HWPoison bit check") is applied.
> 
> This looks like a general bug fix that should be merged ASAP? 
> 
> Or do you think this cannot be hit at all without the other patches?

This bug was introduced by patch "hugetlb, rmap: add reverse mapping for
hugepage" in previous patchset (currently in linux-next) and it's not
merged in mainline yet.
So it's OK if this patch goes into linux-next by its merge to mainline.

Thanks,
Naoya Horiguchi
