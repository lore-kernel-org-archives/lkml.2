Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0LJBYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:24:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45620 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab0LJBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:24:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Dec 2010 10:19:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mm: kswapd: Reset kswapd_max_order and
 classzone_idx after reading
Message-Id: <20101210101907.61f3019b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1291893500-12342-5-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-5-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Dec 2010 11:18:18 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> When kswapd wakes up, it reads its order and classzone from pgdat and
> calls balance_pgdat. While its awake, it potentially reclaimes at a high
> order and a low classzone index. This might have been a once-off that
> was not required by subsequent callers. However, because the pgdat
> values were not reset, they remain artifically high while
> balance_pgdat() is running and potentially kswapd enters a second
> unnecessary reclaim cycle. Reset the pgdat order and classzone index
> after reading.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

