Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2LGLhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:37:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab2LGLhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:37:51 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 1/4] mm: remove obsolete simple_strtoul
Date: Fri,  7 Dec 2012 17:07:17 +0530
Message-Id: <1354880237-23107-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the obsolete simple_strtoul with kstrtoul API.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 mm/kmemleak.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index a217cc5..b141532 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1555,8 +1555,11 @@ static int dump_str_object_info(const char *str)
 	unsigned long flags;
 	struct kmemleak_object *object;
 	unsigned long addr;
+	int rc;
 
-	addr= simple_strtoul(str, NULL, 0);
+	rc = kstrtoul(str, 0, &addr);
+	if (rc)
+		return -EINVAL;
 	object = find_and_get_object(addr, 0);
 	if (!object) {
 		pr_info("Unknown object at 0x%08lx\n", addr);
-- 
1.7.7.6

