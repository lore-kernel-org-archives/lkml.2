Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2DATJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 15:09:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2DATJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 15:09:43 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: shea@shealevy.com, torvalds@linux-foundation.org, mchehab@infradead.org,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/1] Drivers/media/radio: Fix build error
Date: Sun,  1 Apr 2012 15:09:34 -0400
Message-Id: <1333307374-25848-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.10.rc3.3.g19a6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radio-maxiradio depends on SND_FM801_TEA575X_BOOL to build or will
result in an build error such as:

Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko] undefined!
ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko] undefined!
WARNING: modpost: Found 6 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Select CONFIG_SND_TEA575X to fixes problem and enable
the driver to be built as desired.

v2:
instead of selecting CONFIG_SND_FM801_TEA575X_BOOL, select
CONFIG_SND_TEA575X, which in turns selects CONFIG_SND_FM801_TEA575X_BOOL
and any other dependencies for it to build.

Reported-by: Shea Levy <shea@shealevy.com>
Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/media/radio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8db2d7f..b518ce5 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -44,6 +44,7 @@ config USB_DSBR
 config RADIO_MAXIRADIO
 	tristate "Guillemot MAXI Radio FM 2000 radio"
 	depends on VIDEO_V4L2 && PCI && SND
+	select SND_TEA575X
 	---help---
 	  Choose Y here if you have this radio card.  This card may also be
 	  found as Gemtek PCI FM.
-- 
1.7.10.rc3.3.g19a6c

