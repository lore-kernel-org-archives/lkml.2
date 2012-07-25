Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2GYXgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:36:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43619 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2GYXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:36:02 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-2f-501082e010f9
Date: Thu, 26 Jul 2012 08:36:31 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH -mm] remove __GFP_NO_KSWAPD fixes
Message-ID: <20120725233631.GC14411@bbox>
References: <20120724111222.2c5e6b30@annuminas.surriel.com>
 <20120725145119.75be021d@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725145119.75be021d@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:51:19PM -0400, Rik van Riel wrote:
> Turns out I missed two spots where __GFP_NO_KSWAPD is used.
> 
> The removal from the trace code is obvious, since the flag
> got removed there is no need to print it.
> 
> For mtdcore.c, now that memory compaction has been fixed,
> we should no longer see large swap storms from an attempt
> to allocate a large buffer, removing the need to specify
> __GFP_NO_KSWAPD.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>

You should have tidied up comment of the function.
I hope Andrew can do it if he see this review.

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index fcfce24..6ff1308 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1065,8 +1065,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying, swapping, writing back
- * or performing I/O.
+ * ask the memory allocator to avoid re-trying.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.

Thanks.

-- 
Kind regards,
Minchan Kim
