Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab2AFVG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:06:29 -0500
Received: from static.213.204.9.176.clients.your-server.de ([176.9.204.213]:40720
	"EHLO shutemov.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab2AFVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:06:24 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [RESEND, PATCH 3/6] memcg: mark stat field of mem_cgroup struct as __percpu
Date: Fri,  6 Jan 2012 22:57:49 +0200
Message-Id: <1325883472-5614-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

It fixes a lot of sparse warnings.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 39c3d60..831cdc4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -282,7 +282,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 	/*
 	 * used when a cpu is offlined or other synchronizations
 	 * See mem_cgroup_read_stat().
-- 
1.7.8.2

