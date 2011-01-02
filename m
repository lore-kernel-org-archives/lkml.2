Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1ABIHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:07:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:34464 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1ABHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 043/260] ath9k_hw: fix parsing of HT40 5 GHz CTLs
Date: Sun,  2 Jan 2011 02:15:39 -0500
Message-Id: <1293952756-15010-44-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:53.0319 (UTC) FILETIME=[9706A570:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 904879748d7439a6dabdc6be9aad983e216b027d upstream.

The 5 GHz CTL indexes were not being read for all hardware
devices due to the masking out through the CTL_MODE_M mask
being one bit too short. Without this the calibrated regulatory
maximum values were not being picked up when devices operate
on 5 GHz in HT40 mode. The final output power used for Atheros
devices is the minimum between the calibrated CTL values and
what CRDA provides.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/regd.h         |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 2f2993b..104e3ea 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -61,7 +61,7 @@
 
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
+#define CTL_MODE_M              0xf
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index a1c3952..345dd97 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -31,7 +31,6 @@ enum ctl_group {
 #define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2
-- 
1.7.3.3

