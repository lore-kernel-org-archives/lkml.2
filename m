Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0I3DvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:51:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab0I3DvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=osaCSPPAH8xyn5t2QjQABwgEdUK7qX8kg3OZM+Bs0eLMTWjCQ3JEwzCGGmKjZW3rIB
         239t+CAx+rwcHuCC4zARJs7VR6GO+im+LdS7JyTCtzvw1g9297u2uAUPGzsrNZrOpWaf
         zVAxgqO8qO6T1aO89wfVkR6xYfb/LjBQxQfYI=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] mm: declare some external symbols
Date: Thu, 30 Sep 2010 12:50:20 +0900
Message-Id: <1285818621-29890-12-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare 'bdi_pending_list' and 'tag_pages_for_writeback()' to remove
following sparse warnings:

 mm/backing-dev.c:46:1: warning: symbol 'bdi_pending_list' was not declared. Should it be static?
 mm/page-writeback.c:825:6: warning: symbol 'tag_pages_for_writeback' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/backing-dev.h |    1 +
 include/linux/writeback.h   |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 35b0074..8b0ae8b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -111,6 +111,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
+extern struct list_head bdi_pending_list;
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 72a5d64..c7299d2 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -149,6 +149,8 @@ int write_cache_pages(struct address_space *mapping,
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
+void tag_pages_for_writeback(struct address_space *mapping,
+			     pgoff_t start, pgoff_t end);
 
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
-- 
1.7.2.2

