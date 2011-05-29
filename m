Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1E2UqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:46:21 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:38700 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1E2UqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:46:20 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 16:46:19 EDT
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: Minchan Kim <minchan.kim@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger@sun.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] cleancache: use __read_mostly for cleancache_enabled
Date: Sun, 29 May 2011 17:38:18 -0300
Message-Id: <1306701498-10846-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global variable cleancache_enabled is read often but written to
rarely. Use __read_mostly to prevent it being on the same cacheline as
another variable which is written to often, which would cause cacheline
bouncing.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 include/linux/cleancache.h |    2 +-
 mm/cleancache.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 04ffb2e..83fffe8 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -42,7 +42,7 @@ extern void __cleancache_put_page(struct page *);
 extern void __cleancache_flush_page(struct address_space *, struct page *);
 extern void __cleancache_flush_inode(struct address_space *);
 extern void __cleancache_flush_fs(struct super_block *);
-extern int cleancache_enabled;
+extern int cleancache_enabled __read_mostly;
 
 #ifdef CONFIG_CLEANCACHE
 static inline bool cleancache_fs_enabled(struct page *page)
diff --git a/mm/cleancache.c b/mm/cleancache.c
index bcaae4c..a3d7a22 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -24,7 +24,7 @@
  * disabled), so is preferred to the slower alternative: a function
  * call that checks a non-global.
  */
-int cleancache_enabled;
+int cleancache_enabled __read_mostly;
 EXPORT_SYMBOL(cleancache_enabled);
 
 /*
-- 
1.7.4.4

