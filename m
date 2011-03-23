Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1CWVsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:48:02 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33469 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756683Ab1CWVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:47:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18Dqbl1vBYDpU6xkKcxAQo5Q4aO8QreSAvhGvpNsa
	kzYfYG/eCczG+n
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: no need to write CRTC values twice
Date: Wed, 23 Mar 2011 22:03:10 +0000
Message-Id: <1300917792-3880-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1300917792-3880-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Later the correct values will be written so there is no need to
write early some values which might be wrong.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index a982718..c4d2136 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2401,9 +2401,6 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 
 	viafb_write_reg_mask(0x15, VIASR, 0xA2, 0xA2);
 
-	/* Write CRTC */
-	viafb_fill_crtc_timing(crt_timing, vmode_tbl, video_bpp / 8, IGA1);
-
 	/* Write Graphic Controller */
 	for (i = 0; i < StdGR; i++)
 		via_write_reg(VIAGR, i, VPIT.GR[i]);
-- 
1.6.3.2

