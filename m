Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab2KPCjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 21:39:24 -0500
Received: from the.earth.li ([46.43.34.31]:34913 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2KPCjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 21:39:23 -0500
X-Greylist: delayed 2651 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 21:39:23 EST
Date: Thu, 15 Nov 2012 17:55:12 -0800
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] Autoselect more relevant frontends for EM28XX DVB stick
Message-ID: <20121116015512.GE5662@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling up 3.6.6 for my media box recently I noticed that the EM28XX
DVB driver doesn't auto select all of the appropriate DVB tuner modules
required. In particular I needed DVB_LGDT3305 for my a340, but it looks
like DVB_MT352 + DVB_S5H1409 were missing as well. Patch below adds the
appropriate select lines to the Kconfig and is against Linus' current
mainline.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 7a5bd61..617c6e4 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -34,6 +34,7 @@ config VIDEO_EM28XX_DVB
 	tristate "DVB/ATSC Support for em28xx based TV cards"
 	depends on VIDEO_EM28XX && DVB_CORE
 	select DVB_LGDT330X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S921 if MEDIA_SUBDRV_AUTOSELECT
@@ -43,6 +44,8 @@ config VIDEO_EM28XX_DVB
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA10071 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_A8293 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MT352 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEOBUF_DVB
 	---help---
 	  This adds support for DVB cards based on the
-----

J.

-- 
Revd Jonathan McDowell, ULC | This screen intentionally left blank.
