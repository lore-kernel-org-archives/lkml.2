Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1EFAQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:16:06 -0400
Received: from kroah.org ([198.145.64.141]:32924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab1EFANe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:10 2011
Message-Id: <20110506001210.069249667@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 28/38] ath9k: fix the return value of ath_stoprecv
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 2232d31bf18ba02f5cd632bbfc3466aeca394c75 upstream.

The patch 'ath9k_hw: fix stopping rx DMA during resets' added code to detect
a condition where rx DMA was stopped, but the MAC failed to enter the idle
state. This condition requires a hardware reset, however the return value
of ath_stoprecv was 'true' in that case, which allowed it to skip the reset
when issuing a fast channel change.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Paul Stewart <pstew@google.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -533,7 +533,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 			"confusing the DMA engine when we start RX up\n");
 		ATH_DBG_WARN_ON_ONCE(!stopped);
 	}
-	return stopped || reset;
+	return stopped && !reset;
 }
 
 void ath_flushrecv(struct ath_softc *sc)


