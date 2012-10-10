Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2JJQjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:39:17 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59673 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab2JJQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:39:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mcgrof@qca.qualcomm.com
Cc: jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
        senthilb@qca.qualcomm.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V3] ath/ath9k/ar9003_eeprom.c: Remove semicolon after if
Date: Wed, 10 Oct 2012 18:38:17 +0200
Message-Id: <1349887097-24980-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349038599-22026-1-git-send-email-peter.senna@gmail.com>
References: <1349038599-22026-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove a semicolon after if(...) that is preventing the
error check to work correctly. Removing this semicolon will change the
code behavior, but this is intended.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r1@
position p;
@@
if (...);@p

@script:python@
p0 << r1.p;
@@
// Emacs org-mode output
cocci.print_main("", p0)
cocci.print_secs("", p0)
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
NOTE: This patch changes the semantics.

Changes from V1:
Commit message
Added a note about semantics change

Changes from V2:
Commit message

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5bbe505..189aeb2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2989,7 +2989,7 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_PAPRD:
 		if (AR_SREV_9462(ah))
 			return false;
-		if (!ah->config.enable_paprd);
+		if (!ah->config.enable_paprd)
 			return false;
 		return !!(pBase->featureEnable & BIT(5));
 	case EEP_CHAIN_MASK_REDUCE:
-- 
1.7.11.4

