Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab1BPAWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:35 -0500
Received: from kroah.org ([198.145.64.141]:49156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab1BPAWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:40 2011
Message-Id: <20110216001440.238908320@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [152/272] p54: fix sequence no. accounting off-by-one error
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 3b5c5827d1f80ad8ae844a8b1183f59ddb90fe25 upstream.

P54_HDR_FLAG_DATA_OUT_SEQNR is meant to tell the
firmware that "the frame's sequence number has
already been set by the application."

Whereas IEEE80211_TX_CTL_ASSIGN_SEQ is set for
frames which lack a valid sequence number and
either the driver or firmware has to assign one.

Yup, it's the exact opposite!

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -618,7 +618,7 @@ static void p54_tx_80211_header(struct p
 	else
 		*burst_possible = false;
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)


