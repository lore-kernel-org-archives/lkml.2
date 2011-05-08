Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1EHJSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 05:18:04 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:39474 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1EHJRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 05:17:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] input/atari: Fix mouse movement and button mapping
Date: Sun,  8 May 2011 11:17:27 +0200
Message-Id: <1304846247-12401-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
References: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up and down movements were reversed, left and right buttons were swapped.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/mouse/atarimouse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index 16a9d0f..5c4a692 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -77,15 +77,15 @@ static void atamouse_interrupt(char *buf)
 #endif
 
 	/* only relative events get here */
-	dx =  buf[1];
-	dy = -buf[2];
+	dx = buf[1];
+	dy = buf[2];
 
 	input_report_rel(atamouse_dev, REL_X, dx);
 	input_report_rel(atamouse_dev, REL_Y, dy);
 
-	input_report_key(atamouse_dev, BTN_LEFT,   buttons & 0x1);
+	input_report_key(atamouse_dev, BTN_LEFT,   buttons & 0x4);
 	input_report_key(atamouse_dev, BTN_MIDDLE, buttons & 0x2);
-	input_report_key(atamouse_dev, BTN_RIGHT,  buttons & 0x4);
+	input_report_key(atamouse_dev, BTN_RIGHT,  buttons & 0x1);
 
 	input_sync(atamouse_dev);
 
-- 
1.7.0.4

