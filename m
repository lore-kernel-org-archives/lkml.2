Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2HHUOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 16:14:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45952 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2HHUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 16:14:47 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: andrzej.p@samsung.com, lockwood@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging:ccg: Fix missing brackets for sizeof (found by sparse).
Date: Wed,  8 Aug 2012 22:14:38 +0200
Message-Id: <1344456878-968-1-git-send-email-marek.belisko@open-nandra.com>
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

