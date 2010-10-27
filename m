Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0J0Ire (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:47:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55808 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0J0Irb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:47:31 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/2] Reduce the amount of time spent in watermark-related functions
Date: Wed, 27 Oct 2010 09:47:34 +0100
Message-Id: <1288169256-7174-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are in response to a bug report by Shaohua Li
where the amount of time spent in zone_nr_free_pages() is unacceptable
for large machines. All the background is in the first patches leader. The
second patch replaces two setter functions with one function that takes a
callback function as a parameter.

Mel Gorman (2):
  mm: page allocator: Adjust the per-cpu counter threshold when memory
    is low
  mm: vmstat: Use a single setter function and callback for adjusting
    percpu thresholds

 include/linux/mmzone.h |   10 +++-------
 include/linux/vmstat.h |    7 +++++++
 mm/mmzone.c            |   21 ---------------------
 mm/page_alloc.c        |   35 +++++++++++++++++++++++++++--------
 mm/vmscan.c            |   25 +++++++++++++++----------
 mm/vmstat.c            |   32 +++++++++++++++++++++++++++++---
 6 files changed, 81 insertions(+), 49 deletions(-)

