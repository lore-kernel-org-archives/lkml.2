Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0J1PNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:13:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48910 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab0J1PNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:13:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/2] Reduce the amount of time spent in watermark-related functions V4
Date: Thu, 28 Oct 2010 16:13:34 +0100
Message-Id: <1288278816-32667-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V3
  o Added Reviewed-bys
  o Added comment on why pressure_threshold is what it is
  o Make sure pressure threshold does not get over 125
  o Call get_online_cpus and put_online_cpus as appropriate

The following two patches are in response to a bug report by Shaohua Li
where the amount of time spent in zone_nr_free_pages() is unacceptable
for large machines. All the background is in the first patches leader. The
second patch replaces two setter functions with one function that takes a
callback function as a parameter.

 include/linux/mmzone.h |   10 ++------
 include/linux/vmstat.h |    7 ++++++
 mm/mmzone.c            |   21 ------------------
 mm/page_alloc.c        |   35 ++++++++++++++++++++++++-------
 mm/vmscan.c            |   25 +++++++++++++--------
 mm/vmstat.c            |   54 +++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 103 insertions(+), 49 deletions(-)

Mel Gorman (2):
  mm: page allocator: Adjust the per-cpu counter threshold when memory
    is low
  mm: vmstat: Use a single setter function and callback for adjusting
    percpu thresholds

 include/linux/mmzone.h |   10 ++------
 include/linux/vmstat.h |    7 ++++++
 mm/mmzone.c            |   21 -------------------
 mm/page_alloc.c        |   35 ++++++++++++++++++++++++-------
 mm/vmscan.c            |   25 +++++++++++++---------
 mm/vmstat.c            |   52 +++++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 101 insertions(+), 49 deletions(-)

