Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab1EKVLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:11:49 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755759Ab1EKVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:40 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] fix default __strnlen_user macro
Date: Wed, 11 May 2011 16:13:48 -0400
Message-Id: <1305144843-5058-2-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-1-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing __strnlen_user macro simply resolved to strnlen. However, the
count returned by strnlen_user should include the NULL byte. This patch
fixes the __strnlen_user macro to include the NULL byte in the count.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 include/asm-generic/uaccess.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index ac68c99..1d0fdf8 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -289,7 +289,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
  * Return 0 on exception, a value greater than N if too long
  */
 #ifndef __strnlen_user
-#define __strnlen_user strnlen
+#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
 #endif
 
 static inline long strnlen_user(const char __user *src, long n)
-- 
1.6.2.5

