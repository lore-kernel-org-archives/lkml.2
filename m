Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1LXDAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 22:00:34 -0500
Received: from shutemov.name ([188.40.19.243]:42443 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab1LXDA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 22:00:26 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 4/6] memcg: mark stat field of mem_cgroup struct as __percpu
Date: Sat, 24 Dec 2011 05:00:17 +0200
Message-Id: <1324695619-5537-4-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

It fixes a lot of sparse warnings.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 627c19e..b27ce0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -291,7 +291,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 	/*
 	 * used when a cpu is offlined or other synchronizations
 	 * See mem_cgroup_read_stat().
-- 
1.7.7.3

