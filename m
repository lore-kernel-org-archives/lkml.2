Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2LTTPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21749 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2LTTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:19 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] slob: use DIV_ROUND_UP where possible
Date: Thu, 20 Dec 2012 14:11:39 -0500
Message-Id: <1356030701-16284-31-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/slob.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slob.c b/mm/slob.c
index a99fdf7..f729c46 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -122,7 +122,7 @@ static inline void clear_slob_page_free(struct page *sp)
 }
 
 #define SLOB_UNIT sizeof(slob_t)
-#define SLOB_UNITS(size) (((size) + SLOB_UNIT - 1)/SLOB_UNIT)
+#define SLOB_UNITS(size) DIV_ROUND_UP(size, SLOB_UNIT)
 
 /*
  * struct slob_rcu is inserted at the tail of allocated slob blocks, which
-- 
1.8.0

