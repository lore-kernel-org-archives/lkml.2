Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab0HKXjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:39:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45530 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758111Ab0HKXjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:39:22 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/bJYIjp8LbOaJURmfCrX73CGmECEuhiNlRTS7auR
	P72UvjakDjQ2qC
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 01/11] viafb: reset correct PLL
Date: Wed, 11 Aug 2010 23:49:30 +0000
Message-Id: <1281570580-8253-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1281570580-8253-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: reset correct PLL

Looks like we did reset the PLL of the (whatever) engine instead of
the PLL of the secondary display (IGA2, LCDCK). This patch fixes it.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 7dcb4d5..53b0651 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1688,8 +1688,8 @@ void viafb_set_vclock(u32 clk, int set_iga)
 	}
 
 	if (set_iga == IGA2) {
-		viafb_write_reg_mask(SR40, VIASR, 0x01, BIT0);
-		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT0);
+		viafb_write_reg_mask(SR40, VIASR, 0x04, BIT2);
+		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT2);
 	}
 
 	/* Fire! */
-- 
1.6.3.2

