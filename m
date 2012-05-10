Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2EJVKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:10:00 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:57524 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758497Ab2EJVJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:09:57 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org
Subject: [PATCH] use linux/bitops.h instead of linux/log2.h to get fls()
Date: Thu, 10 May 2012 22:49:11 +0200
Message-ID: <1953408.KQLKiNB2bP@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <3154414.psmJh6J2U2@donald.sf-tec.de>
References: <3154414.psmJh6J2U2@donald.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since d66acc39c7cee323733c8503b9de1821a56dff7e (bitops: Optimise get_order())
getorder.h includes log2.h to get fls() and fls64(). They are not defined in
log2.h, but in bitops.h. This works since log2.h includes bitops.h, but we
should do it properly to not get any bad surprises if log2.h changes.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 include/asm-generic/getorder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/getorder.h b/include/asm-generic/getorder.h
index 65e4468..563114f 100644
--- a/include/asm-generic/getorder.h
+++ b/include/asm-generic/getorder.h
@@ -4,7 +4,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
-#include <linux/log2.h>
+#include <linux/bitops.h>
 
 /*
  * Runtime evaluation of get_order()
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
