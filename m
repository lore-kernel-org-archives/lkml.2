Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1JILMC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:12:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1JILL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:11:57 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/7] staging: wlags49_h2: Enable WPA in the HCF
Date: Sun,  9 Oct 2011 12:11:32 +0100
Message-Id: <1318158697-15979-3-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WPA has been disabled in the HCF layer. The firmware does
support it (it is used on other platforms). Enable it so
we can work through the issues.

Note that we also enable this for the HERMES 2.5 non-WARP
firmware cards.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/Makefile  |    1 -
 drivers/staging/wlags49_h2/hcfcfg.h  |   19 ++++++++++++++-----
 drivers/staging/wlags49_h25/Makefile |    1 -
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/Makefile b/drivers/staging/wlags49_h2/Makefile
index e604ebd..c7220c6 100644
--- a/drivers/staging/wlags49_h2/Makefile
+++ b/drivers/staging/wlags49_h2/Makefile
@@ -15,7 +15,6 @@ INSTALLDIR := /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless
 ccflags-y := -I$(KERNELDIR)/include
 ccflags-y += -I$(src) \
 		-DBUS_PCMCIA \
-		-DUSE_WPA \
 		-DUSE_WEXT \
 		-DSTA_ONLY \
 		-DWVLAN_49 \
diff --git a/drivers/staging/wlags49_h2/hcfcfg.h b/drivers/staging/wlags49_h2/hcfcfg.h
index 825550e..7545bc5 100644
--- a/drivers/staging/wlags49_h2/hcfcfg.h
+++ b/drivers/staging/wlags49_h2/hcfcfg.h
@@ -316,16 +316,25 @@ typedef unsigned long			hcf_32;
 //#define HCF_SLEEP (HCF_CDS | HCF_DDS )
 #define HCF_SLEEP (HCF_CDS)
 
-//#define HCF_TYPE    (HCF_TYPE_HII5|HCF_TYPE_STA|HCF_TYPE_AP)
+/* Note: Non-WARP firmware all support WPA. However the original Agere
+ * linux driver does not enable WPA. Enabling WPA here causes whatever
+ * preliminary WPA logic to be included, some of which may be specific
+ * to HERMESI.
+ *
+ * Various comment are clear that WARP and WPA are not compatible
+ * (which may just mean WARP does WPA in a different fashion).
+ */
+
+/* #define HCF_TYPE    (HCF_TYPE_HII5|HCF_TYPE_STA|HCF_TYPE_AP) */
 #ifdef HERMES25
 #ifdef WARP
 #define HCF_TYPE    ( HCF_TYPE_WARP | HCF_TYPE_HII5 )
 #else
-#define HCF_TYPE    HCF_TYPE_HII5
-#endif // WARP
+#define HCF_TYPE    (HCF_TYPE_HII5 | HCF_TYPE_WPA)
+#endif /* WARP */
 #else
-#define HCF_TYPE    HCF_TYPE_NONE
-#endif // HERMES25
+#define HCF_TYPE    HCF_TYPE_WPA
+#endif /* HERMES25 */
 
 #ifdef ENABLE_DMA
 #define HCF_DMA		1
diff --git a/drivers/staging/wlags49_h25/Makefile b/drivers/staging/wlags49_h25/Makefile
index 7d4b563..fe82929 100644
--- a/drivers/staging/wlags49_h25/Makefile
+++ b/drivers/staging/wlags49_h25/Makefile
@@ -15,7 +15,6 @@ INSTALLDIR := /lib/modules/$(shell uname -r)/kernel/drivers/net/wireless
 ccflags-y := -I$(KERNELDIR)/include
 ccflags-y += -I$(src) \
 		-DBUS_PCMCIA \
-		-DUSE_WPA \
 		-DUSE_WEXT \
 		-DSTA_ONLY \
 		-DWVLAN_49 \
-- 
1.7.4.1

