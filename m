Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2GIOwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:52:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38092 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184Ab2GIOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:57 -0400
Message-Id: <20120709143117.913766146@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Panayiotis Karabassis <panayk@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 09/48] ath9k: enable serialize_regmode for non-PCIE AR9287
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panayiotis Karabassis <panayk@gmail.com>

commit 7508b657967cf664b5aa0f6367d05016e7e3bc2a upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=42903

Based on the work of <fynivx@gmail.com>

Signed-off-by: Panayiotis Karabassis <panayk@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -557,7 +557,7 @@ static int __ath9k_hw_init(struct ath_hw
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
 		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;


