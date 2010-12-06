Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0LFWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:43 -0500
Received: from mail.perches.com ([173.55.12.10]:2338 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/29] fs/proc: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:09 -0800
Message-Id: <e7278094df9f79b68aba4aeec043792a9f811afd.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/generic.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index dd29f03..eedc3fe 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -585,8 +585,8 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
-				dir->name, dp->name);
+			WARN(1, "proc_dir_entry '%s/%s' already registered\n",
+			     dir->name, dp->name);
 			break;
 		}
 
@@ -855,9 +855,8 @@ continue_removing:
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
-	WARN(de->subdir, KERN_WARNING "%s: removing non-empty directory "
-			"'%s/%s', leaking at least '%s'\n", __func__,
-			de->parent->name, de->name, de->subdir->name);
+	WARN(de->subdir, "%s: removing non-empty directory '%s/%s', leaking at least '%s'\n",
+	     __func__, de->parent->name, de->name, de->subdir->name);
 	pde_put(de);
 }
 EXPORT_SYMBOL(remove_proc_entry);
-- 
1.7.3.2.245.g03276.dirty

