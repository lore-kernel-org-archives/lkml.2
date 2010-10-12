Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab0JLNXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:23:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0JLNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=grCiQ8VP2Tlu0WfQ1KS3C39OCa3S7dS+1TFi+GU6W9W0GiGt/jMW2cu7COLShoCsSD
         sbwQ7DS0Yh+w7EIINhTw8DB3EmwCkdUSI5lc5fmsNGJYarcCf6R8duLStUn2IsYbjAxx
         JMPQNPa7c11ZmbR82Lfk8DF04pAMHceymC4u0=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 1/2] staging: rt2860: remove custom min() and max()
Date: Tue, 12 Oct 2010 16:22:48 +0300
Message-Id: <58ee6c5338ae1c6dc18633e48fad1b753c0f7ec7.1286889640.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/staging/rt2860/common/ba_action.c |    1 +
 drivers/staging/rt2860/common/mlme.c      |    1 +
 drivers/staging/rt2860/rtmp.h             |    8 --------
 drivers/staging/rt2860/sta/rtmp_data.c    |    1 +
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 1befe99..8eef82d 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -26,6 +26,7 @@
  */
 
 #include "../rt_config.h"
+#include <linux/kernel.h>
 
 #define BA_ORI_INIT_SEQ		(pEntry->TxSeq[TID])	/*1                        // inital sequence number of BA session */
 
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index 3558f65..7300c6e 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -38,6 +38,7 @@
 
 #include "../rt_config.h"
 #include <stdarg.h>
+#include <linux/kernel.h>
 
 u8 CISCO_OUI[] = { 0x00, 0x40, 0x96 };
 
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index f133c8c..ca54e53 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -324,14 +324,6 @@ struct rt_rtmp_sg_list {
 /* */
 /*  Some utility macros */
 /* */
-#ifndef min
-#define min(_a, _b)     (((_a) < (_b)) ? (_a) : (_b))
-#endif
-
-#ifndef max
-#define max(_a, _b)     (((_a) > (_b)) ? (_a) : (_b))
-#endif
-
 #define GET_LNA_GAIN(_pAd)	((_pAd->LatchRfRegs.Channel <= 14) ? (_pAd->BLNAGain) : ((_pAd->LatchRfRegs.Channel <= 64) ? (_pAd->ALNAGain0) : ((_pAd->LatchRfRegs.Channel <= 128) ? (_pAd->ALNAGain1) : (_pAd->ALNAGain2))))
 
 #define INC_COUNTER64(Val)          (Val.QuadPart++)
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index fbe903c..23879b7 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -35,6 +35,7 @@
 	--------	----------		----------------------------------------------
 */
 #include "../rt_config.h"
+#include <linux/kernel.h>
 
 void STARxEAPOLFrameIndicate(struct rt_rtmp_adapter *pAd,
 			     struct rt_mac_table_entry *pEntry,
-- 
1.6.3.3

