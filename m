Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2IEHYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:24:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60124 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2IEHYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:24:34 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-1f-5046fe30557d
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 0/3] memory-hotplug: handle page race between allocation and isolation
Date: Wed,  5 Sep 2012 16:25:59 +0900
Message-Id: <1346829962-31989-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug has a subtle race problem so this patchset fixes the problem
(Look at [3/3] for detail and please confirm the problem before review
other patches in this series.)

 [1/3] is just clean up and help for [2/3].
 [2/3] keeps the migratetype information to freed page's index field
       and [3/3] uses the information.
 [3/3] fixes the race problem with [2/3]'s information.

After applying [2/3], migratetype argument in __free_one_page
and free_one_page is redundant so we can remove it but I decide
to not touch them because it increases code size about 50 byte.

Minchan Kim (3):
  mm: use get_page_migratetype instead of page_private
  mm: remain migratetype in freed page
  memory-hotplug: bug fix race between isolation and allocation

 include/linux/mm.h  |   12 ++++++++++++
 mm/page_alloc.c     |   16 ++++++++++------
 mm/page_isolation.c |    7 +++++--
 3 files changed, 27 insertions(+), 8 deletions(-)

-- 
1.7.9.5

