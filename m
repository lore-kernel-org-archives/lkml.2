Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab2CaTXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:23:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38562 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2CaTXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:23:13 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] debugobjects: Use GFP_ATOMIC to allocate when initializing
Date: Sat, 31 Mar 2012 17:22:52 -0400
Message-Id: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the init stage, we have only 1 cpu and run with IRQs disabled,
we can't allocate with GFP_KERNEL.

This also fixes the related warning on boot.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 lib/debugobjects.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 0ab9ae8..ece5e06 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -1020,7 +1020,7 @@ static int __init debug_objects_replace_static_objects(void)
 	int i, cnt = 0;
 
 	for (i = 0; i < ODEBUG_POOL_SIZE; i++) {
-		obj = kmem_cache_zalloc(obj_cache, GFP_KERNEL);
+		obj = kmem_cache_zalloc(obj_cache, GFP_ATOMIC);
 		if (!obj)
 			goto free;
 		hlist_add_head(&obj->node, &objects);
-- 
1.7.8.5

