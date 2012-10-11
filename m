Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2JKAil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:38:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49446 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933015Ab2JKAif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:38:35 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19Yk1oqPKNYByKnx9XXl0zqRwB3rmhP+3M2ztMj29
	3aoj6Qa5o6SXQ/
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Damien Cassou <damien.cassou@lifl.fr>
Subject: [PATCH] gbefb: fix compile error
Date: Thu, 11 Oct 2012 00:38:52 +0000
Message-Id: <1349915932-3598-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <505B9196.3040203@gmx.de>
References: <505B9196.3040203@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "drivers/video/gbefb.c: use devm_ functions" caused a
compile error.

drivers/video/gbefb.c:1159:16: error: implicit declaration of function
'devm_ioremap' [-Werror=implicit-function-declaration]
drivers/video/gbefb.c:1179:3: error: implicit declaration of function
'devm_ioremap_nocache' [-Werror=implicit-function-declaration]

Fix it by including linux/io.h which defines those functions.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Damien Cassou <damien.cassou@lifl.fr>
---
 drivers/video/gbefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index 9b79d38..8dc1f7a 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/io.h>
 
 #ifdef CONFIG_X86
 #include <asm/mtrr.h>
@@ -28,7 +29,6 @@
 #include <asm/addrspace.h>
 #endif
 #include <asm/byteorder.h>
-#include <asm/io.h>
 #include <asm/tlbflush.h>
 
 #include <video/gbe.h>
-- 
1.7.10.4

