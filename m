Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540Ab2AFVG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:06:26 -0500
Received: from static.213.204.9.176.clients.your-server.de ([176.9.204.213]:40724
	"EHLO shutemov.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162Ab2AFVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:06:24 -0500
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jan 2012 16:06:24 EST
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, <stable@kernel.org>
Subject: [RESEND, PATCH 4/6] memcg: fix broken boolean expression
Date: Fri,  6 Jan 2012 22:57:50 +0200
Message-Id: <1325883472-5614-4-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 831cdc4..0b5a3f8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2085,7 +2085,7 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	for_each_mem_cgroup(iter)
-- 
1.7.8.2

