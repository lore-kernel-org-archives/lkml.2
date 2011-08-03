Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1HCT7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:59:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35071 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1HCT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:59:04 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: joe@perches.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 44/48] dynamic_debug: add space unconditionally at end of dynamic-prefix
Date: Wed,  3 Aug 2011 13:58:34 -0600
Message-Id: <1312401514-20061-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312401514-20061-1-git-send-email-jim.cromie@gmail.com>
References: <1312401514-20061-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_emit_prefix() currently adds a space after line-number,
but not otherwize.  For readability, add space unconditionally.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 321c1b70..d7494a0 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -676,7 +676,8 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
 		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
+		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
+	pos += snprintf(buf + pos, LEFT(pos), " ");
 
 	return buf;
 }
-- 
1.7.4.1

