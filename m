Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab1C3V5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:57:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1C3VG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236619"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: akarwar@marvell.com, bzhao@marvell.com, ak@linux.intel.com,
        johannes@sipsolutions.net, linville@tuxdriver.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [76/275] ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro
Message-Id: <20110330210513.B0FAE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Amitkumar Karwar <akarwar@marvell.com>

commit 8d661f1e462d50bd83de87ee628aaf820ce3c66c upstream.

It is defined in include/linux/ieee80211.h. As per IEEE spec.
bit6 to bit15 in block ack parameter represents buffer size.
So the bitmask should be 0xFFC0.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ieee80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/include/linux/ieee80211.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/ieee80211.h	2011-03-29 22:51:39.677707916 -0700
+++ linux-2.6.35.y/include/linux/ieee80211.h	2011-03-29 23:02:59.744306713 -0700
@@ -959,7 +959,7 @@
 /* block-ack parameters */
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
 #define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
 #define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
