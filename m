Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0IBRAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:00:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0IBRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YbUT9Sy02ZnBpmolPOU1VKaUPiwpEZuFGXA4cFkawYITOhKApU5MIfSKl3IIAa2Dlr
         clVg7G9RrMIE6gGwSDp1MKCzkcGVtAx5NbgY2Dv2zRKPDrIypxM3ppWtzQVbSLNqOfMk
         df4L+lrMZF2oZMV0HQtcmqWHV3JTWw6KIVBdc=
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ida: fix up bitmap size calculation
Date: Fri,  3 Sep 2010 02:00:29 +0900
Message-Id: <1283446829-24050-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ida chunk should consist of 128 bytes (= 1024 bits) by definition
but because of wrong calculation of IDA_BITMAP_LONGS it only contained
992 on 32-bit machines, 960 on 64-bit machines. Fix it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/idr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e968db7..13c7296 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -119,8 +119,8 @@ void idr_init(struct idr *idp);
  * pointer isn't necessary.
  */
 #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
-#define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
-#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
+#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long))
+#define IDA_BITMAP_BITS 	(IDA_CHUNK_SIZE * 8)
 
 struct ida_bitmap {
 	long			nr_busy;
-- 
1.7.2.2

