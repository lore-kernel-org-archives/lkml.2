Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1DQOZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 10:25:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46724 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1DQOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 10:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=BvS64BdXIm36w/NbSxBMzveWgXin23QzZe4WNnDFlFWe9BVrfF2vp8qG95UB1OGvkJ
         oYWA6hv7vYYR+F/e6SpmJT01nAVvDURzp+2JdYgRhyf/q3cTzNIoALlJVUr3gHBij+1+
         KsNl4qqqmnFbsnNAeESQexN8nKgLPC5A/Fc24=
MIME-Version: 1.0
From: dave b <db.pub.mail@gmail.com>
Date: Mon, 18 Apr 2011 00:25:04 +1000
Message-ID: <BANLkTi=eYGpnMcfzEsyj+Y4meks-d6hb6g@mail.gmail.com>
Subject: [PATCH] Remove extra output from normal iwlwifi use
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I personally do not think that having the IWL_ERR, which I have
removed below, enabled during normal use (not debugging) is of any use
to anyone.

--- drivers/net/wireless/iwlwifi/iwl-agn-rs.c.orig	2011-04-18
00:22:55.000000000 +1000
+++ drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2011-04-16
01:09:57.000000000 +1000
@@ -398,10 +398,7 @@
 				tid);
 			ieee80211_stop_tx_ba_session(sta, tid);
 		}
-	} else {
-		IWL_ERR(priv, "Aggregation not enabled for tid %d "
-			"because load = %u\n", tid, load);
-	}
+	}
 	return ret;
 }


--- drivers/net/wireless/iwlwifi/iwl-agn-tx.c.orig	2011-04-18
00:21:05.000000000 +1000
+++ drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2011-04-16
01:08:29.000000000 +1000
@@ -991,9 +991,6 @@
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;

-	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
-			__func__, sta->addr, tid);
-
 	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Start AGG on invalid station\n");

Signed-off-by: dave bl <db.pub.mail@gmail.com>
