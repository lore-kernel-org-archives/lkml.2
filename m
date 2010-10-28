Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0J1JTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 05:19:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43281 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0J1JS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 05:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tSzhGj0hNX2PpPv5PdKDMB900mmYwcb6YuK5uUoXbMUUQEbtLIJFH9ac2R79TapuFq
         /472a0NZku2CjGCBuvZARt/p/23fZUJXI/TG4DU25PxoYeOGVFhT70pudaJawc+oISyn
         3C/bX4uwryMwjwnTrkWNXa227p3yPW9i75k7w=
From: Grazvydas Ignotas <notasas@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: -tip: origin tree build failure (battery-2.6.git related)
Date: Thu, 28 Oct 2010 12:18:11 +0300
Message-Id: <1288257491-14124-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20101028000710.2039c2f4.akpm@linux-foundation.org>
References: <20101028000710.2039c2f4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those definitions get added by the MFD tree and used by the battery
> tree.  Things arrived in the wrong order (and, yes, didn't get tested).

I just assumed mfd tree would be merged first and did not indicate there
was MFD dependency to Anton, sorry about that.
Below is the patch it depends on.


--------------------------- cut ---------------------------
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Fri, 10 Sep 2010 17:10:21 +0200
Subject: i2c: twl: add register defines for pm master module

Some modules already need to talk to at least PROTECT_KEY
register, while at that, add defines to the entire register
space.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/i2c/twl.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 6de90bf..4ddffd2 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -356,6 +356,52 @@ int twl6030_interrupt_mask(u8 bit_mask, u8 offset);
 #define TWL5031_INTERRUPTS_BCISIHCTRL	0x7
 
 /*----------------------------------------------------------------------*/
+  
+/*
+ * PM Master module register offsets (use TWL4030_MODULE_PM_MASTER)
+ */
+
+#define TWL4030_PM_MASTER_CFG_P1_TRANSITION	0x00
+#define TWL4030_PM_MASTER_CFG_P2_TRANSITION	0x01
+#define TWL4030_PM_MASTER_CFG_P3_TRANSITION	0x02
+#define TWL4030_PM_MASTER_CFG_P123_TRANSITION	0x03
+#define TWL4030_PM_MASTER_STS_BOOT		0x04
+#define TWL4030_PM_MASTER_CFG_BOOT		0x05
+#define TWL4030_PM_MASTER_SHUNDAN		0x06
+#define TWL4030_PM_MASTER_BOOT_BCI		0x07
+#define TWL4030_PM_MASTER_CFG_PWRANA1		0x08
+#define TWL4030_PM_MASTER_CFG_PWRANA2		0x09
+#define TWL4030_PM_MASTER_BACKUP_MISC_STS	0x0b
+#define TWL4030_PM_MASTER_BACKUP_MISC_CFG	0x0c
+#define TWL4030_PM_MASTER_BACKUP_MISC_TST	0x0d
+#define TWL4030_PM_MASTER_PROTECT_KEY		0x0e
+#define TWL4030_PM_MASTER_STS_HW_CONDITIONS	0x0f
+#define TWL4030_PM_MASTER_P1_SW_EVENTS		0x10
+#define TWL4030_PM_MASTER_P2_SW_EVENTS		0x11
+#define TWL4030_PM_MASTER_P3_SW_EVENTS		0x12
+#define TWL4030_PM_MASTER_STS_P123_STATE	0x13
+#define TWL4030_PM_MASTER_PB_CFG		0x14
+#define TWL4030_PM_MASTER_PB_WORD_MSB		0x15
+#define TWL4030_PM_MASTER_PB_WORD_LSB		0x16
+#define TWL4030_PM_MASTER_SEQ_ADD_W2P		0x1c
+#define TWL4030_PM_MASTER_SEQ_ADD_P2A		0x1d
+#define TWL4030_PM_MASTER_SEQ_ADD_A2W		0x1e
+#define TWL4030_PM_MASTER_SEQ_ADD_A2S		0x1f
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A12		0x20
+#define TWL4030_PM_MASTER_SEQ_ADD_S2A3		0x21
+#define TWL4030_PM_MASTER_SEQ_ADD_WARM		0x22
+#define TWL4030_PM_MASTER_MEMORY_ADDRESS	0x23
+#define TWL4030_PM_MASTER_MEMORY_DATA		0x24
+
+#define TWL4030_PM_MASTER_KEY_CFG1		0xc0
+#define TWL4030_PM_MASTER_KEY_CFG2		0x0c
+
+#define TWL4030_PM_MASTER_KEY_TST1		0xe0
+#define TWL4030_PM_MASTER_KEY_TST2		0x0e
+
+#define TWL4030_PM_MASTER_GLOBAL_TST		0xb6
+
+/*----------------------------------------------------------------------*/
 
 /* Power bus message definitions */
 
-- 
1.6.3.3

