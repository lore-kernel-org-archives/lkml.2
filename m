Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2K2UDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:03:23 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39086 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2K2UDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:03:21 -0500
From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
To: devel@driverdev.osuosl.org
Cc: line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org,
        "Laurent Navet [Mali]" <laurent.navet@gmail.com>
Subject: [PATCH] staging: line6: use kstrtoint() instead of simple_strtoul()
Date: Thu, 29 Nov 2012 21:03:38 +0100
Message-Id: <1354219418-6882-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>

staging: line6: pcm.c
	call to obsolete simple_strtoul() function is replaced
        by kstrtoint() in pcm_set_impulse_period().
	Also check the return code.

Signed-off-by: Laurent Navet [Mali] <laurent.navet@gmail.com>
---
 drivers/staging/line6/pcm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index a0ce781..876ab89 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -81,7 +81,13 @@ static ssize_t pcm_set_impulse_period(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
-	dev2pcm(dev)->impulse_period = simple_strtoul(buf, NULL, 10);
+        int value;
+        int rv;
+        rv = kstrtoint(buf, 10, &value);
+        if (rv < 0)
+		return rv;
+
+	dev2pcm(dev)->impulse_period = value;
 	return count;
 }
 
-- 
1.7.10.4

