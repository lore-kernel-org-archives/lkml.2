Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab2K3LEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:04:52 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42229 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564Ab2K3LEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:04:49 -0500
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 06:04:49 EST
From: Laurent Navet <laurent.navet@gmail.com>
To: devel@driverdev.osuosl.org
Cc: line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: line6: pcm.c fix checkpatch issues
Date: Fri, 30 Nov 2012 11:57:32 +0100
Message-Id: <1354273052-5203-2-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354273052-5203-1-git-send-email-laurent.navet@gmail.com>
References: <1354273052-5203-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix those checkpatch issues
drivers/staging/line6/pcm.c:84:
	WARNING: simple_strtoul is obsolete, use kstrtoul instead
	call to obsolete simple_strtoul() replaced by kstrtoint()

drivers/staging/line6/pcm.c:423:
	ERROR: switch and case should be at the same indent
	realigns comments

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/line6/pcm.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 6c1e313..17969c6 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -49,11 +49,11 @@ static ssize_t pcm_set_impulse_volume(struct device *dev,
 {
 	struct snd_line6_pcm *line6pcm = dev2pcm(dev);
 	int value;
-	int rv;
+	int ret;
 
-	rv = kstrtoint(buf, 10, &value);
-	if (rv < 0)
-		return rv;
+	ret = kstrtoint(buf, 10, &value);
+	if (ret < 0)
+		return ret;
 
 	line6pcm->impulse_volume = value;
 
@@ -81,7 +81,14 @@ static ssize_t pcm_set_impulse_period(struct device *dev,
 				      struct device_attribute *attr,
 				      const char *buf, size_t count)
 {
-	dev2pcm(dev)->impulse_period = simple_strtoul(buf, NULL, 10);
+	int value;
+	int ret;
+
+	ret = kstrtoint(buf, 10, &value);
+	if (ret < 0)
+		return ret;
+
+	dev2pcm(dev)->impulse_period = value;
 	return count;
 }
 
@@ -455,13 +462,12 @@ int line6_init_pcm(struct usb_line6 *line6,
 		ep_write = 0x01;
 		break;
 
-		/* this is for interface_number == 1:
-		   case LINE6_DEVID_TONEPORT_UX2:
-		   case LINE6_DEVID_PODSTUDIO_UX2:
-		   ep_read  = 0x87;
-		   ep_write = 0x00;
-		   break;
-		 */
+	/* this is for interface_number == 1:
+	case LINE6_DEVID_TONEPORT_UX2:
+	case LINE6_DEVID_PODSTUDIO_UX2:
+		ep_read  = 0x87;
+		ep_write = 0x00;
+		break; */
 
 	default:
 		MISSING_CASE;
-- 
1.7.10.4

