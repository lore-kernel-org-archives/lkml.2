Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2BCNnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:43:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2BCNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:43:15 -0500
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>, Ram Pai <linuxram@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [Patch] resource: move EXPORT_SYMBOL right after definition
Date: Fri,  3 Feb 2012 21:42:39 +0800
Message-Id: <1328276573-15265-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL(adjust_resource) should be right after adjust_resource().

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/kernel/resource.c b/kernel/resource.c
index 7640b3a..7e8ea66 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -749,6 +749,7 @@ int adjust_resource(struct resource *res, resource_size_t start, resource_size_t
 	write_unlock(&resource_lock);
 	return result;
 }
+EXPORT_SYMBOL(adjust_resource);
 
 static void __init __reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
@@ -792,8 +793,6 @@ void __init reserve_region_with_split(struct resource *root,
 	write_unlock(&resource_lock);
 }
 
-EXPORT_SYMBOL(adjust_resource);
-
 /**
  * resource_alignment - calculate resource's alignment
  * @res: resource pointer
