Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2GQMfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:35:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2GQMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:35:03 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Brice Goglin <brice@myri.com>,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4/4 v2] mm: fix possible incorrect return value of move_pages() syscall
Date: Tue, 17 Jul 2012 21:33:35 +0900
Message-Id: <1342528415-2291-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342528415-2291-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1342528415-2291-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_pages() syscall may return success in case that
do_move_page_to_node_array return positive value which means migration failed.
This patch changes return value of do_move_page_to_node_array
for not returning positive value. It can fix the problem.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Brice Goglin <brice@myri.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan@kernel.org>

diff --git a/mm/migrate.c b/mm/migrate.c
index f495c58..eeaf409 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1172,7 +1172,7 @@ set_status:
 	}
 
 	up_read(&mm->mmap_sem);
-	return err;
+	return err > 0 ? -EBUSY : err;
 }
 
 /*
-- 
1.7.9.5

