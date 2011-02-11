Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1BKMRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:17:33 -0500
Received: from ni.piap.pl ([195.187.100.4]:40248 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BKMRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:17:31 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:10:30 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m3lj1mrcuh.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/7] Solo6x10: accept WxH >= screen dimentions.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to request full resolution (704x576 or 704x480)
independently of the color system used (PAL or NTSC).

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index 7bbb940..2b3d30b 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -1034,13 +1034,17 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 		if (pix->width != solo_enc->width ||
 		    pix->height != solo_enc->height)
 			return -EBUSY;
-	} else if (!(pix->width == solo_dev->video_hsize &&
-	      pix->height == solo_dev->video_vsize << 1) &&
-	    !(pix->width == solo_dev->video_hsize >> 1 &&
-	      pix->height == solo_dev->video_vsize)) {
+	}
+
+	if (pix->width < solo_dev->video_hsize ||
+	    pix->height < solo_dev->video_vsize << 1) {
 		/* Default to CIF 1/2 size */
 		pix->width = solo_dev->video_hsize >> 1;
 		pix->height = solo_dev->video_vsize;
+	} else {
+		/* Full frame */
+		pix->width = solo_dev->video_hsize;
+		pix->height = solo_dev->video_vsize << 1;
 	}
 
 	if (pix->field == V4L2_FIELD_ANY)

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
