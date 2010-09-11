Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0IKNiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 09:38:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63483 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0IKNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 09:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uGxQwP7Vel0zGe/G5RO4NadwDC1Bg4i1YuYVMxfuzL0Hub6+qf9LHYMnCBK+QdR+rb
         HtjL1BUXp+G7jQLRwZ3LM0fGV82kBZVS38UQ2tt/gtROlg0eg+1trw/lzOG7N7sarY/5
         NIR8QH0GIrEAqPljIJe8iuQXYABkplFvZGPfY=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] drivers: scsi: remove private hex_to_bin() implementation
Date: Sat, 11 Sep 2010 16:38:00 +0300
Message-Id: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/libsas/sas_scsi_host.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0cfba9..527dcf7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1078,14 +1078,10 @@ void sas_target_destroy(struct scsi_target *starget)
 static void sas_parse_addr(u8 *sas_addr, const char *p)
 {
 	int i;
-	for (i = 0; i < SAS_ADDR_SIZE; i++) {
+	for (i = 0; i < SAS_ADDR_SIZE && *p; i++) {
 		u8 h, l;
-		if (!*p)
-			break;
-		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
-		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
+		h = hex_to_bin(*p++);
+		l = hex_to_bin(*p++);
 		sas_addr[i] = (h<<4) | l;
 	}
 }
-- 
1.7.2.2

