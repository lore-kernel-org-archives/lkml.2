Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1FLIpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:45:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37571 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1FLIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pCLnfvViSoU/gUSPeL/NejvFLv4lvAlzw6bSGlvhU3hfat+Z4D9CqWFzrGgtt4MvEV
         trR619+Ukg/IkekACAwyx1LldhEGI5Vc7P/+k87Urle9TDJgijDWpifPGYSwcEFDHr6B
         1rdFtn6CSVGLikSXPm82HLMirzLXil+HiBOmk=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Peter Jones <pjones@redhat.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH] efifb: Fix call to wrong unregister function
Date: Sun, 12 Jun 2011 10:45:01 +0200
Message-Id: <1307868301-1773-1-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like driver_unregister must be called instead of device_unregister.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 drivers/video/efifb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index 69c49df..d8717a6 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -541,7 +541,7 @@ static int __init efifb_init(void)
 	 */
 	ret = platform_driver_probe(&efifb_driver, efifb_probe);
 	if (ret) {
-		platform_device_unregister(&efifb_driver);
+		platform_driver_unregister(&efifb_driver);
 		return ret;
 	}
 
-- 
1.7.4.1

