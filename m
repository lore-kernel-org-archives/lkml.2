Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1HBJnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:43:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65282 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1HBJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:43:15 -0400
MIME-Version: 1.0
Date: Tue, 2 Aug 2011 11:43:14 +0200
Message-ID: <CAGXE3d9ynyJX2eAr2bfwOc_PdDNEwVHDVsA_Jx1ReBht=eVuYw@mail.gmail.com>
Subject: [PATCH] rt2x00: Fix compilation without CONFIG_RT2X00_LIB_CRYPTO
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ivo van Doorn <IvDoorn@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced by commit
77b5621bac4a56b83b9081f48d4e7d1accdde400 (rt2x00: Don't use queue entry
as parameter when creating TX descriptor.)

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
Sending directly to John as I assume this should go through the wireless tree?

 drivers/net/wireless/rt2x00/rt2x00lib.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h
b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 15cdc7e..4cdf247 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -355,7 +355,8 @@ static inline enum cipher
rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *
 	return CIPHER_NONE;
 }

-static inline void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
+static inline void rt2x00crypto_create_tx_descriptor(struct
rt2x00_dev *rt2x00dev,
+						     struct sk_buff *skb,
 						     struct txentry_desc *txdesc)
 {
 }
-- 
1.7.3.4
