Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1G3Lbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 07:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1G3Lbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 07:31:37 -0400
Date: Sat, 30 Jul 2011 13:32:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Ivo van Doorn <IvDoorn@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: [PATCH] rt2x00: rt2800: fix zeroing skb structure
Message-ID: <20110730113255.GB2847@redhat.com>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan>
 <4E318BD0.40202@lwfinger.net>
 <20110730113009.GA2847@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730113009.GA2847@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should clear skb->data not skb itself. Bug was introduced by:
commit 0b8004aa12d13ec750d102ba4082a95f0107c649 "rt2x00: Properly
reserve room for descriptors in skbs".

Cc: stable@kernel.org # 2.6.36+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 75d2c6c..f94d669 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -703,8 +703,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Add space for the TXWI in front of the skb.
 	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-	memset(entry->skb, 0, TXWI_DESC_SIZE);
+	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
 
 	/*
 	 * Register descriptor details in skb frame descriptor.
-- 
1.7.4

