Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0J3VMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:12:24 -0400
Received: from mail.perches.com ([173.55.12.10]:3785 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab0J3VJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/39] fs/proc: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:44 -0700
Message-Id: <37f22dd5a0a84e5e0a5436899312a3d2c3c92dc9.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
1.7.3.1.g432b3.dirty

