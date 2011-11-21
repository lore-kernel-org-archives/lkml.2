Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1KUUzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:55:33 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:49420 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab1KUUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:54:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/8] fbdev/amifb: Fix double free
Date: Mon, 21 Nov 2011 21:53:53 +0100
Message-Id: <1321908839-11419-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
References: <1321908839-11419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/amifb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index 72454c7..39d211a 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2464,7 +2464,6 @@ static void amifb_deinit(struct platform_device *pdev)
 {
 	if (fb_info.cmap.len)
 		fb_dealloc_cmap(&fb_info.cmap);
-	fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
 	if (videomemory)
 		iounmap((void *)videomemory);
-- 
1.7.0.4

