Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2IGAiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:38:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48599 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2IGAiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:38:00 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-ce-504941e34b7a
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Xishi Qiu <qiuxishi@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v3 0/4] memory-hotplug: handle page race between allocation and isolation
Date: Fri,  7 Sep 2012 09:39:28 +0900
Message-Id: <1346978372-17903-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory hotplug has a subtle race problem so this patchset fixes the problem
(Look at [3/3] for detail and please confirm the problem before review
other patches in this series.)

 [1/4] is just clean up and help for [2/4].
 [2/4] keeps the migratetype information to freed page's index field
       and [3/4] uses the information.
 [3/4] fixes the race problem with [2/4]'s information.
 [4/4] enhance memory-hotremove operation success ratio

After applying [2/4], migratetype argument in __free_one_page
and free_one_page is redundant so we can remove it but I decide
to not touch them because it increases code size about 50 byte.

This patchset is based on mmotm-2012-09-06-16-46

Minchan Kim (4):
  use get_page_migratetype instead of page_private
  mm: remain migratetype in freed page
  memory-hotplug: bug fix race between isolation and allocation
  memory-hotplug: fix pages missed by race rather than failing

 include/linux/mm.h             |   12 ++++++++++++
 include/linux/page-isolation.h |    4 ++++
 mm/page_alloc.c                |   19 ++++++++++++-------
 mm/page_isolation.c            |   18 ++++++++++++++++--
 4 files changed, 44 insertions(+), 9 deletions(-)

-- 
1.7.9.5

