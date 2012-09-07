Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667Ab2IGN5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:57:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42976 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2IGN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:57:07 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Fengguang Wu <wfg@linux.intel.com>,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <axboe@kernel.dk>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH -mm] cciss: select CONFIG_CHECK_SIGNATURE
Date: Fri,  7 Sep 2012 22:56:51 +0900
Message-Id: <1347026211-10557-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch cciss-use-check_signature.patch in -mm tree introduced
a build error:

drivers/built-in.o: In function `CISS_signature_present':
drivers/block/cciss.c:4270: undefined reference to `check_signature'

Add missing CONFIG_CHECK_SIGNATURE to fix this issue.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Fengguang Wu <wfg@linux.intel.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
---
 drivers/block/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f529407..f7de322 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -131,6 +131,7 @@ config BLK_CPQ_DA
 config BLK_CPQ_CISS_DA
 	tristate "Compaq Smart Array 5xxx support"
 	depends on PCI
+	select CHECK_SIGNATURE
 	help
 	  This is the driver for Compaq Smart Array 5xxx controllers.
 	  Everyone using these boards should say Y here.
-- 
1.7.11.4

