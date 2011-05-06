Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1EFAuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:50:03 -0400
Received: from kroah.org ([198.145.64.141]:36973 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab1EFAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.075879573@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Risto Suominen <Risto.Suominen@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [080/143] ALSA: powermac - Reverse HP detection on G4 DA
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Risto Suominen <Risto.Suominen@gmail.com>

commit 819ef70b135ba66cd1659c913255686bf931e3d4 upstream.

Reverse headphone detection bit on PowerMac G4 Digital Audio (Tumbler).

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/ppc/tumbler.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
 
@@ -1134,7 +1137,7 @@ static long tumbler_find_device(const ch
 		gp->inactive_val = (*base) ? 0x4 : 0x5;
 	} else {
 		const u32 *prop = NULL;
-		gp->active_state = 0;
+		gp->active_state = IS_G4DA && !strcmp(device, "keywest-gpio15");
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and


