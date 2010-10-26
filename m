Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab0JZKTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:19:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60801 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759496Ab0JZKSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:25 -0400
From: Julia Lawall <julia@diku.dk>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] drivers/video/omap/blizzard.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:41 +0200
Message-Id: <1288088743-3725-13-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  Initialize the out_y
field as well as the out_x field, rather than initializing the out_x field
twice.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 drivers/video/omap/blizzard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/omap/blizzard.c b/drivers/video/omap/blizzard.c
index 2ffb34a..87785c2 100644
--- a/drivers/video/omap/blizzard.c
+++ b/drivers/video/omap/blizzard.c
@@ -1590,7 +1590,7 @@ static int blizzard_init(struct omapfb_device *fbdev, int ext_mode,
 	blizzard.auto_update_window.width = fbdev->panel->x_res;
 	blizzard.auto_update_window.height = fbdev->panel->y_res;
 	blizzard.auto_update_window.out_x = 0;
-	blizzard.auto_update_window.out_x = 0;
+	blizzard.auto_update_window.out_y = 0;
 	blizzard.auto_update_window.out_width = fbdev->panel->x_res;
 	blizzard.auto_update_window.out_height = fbdev->panel->y_res;
 	blizzard.auto_update_window.format = 0;

