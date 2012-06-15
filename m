Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2FOCun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 22:50:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:9392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2FOCum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 22:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165903289"
Date: Fri, 15 Jun 2012 10:50:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/vmscan: cleanup on the comments of
 do_try_to_free_pages
Message-ID: <20120615025032.GA8250@localhost>
References: <1339723524-6332-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339723524-6332-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 09:25:24AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since lumpy reclaim algorithm is removed by Mel Gorman, cleanup the
> footprint of lumpy reclaim.

I think the "lumpy writeout" here does not mean "lumpy reclaim" :-)

> @@ -2065,8 +2065,9 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>  		 * Try to write back as many pages as we just scanned.  This
>  		 * tends to cause slow streaming writers to write data to the
>  		 * disk smoothly, at the dirtying rate, which is nice.   But
> -		 * that's undesirable in laptop mode, where we *want* lumpy
> -		 * writeout.  So in laptop mode, write out the whole world.
> +		 * that's undesirable in laptop mode, where as much I/O as
> +		 * possible should be trigged if the disk needs to be spun up.
> +		 * So in laptop mode, write out the whole world.
>  		 */
>  		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
>  		if (total_scanned > writeback_threshold) {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
