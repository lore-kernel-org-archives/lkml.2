Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2HGWaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:30:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964770Ab2HGW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 055/122] mwifiex: correction in mcs index check
Date: Tue,  7 Aug 2012 15:25:43 -0700
Message-Id: <20120807221953.226871713@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit fe020120cb863ba918c6d603345342a880272c4d upstream.

mwifiex driver supports 2x2 chips as well. Hence valid mcs values
are 0 to 15. The check for mcs index is corrected in this patch.

For example: if 40MHz is enabled and mcs index is 11, "iw link"
command would show "tx bitrate: 108.0 MBit/s" without this patch.
Now it shows "tx bitrate: 108.0 MBit/s MCS 11 40Mhz" with the patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -634,9 +634,9 @@ mwifiex_dump_station_info(struct mwifiex
 
 	/*
 	 * Bit 0 in tx_htinfo indicates that current Tx rate is 11n rate. Valid
-	 * MCS index values for us are 0 to 7.
+	 * MCS index values for us are 0 to 15.
 	 */
-	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 8)) {
+	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 16)) {
 		sinfo->txrate.mcs = priv->tx_rate;
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
 		/* 40MHz rate */


