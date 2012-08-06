Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2HFVMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:12:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56716 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2HFVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:12:03 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: andrzej.p@samsung.com, lockwood@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging:ccg: Fix missing brackets for sizeof (found by sparse).
Date: Mon,  6 Aug 2012 23:11:49 +0200
Message-Id: <1344287509-4945-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following:
WARNING: sizeof fsg should be sizeof(fsg)
+	memset(&fsg, 0, sizeof fsg);

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ccg/ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
index 6a7aab8..81ac6bb 100644
--- a/drivers/staging/ccg/ccg.c
+++ b/drivers/staging/ccg/ccg.c
@@ -728,7 +728,7 @@ static int mass_storage_function_init(struct ccg_usb_function *f,
 	struct fsg_common *common;
 	int err;
 
-	memset(&fsg, 0, sizeof fsg);
+	memset(&fsg, 0, sizeof(fsg));
 	fsg.nluns = 1;
 	fsg.luns[0].removable = 1;
 	fsg.vendor_name = iManufacturer;
-- 
1.7.9.5

