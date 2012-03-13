Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab2CMAYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:48389 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab2CMAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Risto Suominen <Risto.Suominen@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 134/196] ALSA: powermac - Reverse HP detection on G4 DA
Date: Mon, 12 Mar 2012 20:20:47 -0400
Message-Id: <1331598109-31424-89-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Risto Suominen <Risto.Suominen@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 819ef70b135ba66cd1659c913255686bf931e3d4 upstream.

Reverse headphone detection bit on PowerMac G4 Digital Audio (Tumbler).

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/ppc/tumbler.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 789f44f..3b7471c 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -30,6 +30,7 @@
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/string.h>
 #include <sound/core.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -46,6 +47,8 @@
 #define DBG(fmt...)
 #endif
 
+#define IS_G4DA (machine_is_compatible("PowerMac3,4"))
+
 /* i2c address for tumbler */
 #define TAS_I2C_ADDR	0x34
 
@@ -1134,7 +1137,7 @@ static long tumbler_find_device(const char *device, const char *platform,
 		gp->inactive_val = (*base) ? 0x4 : 0x5;
 	} else {
 		const u32 *prop = NULL;
-		gp->active_state = 0;
+		gp->active_state = IS_G4DA && !strcmp(device, "keywest-gpio15");
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and
-- 
1.7.9.3

