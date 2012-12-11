Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2LKOpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:45:24 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42966 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2LKOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:45:22 -0500
From: dingel@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH] remove unused code from do_wp_page
Date: Tue, 11 Dec 2012 15:44:50 +0100
Message-Id: <1355237090-52434-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
x-cbid: 12121114-5024-0000-0000-000004A6E6AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

page_mkwrite is initalized with zero and only set once, from that point exists no way to get to the oom or oom_free_new labels.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 mm/memory.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 221fc9f..c322708 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2795,10 +2795,6 @@ oom_free_new:
 	page_cache_release(new_page);
 oom:
 	if (old_page) {
-		if (page_mkwrite) {
-			unlock_page(old_page);
-			page_cache_release(old_page);
-		}
 		page_cache_release(old_page);
 	}
 	return VM_FAULT_OOM;
-- 
1.7.12.4

