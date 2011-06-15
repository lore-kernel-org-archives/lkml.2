Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1FPHkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:40:35 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58450 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754991Ab1FPHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:25 -0400
X-Sasl-enc: 0XiYgQ/dBQ/CFJkKDuAtjQ7guye7duQSbUt36W7uDJJw 1308207624
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.675788886@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [17/89] ath9k: Reset chip on baseband hang
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit a4d86d953b8593791cb29cf2acffd48f9ee6c4f9 upstream.

Resetting hardware helps to recover from baseband
hang/panic for AR9003 based chips.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -633,7 +633,8 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	if (status & ATH9K_INT_FATAL) {
+	if ((status & ATH9K_INT_FATAL) ||
+	    (status & ATH9K_INT_BB_WATCHDOG)) {
 		ath_reset(sc, true);
 		return;
 	}
@@ -699,6 +700,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 {
 #define SCHED_INTR (				\
 		ATH9K_INT_FATAL |		\
+		ATH9K_INT_BB_WATCHDOG |		\
 		ATH9K_INT_RXORN |		\
 		ATH9K_INT_RXEOL |		\
 		ATH9K_INT_RX |			\


