Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab0HFTeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:34:16 -0400
Received: from kroah.org ([198.145.64.141]:43525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935822Ab0HFT2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:15 2010
Message-Id: <20100806192115.762217477@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [15/36] ath9k: enable serialize_regmode for non-PCIE AR9160
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 4c85ab11ca56da1aa59b58c80cc6a356515cc645 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=16476

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -863,7 +863,8 @@ int ath9k_hw_init(struct ath_hw *ah)
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
+		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
+		     !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {


