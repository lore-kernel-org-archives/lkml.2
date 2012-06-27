Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2F0RXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:23:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42141 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2F0RXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:23:39 -0400
From: Arvydas Sidorenko <asido4@gmail.com>
To: mcgrof@qca.qualcomm.com
Cc: jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
        senthilb@qca.qualcomm.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, asido4@gmail.com
Subject: [PATCH] Build fix in drivers/net/wireless/ath/ath9k/main.c
Date: Wed, 27 Jun 2012 21:19:39 +0200
Message-Id: <1340824779-5157-1-git-send-email-asido4@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fad29cd2f59949581050a937786c2c9bc78b2f04 broke the build if
no CONFIG_ATH9K_BTCOEX_SUPPORT is enabled.

Signed-off-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c14cf5a..e4e73f0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -151,8 +151,10 @@ static void __ath_cancel_work(struct ath_softc *sc)
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_delayed_work_sync(&sc->hw_pll_work);
 
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	if (ath9k_hw_mci_is_enabled(sc->sc_ah))
 		cancel_work_sync(&sc->mci_work);
+#endif
 }
 
 static void ath_cancel_work(struct ath_softc *sc)
-- 
1.7.8.6

