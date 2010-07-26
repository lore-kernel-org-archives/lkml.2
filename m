Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0GZDCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 23:02:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53319 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0GZDCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 23:02:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 0/4] memcg reclaim tracepoint v2
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100726120107.2EEE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 26 Jul 2010 12:02:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently, Mel Gorman added some vmscan tracepoint. but they can't
trace memcg. So, This patch series does.


Changelog since v1
 o drop all memcg bugfix and cleanups


diffstat
=========================
KOSAKI Motohiro (4):
  vmscan: convert direct reclaim tracepoint to DEFINE_TRACE
  memcg, vmscan: add memcg reclaim tracepoint
  vmscan: convert mm_vmscan_lru_isolate to DEFINE_EVENT
  memcg: add mm_vmscan_memcg_isolate tracepoint

 include/trace/events/vmscan.h |   79 +++++++++++++++++++++++++++++++++++++++--
 mm/memcontrol.c               |    6 +++
 mm/vmscan.c                   |   20 ++++++++++-
 3 files changed, 101 insertions(+), 4 deletions(-)

Sameple output is here.
=========================

              dd-1851  [001]   158.837763: mm_vmscan_memcg_reclaim_begin: order=0 may_writepage=1 gfp_flags=GFP_HIGHUSER_MOVABLE
              dd-1851  [001]   158.837783: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
              dd-1851  [001]   158.837860: mm_vmscan_memcg_reclaim_end: nr_reclaimed=32
  (...)
              dd-1970  [000]   266.608235: mm_vmscan_wakeup_kswapd: nid=0 zid=1 order=0
              dd-1970  [000]   266.608239: mm_vmscan_wakeup_kswapd: nid=1 zid=1 order=0
              dd-1970  [000]   266.608248: mm_vmscan_wakeup_kswapd: nid=2 zid=1 order=0
         kswapd1-348   [001]   266.608254: mm_vmscan_kswapd_wake: nid=1 order=0
              dd-1970  [000]   266.608254: mm_vmscan_wakeup_kswapd: nid=3 zid=1 order=0
         kswapd3-350   [000]   266.608266: mm_vmscan_kswapd_wake: nid=3 order=0
  (...)
         kswapd0-347   [001]   267.328891: mm_vmscan_memcg_softlimit_reclaim_begin: order=0 may_writepage=1 gfp_flags=GFP_HIGHUSER_MOVABLE
         kswapd0-347   [001]   267.328897: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.328915: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.328989: mm_vmscan_memcg_softlimit_reclaim_end: nr_reclaimed=32
         kswapd0-347   [001]   267.329019: mm_vmscan_lru_isolate: isolate_mode=1 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.330562: mm_vmscan_lru_isolate: isolate_mode=1 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
  (...)
         kswapd2-349   [001]   267.407081: mm_vmscan_kswapd_sleep: nid=2
         kswapd3-350   [001]   267.408077: mm_vmscan_kswapd_sleep: nid=3
         kswapd1-348   [000]   267.427858: mm_vmscan_kswapd_sleep: nid=1
         kswapd0-347   [001]   267.430064: mm_vmscan_kswapd_sleep: nid=0







