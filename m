Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1LLXNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:13:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1LLXN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:26 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 12/25] dynamic_debug: reduce lineno field to a saner 18 bits
Date: Mon, 12 Dec 2011 16:12:38 -0700
Message-Id: <1323731569-20644-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
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
index fc39640..7e3c53a 100644
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
1.7.7.3

