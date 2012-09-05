Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab2IEMRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:17:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39658 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab2IEMRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:17:47 -0400
From: yan <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3 v2] proc: use kzalloc instead of kmalloc and memset
Date: Wed,  5 Sep 2012 20:17:17 +0800
Message-Id: <1346847437-3308-4-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
References: <1346847437-3308-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the memory will be written twice after this change, but that 
should be negligible.

Signed-off-by: yan <clouds.yan@gmail.com>
---
 fs/proc/generic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 9e8f631..38de015 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -616,10 +616,9 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 
 	len = strlen(fn);
 
-	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
 	if (!ent) goto out;
 
-	memset(ent, 0, sizeof(struct proc_dir_entry));
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
-- 
1.7.9.5

