Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0LJLRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:17:55 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34363 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab0LJLRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:17:54 -0500
Date: Fri, 10 Dec 2010 11:17:37 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: make kswapd use a correct order
Message-ID: <20101210111736.GO20133@csn.ul.ie>
References: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com> <20101209141317.60d14fb5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101209141317.60d14fb5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:13:17PM -0800, Andrew Morton wrote:
> On Fri,  3 Dec 2010 01:00:49 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > +static bool kswapd_try_to_sleep(pg_data_t *pgdat, int order)
> 
> OT: kswapd_try_to_sleep() does a
> trace_mm_vmscan_kswapd_sleep(pgdat->node_id) if it sleeps for a long
> time, but doesn't trace anything at all if it does a short sleep. 
> Where's the sense in that?
> 

The tracepoint is to mark when kswapd is going fully to sleep and being
inactive because all its work is done. The tracepoints name might be
unfortunate because it's really used to track if kswapd is active or
inactive rather than sleeping.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
