Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3AGDmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:42:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59480 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab3AGDmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:42:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,421,1355068800"; 
   d="scan'208";a="6533621"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, tj@kernel.org
Cc: mingo@kernel.org, yinghai@kernel.org, liwanp@linux.vnet.ibm.com,
        benh@kernel.crashing.org, tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH v2] mm: memblock: fix wrong memmove size in memblock_merge_regions()
Date: Mon, 7 Jan 2013 11:41:36 +0800
Message-Id: <1357530096-28548-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 11:42:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/07 11:42:13,
	Serialize complete at 2013/01/07 11:42:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memmove span covers from (next+1) to the end of the array, and the index
of next is (i+1), so the index of (next+1) is (i+2). So the size of remaining
array elements is (type->cnt - (i + 2)).

Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
ChangeLog v1->v2:
- Add a comment pointed out by Tejun.
---
 mm/memblock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..88adc8a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -314,7 +314,8 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 		}
 
 		this->size += next->size;
-		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		/* move forward from next + 1, index of which is i + 2 */
+		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
 		type->cnt--;
 	}
 }
-- 
1.7.11.7

