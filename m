Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2GIVfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:35:46 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:55951 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab2GIVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:35:44 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2012 17:35:44 EDT
From: minyard@acm.org
To: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        linux-sh@vger.kernel.org
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] SH: Convert out[bwl] macros to inline functions
Date: Mon, 09 Jul 2012 15:35:20 -0500
Message-id: <1341866120-18640-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The macros just called BUG(), but that results in unused variable
warnings all over the place, like in the IPMI driver.  The build
regression emails were annoying me, so here's the fix.  I have
not even compile tested this, but it's rather obvious.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 arch/sh/include/asm/io_noioport.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/sh/include/asm/io_noioport.h b/arch/sh/include/asm/io_noioport.h
index e136d28..8cf7084 100644
--- a/arch/sh/include/asm/io_noioport.h
+++ b/arch/sh/include/asm/io_noioport.h
@@ -19,9 +19,20 @@ static inline u32 inl(unsigned long addr)
 	return -1;
 }
 
-#define outb(x, y)	BUG()
-#define outw(x, y)	BUG()
-#define outl(x, y)	BUG()
+static inline void outb(unsigned char x, unsigned int port)
+{
+	BUG();
+}
+
+static inline void outw(unsigned short x, unsigned int port)
+{
+	BUG();
+}
+
+static inline void outl(unsigned int x, unsigned int port)
+{
+	BUG();
+}
 
 #define inb_p(addr)	inb(addr)
 #define inw_p(addr)	inw(addr)
-- 
1.7.4.1

