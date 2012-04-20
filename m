Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2DTV6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:58:38 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19054 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2DTV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:58:35 -0400
From: Glauber Costa <glommer@parallels.com>
To: <cgroups@vger.kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 07/23] change defines to an enum
Date: Fri, 20 Apr 2012 18:57:15 -0300
Message-Id: <1334959051-18203-8-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334959051-18203-1-git-send-email-glommer@parallels.com>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup patch for clarity of expression.
In earlier submissions, people asked it to be in a separate
patch, so here it is.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cbffc4c..2810228 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -374,9 +374,12 @@ enum charge_type {
 };
 
 /* for encoding cft->private value on file */
-#define _MEM			(0)
-#define _MEMSWAP		(1)
-#define _OOM_TYPE		(2)
+enum res_type {
+	_MEM,
+	_MEMSWAP,
+	_OOM_TYPE,
+};
+
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
-- 
1.7.7.6

