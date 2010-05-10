Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab0EJXc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:32:59 -0400
Received: from kroah.org ([198.145.64.141]:33265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab0EJWwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:35 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:24 2010
Message-Id: <20100510223324.153968147@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [075/117] ath9k: reorder ieee80211_free_hw behind ath9k_uninit_hw to avoid oops
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

This code only exists in 2.6.33 -- 2.6.32 and 2.6.34 are not affected.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1358,9 +1358,9 @@ void ath_cleanup(struct ath_softc *sc)
 	free_irq(sc->irq, sc);
 	ath_bus_cleanup(common);
 	kfree(sc->sec_wiphy);
-	ieee80211_free_hw(sc->hw);
 
 	ath9k_uninit_hw(sc);
+	ieee80211_free_hw(sc->hw);
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,


