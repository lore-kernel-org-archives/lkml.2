Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2AOIkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 03:40:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53772 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986Ab2AOIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 03:40:16 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/8] brcm80211: Use brcmu_dbg_hex_dump
Date: Sun, 15 Jan 2012 00:38:43 -0800
Message-Id: <7a7a6b670e004a3f35dd5f69627b638b3ec76f4c.1326616556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1326616556.git.joe@perches.com>
References: <cover.1326616556.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a couple of pr_debug/print_hex_dump to
the standard utility.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 14ab606..72701a4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5858,9 +5858,8 @@ void brcms_c_print_txdesc(struct d11txh *txh)
 	struct ieee80211_rts rts = txh->rts_frame;
 
 	/* add plcp header along with txh descriptor */
-	pr_debug("Raw TxDesc + plcp header:\n");
-	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-			     txh, sizeof(struct d11txh) + 48);
+	brcmu_dbg_hex_dump(txh, sizeof(struct d11txh) + 48,
+			   "Raw TxDesc + plcp header:\n");
 
 	pr_debug("TxCtlLow: %04x ", mtcl);
 	pr_debug("TxCtlHigh: %04x ", mtch);
@@ -5986,9 +5985,7 @@ void brcms_c_print_rxh(struct d11rxhdr *rxh)
 		{0, NULL}
 	};
 
-	pr_debug("Raw RxDesc:\n");
-	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh,
-			     sizeof(struct d11rxhdr));
+	brcmu_dbg_hex_dump(rxh, sizeof(struct d11rxhdr), "Raw RxDesc:\n");
 
 	brcms_c_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
-- 
1.7.8.111.gad25c.dirty

