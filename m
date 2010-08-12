Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab0HLAIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:21 -0400
Received: from kroah.org ([198.145.64.141]:47799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974Ab0HLAIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:17 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.880570507@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [24/67] rtl8180: avoid potential NULL deref in rtl8180_beacon_work
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 8f1d2d2be73a98c21e68fe2a26f633892d4abdd1 upstream.

ieee80211_beacon_get can return NULL...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -688,6 +688,8 @@ void rtl8180_beacon_work(struct work_str
 
 	/* grab a fresh beacon */
 	skb = ieee80211_beacon_get(dev, vif);
+	if (!skb)
+		goto resched;
 
 	/*
 	 * update beacon timestamp w/ TSF value


