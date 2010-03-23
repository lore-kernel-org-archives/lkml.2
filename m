Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0CWOiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:38:08 -0400
Received: from mail.lippert-at.com ([62.80.22.186]:9384 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753880Ab0CWOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:38:06 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 10:38:05 EDT
Message-ID: <4BA8CEF6.2010707@LiPPERTEmbedded.de>
Date: Tue, 23 Mar 2010 15:23:50 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Tristram Ha <Tristram.Ha@micrel.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ksz884x: fix return value of netdev_set_eeprom
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2010 14:23:44.0612 (UTC) FILETIME=[71C3FA40:01CACA94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ksz884x: fix return value of netdev_set_eeprom

netdev_set_eeprom() confused ethtool by just returning 1 on error
instead of a proper -EINVAL.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
---

--- linux-2.6.34-rc2-git1/drivers/net/ksz884x.c
+++ return_value_fixed/drivers/net/ksz884x.c
@@ -6322,7 +6322,7 @@ static int netdev_set_eeprom(struct net_
 	int len;

 	if (eeprom->magic != EEPROM_MAGIC)
-		return 1;
+		return -EINVAL;

 	len = (eeprom->offset + eeprom->len + 1) / 2;
 	for (i = eeprom->offset / 2; i < len; i++)
_

