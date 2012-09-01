Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2IAJRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:17:15 -0400
Received: from gn237.zone.eu ([217.146.67.237]:54694 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab2IAJRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:17:08 -0400
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Priit Laes <plaes@plaes.org>
Subject: [PATCH 11/14] staging: csr: unifi_wext.h: Remove KERNEL_VERSION checks
Date: Sat,  1 Sep 2012 12:06:07 +0300
Message-Id: <1346490370-32438-12-git-send-email-plaes@plaes.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346490370-32438-1-git-send-email-plaes@plaes.org>
References: <1346490370-32438-1-git-send-email-plaes@plaes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/staging/csr/unifi_wext.h | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/csr/unifi_wext.h b/drivers/staging/csr/unifi_wext.h
index 6d7a995..beba089 100644
--- a/drivers/staging/csr/unifi_wext.h
+++ b/drivers/staging/csr/unifi_wext.h
@@ -70,15 +70,9 @@ uf_iwe_stream_add_point(struct iw_request_info *info, char *start, char *stop,
 {
     char *new_start;
 
-    new_start = iwe_stream_add_point(
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27) || defined (IW_REQUEST_FLAG_COMPAT)
-                                     info,
-#endif
-                                     start, stop, piwe, extra);
+    new_start = iwe_stream_add_point(info, start, stop, piwe, extra);
     if (unlikely(new_start == start))
-    {
         return -E2BIG;
-    }
 
     return (new_start - start);
 }
@@ -90,14 +84,9 @@ uf_iwe_stream_add_event(struct iw_request_info *info, char *start, char *stop,
 {
     char *new_start;
 
-    new_start = iwe_stream_add_event(
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27) || defined(IW_REQUEST_FLAG_COMPAT)
-                                     info,
-#endif
-                                     start, stop, piwe, len);
-    if (unlikely(new_start == start)) {
+    new_start = iwe_stream_add_event(info, start, stop, piwe, len);
+    if (unlikely(new_start == start))
         return -E2BIG;
-    }
 
     return (new_start - start);
 }
@@ -108,14 +97,9 @@ uf_iwe_stream_add_value(struct iw_request_info *info, char *stream, char *start,
 {
     char *new_start;
 
-    new_start = iwe_stream_add_value(
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27) || defined(IW_REQUEST_FLAG_COMPAT)
-                                     info,
-#endif
-                                     stream, start, stop, piwe, len);
-    if (unlikely(new_start == start)) {
+    new_start = iwe_stream_add_value(info, stream, start, stop, piwe, len);
+    if (unlikely(new_start == start))
         return -E2BIG;
-    }
 
     return (new_start - start);
 }
-- 
1.7.12

