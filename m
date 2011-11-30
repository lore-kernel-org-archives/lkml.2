Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1K3CPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:15:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45708 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637Ab1K3CPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:15:05 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/28] bio: Use current logging styles
Date: Tue, 29 Nov 2011 18:14:01 -0800
Message-Id: <10b5b92988f745e2c331397b3975ad69070cf703.1322609672.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use pr_fmt and pr_<level>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/bio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b1fe82c..98acfb1 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -15,6 +15,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/bio.h>
@@ -111,7 +114,7 @@ static struct kmem_cache *bio_find_or_create_slab(unsigned int extra_size)
 	if (!slab)
 		goto out_unlock;
 
-	printk(KERN_INFO "bio: create slab <%s> at %d\n", bslab->name, entry);
+	pr_info("create slab <%s> at %d\n", bslab->name, entry);
 	bslab->slab = slab;
 	bslab->slab_ref = 1;
 	bslab->slab_size = sz;
-- 
1.7.6.405.gc1be0

