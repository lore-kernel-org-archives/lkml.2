Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab0IJKdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:33:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56549 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0IJKdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:33:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use lock_page() instead trylock_page()
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100909182649.C94F.A69D9226@jp.fujitsu.com>
References: <20100909092203.GL29263@csn.ul.ie> <20100909182649.C94F.A69D9226@jp.fujitsu.com>
Message-Id: <20100910193307.C97B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Sep 2010 19:33:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Afaik, detailed rule is,
> 
> o kswapd can call lock_page() because they never take page lock outside vmscan

s/lock_page()/lock_page_nosync()/



> o if try_lock() is successed, we can call lock_page_nosync() against its page after unlock.
>   because the task have gurantee of no lock taken.
> o otherwise, direct reclaimer can't call lock_page(). the task may have a lock already.
> 
> I think.
> 
> 
> >  I did not
> > think of an obvious example of when this would happen. Similarly,
> > deadlock situations with mmap_sem shouldn't happen unless multiple page
> > locks are being taken.
> > 
> > (prepares to feel foolish)
> > 
> > What did I miss?
> 
> 
> 
> 
> 



