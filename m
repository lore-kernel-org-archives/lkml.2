Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab0J1Veh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611Ab0J1Vd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:33:29 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 19/20] fs/notify/fanotify/fanotify_user.c: fix warnings
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:33:25 -0400
Message-ID: <20101028213325.24810.54488.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

fs/notify/fanotify/fanotify_user.c: In function 'fanotify_release':
fs/notify/fanotify/fanotify_user.c:375: warning: unused variable 'lre'
fs/notify/fanotify/fanotify_user.c:375: warning: unused variable 're'

this is really ugly.

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index fa71d5d..fce66df 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -376,11 +376,10 @@ static ssize_t fanotify_write(struct file *file, const char __user *buf, size_t
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
-	struct fanotify_response_event *re, *lre;
-
-	pr_debug("%s: file=%p group=%p\n", __func__, file, group);
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+	struct fanotify_response_event *re, *lre;
+
 	mutex_lock(&group->fanotify_data.access_mutex);
 
 	group->fanotify_data.bypass_perm = true;

