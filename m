Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab0HEGLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:11:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51023 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:11:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>
Subject: [RFC][PATCH 0/7] low latency synchrounous lumpy reclaim
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Aug 2010 15:11:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If slow usb storage is connected and run plenty io operation, lumpy
reclaim often stall in shrink_inactive_list(). This patch series try 
to solve this issue.
At least, This works fine on my desktop and usb stick environment :-)

This patch is still RFC. comment, reviewing and testing are welcome!




Wu Fengguang (1):
  vmscan: raise the bar to PAGEOUT_IO_SYNC stalls

KOSAKI Motohiro (6):
  vmscan: synchronous lumpy reclaim don't call congestion_wait()
  vmscan: synchrounous lumpy reclaim use lock_page() instead trylock_page()
  vmscan: narrowing synchrounous lumply reclaim condition
  vmscan: kill dead code in shrink_inactive_list()
  vmscan: remove PF_SWAPWRITE from __zone_reclaim()
  vmscan: isolated_lru_pages() stop neighbor search if neighbor can't be isolated

 mm/vmscan.c |  211 ++++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 138 insertions(+), 73 deletions(-)



