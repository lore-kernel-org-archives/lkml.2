Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0JWRG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:06:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40450 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab0JWRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aSn9decfnIi/8u+yVW4TYcQpZJC2oBNzmf34UvH5wNkDmD8aNit5zpnnJIexIJP89f
         1ilx/IGyOCfTySPFihJpaN66ySiuSlibeIk1vuol0aAURnC2HV05Dpd3r2xFIr4wlDLS
         +7qUW/K9w+498HoRKsPdnAmGqUPHSkJsJSJFo=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/buffer.c: change buffer_busy() to use logical-OR expression
Date: Sun, 24 Oct 2010 02:06:15 +0900
Message-Id: <1287853575-14190-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert bitwise-OR operator to logical-OR in favor of short-circuit
evaluation. The end result would be same.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f5755f7..4362e77 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3069,7 +3069,7 @@ EXPORT_SYMBOL(sync_dirty_buffer);
  */
 static inline int buffer_busy(struct buffer_head *bh)
 {
-	return atomic_read(&bh->b_count) |
+	return atomic_read(&bh->b_count) ||
 		(bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
 }
 
-- 
1.7.0.4

