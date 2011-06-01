Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab1FATv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:51:27 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59131 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759627Ab1FATre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:34 -0400
Message-Id: <20110601180610.532642190@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:03 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [patch 07/14] i8253: Make pcsp sound driver use the shared i8253_lock.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-move-sound-pcsp-to-shared-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org

 sound/drivers/pcsp/pcsp.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux-mips/sound/drivers/pcsp/pcsp.h
===================================================================
--- linux-mips.orig/sound/drivers/pcsp/pcsp.h
+++ linux-mips/sound/drivers/pcsp/pcsp.h
@@ -10,14 +10,8 @@
 #define __PCSP_H__
 
 #include <linux/hrtimer.h>
-#include <linux/timex.h>
-#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
-/* Use the global PIT lock ! */
 #include <linux/i8253.h>
-#else
-#include <asm/8253pit.h>
-static DEFINE_RAW_SPINLOCK(i8253_lock);
-#endif
+#include <linux/timex.h>
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
 #define PCSP_DEBUG 0


