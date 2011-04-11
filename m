Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1DKHfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:35:08 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:36022 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1DKHfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:35:06 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: about __BITS_PER_LONG
Date: Mon, 11 Apr 2011 15:34:55 +0800
Message-ID: <003f01cbf81a$f48cfdf0$dda6f9d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acv4GN3kM6fXItETRlGmbhO0q6WGSQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd:

  When using asm-generic/bitsperlong.h, I think that __BITS_PER_LONG could be the
same as BITS_PER_LONG if-not-defined. And this could avoid the duplicated macros
in almost all architectures.

Regards.

Guan Xuetao

---
diff --git a/include/asm-generic/bitsperlong.h b/include/asm-generic/bitsperlong.h
index 4ae54e0..31d032a 100644
--- a/include/asm-generic/bitsperlong.h
+++ b/include/asm-generic/bitsperlong.h
@@ -9,7 +9,11 @@
  * to decide it, but rather check a compiler provided macro.
  */
 #ifndef __BITS_PER_LONG
-#define __BITS_PER_LONG 32
+#   ifdef CONFIG_64BIT
+#	define __BITS_PER_LONG 64
+#   else
+#	define __BITS_PER_LONG 32
+#   endif /* CONFIG_64BIT */
 #endif
 
 #ifdef __KERNEL__

