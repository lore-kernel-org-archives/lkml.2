Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1A1Iws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:52:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1A1Iwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:52:47 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        John Kacur <jkacur@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        alsa-devel@alsa-project.org
Subject: [Patch] sound: silent echo'ed messages in Makefile
Date: Fri, 28 Jan 2011 16:52:00 +0800
Message-Id: <1296204727-19160-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silent these echo's, please.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/sound/oss/Makefile b/sound/oss/Makefile
index 96f14dc..90ffb99 100644
--- a/sound/oss/Makefile
+++ b/sound/oss/Makefile
@@ -87,7 +87,7 @@ ifeq ($(CONFIG_PSS_HAVE_BOOT),y)
 	$(obj)/bin2hex pss_synth < $< > $@
 else
     $(obj)/pss_boot.h:
-	(							\
+	$(Q)(							\
 	    echo 'static unsigned char * pss_synth = NULL;';	\
 	    echo 'static int pss_synthLen = 0;';		\
 	) > $@
@@ -102,7 +102,7 @@ ifeq ($(CONFIG_TRIX_HAVE_BOOT),y)
 	$(obj)/hex2hex -i trix_boot < $< > $@
 else
     $(obj)/trix_boot.h:
-	(							\
+	$(Q)(							\
 	    echo 'static unsigned char * trix_boot = NULL;';	\
 	    echo 'static int trix_boot_len = 0;';		\
 	) > $@
