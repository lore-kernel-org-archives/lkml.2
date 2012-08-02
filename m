Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2HBGFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:05:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2HBGAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:00:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,698,1336320000"; 
   d="scan'208";a="5534623"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org
Subject: [RFC PATCH 05/23 V2] mm,migrate: use N_MEMORY instead N_HIGH_MEMORY
Date: Thu, 2 Aug 2012 14:01:10 +0800
Message-Id: <1343887288-8866-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/02 14:01:25,
	Serialize complete at 2012/08/02 14:01:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/migrate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index be26d5c..dbe4f86 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1226,7 +1226,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			if (node < 0 || node >= MAX_NUMNODES)
 				goto out_pm;
 
-			if (!node_state(node, N_HIGH_MEMORY))
+			if (!node_state(node, N_MEMORY))
 				goto out_pm;
 
 			err = -EACCES;
-- 
1.7.1

