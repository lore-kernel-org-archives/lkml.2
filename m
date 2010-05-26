Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0EZQtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:49:35 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:39056 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab0EZQtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WMpPC/HkiRD+yDx+7XTNeldvGXziJQBb+fj3S/b86hx254v/+SaZ8siYAx1hGx8iMw
         obszNYyJJXyWhRKG+SotB0rZGpwjAfqvTOHY/r6N8BPSmfMOPsMuNGGG8JJDg8h0FhkQ
         7cY+1k4IZgvy+swj1JqgE2KNJzO0EODJUvJ50=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: ath9k-devel@venema.h4ckr.net
Cc: mcgrog@gmail.com, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]wireless:ath9k Fix ath_print in xmit.c
Date: Wed, 26 May 2010 09:49:14 -0700
Message-Id: <1274892555-10422-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ath_print in xmit.c should say "Reseting hardware"
instead of Reaseting HAL!(since HAL is being fazed out).
dmesg shows:
[ 8660.899624] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 8660.899676] ath: Unable to stop TxDMA. Reset HAL!

 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3db1917..2a0558e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1198,7 +1198,7 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		int r;
 
 		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to stop TxDMA. Reset HAL!\n");
+			  "Unable to stop TxDMA. Reseting hardware!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
-- 
1.6.5.GIT

