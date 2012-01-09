Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2AIHvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:51:12 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38790 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab2AIHvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:51:10 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/staging/omapdrm/omap_fbdev.c: move free after uses
Date: Mon,  9 Jan 2012 08:51:03 +0100
Message-Id: <1326095463-8545-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move the free after the final uses.

The semantic patch that makes this report is available
in scripts/coccinelle/free/kfree.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/omapdrm/omap_fbdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_fbdev.c b/drivers/staging/omapdrm/omap_fbdev.c
index 093ae2f..c64b87c 100644
--- a/drivers/staging/omapdrm/omap_fbdev.c
+++ b/drivers/staging/omapdrm/omap_fbdev.c
@@ -362,11 +362,11 @@ void omap_fbdev_free(struct drm_device *dev)
 
 	fbdev = to_omap_fbdev(priv->fbdev);
 
-	kfree(fbdev);
-
 	/* this will free the backing object */
 	if (fbdev->fb)
 		fbdev->fb->funcs->destroy(fbdev->fb);
 
+	kfree(fbdev);
+
 	priv->fbdev = NULL;
 }

