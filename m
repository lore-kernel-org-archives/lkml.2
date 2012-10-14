Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2JNSN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:13:59 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46156 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2JNSN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:13:58 -0400
From: Fabio Estevam <festevam@gmail.com>
To: akpm@linux-foundation.org
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, markus@oberhumer.com,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] lib: decompress_unlzo: Change include file name
Date: Sun, 14 Oct 2012 15:13:10 -0300
Message-Id: <1350238390-1549-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Commit 7c979cebc (lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c) 
renamed lzo1x_decompress.c file, but missed to update lib/decompress_unlzo.c,
which breaks imx_v6_v7_defconfig build:

arch/arm/boot/compressed/../../../../lib/decompress_unlzo.c:34:34: fatal error: lzo/lzo1x_decompress.c: No such file or directory

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 lib/decompress_unlzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index 4531294..960183d 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -31,7 +31,7 @@
  */
 
 #ifdef STATIC
-#include "lzo/lzo1x_decompress.c"
+#include "lzo/lzo1x_decompress_safe.c"
 #else
 #include <linux/decompress/unlzo.h>
 #endif
-- 
1.7.9.5

