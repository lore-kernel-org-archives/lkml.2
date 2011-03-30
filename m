Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab1C3VHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:17014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933356Ab1C3VG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277049"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: chunkeey@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [58/275] p54: fix sequence no. accounting off-by-one error
Message-Id: <20110330210454.BB1FE3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit 3b5c5827d1f80ad8ae844a8b1183f59ddb90fe25 upstream.

P54_HDR_FLAG_DATA_OUT_SEQNR is meant to tell the
firmware that "the frame's sequence number has
already been set by the application."

Whereas IEEE80211_TX_CTL_ASSIGN_SEQ is set for
frames which lack a valid sequence number and
either the driver or firmware has to assign one.

Yup, it's the exact opposite!

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/p54/txrx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/p54/txrx.c	2011-03-29 22:51:46.583531213 -0700
+++ linux-2.6.35.y/drivers/net/wireless/p54/txrx.c	2011-03-29 23:02:59.358316589 -0700
@@ -616,7 +616,7 @@
 	else
 		*burst_possible = false;
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
