Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1DZVWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:22:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:1301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab1DZVOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327671"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jason.conti@gmail.com, chunkeey@googlemail.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [84/106] p54: Initialize extra_len in p54_tx_80211
Message-Id: <20110426211406.21A4C3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jason Conti <jason.conti@gmail.com>

commit a6756da9eace8b4af73e9dea43f1fc2889224c94 upstream.

This patch fixes a very serious off-by-one bug in
the driver, which could leave the device in an
unresponsive state.

The problem was that the extra_len variable [used to
reserve extra scratch buffer space for the firmware]
was left uninitialized. Because p54_assign_address
later needs the value to reserve additional space,
the resulting frame could be to big for the small
device's memory window and everything would
immediately come to a grinding halt.

Reference: https://bugs.launchpad.net/bugs/722185

Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Jason Conti <jason.conti@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/p54/txrx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/p54/txrx.c
+++ linux-2.6.35.y/drivers/net/wireless/p54/txrx.c
@@ -702,7 +702,7 @@ int p54_tx_80211(struct ieee80211_hw *de
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len;
+	unsigned int padding, len, extra_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;
