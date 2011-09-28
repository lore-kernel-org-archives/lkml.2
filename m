Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1I1Wo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab1I1Woy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.406936554@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Manual Munz <freifunk@somakoma.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [143/244] b43: Fix beacon problem in ad-hoc mode
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1571,7 +1571,8 @@ static void handle_irq_beacon(struct b43
 	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */


