Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab0FQJdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:33:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64564 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab0FQJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IzZZboiuU3NqRA7ZnTzbvQw75jBCx47hqV5Yxx6Esxs0hru1dOR+R36TRUFCCFiynv
         E2KQd6qs4I/cLNQcnl6d/nC/uUNZkJQZCQwJ/n+Rht4TyazCuuUSUHtzP/8FHBPEsWZ+
         b7LcMsUfVOF7i5zFqyIs4iOpk4mxWLn6Sq/KI=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] kgdb: remove custom hex_to_bin() implementation
Date: Thu, 17 Jun 2010 12:33:35 +0300
Message-Id: <1276767215-4217-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Martin Hicks <mort@sgi.com>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 kernel/debug/gdbstub.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 4b17b32..d721b1b 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -52,17 +52,6 @@ static unsigned long		gdb_regs[(NUMREGBYTES +
  * GDB remote protocol parser:
  */
 
-static int hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
 #ifdef CONFIG_KGDB_KDB
 static int gdbstub_read_wait(void)
 {
@@ -123,8 +112,8 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(gdbstub_read_wait()) << 4;
-			xmitcsum += hex(gdbstub_read_wait());
+			xmitcsum = hex_to_bin(gdbstub_read_wait()) << 4;
+			xmitcsum += hex_to_bin(gdbstub_read_wait());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
@@ -280,8 +269,8 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 	tmp_hex = tmp_raw - 1;
 	while (tmp_hex >= buf) {
 		tmp_raw--;
-		*tmp_raw = hex(*tmp_hex--);
-		*tmp_raw |= hex(*tmp_hex--) << 4;
+		*tmp_raw = hex_to_bin(*tmp_hex--);
+		*tmp_raw |= hex_to_bin(*tmp_hex--) << 4;
 	}
 
 	return probe_kernel_write(mem, tmp_raw, count);
@@ -304,7 +293,7 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
 		(*ptr)++;
 	}
 	while (**ptr) {
-		hex_val = hex(**ptr);
+		hex_val = hex_to_bin(**ptr);
 		if (hex_val < 0)
 			break;
 
-- 
1.6.3.3

