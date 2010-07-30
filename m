Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab0G3TSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:18:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:33897 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633Ab0G3TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 01/15] kgdb: remove custom hex_to_bin()implementation
Date: Fri, 30 Jul 2010 14:17:22 -0500
Message-Id: <1280517456-1167-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:40.0298 (UTC) FILETIME=[E0BDDAA0:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/gdbstub.c |   21 +++++----------------
 1 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index e8fd686..3517fd7 100644
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
1.6.4.rc1

