Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2GYDST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:18:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59049 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2GYDSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:18:18 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, Willy Tarreau <willy@meta-x.org>,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/panel: fix checkpatch warnings
Date: Wed, 25 Jul 2012 12:18:12 +0900
Message-Id: <1343186292-9740-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now checkpatch clean.

$ find drivers/staging/panel -name "*.[ch]"|xargs ./scripts/checkpatch.pl \
-f --terse --nosummary|cut -f3- -d":"|sort |uniq -c|sort -n

2  WARNING: Single statement macros should not use a do {} while (0) loop

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/panel/panel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 39f9982..d9fec5b 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -137,8 +137,8 @@
 #define r_ctr(x)        (parport_read_control((x)->port))
 #define r_dtr(x)        (parport_read_data((x)->port))
 #define r_str(x)        (parport_read_status((x)->port))
-#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
-#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
+#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
+#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))
 
 /* this defines which bits are to be used and which ones to be ignored */
 /* logical or of the output bits involved in the scan matrix */
-- 
1.7.5.4

