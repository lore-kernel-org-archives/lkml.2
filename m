Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1FOKQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:16:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1FOKQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=KRyzS3ceaz2TVfJw/lDSvXclxTyeBurbCl1GXmIwxRmstTLxqPc3tPuPYAXmbp83r5
         V0olgpPh6ceo28bLscN4+Znx58xjdBKHEmj/proz48s1cFBH8H0thNbAqQnp9hYsuwGo
         CPmdBazQ9bxxnXHPt2kyAwlRCKWeb7Oyo47gI=
Message-ID: <4DF8865F.5010007@gmail.com>
Date: Wed, 15 Jun 2011 12:15:59 +0200
From: Vladimir Pantelic <vladoman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20110511 Firefox/4.0.1 SeaMonkey/2.1
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: linux-omap@vger.kernel.org, "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH] omap v4l2: fix wrong resizer calculation
References: <4DB67614.7030008@gmail.com>
In-Reply-To: <4DB67614.7030008@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060408030204090801090000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060408030204090801090000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

ping

--------------060408030204090801090000
Content-Type: text/x-diff;
 name="0001-omap-v4l2-fix-wrong-resizer-calculation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-omap-v4l2-fix-wrong-resizer-calculation.patch"

>From 47473f26bda2ef2e3a5e8f0203fde0c74c412c36 Mon Sep 17 00:00:00 2001
From: Vladimir Pantelic <vladoman@gmail.com>
Date: Tue, 26 Apr 2011 09:28:11 +0200
Subject: [PATCH] omap v4l2: fix wrong resizer calculation

in omap_vout_new_crop(), "crop" is the output parameter and
therefore new_crop/try_crop should be used to calculate the
resizer values

Signed-off-by: Vladimir Pantelic <vladoman@gmail.com>
---
 drivers/media/video/omap/omap_voutlib.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/omap/omap_voutlib.c b/drivers/media/video/omap/omap_voutlib.c
index 2aa6a76..8ae7481 100644
--- a/drivers/media/video/omap/omap_voutlib.c
+++ b/drivers/media/video/omap/omap_voutlib.c
@@ -193,7 +193,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 		return -EINVAL;
 
 	if (cpu_is_omap24xx()) {
-		if (crop->height != win->w.height) {
+		if (try_crop.height != win->w.height) {
 			/* If we're resizing vertically, we can't support a
 			 * crop width wider than 768 pixels.
 			 */
@@ -202,7 +202,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 		}
 	}
 	/* vertical resizing */
-	vresize = (1024 * crop->height) / win->w.height;
+	vresize = (1024 * try_crop.height) / win->w.height;
 	if (cpu_is_omap24xx() && (vresize > 2048))
 		vresize = 2048;
 	else if (cpu_is_omap34xx() && (vresize > 4096))
@@ -221,7 +221,7 @@ int omap_vout_new_crop(struct v4l2_pix_format *pix,
 			try_crop.height = 2;
 	}
 	/* horizontal resizing */
-	hresize = (1024 * crop->width) / win->w.width;
+	hresize = (1024 * try_crop.width) / win->w.width;
 	if (cpu_is_omap24xx() && (hresize > 2048))
 		hresize = 2048;
 	else if (cpu_is_omap34xx() && (hresize > 4096))
-- 
1.6.0.2


--------------060408030204090801090000--
