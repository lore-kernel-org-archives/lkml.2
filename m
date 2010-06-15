Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0FOOcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:32:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64937 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab0FOOcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:32:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Usvgw9P9g/dgd7RbimCv3c3+t20OzN8GR5BGuCVKgkCFi/ZXwd8l8wuaa6No4whQS5
         blUHIadkkeb3OKjV3NAJgt4mgamZpNJo2+hEjYEY6zCO6ETgwu4NjWcfDPrUYTFCa9cy
         Orgo3gCPYFTsuT5nZ4qAfoPUkrw38+Paary2M=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH] drivers: vt: clean up the code - use kernel library
Date: Tue, 15 Jun 2010 17:24:16 +0300
Message-Id: <1276611856-28232-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/char/vt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 7cdb6ee..1ff87fa 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/ctype.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -1789,8 +1790,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state = ESnormal;
 		return;
 	case ESpalette:
-		if ( (c>='0'&&c<='9') || (c>='A'&&c<='F') || (c>='a'&&c<='f') ) {
-			vc->vc_par[vc->vc_npar++] = (c > '9' ? (c & 0xDF) - 'A' + 10 : c - '0');
+		if (isxdigit(c)) {
+			vc->vc_par[vc->vc_npar++] = hex_to_bin(c);
 			if (vc->vc_npar == 7) {
 				int i = vc->vc_par[0] * 3, j = 1;
 				vc->vc_palette[i] = 16 * vc->vc_par[j++];
-- 
1.6.6.1

