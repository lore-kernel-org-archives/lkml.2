Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2JCGfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 02:35:22 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34416 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2JCGfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 02:35:20 -0400
From: Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
        VGER <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH] ARM: davinci: dm644x: fix out range signal for ED
Date: Wed,  3 Oct 2012 12:05:00 +0530
Message-Id: <1349246100-7477-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.lad@ti.com>

while testing display on dm644x, for ED out-range signals
was observed. This patch fixes appropriate clock setting
for ED.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/dm644x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 79d2880..688484b 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -713,8 +713,7 @@ static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
 		break;
 	case VPBE_ENC_CUSTOM_TIMINGS:
 		if (pclock <= 27000000) {
-			v |= DM644X_VPSS_MUXSEL_PLL2_MODE |
-			     DM644X_VPSS_DACCLKEN;
+			v |= DM644X_VPSS_DACCLKEN;
 			writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
 		} else {
 			/*
-- 
1.7.4.1

