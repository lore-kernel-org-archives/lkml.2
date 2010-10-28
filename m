Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376Ab0J1SbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:31:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40299 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761286Ab0J1Sax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:30:53 -0400
Date: Thu, 28 Oct 2010 20:30:51 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] mac/m68k: adb-iop - flags should be unsigned long
Message-ID: <alpine.DEB.2.00.1010282029540.29755@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/macintosh/adb-iop.c: In function ¡adb_iop_complete¢:
drivers/macintosh/adb-iop.c:85: warning: comparison of distinct pointer types lacks a cast
drivers/macintosh/adb-iop.c:92: warning: comparison of distinct pointer types lacks a cast
drivers/macintosh/adb-iop.c: In function ¡adb_iop_listen¢:
drivers/macintosh/adb-iop.c:111: warning: comparison of distinct pointer types lacks a cast
drivers/macintosh/adb-iop.c:151: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/macintosh/adb-iop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index 4446966..f5f4da3 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -80,7 +80,7 @@ static void adb_iop_end_req(struct adb_request *req, int state)
 static void adb_iop_complete(struct iop_msg *msg)
 {
 	struct adb_request *req;
-	uint flags;
+	unsigned long flags;
 
 	local_irq_save(flags);
 
@@ -103,7 +103,7 @@ static void adb_iop_listen(struct iop_msg *msg)
 {
 	struct adb_iopmsg *amsg = (struct adb_iopmsg *) msg->message;
 	struct adb_request *req;
-	uint flags;
+	unsigned long flags;
 #ifdef DEBUG_ADB_IOP
 	int i;
 #endif
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
