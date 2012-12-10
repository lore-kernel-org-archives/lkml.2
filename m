Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2LJLbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:31:44 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32825 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2LJLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:31:42 -0500
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com> (maintainer:KMEMLEAK),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        linux-kernel@vger.kernel.org (open list)
Cc: Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH RESEND 1/4] mm: remove obsolete simple_strtoul
Date: Mon, 10 Dec 2012 17:00:07 +0530
Message-Id: <1355139007-10012-1-git-send-email-abhi.c.pawar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the obsolete simple_strtoul with kstrtoul API.

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 mm/kmemleak.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index a217cc5..752a705 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1556,7 +1556,8 @@ static int dump_str_object_info(const char *str)
 	struct kmemleak_object *object;
 	unsigned long addr;
 
-	addr= simple_strtoul(str, NULL, 0);
+	if (kstrtoul(str, 0, &addr))
+		return -EINVAL;
 	object = find_and_get_object(addr, 0);
 	if (!object) {
 		pr_info("Unknown object at 0x%08lx\n", addr);
-- 
1.7.7.6

