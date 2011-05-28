Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1E1Rh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:37:26 -0400
Received: from mail.perches.com ([173.55.12.10]:2246 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab1E1RhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:24 -0400
From: Joe Perches <joe@perches.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-mm@kvack.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 14/15] mm: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:34 -0700
Message-Id: <f3d616b526e00bd8f01a250b7ce8c5a6e2412768.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/page_cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 74ccff6..dbb28fd 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -478,11 +478,10 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
 	array_size = length * sizeof(void *);
 
-	array = vmalloc(array_size);
+	array = vzalloc(array_size);
 	if (!array)
 		goto nomem;
 
-	memset(array, 0, array_size);
 	ctrl = &swap_cgroup_ctrl[type];
 	mutex_lock(&swap_cgroup_mutex);
 	ctrl->length = length;
-- 
1.7.5.rc3.dirty

