Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0LHA7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:30 -0500
Received: from kroah.org ([198.145.64.141]:48493 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab0LHA72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:28 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.671143499@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [033/289] ath9k_hw: Fix memory leak on ath9k_hw_rf_alloc_ext_banks failure
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 48a7c3df14d0cda850337a9b3f9e667a0b12a996 upstream.

The allocated externel radio banks have to be freed in
case of ath9k_hw_rf_alloc_ext_banks failure.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -486,6 +486,7 @@ static int ath9k_hw_post_init(struct ath
 		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
 			  "Failed allocating banks for "
 			  "external radio\n");
+		ath9k_hw_rf_free_ext_banks(ah);
 		return ecode;
 	}
 


