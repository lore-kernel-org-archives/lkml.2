Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab0LUBbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:31:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35522 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab0LUBa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:30:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=IcXn7j42ugbpbQo6n+I3FN1v+mDZKzEMqeEKKrDFaMQCFB9XzvKbNVubWgNqnw82ls
         P9zaPKuUyT9TssXU1btOO7TPDv8+d3qG7Y2sFKj4sygSx+ImO6+eMlvgQHi6Bd6YM6Xx
         F+fstLegnboR0k2lu8FACSBVh2Tt3cTwFk8aQ=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: [PATCH] drivers/block/cciss.c: Fix compiling error by adding ';' at the end of continue statement.
Date: Mon, 20 Dec 2010 23:24:05 -0200
Message-Id: <d1169c43a6baf75fe24f97c8c535288759354af5.1292894545.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the following error:

drivers/block/cciss.c: In function ‘cciss_revalidate’:
drivers/block/cciss.c:2839: error: expected ‘;’ before ‘if’
make[2]: *** [drivers/block/cciss.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [drivers/block] Error 2

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 233e06c..8e0f925 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2835,7 +2835,7 @@ static int cciss_revalidate(struct gendisk *disk)
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
 		if (!h->drv[logvol])
-			continue
+			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
-- 
1.7.3.2.343.g7d43d

