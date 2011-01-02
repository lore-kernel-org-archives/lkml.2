Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1ABMk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:40:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59800 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1ABMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:40:27 -0500
Message-ID: <4d207236.cc7e0e0a.6f59.3760@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sun, 2 Jan 2011 14:03:00 +0200
Subject: [PATCH 4/9 v2] xc5000: add support for DVB-C tuning.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/common/tuners/xc5000.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 76ac5cd..e3218c9 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -683,6 +683,24 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 			return -EINVAL;
 		}
 		priv->rf_mode = XC_RF_MODE_AIR;
+	} else if (fe->ops.info.type == FE_QAM) {
+		dprintk(1, "%s() QAM\n", __func__);
+		switch (params->u.qam.modulation) {
+		case QAM_16:
+		case QAM_32:
+		case QAM_64:
+		case QAM_128:
+		case QAM_256:
+		case QAM_AUTO:
+			dprintk(1, "%s() QAM modulation\n", __func__);
+			priv->bandwidth = BANDWIDTH_8_MHZ;
+			priv->video_standard = DTV7_8;
+			priv->freq_hz = params->frequency - 2750000;
+			priv->rf_mode = XC_RF_MODE_CABLE;
+			break;
+		default:
+			return -EINVAL;
+		}
 	} else {
 		printk(KERN_ERR "xc5000 modulation type not supported!\n");
 		return -EINVAL;
-- 
1.7.1

