Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab0DVUZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:25:32 -0400
Received: from kroah.org ([198.145.64.141]:59636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab0DVUAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:10 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:09 2010
Message-Id: <20100422195409.144789154@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [044/139] ath9k: fix double calls to ath_radio_enable
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1144601118507f8b3b676a9a392584d216d3f2cc upstream.

With the enable_radio being uninitialized, ath_radio_enable() might be
called twice, which can leave some hardware in an undefined state.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2721,8 +2721,7 @@ static int ath9k_config(struct ieee80211
 		all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
 		ath9k_set_wiphy_idle(aphy, idle);
 
-		if (!idle && all_wiphys_idle)
-			enable_radio = true;
+		enable_radio = (!idle && all_wiphys_idle);
 
 		/*
 		 * After we unlock here its possible another wiphy


