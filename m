Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2JDMgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:36:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54831 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2JDMgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:36:33 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib: Use kmalloc_track_caller to get accurate traces for kvasprintf
Date: Thu,  4 Oct 2012 09:36:14 -0300
Message-Id: <1349354174-5560-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously kvasprintf allocation was being done through kmalloc,
thus producing an unaccurate trace report.

This is a common problem: in order to get accurate callsite tracing,
a lib/utils function shouldn't allocate kmalloc but instead
use kmalloc_track_caller.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 lib/kasprintf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kasprintf.c b/lib/kasprintf.c
index ae0de80..32f1215 100644
--- a/lib/kasprintf.c
+++ b/lib/kasprintf.c
@@ -21,7 +21,7 @@ char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
 	len = vsnprintf(NULL, 0, fmt, aq);
 	va_end(aq);
 
-	p = kmalloc(len+1, gfp);
+	p = kmalloc_track_caller(len+1, gfp);
 	if (!p)
 		return NULL;
 
-- 
1.7.8.6

