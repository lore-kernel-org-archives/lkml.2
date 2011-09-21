Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1IUV53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:57:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1IUV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:56:46 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 24/26] dynamic_debug: reduce lineno field to a saner 18 bits
Date: Wed, 21 Sep 2011 15:55:13 -0600
Message-Id: <1316642115-20029-25-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

lineno:24 allows files with 4 million lines, an insane file-size, even
for never-to-get-in-tree machine generated code.  Reduce this to 18
bits, which still allows 256k lines.  This is still insanely big, but
its not raving mad.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 2c9c476..5622e04 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -15,7 +15,7 @@ struct _ddebug {
 	const char *function;
 	const char *filename;
 	const char *format;
-	unsigned int lineno:24;
+	unsigned int lineno:18;
 	/*
  	 * The flags field controls the behaviour at the callsite.
  	 * The bits here are changed dynamically when the user
-- 
1.7.4.4

