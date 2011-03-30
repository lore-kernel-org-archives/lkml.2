Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab1C3WGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:06:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217Ab1C3VGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734030"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: vasanth@atheros.com, nbd@openwrt.org, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [36/275] ath9k: Fix bug in delimiter padding computation
Message-Id: <20110330210431.983F33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit 39ec2997c374b528cdbf65099b6d6b8593a67f7f upstream.

There is a roundng error in delimiter padding computation
which causes severe throughput drop with some of AR9003.

signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/ath/ath9k/ath9k.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2011-03-29 22:51:54.545327490 -0700
+++ linux-2.6.35.y/drivers/net/wireless/ath/ath9k/ath9k.h	2011-03-29 23:02:58.936327387 -0700
@@ -174,8 +174,8 @@
 
 /* returns delimiter padding required given the packet length */
 #define ATH_AGGR_GET_NDELIM(_len)					\
-	(((((_len) + ATH_AGGR_DELIM_SZ) < ATH_AGGR_MINPLEN) ?           \
-	  (ATH_AGGR_MINPLEN - (_len) - ATH_AGGR_DELIM_SZ) : 0) >> 2)
+       (((_len) >= ATH_AGGR_MINPLEN) ? 0 :                             \
+        DIV_ROUND_UP(ATH_AGGR_MINPLEN - (_len), ATH_AGGR_DELIM_SZ))
 
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
