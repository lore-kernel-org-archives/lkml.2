Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161684Ab2GLWja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161660Ab2GLWjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Panayiotis Karabassis <panayk@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 067/187] ath9k: enable serialize_regmode for non-PCIE AR9287
Date: Thu, 12 Jul 2012 15:33:43 -0700
Message-Id: <20120712191528.610688804@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Panayiotis Karabassis <panayk@gmail.com>

commit 7508b657967cf664b5aa0f6367d05016e7e3bc2a upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=42903

Based on the work of <fynivx@gmail.com>

Signed-off-by: Panayiotis Karabassis <panayk@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -558,7 +558,7 @@ static int __ath9k_hw_init(struct ath_hw
 
 	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
 		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;


