Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0IIDZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 23:25:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:34943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab0IIDZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 23:25:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,336,1280732400"; 
   d="scan'208";a="552874205"
Date: Thu, 9 Sep 2010 11:25:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05/10] vmscan: Synchrounous lumpy reclaim use
 lock_page() instead trylock_page()
Message-ID: <20100909032524.GA12245@localhost>
References: <1283770053-18833-1-git-send-email-mel@csn.ul.ie>
 <1283770053-18833-6-git-send-email-mel@csn.ul.ie>
 <20100909120448.58acc9a6.kamezawa.hiroyu@jp.fujitsu.com>
 <20100909121547.2e69735a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909121547.2e69735a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 11:15:47AM +0800, KAMEZAWA Hiroyuki wrote:
> On Thu, 9 Sep 2010 12:04:48 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Mon,  6 Sep 2010 11:47:28 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > 
> > > With synchrounous lumpy reclaim, there is no reason to give up to reclaim
> > > pages even if page is locked. This patch uses lock_page() instead of
> > > trylock_page() in this case.
> > > 
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > 
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> Ah......but can't this change cause dead lock ??

You mean the task goes for page allocation while holding some page
lock? Seems possible.

Thanks,
Fengguang
