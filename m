Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab1JGUfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:35:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51628 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab1JGUfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:35:12 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 26/26] printk.h: fix pr_cont_once() to not use pr_fmt()
Date: Fri,  7 Oct 2011 14:33:32 -0600
Message-Id: <1318019612-20068-27-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

pr_cont() doesnt use pr_fmt(), since it continues printing a single
line, and the prefix has already been done.  Fix pr_cont_once() to do
the same.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/printk.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e21de7e..4ba6cde 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -255,7 +255,7 @@ extern void dump_stack(void) __cold;
 #define pr_info_once(fmt, ...)					\
 	printk_once(KERN_INFO pr_fmt_info(fmt), ##__VA_ARGS__)
 #define pr_cont_once(fmt, ...)					\
-	printk_once(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
+	printk_once(KERN_CONT fmt, ##__VA_ARGS__)
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug_once(fmt, ...)					\
-- 
1.7.4.4

