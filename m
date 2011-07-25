Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1GYVog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:44:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39747 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1GYVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:56 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 24/25] dynamic_debug: drop pr_fmt() from dynamic_pr_debug
Date: Mon, 25 Jul 2011 15:42:49 -0600
Message-Id: <1311630170-26057-25-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_pr_debug can add module, function, file, and line selectively,
theres no need to also add them via macro.  Moreover, adding them
via the macro, which is useful for pr_info and friends, causes
pr_debug to double-print those fields added by the flag-settings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 8f46a5d..6fd10ab 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -65,7 +65,7 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 #define dynamic_pr_debug(fmt, ...) do {					\
 	DYNAMIC_DEBUG_METADATA(fmt);					\
 	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
+		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
-- 
1.7.4.1

