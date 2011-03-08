Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1CHTxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:53:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1CHTw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DHfao3gESzBpJ9sE3XwMHCkbpxW+A8QQOCBedoRtvF9eX79bsIc1wX9JxuqID6SN4p
         mhQe88PeGSKbspk14wvSxOKOkYqbganKxtYf1no1EsYdSV0LxKlHcSgeIrTV2jrCu+Qp
         VkiY8saTJivtZA31gAEYMaewlYtiIdvsRx388=
Message-ID: <4D768917.9040605@gmail.com>
Date: Tue, 08 Mar 2011 20:52:55 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] can: wrong index used in inner loop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index i was already used in the outer loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/can/usb/esd_usb2.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 05a5275..dc53c83 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -659,7 +659,7 @@ failed:
 static void unlink_all_urbs(struct esd_usb2 *dev)
 {
 	struct esd_usb2_net_priv *priv;
-	int i;
+	int i, j;
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 	for (i = 0; i < dev->net_count; i++) {
@@ -668,8 +668,8 @@ static void unlink_all_urbs(struct esd_usb2 *dev)
 			usb_kill_anchored_urbs(&priv->tx_submitted);
 			atomic_set(&priv->active_tx_jobs, 0);
 
-			for (i = 0; i < MAX_TX_URBS; i++)
-				priv->tx_contexts[i].echo_index = MAX_TX_URBS;
+			for (j = 0; j < MAX_TX_URBS; j++)
+				priv->tx_contexts[j].echo_index = MAX_TX_URBS;
 		}
 	}
 }
