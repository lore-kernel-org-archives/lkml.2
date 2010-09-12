Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0ILS5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 14:57:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41655 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0ILS5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 14:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ij5bn1uOK3R2w9ITzLh+uGyFNXi5V3UmexGispzyXpMCNn0qQNbQ/sM+QSZdzTHf+W
         MLXW0T6wdRpSqN+mY6innn1qWLzozSuFNBOvzeAiu2e2VHfjOfg33ZAdNmNWCnrmOGea
         e+Dzyir3n6XeXUtnyT/12HkZnu5eVuGk/z+mE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mundt <lethal@linux-sh.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] char: hvc: check for error case
Date: Sun, 12 Sep 2010 22:57:14 +0400
Message-Id: <1284317835-5086-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hvc_alloc() may fail, if so exit from init() with error.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I cannot compile this driver at all, so it is not tested.

 drivers/char/hvc_tile.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hvc_tile.c b/drivers/char/hvc_tile.c
index c4efb55..7a84a05 100644
--- a/drivers/char/hvc_tile.c
+++ b/drivers/char/hvc_tile.c
@@ -61,7 +61,8 @@ console_initcall(hvc_tile_console_init);
 
 static int __init hvc_tile_init(void)
 {
-	hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
-	return 0;
+	struct hvc_struct *s;
+	s = hvc_alloc(0, 0, &hvc_tile_get_put_ops, 128);
+	return IS_ERR(s) ? PTR_ERR(s) : 0;
 }
 device_initcall(hvc_tile_init);
-- 
1.7.0.4

