Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2GWArs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:47:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44978 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2GWArr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:47:47 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-26-500c9f32351a
From: Minchan Kim <minchan@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, lliubbo@gmail.com,
        Minchan Kim <minchan@kernel.org>
Subject: [RESEND RFC 0/3] memory-hotplug: handle page race between allocation and isolation
Date: Mon, 23 Jul 2012 09:47:59 +0900
Message-Id: <1343004482-6916-1-git-send-email-minchan@kernel.org>
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

