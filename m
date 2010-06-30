Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0F3OTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:19:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42502 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0F3OS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rQYZc2jk6yJIYYUa3I4iJUwDUvUJ9TfbUmxpBzUCw+5tKVMgbVyhs6f44jtnL7O/zn
         xqf57j8BpnFQcsvNmRQ3+4iAhtPuSzTafNXe8PbN7hmkJv08otjc6nvjYxxwP5MXGyX0
         kLoJzoqGYq1yl3DbpsbEQye5XXbn8qB7+1tVM=
From: Afzal Mohammed <lazfamam@gmail.com>
To: tomi.valkeinen@nokia.com
Cc: ville.syrjala@nokia.com, tj@kernel.org, lazfamam@gmail.com,
       linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP:DSS2:OMAPFB: Fix probe error path
Date: Wed, 30 Jun 2010 19:45:27 +0530
Message-Id: <1277907327-3443-1-git-send-email-lazfamam@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enabling fb0 fails in omapfb_create_framebuffers(), remove
sysfs file before returning to probe. This is required to complete
the cleanup in the above mentioned error case.

Signed-off-by: Afzal Mohammed <lazfamam@gmail.com>
---
 drivers/video/omap2/omapfb/omapfb-main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
index 4b4506d..2319b81 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1945,6 +1945,7 @@ static int omapfb_create_framebuffers(struct omapfb2_device *fbdev)
 			r = omapfb_overlay_enable(ovl, 1);
 
 			if (r) {
+				omapfb_remove_sysfs(fbdev);
 				dev_err(fbdev->dev,
 						"failed to enable overlay\n");
 				return r;
-- 
1.7.0.4

