Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1AIQ4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 11:56:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1AIQ4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 11:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r0qqA0sdGtIWtSVccYfzdYTTeYIOvz35keICsSndoKwZDvqWzsRsEgflSItqQSSViB
         v4J+F5SDldFDaUtUHlLRcsK8e4ED3MrlCvFteKY9iY0aPnvtilbIM3490POaXsK9iUrz
         L1gbJmmw6WU+HxRNVs51T1rPhmy9zAE23ED2I=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>
Subject: [PATCH 3/3] mmc: remove anti clock gating quirk for wl1271
Date: Sun,  9 Jan 2011 17:26:20 +0100
Message-Id: <cb471b35d320b96a9d143103fd9e9b76f8998470.1294588491.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1294588491.git.tardyp@gmail.com>
References: <cover.1294588491.git.tardyp@gmail.com>
In-Reply-To: <cover.1294588491.git.tardyp@gmail.com>
References: <cover.1294588491.git.tardyp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Tardy <pierre.tardy@intel.com>

Signed-off-by: Pierre Tardy <pierre.tardy@intel.com>
---
 drivers/mmc/core/quirks.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/quirks.c b/drivers/mmc/core/quirks.c
index fe467c8..506e4fc 100644
--- a/drivers/mmc/core/quirks.c
+++ b/drivers/mmc/core/quirks.c
@@ -33,6 +33,14 @@ static void add_quirk(struct mmc_card *card, int data)
 }
 
 /*
+ * This hook just removes a quirk unconditionnally
+ */
+static void remove_quirk_hook(struct mmc_card *card, int data)
+{
+	card->quirks &= ~data;
+}
+
+/*
  * This hook just adds a quirk for all sdio devices
  */
 static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
@@ -41,9 +49,19 @@ static void add_quirk_for_sdio_devices(struct mmc_card *card, int data)
 		card->quirks |= data;
 }
 
+#ifndef SDIO_VENDOR_ID_TI
+#define SDIO_VENDOR_ID_TI		0x0097
+#endif
+
+#ifndef SDIO_DEVICE_ID_TI_WL1271
+#define SDIO_DEVICE_ID_TI_WL1271	0x4076
+#endif
+
 static const struct mmc_fixup mmc_fixup_methods[] = {
 	{ SDIO_ANY_ID, SDIO_ANY_ID,
 		add_quirk_for_sdio_devices, MMC_QUIRK_BROKEN_CLK_GATING }
+	{ SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271,
+		remove_quirk_hook, MMC_QUIRK_BROKEN_CLK_GATING },
 	{ 0 }
 };
 
-- 
1.7.1

