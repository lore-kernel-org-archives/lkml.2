Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1HZHD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:03:27 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:59883 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1HZHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:03:26 -0400
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH] mmc: core: Add default timeout value for CMD6.
Date: Fri, 26 Aug 2011 15:48:06 +0900
Message-Id: <1314341286-22141-1-git-send-email-tgih.jun@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXT_CSD[248] includes the default maximum timeout for CMD6.
This field is added at eMMC4.5 Spec.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/core/mmc.c   |    4 ++++
 include/linux/mmc/card.h |    1 +
 include/linux/mmc/mmc.h  |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 5700b1c..68eb368 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -410,6 +410,10 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 	else
 		card->erased_byte = 0x0;

+	if (card->ext_csd.rev >= 6)
+		card->ext_csd.generic_cmd6_time = 10 *
+			ext_csd[EXT_CSD_GENERIC_CMD6_TIME];
+
 out:
 	return err;
 }
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index b460fc2..e992fe3 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -52,6 +52,7 @@ struct mmc_ext_csd {
 	u8			part_config;
 	unsigned int		part_time;		/* Units: ms */
 	unsigned int		sa_timeout;		/* Units: 100ns */
+	unsigned int		generic_cmd6_time;	/* Units: ms */
 	unsigned int		hs_max_dtr;
 	unsigned int		sectors;
 	unsigned int		card_type;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 5a794cb..e869f00 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -293,6 +293,7 @@ struct _mmc_csd {
 #define EXT_CSD_SEC_ERASE_MULT		230	/* RO */
 #define EXT_CSD_SEC_FEATURE_SUPPORT	231	/* RO */
 #define EXT_CSD_TRIM_MULT		232	/* RO */
+#define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */

 /*
  * EXT_CSD field definitions
--
1.7.0.4

