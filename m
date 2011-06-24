Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1FXWDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:03:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab1FXWDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:03:14 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=3rvgeqzMqd0A:10 a=yXbLqZANKl0A:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=pdJl1Pn17w1wWSCKyzkA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 24 Jun 2011 17:03:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] staging: rtl8192u: Fix big-endian warning
Message-ID: <4e0509a0.ol+hDilyyLRjLXuo%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling the rtl8192u driver from staging on a big-endian
architecture, the following warning results:

  CC [M]  drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.o
drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c: In function 'ieee80211_probe_resp':
drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c:780: warning: value computed is not used

The warning is due to misuse of cpu_to_le16().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ wireless-testing-new/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -776,7 +776,7 @@ static struct sk_buff* ieee80211_probe_r
 		cpu_to_le16(ieee->current_network.capability & WLAN_CAPABILITY_SHORT_PREAMBLE); //add short preamble here
 
 	if(ieee->short_slot && (ieee->current_network.capability & WLAN_CAPABILITY_SHORT_SLOT))
-		cpu_to_le16((beacon_buf->capability |= WLAN_CAPABILITY_SHORT_SLOT));
+		beacon_buf->capability |= cpu_to_le16(WLAN_CAPABILITY_SHORT_SLOT);
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
 	if (encrypt)
