Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1KIIeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:34:22 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:1238
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab1KIIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:34:20 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzz8275bhz2ei87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,13,
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@gmail.com>
To: Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <libertas-dev@lists.infradead.org>
CC: Steven Miao <realmz6@gmail.com>,
        "open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: libertas: fix unaligned le64 accesses
Date: Wed, 9 Nov 2011 16:30:40 +0800
Message-ID: <1320827440-16904-1-git-send-email-realmz6@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use get_unaligned_le64() to get timestamp

Signed-off-by: Steven Miao <realmz6@gmail.com>
---
 drivers/net/wireless/libertas/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index b456a53..f23c2b1 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -630,7 +630,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			if (channel &&
 			    !(channel->flags & IEEE80211_CHAN_DISABLED))
 				cfg80211_inform_bss(wiphy, channel,
-					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
+					bssid, get_unaligned_le64(tsfdesc),
 					capa, intvl, ie, ielen,
 					LBS_SCAN_RSSI_TO_MBM(rssi),
 					GFP_KERNEL);
-- 
1.7.0.4


