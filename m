Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2IGAGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:06:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52751 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2IGAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:06:50 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-55-50493a984a66
Date: Fri, 7 Sep 2012 09:08:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/3] mm: remain migratetype in freed page
Message-ID: <20120907000827.GF16231@bbox>
References: <1346908619-16056-1-git-send-email-minchan@kernel.org>
 <1346908619-16056-3-git-send-email-minchan@kernel.org>
 <50483EF4.6010909@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50483EF4.6010909@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:13:08PM +0900, Kamezawa Hiroyuki wrote:
> (2012/09/06 14:16), Minchan Kim wrote:
> > The page allocator caches the pageblock information in page->private while
> > it is in the PCP freelists but this is overwritten with the order of the
> > page when freed to the buddy allocator. This patch stores the migratetype
> > of the page in the page->index field so that it is available at all times
> > when the page remain in free_list.
> > 
> sounds reasonable.
> 
> > This patch adds a new call site in __free_pages_ok so it might be
> > overhead a bit but it's for high order allocation.
> > So I believe damage isn't hurt.
> > 
> > * from v1
> >    * Fix move_freepages's migratetype - Mel
> >    * Add more kind explanation in description - Mel
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> 
> Hmm, page->index is valid only when the page is the head of buddy chunk ?

Yes.

> 
> Anyway,
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks, Kame!

-- 
Kind regards,
Minchan Kim
