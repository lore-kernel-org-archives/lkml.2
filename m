Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1DWHOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 03:14:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58731 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1DWHOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 03:14:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] amd64_edac: Remove node interleave warning
Date: Sat, 23 Apr 2011 09:13:57 +0200
Message-Id: <1303542839-28442-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This warning was wrongfully added for a normal condition - intlvsel
actually selects the destination node when node interleaving is enabled
and it is not a mismatch. For a detailed example, see section 2.8.10.2
"Node Interleaving" in F10h BKDG.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 31e71c4f..8dff05b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1403,12 +1403,8 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 		return -EINVAL;
 	}
 
-	if (intlv_en &&
-	    (intlv_sel != ((sys_addr >> 12) & intlv_en))) {
-		amd64_warn("Botched intlv bits, en: 0x%x, sel: 0x%x\n",
-			   intlv_en, intlv_sel);
+	if (intlv_en && (intlv_sel != ((sys_addr >> 12) & intlv_en)))
 		return -EINVAL;
-	}
 
 	sys_addr = f1x_swap_interleaved_region(pvt, sys_addr);
 
-- 
1.7.4.rc2

