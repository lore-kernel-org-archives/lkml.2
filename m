Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2GQHBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:01:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55302 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2GQHBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:01:21 -0400
X-AuditID: 9c930179-b7bdcae000003d91-ac-50050dbe5ffb
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/3] memory-hotplug: handle page race between allocation and isolation
Date: Tue, 17 Jul 2012 16:01:42 +0900
Message-Id: <1342508505-23492-1-git-send-email-minchan@kernel.org>
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

