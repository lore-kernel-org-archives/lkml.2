Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0HCAFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:05:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47320 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0HCAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pR5hHQnfHPhFPyA5KbJhbG9vOC9wUEt4ygV0LJLvhwGNorLnj5Scg+WmseJdCZafly
         cPiz5g7ujpP6DUTebK6K7A85D0UzaQ0RS2PJ54z8OdCFvWD/iDua9BHooIyLjjyiw9RL
         U3iPEG48OdjA13lFOjt/0VTBfQzq+qrmIz7nw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, j@w1.fi,
        linville@tuxdriver.com, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]hostap:hostap_hw.c Fix variable 'fc' set but not used
Date: Mon,  2 Aug 2010 17:05:06 -0700
Message-Id: <1280793906-1810-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below fixes a build wanring from GCC.

  CC [M]  drivers/net/wireless/hostap/hostap_plx.o
In file included from drivers/net/wireless/hostap/hostap_plx.c:264:0:
drivers/net/wireless/hostap/hostap_hw.c: In function 'prism2_tx_80211':
drivers/net/wireless/hostap/hostap_hw.c:1816:18: warning: variable 'fc' set but not used

Removing fc from this just introduces a new warning
  CC [M]  drivers/net/wireless/hostap/hostap_plx.o
In file included from drivers/net/wireless/hostap/hostap_plx.c:264:0:
drivers/net/wireless/hostap/hostap_hw.c: In function 'prism2_tx_80211':
drivers/net/wireless/hostap/hostap_hw.c:1839:3: warning: statement with no effect

So I went and removed the whole thing. Let me know if theres another solution.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_hw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index e9d9d62..d734f3e 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -1813,7 +1813,7 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	struct hfa384x_tx_frame txdesc;
 	struct hostap_skb_tx_data *meta;
 	int hdr_len, data_len, idx, res, ret = -1;
-	u16 tx_control, fc;
+	u16 tx_control;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -1836,7 +1836,6 @@ static int prism2_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	/* skb->data starts with txdesc->frame_control */
 	hdr_len = 24;
 	skb_copy_from_linear_data(skb, &txdesc.frame_control, hdr_len);
- 	fc = le16_to_cpu(txdesc.frame_control);
 	if (ieee80211_is_data(txdesc.frame_control) &&
 	    ieee80211_has_a4(txdesc.frame_control) &&
 	    skb->len >= 30) {
-- 
1.7.1.rc1.21.gf3bd6

