Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab1HWWtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:49:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64706 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab1HWWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:49:04 -0400
Message-ID: <4E542E5B.6040005@gmail.com>
Date: Wed, 24 Aug 2011 00:48:59 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: ctxfi: Bump playback substreams to 256
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are references in the code to 256 sources, so I tested it with 256 aplays,
of which the first and last with real data and the rest playing /dev/zero .

Also increase amount of page tables, so the default aplay size works.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

---
diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index 457d211..2c86226 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -404,7 +404,7 @@ int ct_alsa_pcm_create(struct ct_atc *atc,
 	int err;
 	int playback_count, capture_count;
 
-	playback_count = (IEC958 == device) ? 1 : 8;
+	playback_count = (IEC958 == device) ? 1 : 256;
 	capture_count = (FRONT == device) ? 1 : 0;
 	err = snd_pcm_new(atc->card, "ctxfi", device,
 			  playback_count, capture_count, &pcm);
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index c749fa7..e134b3a 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -20,7 +20,7 @@
 #include "cthardware.h"
 #include <linux/slab.h>
 
-#define SRC_RESOURCE_NUM	64
+#define SRC_RESOURCE_NUM	256
 #define SRCIMP_RESOURCE_NUM	256
 
 static unsigned int conj_mask;
diff --git a/sound/pci/ctxfi/ctvmem.h b/sound/pci/ctxfi/ctvmem.h
index b23adfc..e6da60e 100644
--- a/sound/pci/ctxfi/ctvmem.h
+++ b/sound/pci/ctxfi/ctvmem.h
@@ -18,7 +18,7 @@
 #ifndef CTVMEM_H
 #define CTVMEM_H
 
-#define CT_PTP_NUM	1	/* num of device page table pages */
+#define CT_PTP_NUM	4	/* num of device page table pages */
 
 #include <linux/mutex.h>
 #include <linux/list.h>

