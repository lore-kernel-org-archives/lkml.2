Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1F0XLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:11:41 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34298 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1F0XJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=k9sD3Y5n1AYrv/3f8aCiiNqxp+tg56gUPt+58l+MwwN/wNa+xKuY4nhdLf7QDiAI84
         ZVTmMxPiedf2v/dNBrOOgJOMPSP/2yUZ2znPiikSFYPNc+Ai1yZvPhMoSM/QNjBYff24
         Vus6e4Nfyz0nUueRTTxg6fCYLhaQZvcaiALf8=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] vesafb: fix memory leak
Date: Tue, 28 Jun 2011 07:08:53 +0800
Message-Id: <1309216133-3118-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing framebuffer, free colourmap allocations.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
---
 drivers/video/vesafb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
index a99bbe8..501b340 100644
--- a/drivers/video/vesafb.c
+++ b/drivers/video/vesafb.c
@@ -175,6 +175,7 @@ static int vesafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 
 static void vesafb_destroy(struct fb_info *info)
 {
+	fb_dealloc_cmap(&info->cmap);
 	if (info->screen_base)
 		iounmap(info->screen_base);
 	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
-- 
1.7.4.1

