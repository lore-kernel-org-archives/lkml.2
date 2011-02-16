Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1BPAWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:53 -0500
Received: from kroah.org ([198.145.64.141]:49231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab1BPAWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:41 2011
Message-Id: <20110216001441.287649357@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [162/272] carl9170: fix typo in PS code
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 5820de5303f73d48dcc3a053c875d1f0da7eef67 upstream.

This patch fixes a off-by-one bug which bugged
the driver's PS-POLL capability.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/carl9170/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -564,7 +564,7 @@ static void carl9170_ps_beacon(struct ar
 	cam = ieee80211_check_tim(tim_ie, tim_len, ar->common.curaid);
 
 	/* 2. Maybe the AP wants to send multicast/broadcast data? */
-	cam = !!(tim_ie->bitmap_ctrl & 0x01);
+	cam |= !!(tim_ie->bitmap_ctrl & 0x01);
 
 	if (!cam) {
 		/* back to low-power land. */


