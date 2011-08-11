Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1HKJR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:17:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48511 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1HKJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:17:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 11 Aug 2011 18:10:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        XFS <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
 kswapd except in high priority
Message-Id: <20110811181029.d3c10169.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1312973240-32576-6-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-6-git-send-email-mgorman@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 11:47:18 +0100
Mel Gorman <mgorman@suse.de> wrote:

> It is preferable that no dirty pages are dispatched for cleaning from
> the page reclaim path. At normal priorities, this patch prevents kswapd
> writing pages.
> 
> However, page reclaim does have a requirement that pages be freed
> in a particular zone. If it is failing to make sufficient progress
> (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> considered to be the point where kswapd is getting into trouble
> reclaiming pages. If this priority is reached, kswapd will dispatch
> pages for writing.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, I'd like to see summary of the effect of priority..

