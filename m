Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab1KCBjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:39:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934104Ab1KCBjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.345465517@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Manual Munz <freifunk@somakoma.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [029/101] b43: Fix beacon problem in ad-hoc mode
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Manual Munz <freifunk@somakoma.de>

commit 8c23516fbb209ccf8f8c36268311c721faff29ee upstream.

In ad-hoc mode, driver b43 does not issue beacons.

Signed-off-by: Manual Munz <freifunk@somakoma.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1526,7 +1526,8 @@ static void handle_irq_beacon(struct b43
 	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */


