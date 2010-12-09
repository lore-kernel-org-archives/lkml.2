Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0LIPIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:08:23 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:64761 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab0LIPIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:08:21 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 10:08:20 EST
From: Tobias Klauser <tklauser@distanz.ch>
To: giometti@linux.it
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] c2port: Remove redundant unlikely()
Date: Thu,  9 Dec 2010 16:00:00 +0100
Message-Id: <1291906801-1389-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.12.9.145115
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/misc/c2port/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index 19fc7c1..95a82de 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -913,7 +913,7 @@ struct c2port_device *c2port_device_register(char *name,
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
 					"c2port%d", id);
-	if (unlikely(IS_ERR(c2dev->dev))) {
+	if (IS_ERR(c2dev->dev)) {
 		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
 	}
-- 
1.7.0.4

