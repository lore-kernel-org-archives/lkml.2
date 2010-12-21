Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab0LUKKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:10:00 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:49504 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab0LUKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:09:59 -0500
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 05:09:59 EST
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org,
        Stefan Schmidt <stefan@datenfreihafen.org>
Date: Tue, 21 Dec 2010 10:42:06 +0100
Message-Id: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH] block/cciss: Close continue statement with semicolon to fix build
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following build error:
drivers/block/cciss.c: In function ‘cciss_revalidate’:
drivers/block/cciss.c:2839: error: expected ‘;’ before ‘if’
make[2]: *** [drivers/block/cciss.o] Error 1

Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
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
1.7.2.3

