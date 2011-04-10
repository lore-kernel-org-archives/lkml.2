Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1DJTKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 15:10:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63064 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1DJTJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 15:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=efDxG5dFSCtAHKR01AIqnDyufDqJEkwX+UOfQU+D9GSWffhqQk/VHL8IoKsjagnogw
         rKrWGzTmGARTHnoklRxu8mx3AvwNZvQDAQxKJk9E4teLh7VA1BKf6CXBAj4jOgWd4kVd
         eKhy6ryjFO2+DOxA+KQsRa//vmaaSjJoY7agI=
Message-ID: <4DA20083.8050208@gmail.com>
Date: Sun, 10 Apr 2011 21:09:55 +0200
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: index out of bounds
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether index is within bounds before testing the element

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4c0d36a..1809409 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1092,8 +1092,7 @@ static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 	if (!(rate->flags & IEEE80211_TX_RC_MCS))
 		return rate->idx;
 
-	while (rate->idx > mcs_rix_off[i] &&
-	       i < ARRAY_SIZE(mcs_rix_off)) {
+	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
 		rix++; i++;
 	}
 
