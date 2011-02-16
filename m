Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab1BPBLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:11:00 -0500
Received: from kroah.org ([198.145.64.141]:45664 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab1BPAtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:07 2011
Message-Id: <20110216002106.926730792@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 078/176] ALSA: fix invalid hardware.h include in ac97c for AVR32 architecture
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

commit fd76804f3f5484b35e6a51214c91e916ebba05aa upstream.

This patch fixes the non-compiling AC97C driver for AVR32 architecture by
include mach/hardware.h only for AT91 architecture. The AVR32 architecture does
not supply the hardware.h include file.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/atmel/ac97c.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -33,9 +33,12 @@
 #include <linux/dw_dmac.h>
 
 #include <mach/cpu.h>
-#include <mach/hardware.h>
 #include <mach/gpio.h>
 
+#ifdef CONFIG_ARCH_AT91
+#include <mach/hardware.h>
+#endif
+
 #include "ac97c.h"
 
 enum {


